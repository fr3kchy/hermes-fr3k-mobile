#!/data/data/com.termux/files/usr/bin/bash
# Phone trends — analyze state history
set -uo pipefail
LOG="$HOME/.hermes/data/phone-state.jsonl"
[ ! -f "$LOG" ] && echo "No state history yet. Run state-tracker.sh first." && exit 0
ENTRIES=$(wc -l < "$LOG")
[ "$ENTRIES" -lt 2 ] && echo "Need more data points (have $ENTRIES, need 2+)" && exit 0

echo "=== PHONE TRENDS ==="

# Battery drain rate
echo ""
echo "--- Battery Drain ---"
FIRST_PCT=$(head -1 "$LOG" | jq -r '.battery.pct')
LAST_PCT=$(tail -1 "$LOG" | jq -r '.battery.pct')
FIRST_TS=$(head -1 "$LOG" | jq -r '.ts')
LAST_TS=$(tail -1 "$LOG" | jq -r '.ts')
DRAIN=$((FIRST_PCT - LAST_PCT))
echo "  Start: ${FIRST_PCT}% at ${FIRST_TS}"
echo "  Now:   ${LAST_PCT}% at ${LAST_TS}"
echo "  Drain: ${DRAIN}% over tracking period"
if [ "$DRAIN" -gt 0 ] 2>/dev/null; then
  # Estimate hours to empty
  HOURS_TRACKED=$(jq -s '(last.ts as $end | first.ts as $start | ($end | sub("[+]..:..$"; "Z") | fromdateiso8601) - ($start | sub("[+]..:..$"; "Z") | fromdateiso8601)) / 3600' "$LOG" 2>/dev/null)
  if [ -n "$HOURS_TRACKED" ] && [ "$(echo "$HOURS_TRACKED > 0" | bc 2>/dev/null)" = "1" ]; then
    RATE=$(echo "scale=1; $DRAIN / $HOURS_TRACKED" | bc 2>/dev/null)
    REMAINING=$(echo "scale=0; $LAST_PCT / $RATE" | bc 2>/dev/null)
    echo "  Rate: ${RATE}%/hr | Est. ${REMAINING}hrs to empty"
  fi
fi

# Temperature
echo ""
echo "--- Temperature ---"
jq -s '[.[].battery.temp] | "  Min: \(min)C | Max: \(max)C | Avg: \((add/length * 10 | round / 10))C"' "$LOG" 2>/dev/null

# WiFi
echo ""
echo "--- WiFi ---"
jq -s '[.[].wifi.ssid] | unique | "  Networks: \(join(", "))"' "$LOG" 2>/dev/null
jq -s '[.[].wifi.signal] | "  Signal: min \(min)dBm | max \(max)dBm"' "$LOG" 2>/dev/null

# Memory
echo ""
echo "--- Memory ---"
jq -s 'last | .mem | "  RAM: \(.used/1024 | round)MB / \(.total/1024 | round)MB (\(.used*100/.total | round)%)"' "$LOG" 2>/dev/null

echo ""
echo "  Data points: $ENTRIES"
echo "===================="
