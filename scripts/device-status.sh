#!/data/data/com.termux/files/usr/bin/bash
# fr3k device status — comprehensive system report
set -euo pipefail

echo "==============================="
echo "  fr3k DEVICE STATUS REPORT"
echo "  $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "==============================="
echo ""

# Battery
echo "--- BATTERY ---"
termux-battery-status 2>/dev/null | jq -r '"  Level: \(.percentage)%  Status: \(.status)  Health: \(.health)  Temp: \(.temperature)°C"' 2>/dev/null || echo "  (unavailable)"

# Storage
echo ""
echo "--- STORAGE ---"
duf 2>/dev/null | head -5 || df -h / | tail -1

# Memory
echo ""
echo "--- MEMORY ---"
free -h 2>/dev/null | awk 'NR==1{printf "  %-10s %-10s %-10s\n","Total","Used","Free"} NR==2{printf "  %-10s %-10s %-10s\n",$2,$3,$4}'

# Network
echo ""
echo "--- NETWORK ---"
echo "  IP: $(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo 'N/A')"
termux-wifi-connectioninfo 2>/dev/null | jq -r '"  WiFi: \(.ssid)  Signal: \(.rssi)dBm  IP: \(.ip)"' 2>/dev/null || echo "  WiFi: N/A"

# Location
echo ""
echo "--- LOCATION ---"
termux-location -p network 2>/dev/null | jq -r '"  Lat: \(.latitude)  Lon: \(.longitude)  Accuracy: \(.accuracy)m"' 2>/dev/null || echo "  (GPS off or unavailable)"

# System
echo ""
echo "--- SYSTEM ---"
echo "  Kernel: $(uname -r)"
echo "  Uptime: $(uptime | sed 's/.*up /up /' | sed 's/,.*//')"
echo "  Load: $(cat /proc/loadavg | cut -d' ' -f1-3)"

# Top processes
echo ""
echo "--- TOP PROCESSES ---"
procs --sortd cpu 2>/dev/null | head -5 || ps aux --sort=-%cpu 2>/dev/null | head -5

echo ""
echo "==============================="
echo "  Tools: $(pkg list-installed 2>/dev/null | wc -l) packages"
echo "  Python: $(python3 --version 2>/dev/null)"
echo "  Node: $(node --version 2>/dev/null)"
echo "==============================="
