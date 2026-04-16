#!/data/data/com.termux/files/usr/bin/bash
# Battery monitor — alerts at thresholds, logs history
# Run in background or via cron

set -euo pipefail
LOG="$HOME/.hermes/logs/battery.log"
mkdir -p "$(dirname "$LOG")"

BATT=$(timeout 8 termux-battery-status 2>/dev/null)
[ -z "$BATT" ] && exit 0

PCT=$(echo "$BATT" | jq -r '.percentage')
STATUS=$(echo "$BATT" | jq -r '.status')
TEMP=$(echo "$BATT" | jq -r '.temperature')

# Log it
echo "$(date -Iseconds) pct=$PCT status=$STATUS temp=$TEMP" >> "$LOG"

# Alerts
case "$STATUS" in
  DISCHARGING)
    if [ "$PCT" -le 15 ] && [ "$PCT" -gt 10 ]; then
      timeout 5 termux-notification -t "Battery Low" -c "${PCT}% — plug in soon" --id batt-low 2>/dev/null
      timeout 5 termux-vibrate -d 500 2>/dev/null
      echo "ALERT: Battery at ${PCT}%"
    elif [ "$PCT" -le 10 ]; then
      timeout 5 termux-notification -t "BATTERY CRITICAL" -c "${PCT}% — CHARGE NOW" --id batt-crit 2>/dev/null
      timeout 5 termux-vibrate -d 1000 2>/dev/null
      timeout 5 termux-vibrate -d 500 2>/dev/null
      echo "CRITICAL: Battery at ${PCT}%"
    fi
    ;;
  FULL)
    timeout 5 termux-notification -t "Battery Full" -c "100% charged" --id batt-full 2>/dev/null
    echo "Battery full"
    ;;
esac

# Temp warning
TEMP_INT=${TEMP%.*}
if [ "$TEMP_INT" -gt 40 ]; then
  timeout 5 termux-notification -t "Phone Hot" -c "${TEMP}°C — check apps" --id batt-hot 2>/dev/null
  echo "WARNING: Temperature ${TEMP}°C"
fi
