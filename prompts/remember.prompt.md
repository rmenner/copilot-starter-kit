---
agent: agent
model: gpt-4o-mini
description: Save a fact, preference, or convention to your personal memory file.
---

Save the following to `~/.agents/instructions/memory.instructions.md`:

> MEMORY: ${input:fact:What would you like me to remember?}

## Instructions

1. Read the memory file and check for an existing duplicate. If found, stop and notify.
2. Append the new entry on its own line at the end of the file, prefixed with `MEMORY:`.
3. Show the appended line for verification.

## Entry format

```
MEMORY: <the fact or preference in plain language>
```

## Rules

- Append only — never delete or overwrite existing entries.
- One item per invocation.
- No secrets, tokens, or passwords.
- If the item belongs in `.github/copilot-instructions.md` instead, say so and ask before saving.
