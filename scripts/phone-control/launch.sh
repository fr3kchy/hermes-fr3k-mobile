#!/data/data/com.termux/files/usr/bin/bash
# Quick app launcher and actions
set -uo pipefail
T() { timeout 8 "$@" 2>/dev/null; }

case "${1:-help}" in
  # ── Apps via intent ──
  camera)   am start -a android.media.action.IMAGE_CAPTURE 2>/dev/null && echo "Camera opened" ;;
  settings) am start -a android.settings.SETTINGS 2>/dev/null && echo "Settings opened" ;;
  wifi-set) am start -a android.settings.WIFI_SETTINGS 2>/dev/null && echo "WiFi settings opened" ;;
  battery-set) am start -a android.settings.BATTERY_SAVER_SETTINGS 2>/dev/null && echo "Battery settings" ;;
  bluetooth) am start -a android.settings.BLUETOOTH_SETTINGS 2>/dev/null && echo "Bluetooth settings" ;;
  location-set) am start -a android.settings.LOCATION_SOURCE_SETTINGS 2>/dev/null && echo "Location settings" ;;
  app-set) am start -a android.settings.APPLICATION_SETTINGS 2>/dev/null && echo "App settings" ;;
  dev-set) am start -a android.settings.APPLICATION_DEVELOPMENT_SETTINGS 2>/dev/null && echo "Dev settings" ;;
  
  # ── Open URLs ──
  web)     T termux-open-url "${2:-https://mcpintelligence.com.au}" && echo "Opening URL" ;;
  google)  T termux-open-url "https://www.google.com/search?q=${2:-}" && echo "Searching: $2" ;;
  github)  T termux-open-url "https://github.com/${2:-fr3kchy}" && echo "Opening GitHub" ;;
  maps)    T termux-open-url "https://maps.google.com/?q=${2:-}" && echo "Opening Maps" ;;
  youtube) T termux-open-url "https://www.youtube.com/results?search_query=${2:-}" && echo "YouTube search" ;;
  
  # ── Share ──
  share)   T termux-share "${2:?Usage: launch.sh share <file>}" && echo "Shared" ;;
  open)    T termux-open "${2:?Usage: launch.sh open <file>}" && echo "Opened" ;;
  
  # ── Download ──
  dl)      T termux-download "${2:?Usage: launch.sh dl <url>}" && echo "Downloading" ;;
  
  # ── Screen control ──
  lock)
    # Best we can do without root: set brightness to 0
    T termux-brightness 0
    T termux-torch off
    echo "Screen minimized (no root lock)"
    ;;
  night)
    T termux-brightness 20
    T termux-volume music 0
    T termux-volume ring 0
    T termux-volume notification 0
    echo "Night mode: dim + silent"
    ;;
  day)
    T termux-brightness 200
    T termux-volume music 10
    T termux-volume ring 5
    T termux-volume notification 5
    echo "Day mode: bright + audible"
    ;;
  
  help|*)
    cat << 'HELP'
launch.sh <cmd> [args]
  Apps:     camera/settings/wifi-set/battery-set/bluetooth/location-set/app-set/dev-set
  Web:      web <url>/google <q>/github <user>/maps <q>/youtube <q>
  Files:    share <file>/open <file>/dl <url>
  Presets:  lock/night/day
HELP
    ;;
esac
