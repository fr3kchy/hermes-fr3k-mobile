---
name: ace-context-engineering
description: "Agentic Context Engineering (ACE) framework by ace-agent/ace (965 stars). Three-role self-improvement architecture: Generator, Reflector, Curator. Evolves contexts as playbooks through incremental delta updates. +10.6% on agent tasks, 86.9% lower adaptation latency. Use when implementing self-improvement loops, skill evolution, or memory optimization."
---

# ACE — Agentic Context Engineering

Source: ace-agent/ace (965 stars) · Paper: arxiv.org/abs/2510.04618
Score: IMPACT=9/10 COMPLEXITY=5/10 RELIABILITY=8/10 — HIGH PRIORITY

## Core Concept

Treats contexts as evolving playbooks that accumulate, refine, and organize strategies through structured roles. Solves two critical problems:
- **Brevity bias**: Iterative summarization loses detail
- **Context collapse**: Rewriting erodes knowledge over time

## Three-Role Architecture

### 1. Generator
- Produces reasoning trajectories for new queries
- Uses playbook (accumulated knowledge) + reflection (past feedback)
- Surfaces effective strategies AND recurring pitfalls
- Maps to: our skill execution + memory recall

### 2. Reflector
- Analyzes generator outputs
- Tags bullets as helpful/harmful/neutral
- Separates evaluation from curation (key insight)
- Extracts insights without curation bias
- Maps to: our post-task evaluation

### 3. Curator
- Converts lessons into structured delta updates
- Uses helpful/harmful counters for ranking
- Operations: ADD, UPDATE, MERGE, DELETE
- Deterministic merging with de-duplication and pruning
- Maps to: our skill self-improvement

## Incremental Delta Updates

Instead of rewriting the entire playbook:
- Localized edits preserve prior knowledge
- New insights accumulated incrementally
- Helpful/harmful counters track bullet quality
- De-duplication prevents redundancy
- Pruning removes low-value entries

## Key Metrics

- +10.6% improvement on agent tasks (AppWorld)
- +8.6% on domain-specific benchmarks (Finance)
- -86.9% adaptation latency vs existing methods
- -75.1% rollouts vs GEPA
- -83.6% token cost vs Dynamic Cheatsheet

## Applicable to Hermes

### Direct Integration Points

1. **Playbook = Skills + Memory**
   - Our skills are ACE "bullets" — strategies with helpful/harmful tracking
   - Our memory entries are playbook entries
   - Add helpful/harmful counters to each skill

2. **Generator = Skill Execution**
   - When executing a skill, use playbook (relevant skills + memory)
   - Track which bullets were used
   - Record reasoning trace

3. **Reflector = Post-Task Evaluation**
   - After task completion, analyze what worked/didn't
   - Tag skills used as helpful/harmful/neutral
   - Extract new insights (potential new skills)
   - Separate evaluation from curation

4. **Curator = Skill Evolution**
   - Based on reflector feedback:
     - ADD: new insights → new skill
     - UPDATE: refine existing skill based on feedback
     - MERGE: combine similar skills
     - DELETE: remove ineffective skills
   - Use helpful/harmful counters for quality ranking

### Implementation Pattern

```
Task → Generator (load skills + memory) → Execute → Result
                                              ↓
                                         Reflector (analyze, tag)
                                              ↓
                                         Curator (ADD/UPDATE/MERGE/DELETE)
                                              ↓
                                         Updated Playbook
```

### Anti-Patterns ACE Prevents

1. **Brevity bias**: Don't summarize skills into oblivion — keep detailed steps
2. **Context collapse**: Don't overwrite skills — use delta updates
3. **Knowledge erosion**: Don't lose old knowledge — accumulate incrementally
4. **Redundancy**: De-duplicate similar strategies
5. **Low-value clutter**: Prune bullets with negative helpful/harmful ratio

## Quick Implementation

Add to each skill file frontmatter:
```yaml
---
name: skill-name
helpful_count: 0
harmful_count: 0
last_used: null
last_reflected: null
---
```

After each skill use, reflector updates counters. Curator uses counters to decide ADD/UPDATE/MERGE/DELETE.
