# Media Requirements by Platform

## Photo Requirements

### Instagram
- Formats: JPEG, PNG, GIF
- Aspect ratio: 4:5 to 1.91:1

### X (Twitter)
- Formats: JPEG, PNG, GIF
- Max 4 images per tweet

## Video Requirements

### TikTok
- Formats: MP4, MOV, WebM
- Recommended: 1080x1920 (9:16)

### Instagram
- Formats: MP4, MOV
- Reels: 0-90s

### YouTube
- Formats: MP4, MOV, AVI, WMV, FLV, WebM
- Max duration: 12 hours

## FFmpeg Re-encoding

```bash
ffmpeg -y -i {input} -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k {output}
```
