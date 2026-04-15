"""
bus_envelope.py — Canonical internal message envelope and receipt lifecycle.

Every message entering the system (from IRC or Nostr) becomes a BusEnvelope
before being persisted or routed. Receipts track the lifecycle of each envelope.
"""

import json
import uuid
from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone
from typing import Optional


def _ulid() -> str:
    """Simple time-ordered ID using uuid4 (good enough without ulid library)."""
    return str(uuid.uuid4())


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


@dataclass
class BusEnvelope:
    message_id: str = field(default_factory=_ulid)
    trace_id: str = field(default_factory=_ulid)
    created_at: str = field(default_factory=_now_iso)
    source_bus: str = "irc"              # "irc" | "nostr"
    source_ref: str = ""                  # channel name OR relay+event_id
    source_actor: str = ""               # nick OR npub
    intent: str = ""
    task_scope: str = "feature"          # feature | maintenance | bug
    payload_type: str = "text"           # text | cron_output | nip90_job
    payload: dict = field(default_factory=dict)
    ack_required: bool = False
    reply_to: Optional[str] = None       # message_id of parent
    payment_context: Optional[dict] = None  # {required, amount_msat, invoice, state}
    semantic_tags: list = field(default_factory=list)

    def to_json(self) -> str:
        return json.dumps(asdict(self), sort_keys=True)

    @classmethod
    def from_dict(cls, d: dict) -> "BusEnvelope":
        valid = {k for k in cls.__dataclass_fields__}
        return cls(**{k: v for k, v in d.items() if k in valid})

    @classmethod
    def from_irc_task(cls, entry: dict) -> "BusEnvelope":
        """Coerce a legacy flat IRC task queue entry into an envelope."""
        return cls(
            message_id=entry.get("message_id", _ulid()),
            source_bus="irc",
            source_ref=entry.get("channel", ""),
            source_actor=entry.get("nick", ""),
            intent=entry.get("intent", ""),
            task_scope=entry.get("task_scope", "feature"),
            payload_type="text",
            payload={"task_text": entry.get("task_text", "")},
        )


# ---------------------------------------------------------------------------
# Receipt lifecycle
# ---------------------------------------------------------------------------

VALID_STATUSES = frozenset({
    "received", "queued", "processing",
    "payment_required", "fulfilled", "failed", "cancelled",
})

# NIP-90 kind:7000 status mappings (internal → nostr)
NIP90_STATUS_MAP = {
    "received": "payment-required",   # first feedback, before payment decision
    "payment_required": "payment-required",
    "processing": "processing",
    "fulfilled": "success",
    "failed": "error",
    "cancelled": "error",
}


def emit_receipt(
    message_id: str,
    status: str,
    detail: Optional[dict] = None,
    source_bus: str = "irc",
    trace_id: Optional[str] = None,
    *,
    _insert_fn=None,       # injected by gateway: async def (table, row) -> Optional[dict]
    _nostr_fn=None,        # injected by nostr agent: async def (message_id, status, detail) -> None
):
    """
    Emit a receipt for a message. Synchronous wrapper — callers should
    await emit_receipt_async() in async contexts.

    For async use, import emit_receipt_async instead.
    """
    import asyncio
    if asyncio.get_event_loop().is_running():
        asyncio.ensure_future(
            emit_receipt_async(message_id, status, detail, source_bus, trace_id,
                               _insert_fn=_insert_fn, _nostr_fn=_nostr_fn)
        )
    else:
        asyncio.run(
            emit_receipt_async(message_id, status, detail, source_bus, trace_id,
                               _insert_fn=_insert_fn, _nostr_fn=_nostr_fn)
        )


async def emit_receipt_async(
    message_id: str,
    status: str,
    detail: Optional[dict] = None,
    source_bus: str = "irc",
    trace_id: Optional[str] = None,
    *,
    _insert_fn=None,
    _nostr_fn=None,
):
    """
    Persist a receipt row and (if source_bus == 'nostr') fire a NIP-90
    kind:7000 feedback event via the injected _nostr_fn.
    """
    if status not in VALID_STATUSES:
        raise ValueError(f"Invalid receipt status: {status!r}")

    row = {
        "message_id": message_id,
        "trace_id": trace_id or message_id,
        "status": status,
        "at": _now_iso(),
        "detail_json": json.dumps(detail or {}),
        "source_bus": source_bus,
    }

    if _insert_fn is not None:
        try:
            await _insert_fn("bus_receipts", row)
        except Exception as e:
            import logging
            logging.getLogger("bus_envelope").warning("emit_receipt insert failed: %s", e)

    if source_bus == "nostr" and _nostr_fn is not None:
        nostr_status = NIP90_STATUS_MAP.get(status, "error")
        try:
            await _nostr_fn(message_id, nostr_status, detail or {})
        except Exception as e:
            import logging
            logging.getLogger("bus_envelope").warning("emit_receipt nostr feedback failed: %s", e)
