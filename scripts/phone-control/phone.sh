#!/data/data/com.termux/files/usr/bin/bash
# fr3k phone control
set -euo pipefail
T() { timeout 8 "$@" 2>/dev/null; }

case "${1:-help}" in
  status)
    echo "=== PHONE STATUS ==="
    BATT=$(T termux-battery-status)
    [ -n "$BATT" ] && echo "$BATT" | jq -r '"Battery: \(.percentage)% [\(.status)] \(.temperature)C"'
    WIFI=$(T termux-wifi-connectioninfo)
    [ -n "$WIFI" ] && echo "$WIFI" | jq -r '"WiFi: \(.ssid) | IP: \(.ip) | Signal: \(.rssi)dBm"'
    VOL=$(T termux-volume | jq -r '.[] | select(.stream=="music") | "Music: \(.volume)/\(.max_volume)"' 2>/dev/null)
    [ -n "$VOL" ] && echo "$VOL"
    echo "RAM: $(free -h | awk 'NR==2{printf "%s/%s", $3, $2}')"
    df -h /data/data/com.termux/files/home | awk 'NR==2{print "Disk: "$3" of "$2" used ("$5")"}'
    echo "IP: $(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo 'N/A')"
    echo "===================="
    ;;
  battery) T termux-battery-status | jq . ;;
  wifi) T termux-wifi-connectioninfo | jq . ;;
  wifi-scan) T termux-wifi-scaninfo | jq . ;;
  copy) echo "$2" | T termux-clipboard-set; T termux-toast "Copied"; echo "Done" ;;
  paste) T termux-clipboard-get ;;
  notify) T termux-notification -t "${2:-fr3k}" -c "${3:-}" --id "${4:-fr3k-$(date +%s)}"; echo "Sent" ;;
  notify-list) T termux-notification-list | jq . ;;
  notify-remove) T termux-notification-remove "$2"; echo "Removed" ;;
  sms) T termux-sms-list -l "${2:-5}" | jq '.[] | {from: .number, msg: .body, time: .received}' ;;
  calls) T termux-call-log -l "${2:-5}" | jq '.[] | {name: .name, num: .number, type: .type, time: .date}' ;;
  vol)
    if [ -n "${2:-}" ]; then T termux-volume "${3:-music}" "$2"; echo "Vol=$2"
    else T termux-volume | jq .; fi ;;
  mute) T termux-volume music 0; echo "Muted" ;;
  unmute) T termux-volume music 15; echo "Unmuted" ;;
  brightness) T termux-brightness "${2:-128}"; echo "Brightness=${2:-128}" ;;
  torch) T termux-torch "${2:-on}"; echo "Torch=${2:-on}" ;;
  vibrate) T termux-vibrate -d "${2:-500}"; echo "Buzz" ;;
  sensor)
    case "${2:-list}" in
      list) T termux-sensor -l | jq '.sensors' ;;
      accel) T termux-sensor -s acc_bma2x2 -n "${3:-1}" | jq . ;;
      light) T termux-sensor -s light_ltr569 -n "${3:-1}" | jq . ;;
      steps) T termux-sensor -s "Step Counter" -n "${3:-1}" | jq . ;;
      *) T termux-sensor -s "$2" -n "${3:-1}" | jq . ;;
    esac ;;
  cell) T termux-telephony-cellinfo | jq . ;;
  device) T termux-telephony-deviceinfo | jq . ;;
  wake-on) T termux-wake-lock; echo "Locked" ;;
  wake-off) T termux-wake-unlock; echo "Unlocked" ;;
  help|*)
    cat << 'HELP'
phone.sh <cmd>
  status/battery/wifi/wifi-scan
  copy <text>/paste
  notify <title> <body> [id]/notify-list/notify-remove <id>
  sms [n]/calls [n]
  vol [n] [stream]/mute/unmute
  brightness <0-255>/torch on/off/vibrate [ms]
  sensor list/accel/light/steps
  cell/device/wake-on/wake-off
HELP
    ;;
esac
