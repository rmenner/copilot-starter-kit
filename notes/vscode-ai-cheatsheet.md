# VS Code AI — Cheat Sheet

---

## Context Building

- **`#file`** — reference a specific file by name
- **`#folder`** — reference an entire folder
- **`#selection`** — pass the highlighted code
- **`#editor`** — pass visible editor content
- **`#terminalLastCommand`** — include last terminal command + output
- **`#terminalSelection`** — include selected terminal text
- **`#fetch`** — fetch a URL and include its content as context
- **`@workspace`** — search the full workspace for relevant code
- **`@terminal`** — scope to terminal/shell context
- **`@vscode`** — ask about VS Code settings, keybindings, or commands
- Open editor tabs are included as background context automatically
- Keep context short and targeted — don't dump everything

---

## Slash Commands

- **`/explain`** — explain selected or referenced code
- **`/fix`** — propose a fix for current errors
- **`/tests`** — generate unit tests
- **`/doc`** — generate JSDoc / docstrings
- **`/clear`** — reset the chat session
- **`/new`** — scaffold a new file or project
- **`/newNotebook`** — create a Jupyter notebook from a description
- **`/init`** — initialize a new project or workspace with recommended structure and config

---

## Prompting Tips

- Use **Role + Task + Constraints** structure for clear prompts
- Break multi-part work into **numbered steps** in one prompt
- State **negative constraints** ("do not modify…")
- **Iterate in the same thread** — follow-ups keep context; new chat resets it
- **Name files and functions explicitly** instead of saying "the code"
- Keep prompts focused — **one concern per prompt**
- Use **"Ask one question at a time until you are 95% sure you can complete my task"** to force the AI to clarify before acting

---

## Model Selection

- **Copilot (default)** — fast inline completions, low latency
- **GPT-4o Mini / Claude Haiku** — fast Q&A, boilerplate
- **GPT-4o / Claude Sonnet** — complex refactors, architecture
- **Claude Opus / o1** — deepest reasoning, security review
- Switch via the **model picker dropdown** in chat panel
- Match model weight to task complexity

---

## Custom Instructions

- File: **`.github/copilot-instructions.md`**
- Auto-loaded into every Copilot chat session in the repo
- Encode team conventions, frameworks, naming rules, test setup
- Version-controlled — shared by everyone on the repo

---

## Reusable Prompts

- Location: **`.github/prompts/*.prompt.md`**
- Markdown files with YAML front matter
- Invoke by name to run standardized tasks
- Good for scaffolding, audits, migration guides
- **Global prompts** — set `chat.promptFilesLocations`, `chat.instructionsFilesLocations`, and `chat.agentSkillsLocations` in User Settings to register your `~/.agents/` subfolders across all workspaces
- **Repo prompts** live in `.github/prompts/` (team-shared); **global prompts** live in `~/.agents/prompts/` (personal, all workspaces)

---

## Memory

- Copilot remembers facts and preferences across sessions
- **Per-user only** — not shared with teammates
- Use for personal workflow preferences
- Use **custom instructions** (not memory) for team-wide standards

---

## VS Code AI vs Copilot CLI

- **VS Code AI**
  - Code edits, refactors, architecture Q&A, test generation
  - Full workspace + editor context
  - Conversational, iterative, visual diffs

- **Copilot CLI (`copilot` in terminal)**
  - Install: `brew install copilot-cli` or `npm install -g @github/copilot`
  - Invoke: type `copilot` in any terminal
  - Full agentic terminal experience with slash commands:
    - `/plan` — outline work before executing
    - `/model` — switch models mid-session
    - `/fleet` — parallelize work across subagents
    - `/resume` — pick up a previous session
    - `/mcp` — connect to GitHub-native MCP servers (issues, PRs, branches)
    - `/delegate` — hand off work, review `/diff`, open a PR
    - `/agent` + `/skills` — customize behavior with `AGENTS.md`
    - `/ide` — open current work in VS Code
    - `/experimental` — access preview features

- **Rule of thumb:** VS Code AI _builds_ code in the editor; Copilot CLI _drives_ the full dev workflow from the terminal
