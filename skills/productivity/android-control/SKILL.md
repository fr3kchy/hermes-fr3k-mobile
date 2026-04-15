---
name: android-control
description: Control Android phone from Termux CLI - launch apps, open URLs, manage settings, send intents. Works without root.
version: 1.0.0
triggers:
  - launch app
  - open settings
  - open URL
  - phone control
  - android automation
---

# Android Control (Termux)

## Capabilities (No Root Required)

### 1. Launch Settings Screens
```
am start -n com.android.settings/.Settings                          # Main settings
am start -n com.android.settings/.Settings\$WifiSettingsActivity     # WiFi
am start -n com.android.settings/.Settings\$BluetoothSettingsActivity # Bluetooth
am start -n com.android.settings/.Settings\$DisplaySettingsActivity  # Display
am start -n com.android.settings/.Settings\$SoundSettingsActivity    # Sound
am start -n com.android.settings/.Settings\$LocationSettingsActivity # Location
```

### 2. Open URLs (Deep Links)
```
am start -a android.intent.action.VIEW -d "https://linkedin.com"
am start -a android.intent.action.VIEW -d "https://tiktok.com"
termux-open-url "https://example.com"
```
URLs auto-open in the right app if installed (Chrome, Maps, etc.)

### 3. Send Broadcasts
```
am broadcast -a com.termux.api.clipboard
am broadcast -a android.intent.action.BATTERY_LOW  # Test only
```

### 4. System Info
```
getprop ro.product.model        # Phone model
getprop ro.build.version.release # Android version
cat /proc/cpuinfo               # CPU info
cat /proc/meminfo | head -5     # Memory
wm size                         # Screen resolution
ip addr show wlan0              # WiFi IP
curl -s ifconfig.me             # Public IP
```

### 5. File Access
```
ls /sdcard/                     # Shared storage
ls /sdcard/Download/
ls /sdcard/DCIM/
```

### 6. Termux:API CLI (installed)
Requires companion app from F-Droid for full functionality.
Available commands (after companion app install):
```
termux-battery-status    # Battery info
termux-clipboard-get     # Read clipboard
termux-clipboard-set "text" # Set clipboard
termux-contact-list      # Contacts
termux-dialog            # Show dialog on phone
termux-location          # GPS location
termux-notification      # Create notification
termux-sms-list          # Read SMS
termux-sms-send -n NUMBER "message"  # Send SMS
termux-toast "message"   # Toast notification
termux-tts-speak "text"  # Text to speech
termux-vibrate           # Vibrate phone
termux-wake-lock         # Keep screen on
termux-wake-unlock       # Release wake lock
termux-share file        # Share file
termux-download URL      # Download file
```

## Pitfalls & Workarounds (Learned)

### Termux:API Companion App (Critical)
- `termux-battery-status` works WITHOUT the companion app (reads from /sys directly)
- All other APIs (clipboard, location, toast, SMS, sensors) FAIL with: "Termux:API is not yet available on Google Play" — this means the companion app isn't installed OR there's a source mismatch
- Check with: `pm list packages | grep termux` — if only `com.termux` shows (not `com.termux.api`), companion app is missing or not registering
- MUST be installed from F-Droid, NOT Google Play (Play version doesn't exist yet)
- **BOTH Termux AND Termux:API must come from the same source (both F-Droid)**. Mismatched sources cause the "not yet available on Google Play" error even when the app appears installed. The `termux-api` CLI binary communicates through `com.termux.app.TermuxService`, so both apps must be from the same build.
- If Termux was installed from Play Store, reinstall Termux from F-Droid too: `curl -sL "https://f-droid.org/repo/com.termux_1002.apk" -o /sdcard/Download/termux-fdroid.apk` (108MB, use background process with long timeout)
- F-Droid API version codes: v0.53.0 (code 1002), v0.52.0 (code 1001)
- App may not register in `pm list packages` even when installed — verify by opening app info on the phone

### Installing APKs from Termux
- `pm install /sdcard/Download/file.apk` FAILS due to SELinux — system_server can't read fuse storage
- Fix: open with system installer intent instead:
  ```
  am start -a android.intent.action.VIEW -d "file:///sdcard/Download/file.apk" -t "application/vnd.android.package-archive"
  ```
- If that doesn't show on screen, try `termux-open /path/to/file.apk`
- User must tap "Install" on the prompt and grant permissions
- Large APKs (100MB+) may need background download: `curl -sL URL -o PATH --max-time 600 &` then poll with `ls -lh`
- Download F-Droid Termux:API (small, ~4MB): `curl -sL "https://f-droid.org/repo/com.termux.api_1002.apk" -o /sdcard/Download/termux-api-fdroid.apk`
- Download F-Droid Termux (large, ~108MB): `curl -sL "https://f-droid.org/repo/com.termux_1002.apk" -o /sdcard/Download/termux-fdroid.apk`

### ADB Wireless Debugging
- Wireless Debugging shows TWO ports: one for **pairing** (with code), one for **connecting** (no code)
- `adb pair IP:PAIR_PORT CODE` — may fail with "protocol fault" if port changed or timing issue
- If pairing fails: turn Wireless Debugging OFF then ON again, get fresh ports
- After pairing: `adb connect IP:CONNECT_PORT` (second port, different from pair port)
- Once ADB connected, `input tap`, `input keyevent`, `input text` all work via ADB shell

### Settings Commands
- `settings get/set` fails with "Permission Denial: INTERACT_ACROSS_USERS" without ADB or root
- `dumpsys` also fails without elevated permissions

## What Needs User Setup

### For Termux:API Full Features
1. Download APK: `curl -sL "https://f-droid.org/repo/com.termux.api_51.apk" -o /sdcard/Download/termux-api.apk`
2. Open installer: `am start -a android.intent.action.VIEW -d "file:///sdcard/Download/termux-api.apk" -t "application/vnd.android.package-archive"`
3. User taps Install, grants all permissions
4. Verify: `pm list packages | grep termux.api`

### For ADB / Input Injection (tap, swipe, keyevent)
⚠️ **Same-device ADB does NOT work.** Termux can't pair with its own wireless debugging.
You need a SECOND device (laptop, another phone) to connect via ADB.
Alternative: use Shizuku (see below).

1. Enable Developer Options: Settings > About Phone > Tap Build Number 7 times
2. Enable Wireless Debugging: Settings > Developer Options > Wireless Debugging
3. From a SECOND device with ADB: `adb pair PHONE_IP:PAIR_PORT CODE`
4. Then: `adb connect PHONE_IP:CONNECT_PORT`
5. From second device: `adb shell input tap x y`, etc.

### For Input Control Without ADB (Shizuku - Recommended)
Shizuku runs a local ADB server on the device itself, bypassing same-device limitation.
1. Install "Shizuku" from Play Store
2. Enable via wireless debugging (Shizuku app guides you)
3. Termux can then use Shizuku's ADB for `input` commands

## Tested on fr3k's Motorola (Android 13, aarch64)

### What Works
- `am start -n com.android.settings/.Settings\$WifiSettingsActivity` — WiFi
- `am start -n com.android.settings/.Settings\$BluetoothSettingsActivity` — BT
- `am start -n com.android.settings/.Settings\$DisplaySettingsActivity` — Display
- `am start -n com.android.settings/.Settings\$SoundSettingsActivity` — Sound
- `am start -n com.android.settings/.Settings\$LocationSettingsActivity` — Location
- `am start -a android.intent.action.VIEW -d URL` — open URLs
- `termux-battery-status` — works WITHOUT companion app (reads sysfs)
- `termux-open` / `termux-open-url` — open files/URLs
- `curl`, `wget`, `python` — full network access
- `/sdcard/` — shared storage access
- `ifconfig` — network info

### What Doesn't Work
- `input tap/swipe/keyevent` — needs INJECT_EVENTS (root or ADB)
- `settings get/set` — needs INTERACT_ACROSS_USERS
- `dumpsys` — needs DUMP permission
- `termux-toast/clipboard/location/etc` — needs companion app (package not registering even when "installed")
- Same-device ADB pairing — kernel limitation, can't pair Termux ADB daemon with own wireless debug server

### Known Issues
- Termux:API companion app (com.termux.api) may not register in pm list even when installed — version mismatch between F-Droid Termux and the API app
- ADB wireless debugging can't pair from same device — need second device or Shizuku workaround
- **ADB same-device pairing DOES NOT WORK** — Termux's ADB daemon and Android's wireless debug server share the same kernel, causing "protocol fault" on all IPs (127.0.0.1, 192.168.x.x, 100.x.x.x). You need a SECOND device (laptop or another phone) to pair via ADB, or use Shizuku instead.
- `input` commands (tap, swipe, keyevent) require INJECT_EVENTS permission — only available via ADB shell from a second device, or Shizuku

## Phone Info
- Model: Motorola (Android 13, aarch64)
- IP: 168.140.255.132
- Third-party apps: Claude, Termux only
