# fabric-patterns Skill

Use Daniel Miessler's Fabric patterns to augment responses. Fabric provides 252+ AI prompts organized by task.

## Triggers
- User asks to use a fabric pattern
- User wants prompt augmentation
- Pattern name matches fabric pattern (e.g., summarize, analyze_prose, extract_wisdom)

## Usage

### List available patterns
```bash
ls ~/.openclaw/workspace-external/fabric/data/patterns/
```

### Use a pattern
The skill reads the pattern file and applies it to the current context.

**Pattern categories:**
- `ai/` — AI-specific patterns
- `analyze_*` — Analysis patterns
- `extract_*` — Extraction patterns  
- ` summarize*` — Summarization patterns
- `write_*` — Writing patterns

## Integration

Fabric patterns are stored at:
`~/.openclaw/workspace-external/fabric/data/patterns/`

Each pattern contains a system prompt that can be injected into conversations.

## Examples

- `summarize` → Summarize content
- `analyze_prose` → Analyze writing quality
- `extract_wisdom` → Extract key insights
- `analyze_claims` → Evaluate claims critically

## Add Custom Patterns

Drop new patterns into:
`~/.openclaw/workspace-external/fabric/data/patterns/`

Format: Each folder contains `system.md` with the prompt.
