#!/data/data/com.termux/files/usr/bin/bash
# Read and format recent SMS
set -euo pipefail
COUNT="${1:-10}"
echo "=== LAST $COUNT SMS ==="
timeout 8 termux-sms-list -l "$COUNT" 2>/dev/null | \
  jq -r '.[] | "[\(.received | split("T")[0])] \(.number): \(.body | .[0:80])"' 2>/dev/null
echo "===================="
