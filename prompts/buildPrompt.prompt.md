---
agent: agent
model: gpt-4o-mini
description: Build a well-formatted, context-efficient VS Code Copilot reusable prompt file.
---

Create a new `.prompt.md` file for the following task:

> ${input:task:Describe what this prompt should do}

**Mode** (leave blank to auto-select): `${input:mode:ask | edit | agent — or leave blank}`
**Model** (leave blank to auto-select): `${input:model:e.g. gpt-4o-mini, gpt-4o — or leave blank}`

## VS Code Prompt File Rules

**Front matter (only these keys are valid):**
- `agent`: `ask` | `edit` | `agent` — default `ask`
- `model`: model ID (e.g. `gpt-4o-mini`, `claude-sonnet-4-5`)
- `description`: one sentence, ≤15 words
- `tools`: list of allowed tools (agent mode only)

**Do not use:** `name`, `argument-hint`, `mode`, `variables` YAML blocks — these are not supported.

**Variables:**
- Inline inputs: `${input:varName:placeholder}`
- Context references: `${file}`, `${selection}`, `${input:varName}`

**Body:**
- No H1 heading — the filename is the prompt's name
- Keep instructions tight — every sentence must add model value
- Prefer numbered steps for sequential tasks, bullets for rules
- Omit examples unless the format is non-obvious

## Output

1. Use the provided `agent` if given; otherwise infer — `agent` if file writes are needed, `edit` for code changes, `ask` for Q&A.
2. Use the provided `model` if given; otherwise choose the lightest effective model for the task.
3. Write the front matter with only the necessary keys.
4. Write a concise body: one action sentence up top, then steps and rules.
5. Save as `${input:filename:filename}.prompt.md` in `~/.agents/prompts/` for global use or `.github/prompts/` for repo-level use.
6. Show the final file contents for review before saving.
