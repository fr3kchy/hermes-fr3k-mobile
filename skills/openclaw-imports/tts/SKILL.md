# TTS Skill

> Text-to-Speech using MiniMax

## Trigger Words
- "speak", "say", "read aloud", "text to speech", "tts", "generate audio"

## Usage

```
User: "Read this aloud: Hello world"
→ Generates hello.mp3

User: "Speak this: Welcome to the system"
→ Generates audio file
```

## Implementation

```bash
# Basic
~/.openclaw/workspace/scripts/tts/minimax-tts.sh "text" --output file.mp3

# With options
~/.openclaw/workspace/scripts/tts/minimax-tts.sh "text" \
  --voice English_expressive_narrator \
  --speed 1.0 \
  --output output.mp3
```

## Options

| Option | Description |
|--------|-------------|
| --voice | Voice ID (default: English_expressive_narrator) |
| --speed | Speed 0.5-2.0 (default: 1.0) |
| --output | Output file (default: speak.mp3) |

## Python

```bash
python3 ~/.openclaw/workspace/scripts/tts/minimax_tts.py speak "text" --output file.mp3
```
