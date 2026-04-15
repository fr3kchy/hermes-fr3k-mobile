---
name: clawrouter
description: ClawRouter — smart LLM router for autonomous agents. Reduces AI API costs by up to 92%. Uses wallet signatures (no API keys) and x402 USDC micropayments. Routes to 55+ models automatically based on 15-dimension scoring.
---

# ClawRouter Skill

## Overview

ClawRouter is the only LLM router built for autonomous AI agents:
- **No API keys** — wallet signature = authentication
- **No credit cards** — USDC per-request via x402 protocol
- **55+ models** — OpenAI, Anthropic, Google, xAI, DeepSeek, and more
- **92% cost savings** — automatic routing to cheapest capable model
- **<1ms routing** — runs locally, zero external dependencies

## Installation

```bash
npm install -g @blockrun/clawrouter
```

## Usage

```bash
# Start the router server
clawrouter --port 8402

# Or as MCP server
clawrouter --mcp

# Check status
clawrouter doctor

# View reports
clawrouter report daily
```

## Configuration

In openclaw.json:
```json
{
  "extensions": {
    "clawrouter": {
      "walletKey": "0x...",  // Optional - auto-generated
      "routing": {}  // Override routing config
    }
  }
}
```

## For Agents

ClawRouter routes requests automatically based on:
- Task complexity (reasoning depth needed)
- Latency requirements
- Cost constraints
- Model capabilities

Agents just make requests — ClawRouter picks the optimal model.

