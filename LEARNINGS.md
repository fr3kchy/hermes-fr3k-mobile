# LEARNINGS.md — fr3kclaw Knowledge Log
Auto-maintained by hermes-autolearn skill.
Each entry = a workflow, fix, or pattern worth remembering.

---

## 2026-03-27 18:40 — Scalper Config Tuning

**What:** Fixed structural loss in Bybit scalper after 39-trade analysis
**Pattern:** 72% win rate + 3.34x loss/win ratio = structural loser. Fix: widen partial TP (0.8→1.5 ATR), raise trailing activation (0.5→1.2 ATR), ban micro-cap shitcoins under $50M 24h volume
**Skill created/updated:** none (config change, not skill)
**Outcome:** Profit factor went from 0.78 → 3.91. Win rate held at 82%. Net PnL flipped from -$2.64 → +$2.84 in same session
**Revert if:** Win rate drops below 60% for 20+ trades after these changes

---

## 2026-03-27 18:30 — Research: OpenClaw Alternatives

**What:** Comprehensive research into nanoclaw, memu bot, hermes agent, NemoClaw
**Pattern:** Hermes Agent (NousResearch) is real feature-parity competitor with `hermes claw migrate` for OpenClaw users. memUBot has superior memory architecture. NanoClaw is security-focused minimal version.
**Skill created/updated:** hermes-autolearn (new)
**Outcome:** Decision: stay on OpenClaw, adapt Hermes self-learning loop

---

## 2026-03-27 10:10 — Scalper Full Reset

**What:** Reset scalper after drawdown event
**Pattern:** Post-mortem on 8340 trades showed stops too tight (53% stop loss hits, avg -59.5bps). Fix: widen to 1.6-1.8 ATR stops, raise TP to 2.2-2.4 ATR, keep only 3 proven scenarios (defensive_carry, breakout_vol, recovery_swing)
**Skill created/updated:** none (config reset)
**Outcome:** Partial success — new issue found with micro-cap slippage, fixed same day

## Unified Pantheon Build (2026-03-28)

**Lesson**: Sub-agents consistently failed on large file generation tasks. Multiple timeouts and empty write validation errors. Direct inline execution via exec + heredocs worked correctly on first attempt.

**What worked**:
- Direct exec with chunked heredocs (cat >>) for large files
- Building TypeScript with `npx tsc` after install
- Testing via direct Node.js ESM import before calling it done

**What failed**:
- Sub-agent file writes (validation errors on empty content)
- Trying to add prototype methods outside class definition (TypeScript doesn't see them)
- Moving files to /tmp then forgetting and losing track

**Result**: UnifiedPantheonCore with 158 entities, 28 auto-improvement methods, TypeScript build clean, MCP server operational
