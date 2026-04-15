---
name: github-repo-audit
description: Analyze a GitHub user's repos for integration potential into a local agent system
category: github
---

# GitHub Repo Audit

**Trigger:** User wants to assess their GitHub repos for tools/configs/skills to integrate into their local agent system.

## Steps

1. **List repos** with metadata:
   ```bash
   gh repo list <user> --limit 30 --json name,description,updatedAt,pushedAt,primaryLanguage,isPrivate,defaultBranchRef
   ```

2. **Triage by recency and description.** Sort by pushedAt desc. Categorize into tiers:
   - **Tier 1:** Directly relevant to agent system (memory, skills, config, tooling)
   - **Tier 2:** Strategic value (trading, research, deployment)
   - **Tier 3:** Reference/inspiration only

3. **Clone Tier 1 repos** (shallow):
   ```bash
   gh repo clone fr3kchy/<repo> <local-dir> -- --depth 1
   ```

4. **Read key files** in each repo:
   - README.md (first 80-100 lines for overview)
   - Project convention files if present (agent instructions, contribution guides)
   - Config files (capabilities.yaml, config.yaml, etc.)
   - Main source entry points (first 200 lines of core files)

5. **Summarize integration value** per repo:
   - What it does (1 sentence)
   - Key integration points
   - How it plugs into the local agent system

## Pitfalls

- **Subagents are slow for this.** Parallel subagent analysis of repos frequently times out. Use direct sequential analysis instead — read READMEs and key files yourself. Subagents work better for deeper single-repo analysis after initial triage.
- **Large repos** can take 60s+ to clone. Set timeout=60 and retry if needed.
- **PDF extraction** — install pymupdf first, then use the terminal script approach (not the execute_code sandbox). See python-pdf-extraction skill if available.
- **Read long files in chunks** (limit=300-500 lines). Don't try to read 100K+ char files at once.
