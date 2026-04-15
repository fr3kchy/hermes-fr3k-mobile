---
name: sandboxed-execution
description: "Sandboxed agent execution patterns from sandboxed.sh: isolated Linux workspaces (systemd-nspawn), multi-runtime support (Claude Code/OpenCode/Amp), model routing with provider fallback, git-backed skill library. Use when setting up isolated agent execution or provider routing."
---

# Sandboxed Execution Patterns

Source: fr3kchy/sandboxed.sh — Self-hosted cloud orchestrator for AI coding agents.

## Architecture

Isolated Linux workspaces with multi-runtime support. Each agent runs in its own container (systemd-nspawn) with:
- Per-mission directories
- Git-backed library of skills/tools/rules
- Model routing with provider fallback chains

## Key Patterns

### Provider Fallback Chains
```yaml
providers:
  - name: anthropic
    models: [claude-sonnet-4, claude-haiku]
    health_check: true
    rate_limit_handling: backoff
  - name: openrouter
    fallback: true
    models: [anthropic/claude-sonnet-4]
```

### Isolated Workspaces
Each agent mission gets:
- Dedicated container
- Own filesystem
- Restricted network (configurable)
- Persistent storage mount

### MCP Registry
Optional tool servers when needed:
- Desktop automation (Playwright)
- Browser control
- File system access
- External APIs

### Automations
Cron-like triggers for recurring agent runs with:
- Schedule definitions
- Output routing
- Failure handling

## Applicable to Hermes

1. **Provider fallback** — Hermes config.yaml could add fallback chains
2. **Workspace isolation** — Hermes uses local terminal, could add container option
3. **Git-backed skills** — Hermes skills are file-based, could add version control
4. **Health checks** — Monitor provider availability before routing
