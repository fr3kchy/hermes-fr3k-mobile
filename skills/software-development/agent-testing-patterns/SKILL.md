---
name: agent-testing-patterns
description: "Agent testing and evaluation patterns. AgentProbe (34★) — pytest plugin for regression-testing AI agents with snapshot testing. Rubric-eval — LLM benchmarking framework. Patterns: snapshot testing, regression detection, rubric-based evaluation. Use when testing agent behavior, validating improvements, or setting up CI for agent systems."
---

# Agent Testing & Evaluation Patterns

## AgentProbe (34★)
Drop-in pytest plugin for regression-testing AI agents.
- Snapshot testing — record expected outputs, catch regressions
- Works with existing pytest infrastructure
- CI-friendly

## Evaluation Patterns

### Snapshot Testing
- Record agent output for given input
- Compare against snapshot on future runs
- Detect regressions automatically

### Rubric-Based Evaluation
- Define criteria (accuracy, completeness, style, efficiency)
- Score each criterion independently
- Weighted final score
- Human-readable evaluation reports

### Regression Detection
- Before: agent output X for input I
- After change: agent output Y for same input I
- Flag if X != Y and Y is worse

### Benchmark Suites
- Define test cases with expected outcomes
- Run across multiple agent configurations
- Compare: speed, accuracy, token cost, failure rate

## Applicable to Hermes

### Add to Our Cycle
After INTEGRATE step, before REFLECT:
```
TEST → Run benchmark suite
       → Compare new skill vs baseline
       → Score: accuracy, speed, token cost
       → If worse: discard, log failure
       → If better: keep, log success
```

### Implementation
```bash
# Create test suite directory
mkdir -p ~/.hermes/tests/regression

# Create test runner
cat > ~/.hermes/tests/run-benchmarks.sh << 'EOF'
#!/bin/bash
echo "Running agent benchmarks..."
for test in ~/.hermes/tests/regression/*.sh; do
  echo "Testing: $(basename $test)"
  bash "$test"
done
EOF
```
