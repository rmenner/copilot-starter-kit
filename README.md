# Copilot Starter Kit

A quick-start kit for developers who want to get more out of GitHub Copilot in VS Code. Clone this repo, run the setup script, and get a working `~/.agents` folder pre-loaded with reusable prompts, global Copilot instructions, and a reference cheat sheet.

---

## What's included

```
prompts/
  clarify.prompt.md       — Ask one question at a time until 95% confident, then act
  remember.prompt.md      — Save a fact or preference to your personal memory file
  buildPrompt.prompt.md   — Scaffold a new reusable prompt from a task description

notes/
  vscode-ai-cheatsheet.md — Quick reference: context, slash commands, prompting tips, model selection

setup.sh                  — macOS / Linux setup script (bash)
setup.ps1                 — Windows / cross-platform setup script (PowerShell 7+)
```

---

## Prerequisites

- [VS Code](https://code.visualstudio.com/) with the [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension
- A Copilot subscription (Free, Pro, Business, or Enterprise)
- macOS/Linux: bash — Windows: PowerShell 7+

---

## Setup

**Option 1 — npx (no clone required, Node.js 18+)**
```bash
npx github:rmenner/copilot-starter-kit
```

**Option 2 — bash (macOS / Linux)**
```bash
git clone https://github.com/rmenner/copilot-starter-kit.git
cd copilot-starter-kit
chmod +x setup.sh
./setup.sh
```

**Option 3 — PowerShell (Windows / cross-platform)**
```powershell
git clone https://github.com/rmenner/copilot-starter-kit.git
cd copilot-starter-kit
.\setup.ps1
```

The script will:
1. Ask for a folder name (default: `.agents`; press Enter to accept, or type a custom name)
2. Create `~/<folder>/{instructions,prompts,skills,notes}`
3. Copy the starter prompts into `~/<folder>/prompts/`
4. Copy the cheat sheet into `~/<folder>/notes/`
5. Offer to auto-update your VS Code `settings.json` to register the prompts folder as a global prompt source, or print the snippet for you to paste in manually

---

## After setup

Restart VS Code, then open Copilot Chat and type `/` to see your global prompts listed:

| Prompt | What it does |
|---|---|
| `clarify` | Forces Copilot to ask one question at a time before acting |
| `remember` | Appends a fact or preference to your personal memory file |
| `buildPrompt` | Scaffolds a new reusable `.prompt.md` from a task description |

---

## `~/.agents` folder structure

| Folder | Purpose |
|---|---|
| `instructions/` | Global Copilot instruction files (e.g. `memory.instructions.md`) |
| `prompts/` | Reusable `.prompt.md` files available in every workspace |
| `skills/` | Agent skill definitions |
| `notes/` | Personal reference docs and cheat sheets |

To add your own global prompt, drop any `.prompt.md` file into `~/.agents/prompts/`. No restart needed.

---

## VS Code settings reference

The key setting that makes global prompts work:

```json
"chat.promptFiles.locations": {
  "~/.agents/prompts": true
}
```

Add to `settings.json` via: **⌘⇧P** → _Open User Settings (JSON)_

---

## Contributing

This repo is intentionally minimal: a starting point, not a library. The goal is to give someone enough to get going, not to cover every use case.

PRs that improve the setup experience, fix bugs, or make the existing prompts clearer are welcome. PRs that add lots of new prompts or skills are out of scope. Build those in your own `~/.agents` folder and share them separately.
