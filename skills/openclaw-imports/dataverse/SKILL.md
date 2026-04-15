---
name: dataverse
description: Dataverse CLI — Query real-time social media data from X/Twitter and Reddit via Bittensor SN13 decentralized network. Use when you need to search social media posts, collect datasets, or analyze Twitter/Reddit sentiment in real-time.
---

# Dataverse Skill

## Overview

Dataverse CLI (`dv`) queries real-time social media data from X/Twitter and Reddit, powered by the Bittensor SN13 decentralized data network.

## Installation

Already installed at: `~/.cargo/bin/dv`

## Setup

```bash
# Get free API key at https://app.macrocosm-os.ai/account?tab=api-keys
dv auth --api-key YOUR_KEY

# Or via environment variable
export MC_API=your-api-key

# Verify
dv status
```

## Usage

```bash
# Search X/Twitter
dv search x -k "bitcoin" -l 10

# Search Reddit
dv search reddit -k "bitcoin" -l 10

# JSON output (for agents)
dv -o json search x -k bitcoin -l 100

# CSV export
dv -o csv search x -k bitcoin -l 1000 > bitcoin_posts.csv

# Dry-run (preview without executing)
dv --dry-run search x -k bitcoin -l 10
```

## Available Commands

- `dv search x -k <keyword>` — Search X/Twitter
- `dv search reddit -k <keyword>` — Search Reddit  
- `dv gravity start` — Start gravity task for continuous collection
- `dv gravity status` — Check gravity task status
- `dv dataset build` — Build dataset from collected data
- `dv auth` — Configure API key
- `dv status` — Show configuration status

## API Key

Get free API key at: https://app.macrocosm-os.ai/account?tab=api-keys

