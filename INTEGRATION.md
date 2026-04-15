# OpenClaw fr3k Setup — Integration Guide for New Agents

This document lets any OpenClaw / Hermes / NemoClaw agent replicate fr3k's full setup on a fresh server.

---

## Architecture

```
Telegram (control) ──► OpenClaw Gateway ──► Agents
                                │
                    ┌───────────┼───────────┐
                    ▼           ▼           ▼
               Bybit        Supabase    Social
               Scalper      (DB/intel)  (LinkedIn/X/TikTok)
                    │
                    ▼
               TradeMemory
               (trade recall)
```

---

## Repos

| Repo | URL | Purpose |
|------|-----|---------|
| openclaw-workspace | https://github.com/fr3kchy/openclaw-workspace | Core config, SOUL.md, skills |
| openclaw-bybit-scalper | https://github.com/fr3kchy/openclaw-bybit-scalper | Trading bot |
| openclaw-private | https://github.com/fr3kchy/openclaw-private | Private infra configs |

---

## Step 1: OpenClaw Core

```bash
npm install -g openclaw
openclaw init
openclaw gateway start
```

---

## Step 2: Clone Workspace

```bash
git clone https://github.com/fr3kchy/openclaw-workspace.git ~/.openclaw/workspace
```

Key files to configure:
- SOUL.md — agent identity and rules
- USER.md — fr3k's preferences
- TOOLS.md — infra endpoints and API keys
- HEARTBEAT.md — self-evolution protocol
- AGENTS.md — agent routing

---

## Step 3: Environment Variables

Create `~/.openclaw/.env`:

```
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-key

# Bybit
BYBIT_API_KEY=your-key
BYBIT_API_SECRET=your-secret

# GitHub
GITHUB_TOKEN=ghp_xxx

# Telegram
TELEGRAM_BOT_TOKEN=xxx
```

---

## Step 4: Bybit Scalper

```bash
git clone https://github.com/fr3kchy/openclaw-bybit-scalper.git ~/openclaw-bybit-scalper
cd ~/openclaw-bybit-scalper
npm install
node cli.js start
```

Full setup: see SETUP.md in that repo.

---

## Step 5: TradeMemory

TradeMemory records every trade decision and outcome for recall.

```bash
pip install fastapi uvicorn pydantic
git clone https://github.com/fr3kchy/tradememory-protocol.git /tmp/tradememory-protocol
cd /tmp/tradememory-protocol
pip install -e .
python3 -m uvicorn src.tradememory.server:app --port 8765 --host 127.0.0.1 &

# Test
curl http://localhost:8765/health
```

---

## Step 6: Supabase Tables

```sql
-- Intel ingestion
CREATE TABLE intel_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source TEXT NOT NULL,
  title TEXT,
  content TEXT,
  url TEXT,
  tags TEXT[],
  sentiment REAL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- CRM leads
CREATE TABLE leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source TEXT,
  name TEXT,
  contact TEXT,
  status TEXT DEFAULT 'new',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

memory fabric tables are now part of the stack too:
- memory_threads
- memory_events
- memory_entities
- memory_facts
- memory_evaluations

apply with:
- sql/memory_fabric_schema.sql
- or use the already-applied migration on project ibsrbnazaorbclczomib

runtime integration now live:
- local cache db: memory/memory_fabric.db
- stream-ingest writes local + attempts Supabase write-through
- governance audit/evaluation writes local + attempts Supabase write-through
- recorder uses credentials from workspace .env.supabase and /home/fr3k/.hermes/secrets/supabase.env

---

## Step 7: Cron Jobs

```
# OSINT ingest every 10min
*/10 * * * * cd ~/workspace/stream-ingest && python3 pipeline/runner.py --sources ai_scout,hackernews,arxiv --once

# TradeMemory sync every 15min
*/15 * * * * cd ~/openclaw-bybit-scalper && node scripts/export-trades.js

# Workspace backup 3am daily
0 3 * * * cd ~/.openclaw/workspace && git add -A && git commit -m "auto-backup" && git push
```

---

## Step 8: Systemd Service (Scalper)

```bash
cat > ~/.config/systemd/user/openclaw-bybit-scalper.service << 'SVCEOF'
[Unit]
Description=OpenClaw Bybit Scalper
After=network.target

[Service]
Type=simple
WorkingDirectory=%h/openclaw-bybit-scalper
ExecStart=/usr/bin/node cli.js start
Restart=on-failure
RestartSec=10
StandardOutput=append:%h/.openclaw-bybit-scalper/bot.log
StandardError=append:%h/.openclaw-bybit-scalper/bot.log
MemoryMax=768M

[Install]
WantedBy=default.target
SVCEOF

systemctl --user daemon-reload
systemctl --user enable --now openclaw-bybit-scalper
```

---

## Verification Checklist

- openclaw gateway status shows running
- Telegram bot responds to messages
- Scalper starts: `node ~/openclaw-bybit-scalper/cli.js start`
- TradeMemory health: `curl localhost:8765/health`
- Supabase connection works
- GitHub push works

---

## Scalper Strategies

The scalper runs 7 concurrent strategies:

- breakout_vol — volume breakout with momentum
- recovery_swing — mean reversion after sharp drops
- anti_chop — trend-following with RSI filter
- defensive_carry — low-volatility carry trades
- momentum_htf — higher timeframe momentum
- gann — Gann angle analysis
- baseline — default fallback strategy

---

## What fr3k's Setup Does Automatically

Every 5min: Evolution engine updates HEARTBEAT-STATE.md
Every 10min: OSINT ingest from HackerNews, arXiv, Reddit, GitHub
Every 15min: Signal consumer routes intel to agents + revenue ops
Every 28min: ArchAgents (arch-ceo, arch-dev, arch-strat) review state and write directives
Every 15min: Scalper syncs trades to TradeMemory
Daily 6am: Competitor scan
Daily 3am: Workspace backup to GitHub

---

## Agent Routing

- code/build/fix → fr3kd3v
- research/search → fr3kr3s3arch
- write/blog/content → fr3kwr1t3
- strategy/plan → fr3kstr4t
- social/linkedin/tiktok → fr3ks0c
- sales/leads → fr3ksales
- support → fr3ksupport
