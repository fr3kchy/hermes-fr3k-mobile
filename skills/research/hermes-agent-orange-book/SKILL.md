---
name: hermes-agent-orange-book
description: "Reference knowledge from the Hermes Agent Orange Book v0.7.0 by Nous Research. Architecture patterns: learning loop, three-layer memory, skill self-improvement, FTS5 recall, Honcho user modeling. Comparison with OpenClaw and Claude Code."
---

# Hermes Agent Orange Book Reference

Source: Orange Book series by HuaShu, based on Hermes Agent v0.7.0 (Nous Research, Feb 2026).

## Core Architecture

Hermes flow: Learning Loop -> Three-Layer Memory -> Skill System -> 40+ Tools -> Multi-Platform Gateway

## Learning Loop (5 Steps)

1. Memory Curation: Post-conversation, decides what to remember. SQLite + FTS5 indexing. On-demand retrieval only.
2. Autonomous Skill Creation: Complex tasks distilled to markdown files in skills directory. Agent self-asks if reuse likely.
3. Skill Self-Improvement: User feedback auto-edits skill files permanently. Update-then-apply loop.
4. FTS5 Cross-Session Recall: Full-text search across history. Topic-based, not full-context. Local only.
5. Honcho User Modeling: 12-layer identity inference. Technical level, work rhythm, communication style, goals, emotions, preference contradictions (stated vs revealed).

Flywheel: Memory feeds skills -> skills generate memories -> memories trigger skill improvement -> improved skills -> better results -> better user modeling -> better memory curation.

## Three-Layer Memory

- Session (Episodic): SQLite + FTS5. What happened. On-demand retrieval.
- Persistent (Semantic): Durable state from conversations. Who you are. Auto-loads context.
- Skill (Procedural): Markdown files. How to do things. Self-evolving.

Retrieval strategy: persistent stores summaries, FTS5 searches raw on-demand. Like cheat sheet + filing cabinet.

## Skill System

Three sources: bundled (40+), agent-created (grows with use), community hub.
Standard: agentskills.io (portable across Claude Code, Cursor, Hermes, 30+ tools).
Self-improvement: execute -> collect feedback -> update skill file -> next execution uses new version.

## vs OpenClaw

OpenClaw: manual SOUL.md, 5700+ ClawHub skills, configuration-as-behavior.
Hermes: auto-created skills, self-improving, autonomous background operation.
Both use agentskills.io standard. Skills are portable.

## vs Claude Code

Claude Code: interactive coding, CLAUDE.md + auto-memory, real-time pair programming.
Hermes: autonomous background, three-layer memory, 24/7 operation.
Complementary: Claude Code = day shift (interactive), Hermes = night shift (autonomous).

## Sub-Agent Architecture

Max 3 concurrent. Independent context. Restricted toolsets. Star topology.
Tools always blocked for sub-agents: delegate_task, clarify, memory, send_message, execute_code.

## Deployment

All state in one directory (portable). Options: local, Docker, $5 VPS, serverless (Daytona/Modal).
Config: model provider, toolsets, MCP servers, gateway (Telegram/Discord).
