#!/data/data/com.termux/files/usr/bin/bash
# Phone state tracker
set -uo pipefail
LOG="$HOME/.hermes/data/phone-state.jsonl"
mkdir -p "$(dirname "$LOG")"
T() { timeout 6 "$@" 2>/dev/null; }

BATT=$(T termux-battery-status)
WIFI=$(T termux-wifi-connectioninfo)
VOL=$(T termux-volume)
MEM=$(free | awk 'NR==2{printf "%d,%d,%d", $2, $3, $4}')
DISK=$(df /data/data/com.termux/files/home | awk 'NR==2{printf "%d,%d,%d", $2, $3, $4}')
PCT=$(echo "$BATT" | jq -r '.percentage // 0')
STATUS=$(echo "$BATT" | jq -r '.status // "unknown"')
TEMP=$(echo "$BATT" | jq -r '.temperature // 0')
PLUGGED=$(echo "$BATT" | jq -r '.plugged // "unknown"')
SSID=$(echo "$WIFI" | jq -r '.ssid // "none"')
SIGNAL=$(echo "$WIFI" | jq -r '.rssi // 0')
MUSIC_VOL=$(echo "$VOL" | jq -r '[.[] | select(.stream=="music") | .volume][0] // 0')

# Compact JSON
echo "{\"ts\":\"$(date -Iseconds)\",\"battery\":{\"pct\":$PCT,\"status\":\"$STATUS\",\"temp\":$TEMP,\"plugged\":\"$PLUGGED\"},\"wifi\":{\"ssid\":\"$SSID\",\"signal\":$SIGNAL},\"vol\":$MUSIC_VOL,\"mem\":{\"total\":$(echo $MEM | cut -d, -f1),\"used\":$(echo $MEM | cut -d, -f2),\"free\":$(echo $MEM | cut -d, -f3)},\"disk\":{\"total\":$(echo $DISK | cut -d, -f1),\"used\":$(echo $DISK | cut -d, -f2),\"avail\":$(echo $DISK | cut -d, -f3)}}" >> "$LOG"

tail -1000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
echo "State logged: batt=${PCT}% temp=${TEMP}C wifi=${SSID}"
