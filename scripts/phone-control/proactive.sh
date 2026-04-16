#!/data/data/com.termux/files/usr/bin/bash
# Proactive phone alerts — checks conditions and notifies
# Run every 10-15 min via cron
set -uo pipefail
T() { timeout 6 "$@" 2>/dev/null; }
NOTIFY() { T termux-notification -t "$1" -c "$2" --id "$3"; }

BATT=$(T termux-battery-status)
PCT=$(echo "$BATT" | jq -r '.percentage // 100')
STATUS=$(echo "$BATT" | jq -r '.status // "unknown"')
TEMP=$(echo "$BATT" | jq -r '.temperature // 0')
TEMP_INT=${TEMP%.*}
PLUGGED=$(echo "$BATT" | jq -r '.plugged // "unknown"')

ALERTS=0

# Battery alerts
if [ "$STATUS" = "DISCHARGING" ]; then
  if [ "$PCT" -le 10 ] 2>/dev/null; then
    NOTIFY "BATTERY CRITICAL" "${PCT}% — CHARGE NOW" "batt-crit"
    T termux-vibrate -d 1000
    T termux-vibrate -d 500
    echo "CRITICAL: battery ${PCT}%"
    ALERTS=1
  elif [ "$PCT" -le 20 ] 2>/dev/null; then
    NOTIFY "Battery Low" "${PCT}% — find a charger" "batt-low"
    T termux-vibrate -d 500
    echo "WARNING: battery ${PCT}%"
    ALERTS=1
  fi
elif [ "$STATUS" = "FULL" ] && [ "$PLUGGED" = "UNPLUGGED" ]; then
  : # already unplugged after full, no alert
fi

# Temperature
if [ "$TEMP_INT" -gt 42 ] 2>/dev/null; then
  NOTIFY "PHONE OVERHEATING" "${TEMP}C — close apps, remove case" "phone-hot"
  T termux-vibrate -d 500
  echo "CRITICAL: temp ${TEMP}C"
  ALERTS=1
elif [ "$TEMP_INT" -gt 38 ] 2>/dev/null; then
  NOTIFY "Phone Warm" "${TEMP}C — monitor usage" "phone-warm"
  echo "WARNING: temp ${TEMP}C"
  ALERTS=1
fi

# WiFi signal weak
WIFI=$(T termux-wifi-connectioninfo)
SIGNAL=$(echo "$WIFI" | jq -r '.rssi // 0')
if [ "$SIGNAL" -lt -85 ] 2>/dev/null && [ "$SIGNAL" -ne 0 ] 2>/dev/null; then
  NOTIFY "Weak WiFi" "Signal: ${SIGNAL}dBm — consider moving" "wifi-weak"
  echo "WARNING: weak signal ${SIGNAL}dBm"
  ALERTS=1
fi

# RAM high
MEM_USED=$(free | awk 'NR==2{printf "%d", $3*100/$2}')
if [ "$MEM_USED" -gt 85 ] 2>/dev/null; then
  NOTIFY "Memory High" "${MEM_USED}% RAM used — close apps" "ram-high"
  echo "WARNING: RAM ${MEM_USED}%"
  ALERTS=1
fi

# Disk space low
DISK_PCT=$(df /data/data/com.termux/files/home | awk 'NR==2{gsub(/%/,""); print $5}')
if [ "$DISK_PCT" -gt 90 ] 2>/dev/null; then
  NOTIFY "Storage Low" "${DISK_PCT}% used — clean up" "disk-low"
  echo "WARNING: disk ${DISK_PCT}%"
  ALERTS=1
fi

[ "$ALERTS" -eq 0 ] && echo "All clear: batt=${PCT}% temp=${TEMP}C ram=${MEM_USED}% disk=${DISK_PCT}%"
