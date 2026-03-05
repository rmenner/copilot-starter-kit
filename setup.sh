#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Colors ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║   Copilot Starter Kit — Setup Script      ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${RESET}"

read -rp "Agents folder name (default: .agents): " AGENTS_FOLDER
AGENTS_FOLDER="${AGENTS_FOLDER:-.agents}"
AGENTS_DIR="$HOME/$AGENTS_FOLDER"
echo "  Using: $AGENTS_DIR"
echo ""

# ─── 1. Create folder structure ───────────────────────────────────────────────
mkdir -p "$AGENTS_DIR"/{instructions,prompts,skills,notes}
echo "  Created: $AGENTS_DIR/{instructions,prompts,skills,notes}"

# ─── 2. Copy starter prompts ──────────────────────────────────────────────────
echo -e "${GREEN}▶ Copying starter prompts to $AGENTS_DIR/prompts/...${RESET}"
cp -v "$SCRIPT_DIR"/prompts/*.prompt.md "$AGENTS_DIR/prompts/"

# ─── 3. Copy cheat sheet to notes ─────────────────────────────────────────────
echo -e "${GREEN}▶ Copying cheat sheet to $AGENTS_DIR/notes/...${RESET}"
cp -v "$SCRIPT_DIR"/notes/vscode-ai-cheatsheet.md "$AGENTS_DIR/notes/"

# ─── 4. VS Code settings ──────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}▶ VS Code settings${RESET}"
echo "  The setting ${CYAN}chat.promptFiles.locations${RESET} tells Copilot where to find your"
echo "  global prompts. It needs to point to: ${CYAN}$AGENTS_DIR/prompts${RESET}"
echo ""
read -rp "  Auto-update VS Code settings.json? (y/n): " UPDATE_SETTINGS

if [[ "$UPDATE_SETTINGS" =~ ^[Yy]$ ]]; then
  # Try stable, then Insiders
  SETTINGS_PATHS=(
    "$HOME/Library/Application Support/Code/User/settings.json"
    "$HOME/Library/Application Support/Code - Insiders/User/settings.json"
    "$HOME/.config/Code/User/settings.json"
    "$HOME/.config/Code - Insiders/User/settings.json"
  )

  SETTINGS_FILE=""
  for path in "${SETTINGS_PATHS[@]}"; do
    if [[ -f "$path" ]]; then
      SETTINGS_FILE="$path"
      break
    fi
  done

  if [[ -z "$SETTINGS_FILE" ]]; then
    echo "  ⚠️  Could not find VS Code settings.json. Falling back to manual instructions."
  else
    # Use python3 to safely merge the setting without overwriting existing config
    python3 - "$SETTINGS_FILE" "$AGENTS_DIR/prompts" <<'EOF'
import sys, json, os

settings_path = sys.argv[1]
prompts_path = sys.argv[2]

# Read existing settings (handle empty file)
with open(settings_path, "r") as f:
  content = f.read().strip()
settings = json.loads(content) if content else {}

# Merge setting
locations = settings.get("chat.promptFiles.locations", {})
locations[prompts_path] = True
settings["chat.promptFiles.locations"] = locations

# Write back with 2-space indent
with open(settings_path, "w") as f:
  json.dump(settings, f, indent=2)
  f.write("\n")

print(f"  ✅ Updated: {settings_path}")
EOF
  fi

else
  echo ""
  echo -e "  ${YELLOW}Add the following to your VS Code settings.json:${RESET}"
  echo ""
  echo '  "chat.promptFiles.locations": {'
  echo "    \"$AGENTS_DIR/prompts\": true"
  echo '  }'
  echo ""
  echo "  Open settings: Code → Settings → Open Settings (JSON)  or  ⌘⇧P → 'Open User Settings JSON'"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}✅ Setup complete!${RESET}"
echo ""
echo "  $AGENTS_DIR/instructions/  — global Copilot instructions (auto-loaded by VS Code)"
echo "  $AGENTS_DIR/prompts/       — reusable prompt files (clarify, remember, buildPrompt)"
echo "  $AGENTS_DIR/skills/        — agent skill definitions"
echo "  $AGENTS_DIR/notes/         — personal reference notes & cheat sheets"
echo ""
echo "  Next steps:"
echo "  1. Restart VS Code to pick up settings changes."
echo "  2. Open Copilot Chat and run a prompt: type '/' and look for 'clarify', 'remember', or 'buildPrompt'."
echo "  3. Add your own prompts to $AGENTS_DIR/prompts/ at any time."
echo ""
