---
name: self-improvement
description: Autonomous self-improvement cycle — research, evaluate, test, integrate, reflect
category: autonomous-ai-agents
---

# Self-Improvement Protocol

## Research Phase
1. Search GitHub trending repos (AI/ML/agent categories) via web_search
2. Search ArXiv for recent AI agent papers (tool use, planning, memory, autonomy)
3. Check Hacker News for AI tool announcements
4. Scan Reddit r/MachineLearning, r/LocalLLaMA for new tools
5. Check Twitter/X AI agent community for breakthroughs

## Evaluation Criteria
For each discovery, score 1-5:
- **Impact**: Does it measurably improve reasoning, tool use, memory, planning, coding, or efficiency?
- **Redundancy**: Do I already have an equivalent? Is it superior?
- **Integration Complexity**: How hard to add? (1=trivial skill, 5=infrastructure change)
- **Reliability**: Active maintenance, community trust, stability

Only pursue items with Impact >= 4 AND (Integration Complexity <= 3 OR Impact = 5).

## Testing Phase
- Create a concrete test scenario before adopting
- Compare against current baseline
- Evaluate: performance, accuracy, efficiency, robustness
- Discard anything without clear measurable improvement

## Integration Phase
- Convert validated improvements into reusable skills via skill_manage
- Update workflows, replace inferior approaches
- Install tools, clone repos, write code as needed
- Never break working systems without fallback

## Reflection Phase
- Identify weaknesses in search strategy, evaluation, testing, integration
- Patch this skill with lessons learned
- Log failures to memory to avoid repeating

## Companion Skills
- `command-compressor` — compress CLI output 70-95% (lean-ctx patterns)
- `three-tier-memory` — episodic/semantic/procedural memory management (phantom patterns)
- `evolution-gate` — conditional firing gate to avoid wasted cycles (phantom patterns)

## Research Sources (verified working)
- GitHub API: `api.github.com/search/repositories` — sort by stars, filter by date
- ArXiv API: `export.arxiv.org/api/query` — may need retry
- HN Algolia: `hn.algolia.com/api/v1/search_by_date` — filter by time range
- Reddit: `reddit.com/r/{sub}/search.json` — needs User-Agent header

## Research Sources (known issues on Termux/Android)
- ArXiv sometimes returns empty (intermittent)
- Some GitHub binary releases won't run (TLS alignment issues)
- pip installs can timeout (building from source on aarch64)

## Persistence
- Save discoveries to memory (target: memory)
- Save successful procedures as skills via skill_manage
- Log failed approaches to avoid repeating
- If binary tools fail on Android, extract patterns and implement natively
