#!/data/data/com.termux/files/usr/bin/bash
# Clipboard history — tracks changes, stores last 50
set -euo pipefail
HIST="$HOME/.hermes/data/clipboard-history.jsonl"
mkdir -p "$(dirname "$HIST")"

CURRENT=$(timeout 5 termux-clipboard-get 2>/dev/null)
[ -z "$CURRENT" ] && exit 0

# Check if changed from last entry
LAST=$(tail -1 "$HIST" 2>/dev/null | jq -r '.text // ""' 2>/dev/null)
if [ "$CURRENT" != "$LAST" ]; then
  echo "{\"ts\":\"$(date -Iseconds)\",\"text\":$(echo "$CURRENT" | jq -Rs .)}" >> "$HIST"
  # Keep last 50
  tail -50 "$HIST" > "$HIST.tmp" && mv "$HIST.tmp" "$HIST"
  echo "Clipboard saved: ${CURRENT:0:50}..."
fi
