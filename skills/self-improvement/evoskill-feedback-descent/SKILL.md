---
name: evoskill-feedback-descent
description: "EvoSkill (484 stars, sentient-agi) — Automated skill discovery for coding agents using Feedback Descent algorithm. GEPA/DSPy-style self-improvement. Agent-agnostic, cross-model, cross-task transferable. Paper: arxiv.org/abs/2603.02766. Use when implementing automated skill evolution, benchmark-driven improvement, or failure-pattern learning."
---

# EvoSkill — Automated Skill Discovery

Source: sentient-agi/EvoSkill (484 stars) · Paper: arxiv.org/abs/2603.02766
Score: IMPACT=9/10 COMPLEXITY=7/10 RELIABILITY=8/10 — HIGHEST PRIORITY

## Core Algorithm: Feedback Descent

From paper arxiv.org/abs/2511.07919. Optimizes text artifacts (skills) through structured textual feedback rather than scalar rewards.

### Algorithm Loop
```
1. Initialize: x* <- x0, feedback_history <- []
2. For t = 1 to max_iterations:
   a. Propose: candidate <- proposer(x*, feedback_history)
   b. Compare: preference, rationale <- evaluator(x*, candidate)
   c. Record: feedback_history.append(rationale)
   d. Update: if preference_for_candidate: x* <- candidate, feedback_history <- []
   e. Early stop: if no improvement for k iterations, break
3. Return x*
```

### Key Components
- **Proposer**: Generates skill candidates from current best + feedback history
- **Evaluator**: Pairwise comparison of current best vs candidate
- **Feedback history**: Accumulated rationales for improvement direction
- **Early stopping**: No improvement for k iterations = stop

## What Makes EvoSkill Different

1. **Pairwise comparison** — not absolute scoring. "Is candidate better than current?" is more reliable than "rate this 1-10"
2. **Structured textual feedback** — rationale for each comparison, not just a score
3. **Feedback history reset** — when improvement found, reset history (fresh start from new best)
4. **Failure-pattern learning** — identifies agent failures, proposes skill improvements to fix them
5. **Cross-agent transferable** — skills evolved in Claude Code work in Codex, OpenClaw, etc.
6. **Cross-model transferable** — skill evolved with one LLM transfers to others
7. **Cross-task transferable** — a SealQA skill can improve BrowseComp performance

## Applicable to Hermes

### Direct Integration

Map to our cycle:
- **RESEARCH** → Proposer (find what to improve based on failure patterns)
- **EVALUATE** → Evaluator (pairwise comparison with rationale)
- **INTEGRATE** → Update x* when candidate wins
- **REFLECT** → Feedback history accumulates, guides next proposal

### Implementation Pattern

```python
# Simplified Feedback Descent for skill evolution
class SkillEvolver:
    def evolve(self, skill, max_iterations=20):
        best = skill
        history = []
        no_improvement = 0
        
        for t in range(max_iterations):
            # Propose: based on best + feedback history
            candidate = self.propose(best, history)
            
            # Evaluate: pairwise comparison
            result = self.evaluate(best, candidate)
            
            # Record feedback
            history.append(result.rationale)
            
            # Update if candidate wins
            if result.preference_for_candidate:
                best = candidate
                history = []  # Reset on improvement
                no_improvement = 0
            else:
                no_improvement += 1
            
            # Early stopping
            if no_improvement >= 5:
                break
        
        return best
```

### Key Insights for Our System

1. **Reset feedback on improvement** — don't carry stale rationales forward
2. **Pairwise > absolute** — "better than before?" is more reliable than "how good?"
3. **Failure patterns = improvement targets** — each failure is a skill improvement opportunity
4. **Frontier size** — keep top N performing programs, not just one best
5. **Concurrent evaluation** — evaluate multiple candidates in parallel

### Comparison with ACE

| Aspect | ACE (context engineering) | EvoSkill (skill evolution) |
|--------|--------------------------|---------------------------|
| Focus | Context/playbook optimization | Skill file optimization |
| Method | Generator/Reflector/Curator | Feedback Descent |
| Feedback | Helpful/harmful counters | Pairwise comparison + rationale |
| Update | ADD/UPDATE/MERGE/DELETE | Replace best on win, reset history |
| Scope | Conversation context | Skill files (SKILL.md) |

Both are complementary: ACE optimizes what the agent KNOWS, EvoSkill optimizes what the agent DOES.
