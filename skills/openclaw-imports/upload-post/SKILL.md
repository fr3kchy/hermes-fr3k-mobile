---
name: upload-post
description: "Upload content to social media platforms via Upload-Post API. Use when posting videos, photos, text, or documents to TikTok, Instagram, YouTube, LinkedIn, Facebook, X (Twitter), Threads, Pinterest, Reddit, or Bluesky."
---

# Upload-Post API

Post content to multiple social media platforms with a single API call.

## Documentation

- Full API docs: https://docs.upload-post.com
- LLM-friendly: https://docs.upload-post.com/llm.txt

## Local Wrapper

```bash
node /home/openclaw/.openclaw/workspace/skills/upload-post/scripts/post.js \
  --platform instagram \
  --caption "caption text" \
  --media /abs/path/to/file.jpg
```

Environment:
- `UPLOAD_POST_API_KEY`
- `UPLOAD_POST_PROFILE` or `UPLOAD_POST_USER`
