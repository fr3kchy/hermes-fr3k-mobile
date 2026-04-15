---
name: command-compressor
description: Compress verbose CLI output to save tokens — inspired by lean-ctx's 90+ shell hook patterns
category: autonomous-ai-agents
---

# Command Output Compression

When running terminal commands, compress output to save tokens while preserving actionable information.

## Compression Rules by Command Type

### Git
| Command | Keep | Discard |
|---------|------|---------|
| `git status` | Modified/untracked file list, branch name | Verbose descriptions, "use git add" hints |
| `git log` | Hash (7 char), author, date (YYYY-MM-DD), first line of message | Full hash, email, full date, merge boilerplate |
| `git diff` | Changed lines with context (3 lines), file paths | Unchanged hunks if >50 lines |
| `git branch` | Branch names, current marker | Remote tracking info |

### Package Managers (npm/pip/cargo)
| Command | Keep | Discard |
|---------|------|---------|
| `npm install` | Errors, warnings, added packages count | Progress bars, "added X packages in Ys" |
| `pip install` | Errors, warnings, installed version | Download progress, dependency tree |
| `npm list` | Top-level + direct deps only | Full tree if >20 packages |

### Docker
| Command | Keep | Discard |
|---------|------|---------|
| `docker ps` | Container names, status, ports | Container IDs (short), created time |
| `docker images` | Repo, tag, size | Image IDs, created |

### Test Runners
| Command | Keep | Discard |
|---------|------|---------|
| `pytest` | Failures with tracebacks, summary line | Passed test names, warnings |
| `jest/vitest` | Failed tests with diffs, summary | Passed test names |

### File Listing (`ls`)
| Command | Keep | Discard |
|---------|------|---------|
| `ls -la` | Name, size (human), type indicator | Permissions, owner, group, inode |
| Long dirs (>20 items) | First 15 + count of remaining | Middle items |

### Build Tools
| Command | Keep | Discard |
|---------|------|---------|
| `tsc` | Errors only | "Found N errors" if errors shown |
| `cargo build` | Errors, warnings (first occurrence per file) | Compilation progress |

## Implementation

When executing terminal commands, if output exceeds 2000 chars:
1. Apply the compression rule for that command type
2. Add `[compressed: X→Y chars]` suffix
3. Preserve error output fully — never compress errors

## Token Estimation
- Rough: 1 token ≈ 4 chars
- `git status` verbose: ~150 tokens → compressed: ~30 tokens (-80%)
- `ls -la` of 50 files: ~800 tokens → compressed: ~120 tokens (-85%)
- `npm test` with failures: keep full, only compress passed test names
