#!/bin/bash
# Post to social media via Postiz API
# Usage: bash postiz-post.sh "Your post text" [platform]
# Platforms: tiktok, linkedin (default: linkedin)

source ~/.hermes/.env.business 2>/dev/null

API_KEY="${POSTIZ_API_KEY}"
TIKTOK_ID="${POSTIZ_TIKTOK_ID}"
LINKEDIN_ID="${POSTIZ_LINKEDIN_ID}"

CONTENT="$1"
PLATFORM="${2:-linkedin}"

if [ -z "$CONTENT" ]; then
  echo "Usage: $0 \"post text\" [tiktok|linkedin]"
  exit 1
fi

if [ "$PLATFORM" = "tiktok" ]; then
  INT_ID="$TIKTOK_ID"
  SETTINGS=',"settings":{"__type":"tiktok","privacy_level":"PUBLIC_TO_EVERYONE","duet":false,"stitch":false,"comment":true,"autoAddMusic":"no","brand_content_toggle":false,"brand_organic_toggle":false,"video_made_with_ai":true,"content_posting_method":"UPLOAD"}'
else
  INT_ID="$LINKEDIN_ID"
  SETTINGS=""
fi

DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)

curl -s -X POST "https://api.postiz.com/public/v1/posts" \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"type\":\"now\",\"date\":\"$DATE\",\"shortLink\":false,\"tags\":[],\"posts\":[{\"integration\":{\"id\":\"$INT_ID\"},\"value\":[{\"content\":\"$CONTENT\",\"image\":[]}]}${SETTINGS}]}"

echo ""
echo "Posted to $PLATFORM at $DATE"
