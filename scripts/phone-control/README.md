# fr3k Phone Control System

Android Termux phone automation — battery, WiFi, SMS, clipboard, sensors, notifications, volume, brightness, torch.

## Scripts

| Script | Purpose |
|--------|---------|
| `phone.sh` | Main CLI — 17 commands |
| `dashboard.sh` | Visual device overview |
| `battery-monitor.sh` | Auto-alerts at 15%/10%/hot temp |
| `clip-history.sh` | Clipboard change tracker |
| `sms-reader.sh` | Formatted SMS reader |

## Quick Start

```bash
# Add to ~/.bashrc
export PHONE="$HOME/phone-control"
alias phone='bash $PHONE/phone.sh'
alias dashboard='bash $PHONE/dashboard.sh'
alias battmon='bash $PHONE/battery-monitor.sh'
alias sms='bash $PHONE/sms-reader.sh'
alias cliphist='bash $PHONE/clip-history.sh'
```

## Commands

```
phone status         Full device report
phone battery        Battery JSON
phone wifi           WiFi info
phone copy "text"    Copy to clipboard
phone paste          Get clipboard
phone notify t body  Send notification
phone notify-list    List notifications
phone sms 5          Last 5 SMS
phone calls 5        Last 5 calls
phone vol            Get volumes
phone vol 10 music   Set music volume
phone mute/unmute    Quick toggle
phone brightness 200 Set brightness (0-255)
phone torch on/off   Flashlight
phone vibrate 500    Vibrate 500ms
phone sensor list    List sensors
phone sensor accel 1 Read accelerometer
phone cell           Cell tower info
phone device         Device info
phone wake-on/off    Wake lock
```

## Requirements

- Termux (F-Droid)
- Termux:API (F-Droid)
- bash, jq, coreutils

## Cron Jobs

```bash
# Battery monitor — every 15 min
*/15 * * * * bash ~/phone-control/battery-monitor.sh

# Clipboard tracker — every 5 min
*/5 * * * * bash ~/phone-control/clip-history.sh
```

## Known Limitations

- `termux-location` — often hangs (GPS off)
- `termux-camera-photo` — hangs (camera permission)
- `termux-contact-list` — permission denied
- `termux-speech-to-text` — permission denied
- All timeouts set to 8 seconds
