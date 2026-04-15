# Agent Swarm Orchestration (Enhanced)

Multi-agent coordination using OpenClaw's native `sessions_spawn`.

## Quick Commands

```bash
# List all agents
node ~/scripts/swarm.js list

# Auto-route a query
node ~/scripts/swarm.js route "I need to write a blog post"

# Spawn specific agent
node ~/scripts/swarm.js spawn fr3kd3v "Fix the login bug"
```

## Architecture

```
User Message
     │
     ▼
┌─────────────┐
│ Triage      │ ← Routes to best specialist
└─────────────┘
     │
     ├──────► fr3kr3s3arch (research)
     ├──────► fr3kwr1t3 (writing)
     ├──────► fr3kstr4t (strategy)
     ├──────► fr3kd3v (development)
     ├──────► fr3ks0c (social)
     ├──────► fr3kdrops (dropship)
     ├──────► fr3ksales (sales)
     └──────► fr3ksupport (support)
```

## Agent IDs

| Agent | Role | Keywords |
|-------|------|----------|
| fr3kr3s3arch | Research | research, search, find, info |
| fr3kwr1t3 | Writing | write, blog, post, content |
| fr3kstr4t | Strategy | strategy, plan, analysis |
| fr3kd3v | Development | code, build, dev, deploy |
| fr3ks0c | Social | social, twitter, linkedin |
| fr3kdrops | Dropship | product, affiliate, dropship |
| fr3ksales | Sales | sales, lead, outreach |
| fr3ksupport | Support | support, help, issue |

## Parallel Execution

Spawn multiple agents at once:

```javascript
// Research + Strategy + Writing combo
await Promise.all([
  sessions_spawn({ agentId: "fr3kr3s3arch", task: "...", mode: "run" }),
  sessions_spawn({ agentId: "fr3kstr4t", task: "...", mode: "run" }),
  sessions_spawn({ agentId: "fr3kwr1t3", task: "...", mode: "run" }),
]);
```

## Triggers
- "coordinate agents"
- "use swarm"
- "delegate to team"
- Spawn any agent directly by name
