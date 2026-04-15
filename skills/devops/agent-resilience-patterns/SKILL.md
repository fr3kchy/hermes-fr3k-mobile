---
name: agent-resilience-patterns
description: "Agent resilience patterns: error recovery with retry backoff, rate limit handling with provider fallback, checkpoint/resume for long tasks, circuit breaker for failing services. Use when building robust agent systems that handle failures gracefully."
---

# Agent Resilience Patterns

## Error Recovery with Retry

### Exponential Backoff
```python
import time

def retry(fn, max_attempts=3, delay=2):
    for attempt in range(max_attempts):
        try:
            return fn()
        except Exception as e:
            if attempt == max_attempts - 1:
                raise
            time.sleep(delay * (2 ** attempt))
```

### Categorized Recovery
- **Transient**: Network timeout, rate limit → retry with backoff
- **Permanent**: Invalid API key, permission denied → fail fast, report
- **Ambiguous**: Unknown error → retry once, then escalate

## Rate Limit Handling

### Provider Fallback Chain
```yaml
providers:
  - name: anthropic
    priority: 1
    models: [claude-sonnet-4, claude-haiku]
  - name: openrouter
    priority: 2
    models: [anthropic/claude-sonnet-4]
  - name: nous
    priority: 3
    models: [xiaomi/mimo-v2-pro]
```

### Circuit Breaker
- Track failures per provider
- After N failures in T seconds: open circuit (stop trying)
- After cooldown: half-open (try one request)
- If success: close circuit (resume normal)
- If failure: open circuit again

## Checkpoint/Resume

For long-running tasks:
1. Save state after each major step
2. On failure, resume from last checkpoint
3. Don't repeat completed work

```python
# Checkpoint pattern
state = load_checkpoint() or {"step": 0}
for step in range(state["step"], total_steps):
    do_step(step)
    save_checkpoint({"step": step + 1, "results": results})
```

## Circuit Breaker Implementation

```python
class CircuitBreaker:
    def __init__(self, failure_threshold=5, cooldown=60):
        self.failures = 0
        self.threshold = failure_threshold
        self.cooldown = cooldown
        self.last_failure = 0
        self.state = "closed"  # closed, open, half-open
    
    def can_execute(self):
        if self.state == "closed":
            return True
        if self.state == "open":
            if time.time() - self.last_failure > self.cooldown:
                self.state = "half-open"
                return True
            return False
        return True  # half-open
    
    def record_success(self):
        self.failures = 0
        self.state = "closed"
    
    def record_failure(self):
        self.failures += 1
        self.last_failure = time.time()
        if self.failures >= self.threshold:
            self.state = "open"
```

## Applicable to Hermes

1. **Retry** — Already in hermes_tools. Verify implementation uses exponential backoff.
2. **Provider fallback** — From sandboxed.sh patterns. Add to config.yaml.
3. **Checkpoint** — For long sub-agent tasks. Save state between phases.
4. **Circuit breaker** — For provider health. Don't hammer failing APIs.
