#!/data/data/com.termux/files/usr/bin/bash
# fr3k phone dashboard
set -euo pipefail
T() { timeout 8 "$@" 2>/dev/null; }

clear
echo "╔══════════════════════════════════════════╗"
echo "║        fr3k PHONE DASHBOARD              ║"
echo "║        $(date '+%Y-%m-%d %H:%M %Z')          ║"
echo "╠══════════════════════════════════════════╣"

# Battery
BATT=$(T termux-battery-status)
if [ -n "$BATT" ]; then
  PCT=$(echo "$BATT" | jq -r '.percentage')
  STATUS=$(echo "$BATT" | jq -r '.status')
  TEMP=$(echo "$BATT" | jq -r '.temperature')
  BAR_LEN=$((PCT / 5))
  BAR=$(printf '█%.0s' $(seq 1 $BAR_LEN 2>/dev/null))
  EMPTY=$(printf '░%.0s' $(seq 1 $((20 - BAR_LEN)) 2>/dev/null))
  echo "║ Battery: [$BAR$EMPTY] ${PCT}%"
  echo "║   Status: $STATUS | Temp: ${TEMP}°C"
fi

# WiFi
WIFI=$(T termux-wifi-connectioninfo)
[ -n "$WIFI" ] && echo "$WIFI" | jq -r '"║ WiFi: \(.ssid) (\(.rssi)dBm)"'

# Network
echo "║ Public IP: $(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo 'N/A')"

# Volume
T termux-volume 2>/dev/null | jq -r '.[] | select(.stream=="music") | "║ Volume: \(.volume)/\(.max_volume)"' 2>/dev/null

# Memory
free -h | awk 'NR==2{printf "║ RAM: %s/%s\n", $3, $2}'

# Storage
df -h /data/data/com.termux/files/home | awk 'NR==2{printf "║ Disk: %s of %s used (%s)\n", $3, $2, $5}'

echo "╠══════════════════════════════════════════╣"
echo "║ Recent SMS:"
T termux-sms-list -l 3 2>/dev/null | \
  jq -r '.[] | "║  [\(.number | .[0:6])] \(.body | .[0:35])..."' 2>/dev/null || \
  echo "║  (no access)"

echo "║ Recent Calls:"
T termux-call-log -l 3 2>/dev/null | \
  jq -r '.[] | "║  \(.type[0:1]) \(.number // .name) \(.date | split("T")[0])"' 2>/dev/null || \
  echo "║  (no access)"

echo "╠══════════════════════════════════════════╣"
echo "║ Termux: 0.118.3 | API: 0.53.0"
uname -r | cut -c1-38 | awk '{printf "║ %s\n", $0}'
echo "╚══════════════════════════════════════════╝"
