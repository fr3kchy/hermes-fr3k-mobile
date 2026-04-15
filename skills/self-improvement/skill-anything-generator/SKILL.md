---
name: skill-anything-generator
description: "SkillAnything (146 stars, AgentSkillOS) — Meta-skill that generates production-ready skills from any target (CLI tool, API, library, workflow). 7-phase pipeline: Analyze → Design → Implement → Test → Benchmark → Optimize → Package. Compatible with Claude Code, OpenClaw, Codex, generic. Use when creating new skills for any software or service."
---

# SkillAnything — Meta-Skill Generator

Source: AgentSkillOS/SkillAnything (146 stars) · v1.0.0 · MIT
Score: IMPACT=8/10 COMPLEXITY=4/10 RELIABILITY=7/10 — HIGH PRIORITY

## Concept

"One target in, production-ready Skills out." A skill that generates skills. Give it any target and it runs an automated 7-phase pipeline.

## 7-Phase Pipeline

```
Target: "jq" or "Stripe API" or "data pipeline"
  |
  v
[Analyze] → [Design] → [Implement] → [Test] → [Benchmark] → [Optimize] → [Package]
  |                                                                              |
  v                                                                              v
analysis.json                                                    dist/
                                                                  ├── claude-code/
                                                                  ├── openclaw/
                                                                  ├── codex/
                                                                  └── generic/
```

### Phases

1. **Analyze** — Understand target: commands, API endpoints, workflows, capabilities
2. **Design** — Design skill structure: triggers, steps, error handling, examples
3. **Implement** — Write SKILL.md with frontmatter, instructions, code snippets
4. **Test** — Validate skill against real usage scenarios
5. **Benchmark** — Measure skill quality (completeness, accuracy, efficiency)
6. **Optimize** — Refine based on benchmark results
7. **Package** — Output multi-platform skill packages (Claude Code, OpenClaw, Codex, generic)

## Applicable to Hermes

### Direct Usage

When fr3k says "create a skill for X", instead of manually writing SKILL.md:
1. Run SkillAnything pipeline on X
2. Get production-ready SKILL.md with proper frontmatter
3. Get multi-platform output (works in hermes, openclaw, claude code)

### Integration with Prime Directive

During RESEARCH phase, when discovering a new tool:
1. RESEARCH finds tool X
2. EVALUATE confirms X is valuable
3. **SkillAnything generates skill for X** (instead of manual writing)
4. TEST validates the generated skill
5. INTEGRATE adds to skill library

This automates step 3 of our cycle — the most tedious part.

### Quick Implementation

```bash
# To generate a skill for any target
cd ~/.hermes/skills
mkdir -p generated/<target-name>
# Run SkillAnything pipeline (or manual equivalent):
# 1. Analyze target capabilities
# 2. Design skill structure
# 3. Write SKILL.md
# 4. Test
# 5. Package
```
