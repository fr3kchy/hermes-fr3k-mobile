---
name: memory-coprocessor-patterns
description: "Memory coprocessor patterns from mnemo-cortex (34★) and ecosystem. Session tapes, watcher daemons, hot/warm/cold tiers, crash-safe storage, bootstrap context generation. Use when designing persistent agent memory, session archival, or context management."
---

# Memory Coprocessor Patterns

Source: mnemo-cortex (34★) — Deep recall for Claude Code, Claude Desktop, OpenClaw.

## Architecture

```
Agent ──writes──▶ Session Tape (disk)
                        │
                  Watcher Daemon ──reads──▶ Mnemo v2 SQLite
                                                │
                  Refresher Daemon ◀──reads─────┘
                        │
                  writes──▶ MNEMO-CONTEXT.md ──▶ Agent Bootstrap
```

## Key Patterns

### 1. Session Tapes
- Agent writes everything to disk (append-only log)
- Separate from agent's working memory
- Survives crashes and restarts

### 2. Watcher Daemon
- Continuously reads session tapes
- Processes into structured SQLite database
- Extracts: entities, relationships, decisions, preferences

### 3. Hot/Warm/Cold Tiers
- **Hot**: Recent sessions (last 24h) — full fidelity
- **Warm**: Last week — compressed summaries
- **Cold**: Older — key facts only, searchable

### 4. Bootstrap Context
- Refresher daemon generates MNEMO-CONTEXT.md
- Loaded at agent startup
- Contains: user preferences, project state, recent decisions
- Prevents "what were we working on?" problem

### 5. Health Monitoring
- `mnemo-cortex health` — verify memory system is operational
- Checks: API server, database, compaction model
- Prevents silent memory failures

## Applicable to Hermes

### Our Current Approach
- SQLite + FTS5 for session memory (good)
- MEMORY-OPTIMIZED.md for persistent memory (good)
- Skills for procedural memory (good)

### Improvements from Mnemo Cortex

1. **Session tapes** — Currently we rely on state.db. Add append-only session tapes as backup.
2. **Hot/warm/cold tiers** — Implement time-based memory compression.
3. **Bootstrap context** — Generate a context snapshot at each session start.
4. **Health checks** — Add memory system health monitoring.

### Implementation

```bash
# Add session tape directory
mkdir -p ~/.hermes/session-tapes

# Add health check script
cat > ~/.hermes/scripts/memory-health.sh << 'EOF'
#!/bin/bash
echo "Memory Health Check"
echo "==================="
echo "State DB: $(test -f ~/.hermes/state.db && echo 'OK' || echo 'MISSING')"
echo "Session tapes: $(ls ~/.hermes/session-tapes/ 2>/dev/null | wc -l) files"
echo "Skills: $(find ~/.hermes/skills -name SKILL.md | wc -l) files"
echo "Memory size: $(du -sh ~/.hermes/state.db 2>/dev/null || echo 'N/A')"
EOF
chmod +x ~/.hermes/scripts/memory-health.sh
```
