---
name: openspace
description: OpenSpace — self-evolving AI agent engine. Makes agents smarter, lower-cost, and self-evolving. Use when you want agent skills to auto-learn, auto-fix, and share intelligence across agents.
---

# OpenSpace Skill

## Overview

OpenSpace is a self-evolving engine that plugs into AI agents (OpenClaw, Claude Code, Codex, nanobot, etc.) and gives them three superpowers:

### 🧬 Self-Evolution
- **AUTO-FIX** — When a skill breaks, it fixes itself
- **AUTO-IMPROVE** — Successful patterns become better skill versions
- **AUTO-LEARN** — Captures winning workflows from usage
- **Quality monitoring** — Tracks skill performance and error rates

### 🌐 Collective Agent Intelligence
- **Shared evolution** — One agent's improvement becomes everyone's upgrade
- **Network effects** — More agents → richer data → faster evolution
- **Easy sharing** — Upload/download evolved skills with one command

### 💰 Token Efficiency
- Smarter agents, dramatically lower costs (46% fewer tokens reported)

## Installation

```bash
# Clone and install
git clone https://github.com/HKUDS/OpenSpace.git
cd OpenSpace
pip install -e .

# Or install dependencies only
pip install litellm python-dotenv openai jsonschema mcp anthropic flask pydantic requests
```

## Usage

### MCP Server Mode
```bash
# Stdio mode (default)
python -m openspace.mcp_server

# SSE on port 8080
python -m openspace.mcp_server --transport sse

# Custom port
python -m openspace.mcp_server --port 9090
```

### Available MCP Tools
- `execute_task` — Delegate a task (auto-registers skills, auto-searches, auto-evolves)
- `search_skills` — Search across local & cloud skills
- `fix_skill` — Manually fix a broken skill
- `upload_skill` — Upload a local skill to cloud

## Environment Variables

Copy `.env.example` to `.env` and configure:
- `OPENAI_API_KEY` — For OpenAI models
- `ANTHROPIC_API_KEY` — For Claude models
- `LITELLM_API_KEY` — For LiteLLM
- Cloud sharing: see `openspace/cloud/auth.py`

## Dashboard

```bash
python -m openspace.dashboard_server
```
Opens a web UI for viewing skills, evolution history, and agent performance.

