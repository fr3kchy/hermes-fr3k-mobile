#!/bin/bash
# LinkedIn Post Script — zero-permission, uses saved chromium session
# Usage: ./post.sh "Your content here" [--image /path/to/image]

CONTENT="$1"
IMAGE=""

shift
while [[ $# -gt 0 ]]; do
    case $1 in
        --image) IMAGE="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if [ -z "$CONTENT" ]; then
    echo "Usage: ./post.sh \"Your content here\" [--image /path/to/image]"
    exit 1
fi

POSTER="$HOME/.openclaw/workspace/scripts/linkedin-post.py"

if [ -n "$IMAGE" ]; then
    python3 "$POSTER" "$CONTENT" --image "$IMAGE"
else
    python3 "$POSTER" "$CONTENT"
fi
