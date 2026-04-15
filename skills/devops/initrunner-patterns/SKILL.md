---
name: initrunner-patterns
description: "Agent orchestration patterns from InitRunner: YAML-first agent definition, trigger system (cron/file/webhook/heartbeat/Telegram/Discord), daemon mode, self-registering tools, multi-agent flow orchestration. Use when designing agent triggers, daemon workflows, or YAML-based agent configs."
---

# InitRunner Integration Patterns

Source: fr3kchy/initrunner — YAML-first AI agent platform.

## Core Concept: One YAML, Four Modes

Define an agent in role.yaml, then run it as:
- Interactive REPL: `initrun run agent -i`
- Autonomous: `initrun run agent -a -p "task"`
- Daemon (24/7): `initrun run agent --daemon`
- API server: OpenAI-compatible endpoint

Same file, no rewrite between prototyping and production.

## Trigger System

Triggers in `spec.triggers` list, activated with `--daemon`:

```yaml
spec:
  triggers:
    - type: cron
      schedule: "0 9 * * 1"  # Monday 9am
      prompt: "Generate weekly report."
    - type: file_watch
      paths: ["./watched"]
      extensions: [".md", ".txt"]
      prompt_template: "File changed: {path}. Summarize."
    - type: webhook
      path: /webhook
      port: 8080
      secret: ${WEBHOOK_SECRET}
    - type: heartbeat
      interval: 300  # seconds
      checklist: HEARTBEAT.md
    - type: telegram
      token: ${TELEGRAM_BOT_TOKEN}
    - type: discord
      token: ${DISCORD_BOT_TOKEN}
```

## Self-Registering Tools

Add a tool by creating one file in agent/tools/ using decorator:
```python
@register_tool("tool_name", ConfigClass)
def my_tool(config, context):
    ...
```
Auto-discovered via pkgutil.iter_modules().

## Multi-Agent Flow (flow.yaml)

Orchestrate multiple agents with delegation:
```yaml
flow:
  - agent: planner
    delegates_to: [researcher, coder]
  - agent: researcher
    tools: [web, browser]
  - agent: coder
    tools: [terminal, file]
```

## Patterns Applicable to Hermes

1. **Daemon mode** — Hermes cron jobs are similar but less flexible
2. **File watch triggers** — Hermes doesn't have this natively, consider adding
3. **Webhook triggers** — Hermes gateway handles this differently
4. **Heartbeat trigger** — Hermes has heartbeat concept, initrunner's is more structured
5. **Self-registering tools** — Hermes skills are similar but markdown-based
