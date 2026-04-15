# Paperclip Operations Skill

> Version: 2026-03-29 | Based on Fru Dev & Greg Isenberg research

## Overview

This skill provides commands for managing Paperclip AI agent fleet. Paperclip is an open-source platform for building zero-human companies with AI agents working 24/7.

## Core Commands

### Health Check
```bash
curl -s http://localhost:3100/api/health
```

### Status
```bash
# Paperclip API
curl -s http://localhost:3100/api/health | jq .

# Check processes
pgrep -a paperclip

# Check embedded Postgres
curl -s localhost:54329
```

## Key Features (from Research)

### 1. Agent Marketplace (Clonet)
- Hire external agents from the Clonet marketplace
- Always vet agents before hiring
- Set budget caps to prevent runaway spending
- Human-in-the-loop approval required

### 2. Org Chart Management
- Agents report to other agents (hierarchical)
- Chief of Staff can't hire without owner permission
- Assign specific skills to agents (e.g., OpenClaw)

### 3. Governance
- Budget caps per agent ($2 demo default)
- Kill switch for oversight
- Approval workflows for hiring

## Optimization Patterns

### Crontab Consolidation
- Merge redundant jobs (provider-monitor + telemetry)
- Stagger OSINT pipeline (avoid collisions)
- Single asset generation schedule

### Process Management
- Kill stale onboard processes
- Monitor with health checks
- Use Paperclip API for real-time status

## Integration Points

### OpenClaw
- Paperclip runs on localhost:3100
- PostgreSQL on port 54329
- Use for fleet management

### Revenue Pipeline
- Agents can handle lead follow-up
- OSINT → Intel → Evolution → Revenue flow
- Assign agents to specific tasks

## Best Practices

1. Always set budget caps on new agents
2. Vet marketplace agents before hiring
3. Use human-in-the-loop for sensitive ops
4. Monitor agent costs regularly
5. Keep org chart lean and clear

