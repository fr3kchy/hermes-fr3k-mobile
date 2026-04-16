#!/data/data/com.termux/files/usr/bin/bash
# fr3k phone control v4 — unified CLI
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
T() { timeout 8 "$@" 2>/dev/null; }
SAFE() { local r; r=$(T "$@"); [ -n "$r" ] && echo "$r"; }
ERR() { echo "Error: $1" >&2; exit 1; }
[ $# -eq 0 ] && set -- help

case "$1" in
  # ── STATUS ──
  status)
    echo "=== PHONE STATUS ==="
    SAFE termux-battery-status | jq -r '"Battery: \(.percentage)% [\(.status)] \(.temperature)C"' 2>/dev/null
    SAFE termux-wifi-connectioninfo | jq -r '"WiFi: \(.ssid) | IP: \(.ip) | Signal: \(.rssi)dBm"' 2>/dev/null
    T termux-volume | jq -r '.[] | select(.stream=="music") | "Music: \(.volume)/\(.max_volume)"' 2>/dev/null
    free -h | awk 'NR==2{printf "RAM: %s/%s\n", $3, $2}'
    df -h /data/data/com.termux/files/home | awk 'NR==2{printf "Disk: %s of %s used (%s)\n", $3, $2, $5}'
    echo "IP: $(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo 'N/A')"
    echo "Uptime:$(uptime | sed 's/.*up /up /; s/,.*//')"
    echo "===================="
    ;;

  # ── BATTERY ──
  battery) SAFE termux-battery-status | jq . 2>/dev/null || ERR "Battery unavailable" ;;

  # ── WIFI ──
  wifi) SAFE termux-wifi-connectioninfo | jq . 2>/dev/null || ERR "WiFi unavailable" ;;
  wifi-scan) SAFE termux-wifi-scaninfo | jq . 2>/dev/null || ERR "WiFi scan failed" ;;

  # ── CLIPBOARD ──
  copy)
    [ -z "${2:-}" ] && ERR "Usage: phone copy <text>"
    echo "$2" | T termux-clipboard-set && T termux-toast "Copied" && echo "Done" || ERR "Clipboard set failed"
    ;;
  paste) SAFE termux-clipboard-get || ERR "Clipboard empty" ;;

  # ── NOTIFICATIONS ──
  notify)
    T termux-notification -t "${2:-fr3k}" -c "${3:-}" --id "${4:-fr3k-$(date +%s)}" && echo "Sent" || ERR "Notification failed"
    ;;
  notify-list) SAFE termux-notification-list | jq . 2>/dev/null || ERR "No notifications" ;;
  notify-remove)
    [ -z "${2:-}" ] && ERR "Usage: phone notify-remove <id>"
    T termux-notification-remove "$2" && echo "Removed" || ERR "Remove failed"
    ;;

  # ── SMS & CALLS ──
  sms) SAFE termux-sms-list -l "${2:-5}" | jq '.[] | {from: .number, msg: .body, time: .received}' 2>/dev/null || ERR "SMS unavailable" ;;
  calls) SAFE termux-call-log -l "${2:-5}" | jq '.[] | {name: .name, num: .number, type: .type, time: .date}' 2>/dev/null || ERR "Call log unavailable" ;;

  # ── VOLUME ──
  vol)
    if [ -n "${2:-}" ]; then
      T termux-volume "${3:-music}" "$2" && echo "Vol=$2" || ERR "Volume set failed"
    else
      SAFE termux-volume | jq . 2>/dev/null || ERR "Volume unavailable"
    fi ;;
  mute) T termux-volume music 0 && echo "Muted" || ERR "Mute failed" ;;
  unmute) T termux-volume music 15 && echo "Unmuted" || ERR "Unmute failed" ;;

  # ── SCREEN ──
  brightness)
    [ -z "${2:-}" ] && ERR "Usage: phone brightness <0-255>"
    T termux-brightness "$2" && echo "Brightness=$2" || echo "Note: brightness needs WRITE_SETTINGS permission"
    ;;
  torch) T termux-torch "${2:-on}" && echo "Torch=${2:-on}" || ERR "Torch failed" ;;
  vibrate) T termux-vibrate -d "${2:-500}" && echo "Buzz" || ERR "Vibrate failed" ;;

  # ── SENSORS ──
  sensor)
    case "${2:-list}" in
      list) SAFE termux-sensor -l | jq '.sensors' 2>/dev/null || ERR "Sensor list unavailable" ;;
      accel) SAFE termux-sensor -s acc_bma2x2 -n "${3:-1}" | jq . 2>/dev/null || ERR "Accelerometer failed" ;;
      light) SAFE termux-sensor -s light_ltr569 -n "${3:-1}" | jq . 2>/dev/null || ERR "Light sensor failed" ;;
      steps) SAFE termux-sensor -s "Step Counter" -n "${3:-1}" | jq . 2>/dev/null || ERR "Step counter failed" ;;
      *) SAFE termux-sensor -s "$2" -n "${3:-1}" | jq . 2>/dev/null || ERR "Sensor '$2' failed" ;;
    esac ;;

  # ── TELEPHONY ──
  cell) SAFE termux-telephony-cellinfo | jq . 2>/dev/null || ERR "Cell info unavailable" ;;
  device) SAFE termux-telephony-deviceinfo | jq . 2>/dev/null || ERR "Device info unavailable" ;;

  # ── WAKE ──
  wake-on) T termux-wake-lock && echo "Locked" || ERR "Wake lock failed" ;;
  wake-off) T termux-wake-unlock && echo "Unlocked" || ERR "Wake unlock failed" ;;

  # ── LAUNCHER ──
  open)
    case "${2:-help}" in
      camera)   am start -a android.media.action.IMAGE_CAPTURE 2>/dev/null && echo "Camera" ;;
      settings) am start -a android.settings.SETTINGS 2>/dev/null && echo "Settings" ;;
      wifi)     am start -a android.settings.WIFI_SETTINGS 2>/dev/null && echo "WiFi settings" ;;
      battery)  am start -a android.settings.BATTERY_SAVER_SETTINGS 2>/dev/null && echo "Battery" ;;
      bluetooth) am start -a android.settings.BLUETOOTH_SETTINGS 2>/dev/null && echo "Bluetooth" ;;
      location) am start -a android.settings.LOCATION_SOURCE_SETTINGS 2>/dev/null && echo "Location" ;;
      apps)     am start -a android.settings.APPLICATION_SETTINGS 2>/dev/null && echo "Apps" ;;
      url)      T termux-open-url "${3:-https://mcpintelligence.com.au}" && echo "Opening URL" ;;
      google)   T termux-open-url "https://www.google.com/search?q=${3:-}" && echo "Search: $3" ;;
      maps)     T termux-open-url "https://maps.google.com/?q=${3:-}" && echo "Maps" ;;
      youtube)  T termux-open-url "https://www.youtube.com/results?search_query=${3:-}" && echo "YouTube" ;;
      share)    T termux-share "${3:?Usage: phone open share <file>}" && echo "Shared" ;;
      file)     T termux-open "${3:?Usage: phone open file <path>}" && echo "Opened" ;;
      dl)       T termux-download "${3:?Usage: phone open dl <url>}" && echo "Downloading" ;;
      help|*)
        echo "phone open <target> [args]"
        echo "  camera/settings/wifi/battery/bluetooth/location/apps"
        echo "  url <url>/google <q>/maps <q>/youtube <q>"
        echo "  share <file>/file <path>/dl <url>"
        ;;
    esac ;;

  # ── PRESETS ──
  night)
    T termux-brightness 20 2>/dev/null
    T termux-volume music 0
    T termux-volume ring 0
    T termux-volume notification 0
    echo "Night mode: dim + silent"
    ;;
  day)
    T termux-brightness 200 2>/dev/null
    T termux-volume music 10
    T termux-volume ring 5
    T termux-volume notification 5
    echo "Day mode: bright + audible"
    ;;
  silent)
    T termux-volume ring 0
    T termux-volume notification 0
    T termux-volume system 0
    echo "Silent mode"
    ;;

  # ── TRACKING ──
  track) bash "$DIR/state-tracker.sh" ;;
  trends) bash "$DIR/trends.sh" ;;
  monitor) bash "$DIR/proactive.sh" ;;
  dashboard) bash "$DIR/dashboard.sh" ;;
  sms-read) bash "$DIR/sms-reader.sh" "${2:-5}" ;;

  # ── HELP ──
  help|*)
    cat << 'HELP'
fr3k phone control v4

  status          Full device report
  battery/wifi    Battery or WiFi details
  wifi-scan       Scan nearby networks
  copy <text>     Copy to clipboard
  paste           Get clipboard
  notify <t> <b>  Send notification
  notify-list     List notifications
  notify-remove <id>
  sms [n] / calls [n]
  vol [n] [stream] / mute / unmute
  brightness <0-255> / torch on/off / vibrate [ms]
  sensor list/accel/light/steps [n]
  cell / device   Cell towers / device info
  wake-on / wake-off

  open <target>   Launch apps/sites (camera/settings/wifi/google/maps/youtube)
  night/day/silent  Preset modes

  track           Log phone state
  trends          Battery/temp/wifi trends
  monitor         Proactive alerts (battery/temp/ram/disk)
  dashboard       Visual overview
  sms-read [n]    Formatted SMS reader
HELP
    ;;
esac
