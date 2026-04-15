---
name: sentrux
description: Sentrux — code quality sensor for AI agents. Scans projects to provide structural health grades (A-F) across 14 dimensions including coupling, cycles, cohesion, dead code, and test coverage. Use when the user wants to check code quality, architecture health, or before/after an agent session.
---

# Sentrux Skill

## Overview

Sentrux is a Rust-based code quality sensor that helps AI agents understand and improve code structure. It provides:
- **14-dimensional health scoring** (A-F grades)
- **Dependency cycle detection**
- **Coupling analysis**
- **Dead code detection**
- **Test coverage gaps**
- **Quality gates for CI/CD**

## Installation (if not in PATH)

```bash
# Linux x86_64
curl -L -o /usr/local/bin/sentrux https://github.com/sentrux/sentrux/releases/download/v0.5.7/sentrux-linux-x86_64
chmod +x /usr/local/bin/sentrux
```

## Usage

### CLI Mode
```bash
sentrux .                    # Scan current directory (GUI)
sentrux check .              # CLI rules check (CI-friendly)
sentrux gate --save .        # Save baseline before agent session
sentrux gate .               # Compare after — catches degradation
```

### MCP Server Mode
```bash
sentrux --mcp               # Start MCP server for AI agents
```

## Integration

This skill works with the sentrux MCP server. If sentrux is installed and running in MCP mode, use the `scan` tool to analyze code.

For manual scanning, run:
```bash
sentrux check /path/to/project
```

## MCP Tools Available

When connected to sentrux MCP:
- `scan` — Full project scan with overview
- `health` — Code health breakdown
- `architecture` — Structural analysis
- `coupling` — Coupling analysis
- `cycles` — Dependency cycles
- `hottest` — Hotspots identification
- `test_gaps` — Test coverage gaps
- `session_start` / `session_end` — Quality gates

