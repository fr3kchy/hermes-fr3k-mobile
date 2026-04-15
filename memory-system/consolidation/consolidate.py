#!/usr/bin/env python3
"""
Memory Consolidation — Inspired by animaworks' hippocampus model.
Runs periodically to merge episodic memories into semantic knowledge.

Usage: Run via cron or manually.
  python consolidate.py --days 7 --dry-run
"""
import sqlite3
import json
import os
from datetime import datetime, timedelta
from pathlib import Path

HERMES_DIR = Path.home() / ".hermes"
DB_PATH = HERMES_DIR / "state.db"
CONSOLIDATION_LOG = HERMES_DIR / "memory-system" / "consolidation" / "log.jsonl"

def get_recent_memories(days=7):
    """Fetch episodic memories from the last N days."""
    if not DB_PATH.exists():
        return []
    conn = sqlite3.connect(str(DB_PATH))
    try:
        cutoff = (datetime.now() - timedelta(days=days)).isoformat()
        # Adjust query based on actual schema
        rows = conn.execute(
            "SELECT content, metadata, created_at FROM memories WHERE created_at > ? ORDER BY created_at DESC",
            (cutoff,)
        ).fetchall()
        return rows
    except Exception as e:
        print(f"Note: {e} (schema may differ, update query)")
        return []
    finally:
        conn.close()

def consolidate(episodic_memories):
    """
    Distill episodic memories into semantic knowledge.
    Groups by topic, extracts patterns, writes to persistent memory.
    """
    # Group memories by topic clusters
    topics = {}
    for content, meta, ts in episodic_memories:
        # Simple keyword clustering (upgrade to embedding similarity later)
        key = content[:50] if content else "unknown"
        topics.setdefault(key, []).append({"content": content, "meta": meta, "ts": ts})
    
    consolidated = []
    for topic, memories in topics.items():
        if len(memories) >= 3:  # Pattern threshold
            consolidated.append({
                "topic": topic,
                "observation_count": len(memories),
                "first_seen": memories[-1]["ts"],
                "last_seen": memories[0]["ts"],
                "pattern": f"Recurring topic: {topic[:100]}"
            })
    
    return consolidated

def save_consolidation(consolidated, dry_run=True):
    """Save consolidated knowledge."""
    if dry_run:
        print(f"Would consolidate {len(consolidated)} patterns")
        for c in consolidated:
            print(f"  - {c['topic'][:60]} ({c['observation_count']} observations)")
        return
    
    CONSOLIDATION_LOG.parent.mkdir(parents=True, exist_ok=True)
    with open(CONSOLIDATION_LOG, "a") as f:
        for c in consolidated:
            c["consolidated_at"] = datetime.now().isoformat()
            f.write(json.dumps(c) + "\n")
    print(f"Consolidated {len(consolidated)} patterns to {CONSOLIDATION_LOG}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--days", type=int, default=7)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    
    memories = get_recent_memories(args.days)
    print(f"Found {len(memories)} memories from last {args.days} days")
    consolidated = consolidate(memories)
    save_consolidation(consolidated, args.dry_run)
