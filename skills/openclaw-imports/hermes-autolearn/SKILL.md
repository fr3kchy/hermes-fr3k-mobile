---
name: hermes-autolearn
version: 1.0.0
description: "Hermes-style auto skill creation loop for OpenClaw. After complex tasks (5+ tool calls), auto-drafts a SKILL.md capturing what worked. Auto-patches skills when errors are found and fixed. Writes LEARNINGS.md entries. Use after every significant task completion."
metadata: {"clawdbot":{"emoji":"🧬","category":"meta"}}
---

# Hermes AutoLearn 🧬

Inspired by Nous Research's Hermes Agent self-improvement loop.
Ported to OpenClaw's skill system.

## When to Trigger

Activate automatically after ANY of these:

1. **Complex task completed** — 5+ tool calls to solve something
2. **Error → fix found** — hit a dead end, found the working path
3. **User corrected approach** — "no, do it this way instead"
4. **Non-trivial workflow discovered** — a multi-step pattern worth repeating
5. **Scalper config change** — any trading parameter tuned successfully
6. **Revenue ops pattern** — lead captured, outreach sent, skill triggered

## The Loop

```
Task completed
     ↓
Was it complex? (5+ tools / errors hit / correction received)
     ↓ YES
Does a skill already exist for this pattern?
     ↓ NO                         ↓ YES
Create new SKILL.md          Patch existing skill
     ↓                            ↓
Write LEARNINGS.md entry     Write LEARNINGS.md entry
     ↓
Done — knowledge persists forever
```

## Step 1: Check If Skill Exists

Before creating, scan installed skills:

```bash
ls ~/.openclaw/workspace/skills/ | grep -i "<relevant-keyword>"
```

If exists → go to **Patch Mode**.
If not → go to **Create Mode**.

## Step 2A: Create Mode

When a new pattern is discovered, write a SKILL.md:

```bash
mkdir -p ~/.openclaw/workspace/skills/<slug>
cat > ~/.openclaw/workspace/skills/<slug>/SKILL.md << 'EOF'
---
name: <slug>
version: 1.0.0
description: "<one-line description of what this skill does and when to use it>"
metadata: {"clawdbot":{"emoji":"⚡","category":"<category>"}}
---

# <Title>

Auto-created by hermes-autolearn after successful task completion.
Created: <ISO timestamp>
Task: <brief description of what was accomplished>

## When to Use

<trigger conditions — be specific>

## Procedure

<numbered steps that worked>

## Pitfalls

<what failed before the working path was found>

## Verification

<how to confirm it worked>
EOF
```

**Category options:** `trading`, `research`, `revenue`, `coding`, `automation`, `comms`, `system`

## Step 2B: Patch Mode

When an existing skill needs updating:

```bash
# Read current skill
cat ~/.openclaw/workspace/skills/<slug>/SKILL.md

# Apply targeted patch (surgical edit, not full rewrite)
# Add to Pitfalls if error was found
# Update Procedure if steps changed
# Bump version: 1.0.0 → 1.0.1
```

Patch format — add to relevant section:
```
## Pitfalls (updated <date>)
- <what failed and why>
- Fix: <what actually worked>
```

## Step 3: Write LEARNINGS.md Entry

Always write to the learnings log regardless of create/patch:

```bash
LEARNINGS_FILE=~/.openclaw/workspace/LEARNINGS.md
ENTRY="
## $(date '+%Y-%m-%d %H:%M') — <task-type>

**What:** <one line summary>
**Pattern:** <the reusable insight>
**Skill created/updated:** <slug or 'none'>
**Outcome:** <success/partial/failed>
"
echo "$ENTRY" >> "$LEARNINGS_FILE"
```

## Step 4: Scalper-Specific Learning

For trading bot interactions, also update the scalper knowledge base:

```bash
SCALPER_LEARNINGS=~/.openclaw-bybit-scalper/agent-learnings.md
```

Format:
```markdown
## <date> — Config Change
- **Changed:** <parameter> from <old> to <new>
- **Reason:** <why — what data showed this was needed>
- **Result:** <outcome after N trades>
- **Revert if:** <condition that would warrant reverting>
```

## Priority Skills to Auto-Create

Watch for these patterns and create skills immediately:

| Pattern | Slug to create |
|---------|---------------|
| Bybit API call that works | `bybit-api-patterns` |
| Config fix that improved PnL | `scalper-tuning-<date>` |
| Revenue lead capture flow | `lead-capture-<platform>` |
| Social post that got engagement | `social-hook-<platform>` |
| Research workflow that worked | `research-<topic>` |
| Error + fix for a known tool | patch existing skill |

## Related Skills

| Skill | Scope |
|-------|-------|
| `self-improving` | USER preferences and corrections |
| `hermes-autolearn` | PROCEDURAL knowledge (how-to workflows) — this skill |
| `agent-system-migration` | STRATEGIC migration (multi-repo consolidation, bootstrapping) |
| `ace-context-engineering` | Context/playbook optimization via Generator/Reflector/Curator |
| `evoskill-feedback-descent` | Skill evolution via Feedback Descent algorithm |

They write to different locations:
- `self-improving` → `~/self-improving/memory.md`
- `hermes-autolearn` → `~/.openclaw/workspace/skills/<slug>/SKILL.md` + `LEARNINGS.md`

## Quick Commands

| Say | Action |
|-----|--------|
| "What have we learned?" | Show last 20 entries from LEARNINGS.md |
| "Did we capture that?" | Check if skill exists for recent task |
| "Create a skill for what we just did" | Trigger create mode manually |
| "What scalper configs have we tried?" | Show scalper-specific learnings |
| "Show me the learning log" | `cat LEARNINGS.md` |

## Rules

1. **Never overwrite a working skill without reading it first**
2. **Patch is preferred over edit** — surgical changes only
3. **Always write a LEARNINGS.md entry** — even if no skill created
4. **Version bump on every patch** — 1.0.0 → 1.0.1 → 1.0.2
5. **Bias toward creation** — if unsure, create it
6. **Tag trading skills separately** — they need different recall context
