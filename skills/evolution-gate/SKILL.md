---
name: evolution-gate
description: Conditional self-improvement gate — only evolve when there is signal, avoid wasted cycles
category: autonomous-ai-agents
---

# Evolution Gate Pattern

Inspired by Phantom's conditional firing gate. Prevents wasted self-improvement cycles by only running when there is genuine signal.

## Gate Decision (run BEFORE starting a full research cycle)

Ask these questions in order:

1. **Last cycle timestamp**: Has it been at least 8 hours since the last cycle? If NO → skip.
2. **Recent failures**: Did we hit errors, dead ends, or user corrections in the last 3 sessions? If YES → fire (learn from failures).
3. **User request**: Did the user ask for improvement or mention a gap? If YES → fire.
4. **Staleness**: Have we searched the same sources 3+ times with no findings? If YES → expand scope (new sources, adjacent domains).
5. **Default**: If none of the above → skip cycle, log "gate skipped: no signal".

## Scoring Calibration

After each cycle, self-evaluate the gate's accuracy:

| Outcome | Gate Accuracy |
|---------|--------------|
| Found useful improvement | Gate was correct to fire |
| Nothing useful found, cycle was quick | Gate was borderline — acceptable |
| Nothing useful found, cycle was long | Gate was wrong — tighten criteria |
| Missed an important discovery | Gate was wrong — loosen criteria |

Adjust gate thresholds based on accuracy over the last 5 cycles.

## Anti-Stagnation Rules

If 3 consecutive cycles find nothing:
1. Expand search to adjacent domains (robotics, PL theory, systems design)
2. Search in different languages (中文, 日本語 communities)
3. Try reverse engineering: what are top AI labs using that is not public yet?
4. Lower the Impact threshold from 4 to 3 temporarily

## Failsafe

If the gate itself seems broken (e.g., always skipping or always firing):
- Force one full cycle regardless
- Evaluate results
- Reset gate calibration
