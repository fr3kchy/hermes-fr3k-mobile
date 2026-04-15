---
name: context-engineering-four-pillars
description: "Context Engineering four-pillar framework from context-kit (44★). Treat context as finite resource with diminishing returns. Pillars: Select (JIT retrieval), Write (persistence), Compress (reduce size), Isolate (sub-agent distribution). Use when optimizing context management, reducing token waste, or designing agent prompt assembly."
---

# Context Engineering — Four Pillars

Source: keli-wen/context-kit (44★) · MIT · Pure functions, framework-agnostic
Score: IMPACT=8/10 COMPLEXITY=3/10 RELIABILITY=9/10 — HIGH PRIORITY

## Core Insight

"Most AI Agent failures are not failures of model capability, but failures of Context Engineering."

Context is a **finite resource with diminishing marginal returns**. As context windows fill up, model performance degrades (context rot). Context Engineering is the discipline of dynamically assembling the optimal context for each reasoning step.

## Four Pillars

### 1. Select (JIT Retrieval)
Pull information on-demand, not upfront.
- Don't load everything — search for what's needed
- FTS5 full-text search (our approach ✓)
- Semantic search with embeddings
- List directory, grep, read file — only when needed

### 2. Write (Persistence)
Persist information outside the context window.
- Memory tool — save facts to persistent store
- Skills — save procedures to files
- Session tapes — append-only logs
- Don't keep everything in context — write it out

### 3. Compress (Reduce Size)
Reduce context size while preserving signal.
- **Rule-based**: Remove comments, whitespace, verbose code
- **Model-based**: Summarize long content
- **Structured**: Convert to compact representations
- Token budget management

### 4. Isolate (Sub-Agent Distribution)
Distribute context across sub-agents.
- Each sub-agent gets only relevant context
- Main agent consolidates results
- Prevents context explosion in complex tasks
- Our delegate_task already does this ✓

## Applicable to Hermes

### What We Already Do Well
- ✓ Select: FTS5 search in session_search
- ✓ Write: memory tool, skills system
- ✓ Isolate: delegate_task with restricted toolsets

### What We Can Improve
- **Compress**: Add rule-based context compression before loading into prompts
- **Token budget**: Track context size, compress when approaching limits
- **JIT retrieval**: More aggressive on-demand loading instead of bulk loading

### Implementation

```python
# Context compression for prompts
def compress_context(text, max_tokens=2000):
    """Reduce context while preserving signal."""
    # Remove code comments
    text = re.sub(r'#.*?\n', '\n', text)
    # Remove blank lines
    text = re.sub(r'\n{3,}', '\n\n', text)
    # Truncate if still too long
    if len(text) > max_tokens * 4:  # rough char estimate
        text = text[:max_tokens*4] + "\n... [truncated]"
    return text
```

## Key Takeaway

Context Engineering isn't "advanced prompting" — it's treating context like memory in an OS. Load what you need, write what you'll need later, compress what's too big, and isolate across workers.
