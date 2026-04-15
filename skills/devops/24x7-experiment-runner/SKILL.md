---
name: 24x7-experiment-runner
description: "Deep Researcher Agent (457 stars) — 24/7 autonomous deep learning experiment runner. Features: context resetting between cycles, progress tracking, Obsidian sync, sandboxed tool execution, fallback mechanisms. Use when setting up autonomous long-running experiments, monitoring pipelines, or implementing always-on agent loops."
---

# 24/7 Autonomous Experiment Runner

Source: Xiangyue-Zhang/auto-deep-researcher-24x7 (457 stars) · Apache 2.0
Score: IMPACT=6/10 COMPLEXITY=5/10 RELIABILITY=7/10 — MEDIUM PRIORITY

## Core Concept

AI agent that autonomously runs deep learning experiments 24/7 while you sleep.

## Key Patterns

### 1. Context Resetting Between Cycles
Reduces token growth by resetting leader context between cycles. Prevents context bloat over long runs.

### 2. Fallback Mechanism
Lightweight fallback to avoid repeated no-progress loops. Detects stagnation and switches strategy.

### 3. Sandboxed Tool Execution
Hardened against path traversal and shell injection. Security-first approach to autonomous execution.

### 4. Progress Tracking
Optional Obsidian sync for live dashboard + daily notes. Falls back to project-local text files if no vault configured.

### 5. PROJECT_BRIEF.md as Control File
Single control file defines the entire experiment. Agent reads brief, plans, executes, reports.

## Applicable to Hermes

### Context Reset Pattern
For long-running hermes sessions, implement context reset:
```
Cycle 1: Full context → Execute → Results
  ↓ Reset
Cycle 2: Fresh context + results summary → Execute → Results
  ↓ Reset
...
```
Prevents token bloat over multi-hour sessions.

### Stagnation Detection
Monitor for repeated failures/no-progress:
- Track consecutive no-improvement iterations
- After threshold, change strategy or escalate
- Log stagnation events for pattern analysis

### PROJECT_BRIEF Pattern
For autonomous tasks, use a single control file:
```markdown
# Task Brief
## Objective
## Constraints
## Success Criteria
## Current State
## Next Steps
```
Agent reads brief, plans, executes, updates brief.

### Security Hardening
- Validate all file paths (no traversal)
- Escape shell arguments
- Restrict tool access to project directory
- Log all tool executions
