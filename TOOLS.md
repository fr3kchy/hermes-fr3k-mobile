# TOOLS.md — Infrastructure Config

> Behavioral rules → SOUL.md | This file: env-specific config only

## Voice
- **Script:** `~/.openclaw/workspace/scripts/freek-voice.sh [casual|info|urgent] "msg"`
- **Status helper:** `~/.openclaw/workspace/scripts/voice-status.sh [casual|info|urgent] --doing "..." --risk "..." --changing "..." --next "..." [--tone psycho|plain]`
- **Target:** parrot (100.88.25.64, Tailscale) | User: fr3k | Key: ~/.ssh/id_ed25519_openclaw
- **Voices:** Emily=casual (en-IE) | Sonia=info (en-GB) | Michelle=urgent (en-US) @ 1.3x

## Talking Avatar
- **Talking Face / Avatar:** https://www.visionstory.ai/s/rqpRoLakerk
- Use this as the talking avatar face for visual output

## AI Tools
- Codex: `/usr/bin/codex` | Claude: `/usr/bin/claude` | Gemini: `/usr/bin/gemini` | OpenCode: `/usr/bin/opencode`

## Swarm
```bash
node ~/scripts/swarm.js list
node ~/scripts/swarm.js route "task"
node ~/scripts/swarm.js spawn fr3kd3v "task"
```

## Browser (CDP)
- Endpoint: http://localhost:9222 | Profile: /home/openclaw/remote-chromium-profile

## MCP Servers
- filesystem (14 tools) | memory (9 tools) | sequential-thinking (1 tool)
- Usage: `mcporter list` | `mcporter call memory.create_entities ...`

## Opik
- Dashboard: https://www.comet.com/pimp-daai/fr3kd3v-openclaw
- Query: `python3 ~/.openclaw/workspace/scripts/opik-query.py summary`

## Dropship (fr3kdrops)
- Amazon: `fionamoranmus-22` | Shopify: https://shopify.pxf.io/9Vg0y5
- Website: https://mcpintelligence.com.au | Workspace: `workspace-fr3kdrops/`

## Revenue Pipeline
- **Storefront**: https://mcpintelligence.com.au
- **Shopify Products**:
  - Founder's Rate — Custom AI Agent System: $10,000 AUD
  - Standard Rate — Custom AI Agent System: $25,000+ AUD
  - Bybit Scalper Ops Pack (Setup & Tuning): $3,000 AUD
- **Lead CRM**: Supabase `leads` table
- **Intake**: Tally/Typeform webhook → `revenue/intake_queue.jsonl`
- **Delivery**: `revenue/delivery_engine.py` — generates custom SOUL.md/MEMORY.md/HEARTBEAT.md + emails

## Social
- LinkedIn: @fr3k-stylin | TikTok: post/engage/trends | YouTube: upload/analytics

## APIs
- Groq, OpenRouter, HuggingFace: configured ✅
- Jina Reader (free): `curl "https://r.jina.ai/http://URL"`
- Buffer: ⚠️ OAuth not set up yet

## Gateway Gotcha
- `openclaw doctor --fix` to repair invalid config keys (`agents.list[0].workload`, `routing`)
- Review diff before running blind

## Context Engineering (Travis Drake)
Pattern applied in all multi-attempt automation scripts:
- `context_tracker.py` at `workspace/scripts/context_tracker.py`
- **5 Principles**: First-class context | Hierarchical layers (L1/L2/L3) | State compression | Failure pattern memory | Context handoff
- **Usage**: `from context_tracker import ContextTracker` → `ctx = ContextTracker(...)` → `ctx.begin_attempt("PLATFORM")` → `state.record_failure(...)` → `ctx.final_report()`
- State format: `[PLATFORM:attempt=N,popup=Y,file=Y,status=verified,fails=0]`

## fr3k Bridge (Meta-Agent Layer)
- **API Server**: http://localhost:8899 (real OpenClaw data via CLI bridge)
- **Proxy/UI**: http://localhost:8765 (dashboard + API proxy)
- **Startup**: `bash ~/.openclaw/fr3k/start-fr3k-bridge.sh [start|stop|restart|status]`
- **Source**: `~/.openclaw/fr3k/` (upstream: ddxfish/sapphire v2.4.0)
- **Key**: `~/.openclaw/keys/fr3k-api.key`
- **Issues DB**: `~/.openclaw/fr3k/issues.json`
- **Endpoints**: `/status`, `/api/companies/{id}/agents`, `/api/agents/{id}`, `/api/companies/{id}/issues`, `/api/issues`, `/api/companies/{id}/metrics`, `/api/companies/{id}/heartbeats`, `/api/services`
- **Cron**: `@reboot` auto-start
- **Logs**: `/tmp/sapphire-api.log`, `/tmp/sapphire-proxy.log`

## Unified Pantheon (MCP)
- **Server:** `unified-pantheon` via mcporter
- **Source:** `/home/openclaw/.openclaw/workspace/unified-pantheon/`
- **Tools:**
  - `get_demon_angel_pair` — retrieve demon-angel pair by number (1–72)
  - `analyze_technology` — analyze tech against dual acceleration/counter framework
  - `trigger_auto_improvement` — run improvement methods
  - `get_improvement_history` — review improvement logs
  - `get_improvement_metrics` — pull metrics
- **Resources:**
  - `improvement://history` — auto-improvement audit trail
  - `improvement://metrics` — current performance metrics
  - `pantheon://framework` — full framework overview (72+72+7+6 entities)
- **Integration Points:**
  - Grimoire pipeline → entity cross-reference
  - Research intel → technology analysis via dual framework
  - Content generation → themed narratives from demon/angel pairs
  - Trading ops → risk/acceleration pattern mapping
  - Revenue → persuasion/counter framework for sales copy

## Agent Reach (OSINT)
- **Installed**: 2026-03-29 | Version: 1.3.0
- **Source**: https://github.com/Panniantong/Agent-Reach (11,258 stars)
- **Skill**: `/home/openclaw/.openclaw/skills/agent-reach/SKILL.md`
- **Active channels**: 9/16 (GitHub, YouTube, V2EX, RSS, Exa, Jina, Reddit, B站, WeChat)
- **Usage**: 
  - `mcporter call 'exa.web_search_exa(...)'` — web search
  - `curl -s "https://r.jina.ai/URL"` — read any page
  - `bird search "query"` — Twitter search
  - `yt-dlp --dump-json URL` — YouTube/B站 subtitles
  - `gh search repos "query"` — GitHub search
