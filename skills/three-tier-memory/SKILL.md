---
name: three-tier-memory
description: Episodic, semantic, and procedural memory management inspired by Phantom's architecture
category: autonomous-ai-agents
---

# Three-Tier Memory System

Inspired by Phantom's vector memory architecture. Adapts the concept to work within Hermes Agent's memory system.

## Memory Tiers

### 1. Episodic Memory (Session Transcripts)
- **What**: Outcomes of past sessions, tasks completed, errors encountered
- **Where**: `session_search` tool (already exists — use it)
- **When**: User references "last time", "we did this before", or you suspect cross-session context
- **Format**: Session summaries with key decisions and outcomes

### 2. Semantic Memory (Accumulated Facts)
- **What**: Stable facts about the user, environment, project conventions
- **Where**: `memory` tool with target='memory' (internal) or target='user' (user profile)
- **When**: You learn something that will matter in future sessions
- **Key rules**:
  - Only persist facts that will still matter in 30+ days
  - User preferences > environment facts > procedural knowledge
  - Keep entries compact (<200 chars each)
  - Total budget: ~2000 chars across all entries
  - Never save task progress, session state, or TODO items

### 3. Procedural Memory (Learned Workflows)
- **What**: Reusable approaches, solutions to recurring problems, optimized workflows
- **Where**: `skill_manage` tool — creates/modifies skills
- **When**:
  - After complex tasks (5+ tool calls) that could recur
  - After fixing tricky errors that might repeat
  - After discovering non-trivial workflows
  - After user-corrected approaches that worked
- **Key rules**:
  - Include trigger conditions ("use when...")
  - Numbered steps with exact commands
  - Document pitfalls and failure modes
  - Include verification steps

## Cross-Tier Query Strategy

When the user asks about something from the past:

1. **First**: Check semantic memory (injected every turn automatically)
2. **Second**: Search episodic memory via `session_search(query=...)`
3. **Third**: Check procedural memory via `skill_view(name)` if a relevant skill exists
4. **Only then**: Ask the user to repeat themselves

## Memory Hygiene

- After each session, review: what should be promoted to semantic memory?
- After completing a complex workflow, evaluate: should this become a skill?
- Periodically: prune stale memory entries, update outdated skills
- If a skill is wrong/outdated, patch it immediately — don't wait
