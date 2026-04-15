#!/bin/bash
# Auto-improvement cycle — runs twice daily
# Searches for business-relevant improvements and integrates them

source ~/.hermes/.env.business 2>/dev/null
LOG="$HOME/.hermes/logs/autoimprove.log"
mkdir -p "$HOME/.hermes/logs"

echo "=== AUTO-IMPROVE $(date) ===" >> "$LOG"

# 1. Search GitHub for AI agent tools
echo "Searching GitHub..." >> "$LOG"
gh search repos "AI agent business" --sort stars --limit 3 --json fullName,description,stargazersCount 2>/dev/null >> "$LOG"

# 2. Check for trending repos
echo "Checking trending..." >> "$LOG"
curl -s "https://api.github.com/search/repositories?q=agent+created:>$(date -d '7 days ago' +%Y-%m-%d)&sort=stars&order=desc&per_page=3" 2>/dev/null | python3 -c "
import json,sys
data=json.load(sys.stdin)
for r in data.get('items',[]):
    print(f\"{r['stargazers_count']}★ {r['full_name']}: {r['description'][:60]}\")
" >> "$LOG" 2>/dev/null

# 3. Log completion
echo "=== DONE $(date) ===" >> "$LOG"
echo "" >> "$LOG"
