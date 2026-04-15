# HEARTBEAT-STATE.md
> Updated: 2026-04-03T07:40+10:00 (2026-04-02T21:40 UTC)
> Purpose: executive state feed for command, trading, revenue, and governance review

## Executive Summary
- **EQUITY: ~$97** | DOWN ~$3 from $100 reset
- Scalper: **active** PID fresh (restarted)
- Scenario execution bug FIXED — shadow-only now properly blocked
- Legacy shadow-only positions CLOSED by fr3k manually (16:22)
- journal.jsonl now recording trade-open/trade-close (patched at 07:25)
- BUG FIXED: `listEnabledScenarioNames` now uses `executionEnabled` not `enabled`

## Service Health
- openclaw-gateway.service: active
- openclaw-bybit-scalper.service: **active (restarted 07:40 — latest patch applied)**
- avatar-daemon.service: active

## Route Pressure
- **trading-ops: UNDER WATER** — equity below $100 reset, legacy positions closed

## Trading Ops
### Current State
- **Scalper: STOPPED** by fr3k directive 2026-04-06 09:08
- Equity: **~$97** (DOWN from $100 reset)
- Open positions: **NONE**
- Service: systemd inactive, process killed (PID 2487934)

### What Just Happened (2026-04-03 07:25-07:40)
1. Journal persistence bug fixed: live closes now written to journal.jsonl
2. Scenario execution bug fixed: `listEnabledScenarioNames` was checking `enabled` not `executionEnabled`
   - Caused: breakout_vol, recovery_swing, defensive_carry etc. still running live
   - Patch: changed filter to use `isScenarioExecutionEnabled()` check
3. Service restarted to apply both patches
4. Legacy positions (SOLVUSDT, XPLUSDT, STABLEUSDT) still open from pre-fix era

### Bugs Fixed This Session
- [x] deriveSideAdjustments drift ceiling (scalper.js ~line 6056)
- [x] stress regime hard-block replaced with high-bar gating
- [x] config.js DEFAULT_CONFIG patched — scenario flags locked at source
- [x] journal persistence for live trade opens/closes (appendJournal calls added)
- [x] listEnabledScenarioNames now uses executionEnabled not enabled flag

### What Still Needs Work
- [x] Close or manage legacy shadow-only positions — CLOSED by fr3k 16:22
- [ ] Equity recovery above $100
- [ ] Verify new execution gate stops shadow-only scenarios on next candidate cycle
- [ ] Monitor fill quality on maker entries

## Revenue Ops
- No change. Storefront: https://mcpintelligence.com.au

## Narrative Output
- No immediate signals

## Governance
- ULTRAWORK authorized by fr3k directive
- Adaptation mode: live
- Continuous monitoring until equity > $100

## Directives
- **MONITOR**: New trades must NOT go into shadow-only scenarios (breakout_vol, recovery_swing, etc.)
- **ALERT**: Drift warning if Buy.scoreThresholdOffset exceeds 3.0
- **NEXT**: Monitor scalper performance with clean slate — no legacy baggage

---
## Scalper Service Fix (2026-04-06)
### Issue
- ERR_MODULE_NOT_FOUND for config.js despite file existing
- Root cause: Node.js ESM specifier resolution fails through systemd 
- WorkingDirectory mismatch in old service file

### Fix Applied
1. Created `/home/openclaw/.openclaw-bybit-scalper/start-wrapper.mjs` - ESM wrapper that fixes module resolution
2. Updated systemd service to use wrapper instead of cli.js directly  
3. Fixed scalper-watchdog.sh pgrep pattern encoding issue

### Current Status
- Scalper: **ACTIVE** via systemd service (PID 2512746 — restarted 09:11 after death at ~09:11)
- Cycles: running clean
- VIX: ELEVATED 23.87 — watch mode
