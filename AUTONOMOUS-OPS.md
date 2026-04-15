# AUTONOMOUS OPS

## Purpose
This file defines the default continuation trigger for the workspace: after major work, the system should keep moving by updating state, reviewing operations, and pushing the next highest-value tasks without waiting for unnecessary user input.

## Active Continuation Rule
- Do the obvious next task unless ambiguity, destruction risk, or external approval is genuinely required.
- Prefer execution over status chatter.
- After substantial work, refresh:
  - `SESSION-STATE.md`
  - `working-buffer.md`
  - `TODO.md` priorities if they changed
- Use `scripts/autonomous-ops-loop.sh` as the continuity trigger.

## Business Default Focus
When no sharper instruction exists, push these lanes:
1. Revenue and sales systems
2. Product reliability / OpenClaw hardening
3. Trading risk control
4. Documentation and automation cleanup

## Current High-Value Targets
- TRADE-001 — improve trading bot sell win rate safely
- AUTO-001 — implement autonomous task queue
- sales/business improvements and repeatable operating packs

## Safety Boundary
Do not make destructive or high-risk external changes blindly. Continue autonomously on analysis, hardening, reporting, packaging, cleanup, and safe automation.

## Unified Pantheon Integration

### Symbolic-Strategic Pattern Library
The pantheon provides 72+72+7+6 entities with technology mappings and acceleration/counter mechanics. This serves as a structured symbolic layer for autonomous decision-making.

### Macro-Pattern Classification
- **Supremes** classify incident/change types: Pride (Lucifer), Chaos (Leviathan), Opposition (Satan), Deception (Belial), Pollution (Azazel), Secrets (Baphomet), Death (Samael)
- **Archangels** provide counter-patterns: Authority (Metatron), Protection (Michael), Communication (Gabriel), Healing (Raphael), Wisdom (Uriel), Faith (Selaphiel)

### Usage in Autonomous Loops
- Event classification uses demon/angel pair matching
- Auto-improvement stubs leverage the 28 ML methods
- All symbolic outputs flagged for `symbolic` tier per grimoire-schema-design.md

### MCP Access
```bash
mcporter call unified-pantheon.get_demon_angel_pair '{"pair_number": 1}'
mcporter call unified-pantheon.analyze_technology '{"technology_name":"Kubernetes","description":"container orchestration"}'
```
