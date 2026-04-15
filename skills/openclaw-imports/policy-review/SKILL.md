---
name: policy-review
description: Use diffs tool to review policy and runtime changes before applying them
---

# Policy and Runtime Change Review

When modifying policy files or runtime configurations, ALWAYS use the `diffs` tool to show the changes before applying them.

## What Requires Review

### Policy Files
Any changes to files in:
- `/home/openclaw/.openclaw/policy/` (and subdirectories)
- Policy configuration files

### Runtime Changes  
Any changes to runtime configurations:
- `/home/openclaw/.openclaw/cron/jobs.json`
- Cron job schedules
- Agent configurations in `openclaw.json`

## Workflow

1. **Before making changes** to any policy or runtime file:
   - Read the current content
   - Generate the proposed new content
   - Use the `diffs` tool with `mode=both` to show the diff
   
2. **Present the diff** to the user for approval:
   - Use `canvas present` with the viewer URL
   - Or send the rendered file via `message` tool

3. **Wait for approval** before applying changes

4. **Only after approval**, apply the changes using `write` or `edit` tools

## Example Prompt

When you need to modify policy or runtime files:

```
Use the diffs tool in mode=both to show the changes I'm about to make to the cron jobs configuration.

Path: cron/jobs.json

Before (current content):
[read the current jobs.json]

After (proposed changes):
[show the proposed changes]
```

Then present the diff for approval before applying.
