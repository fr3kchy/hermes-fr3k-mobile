---
name: agent-architecture-patterns
description: "Collection of agent architecture patterns discovered across the ecosystem. A2A protocol, GUI agents with RL training, DAG workflows, blackboard architectures, bundle-plugin engineering. Use when designing agent communication, workflow orchestration, or multi-agent systems."
---

# Agent Architecture Patterns

## A2A Protocol (Agent-to-Agent)

Google's Agent-to-Agent protocol for cross-agent communication.
- openclaw-a2a-gateway (434★) — bidirectional agent communication
- Supports: task delegation, result passing, status updates
- Pattern: agents expose capabilities, other agents call them

## DAG Workflow Engines

Debuggable runtime for AI agent workflows:
- DAG pipelines with artifact lineage
- Replayable runs (re-execute from any node)
- Leeway (50★) — YAML-defined DAG workflows

## GUI Agent RL Training

ClawGUI (388★):
- Online reinforcement learning for GUI agents
- Standardized evaluation benchmarks
- Training agents that improve through interaction

## Bundle-Plugin Engineering

bundles-forge (50★):
- Agentic skills as bundles/plugins
- Standardized packaging and distribution
- Plugin architecture for extensibility

## Blackboard Architecture

Classic multi-agent pattern:
- Shared knowledge base (blackboard)
- Agents read/write to blackboard
- Coordinator selects next agent based on state
- Good for: heterogeneous agent teams, complex problem decomposition

## Applicable Patterns

1. **A2A for our specialist roles** — fr3kd3v can call fr3kr3s3arch via protocol
2. **DAG for workflow orchestration** — replace sequential cron with parallel DAG
3. **Bundle packaging for skills** — standardize skill distribution
4. **Blackboard for shared state** — replace file-based state with structured blackboard
