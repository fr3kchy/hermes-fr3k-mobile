# AutoExpert Enhancement Skill
> Integrate AutoExpert patterns into fr3k's command organism

## Patterns Extracted from ChatGPT AutoExpert (Dustin Miller, MIT License)

### 1. VERBOSITY Levels
```
V=0: code golf / ultra-terse
V=1: extremely terse
V=2: concise
V=3: detailed (default)
V=4: comprehensive
V=5: exhaustive — expand on key terms, use multiple turns
```

### 2. Slash Commands (implement as needed)
- `/review` — critical self-check: correct mistakes, offer improvements
- `/summary` — compress all Q&A into takeaways
- `/q` — suggest follow-up questions
- `/redo` — re-answer using a different framework
- `/more` — drill deeper
- `/links` — embed Google search links for key terms
- `/alt` — provide alternate viewpoint
- `/arg` — polemic take

### 3. Structured Response Format
```
**Language > Specialist**: {lang} > {EXPERT ROLE}
**Includes**: CSV list of needed libraries/packages
**Requirements**: VERBOSITY, standards, design requirements
## Plan
Step-by-step plan
## Answer
{body}
---
**History**: compressed summary of session
**Source Tree**: file.symbol format
**Next**: unfinished tasks + enhancement suggestions
```

### 4. Inline Google Search Hyperlinks
Format: `emoji [term](https://www.google.com/search?q=extended+query)`
Example: `🔧 [WebSockets](https://www.google.com/search?q=websockets+real-time+python+async)`

### 5. Memory / Session State (for long sessions)
Save to YAML:
```yaml
session:
  timestamp: ISO8601
  requirements: [list]
  history: compressed paragraph
  source_tree:
    - file.ext
      saved: true/false
      symbols: [list]
  next_tasks: [list]
```

## Integration Points
- SOUL.md → add VERBOSITY directive
- AGENTS.md → add structured response format to prime-executive
- HEARTBEAT.md → add session summary format
- Workspace scripts → implement slash commands

## Usage
Read this file to apply AutoExpert patterns to responses.
