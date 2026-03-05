#!/usr/bin/env node
"use strict";

const fs   = require("fs");
const path = require("path");
const os   = require("os");
const rl   = require("readline").createInterface({ input: process.stdin, output: process.stdout });

const PKG_DIR = path.join(__dirname, "..");

// ─── Helpers ──────────────────────────────────────────────────────────────────
const ask  = (q) => new Promise((res) => rl.question(q, res));
const cyan = (s) => `\x1b[36m${s}\x1b[0m`;
const green = (s) => `\x1b[32m${s}\x1b[0m`;
const yellow = (s) => `\x1b[33m${s}\x1b[0m`;

function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  for (const file of fs.readdirSync(src)) {
    if (file === ".gitkeep") continue;
    const srcFile  = path.join(src, file);
    const destFile = path.join(dest, file);
    if (fs.statSync(srcFile).isFile()) {
      fs.copyFileSync(srcFile, destFile);
      console.log(`  Copied: ${file}`);
    }
  }
}

function vscodeSettingsPaths() {
  const home = os.homedir();
  if (process.platform === "darwin") return [
    path.join(home, "Library/Application Support/Code/User/settings.json"),
    path.join(home, "Library/Application Support/Code - Insiders/User/settings.json"),
  ];
  if (process.platform === "win32") return [
    path.join(process.env.APPDATA || "", "Code/User/settings.json"),
    path.join(process.env.APPDATA || "", "Code - Insiders/User/settings.json"),
  ];
  return [
    path.join(home, ".config/Code/User/settings.json"),
    path.join(home, ".config/Code - Insiders/User/settings.json"),
  ];
}

// ─── Main ─────────────────────────────────────────────────────────────────────
(async () => {
  console.log(cyan("\n╔══════════════════════════════════════════╗"));
  console.log(cyan("║   Copilot Starter Kit — Setup Script      ║"));
  console.log(cyan("╚══════════════════════════════════════════╝\n"));

  // 1. Choose folder name
  const folderInput = await ask("Agents folder name (default: .agents): ");
  const agentsFolder = folderInput.trim() || ".agents";
  const agentsDir    = path.join(os.homedir(), agentsFolder);
  console.log(`  Using: ${agentsDir}\n`);

  // 2. Create folder structure
  console.log(green(`▶ Creating ${agentsDir} folder structure...`));
  for (const sub of ["instructions", "prompts", "skills", "notes"]) {
    fs.mkdirSync(path.join(agentsDir, sub), { recursive: true });
    console.log(`  Created: ${path.join(agentsDir, sub)}`);
  }

  // 3. Copy starter prompts
  console.log(green(`\n▶ Copying starter prompts to ${agentsDir}/prompts/...`));
  copyDir(path.join(PKG_DIR, "prompts"), path.join(agentsDir, "prompts"));

  // 4. Copy cheat sheet
  console.log(green(`\n▶ Copying cheat sheet to ${agentsDir}/notes/...`));
  copyDir(path.join(PKG_DIR, "notes"), path.join(agentsDir, "notes"));

  // 5. Seed instructions folder
  console.log(green(`\n▶ Seeding instructions folder at ${agentsDir}/instructions/...`));
  copyDir(path.join(PKG_DIR, "instructions"), path.join(agentsDir, "instructions"));

  // 6. Seed skills folder
  console.log(green(`\n▶ Seeding skills folder at ${agentsDir}/skills/...`));
  copyDir(path.join(PKG_DIR, "skills"), path.join(agentsDir, "skills"));

  // 7. VS Code settings
  const promptsDir      = path.join(agentsDir, "prompts");
  const instructionsDir = path.join(agentsDir, "instructions");
  const skillsDir       = path.join(agentsDir, "skills");
  console.log(yellow("\n▶ VS Code settings"));
  console.log(`  The following settings tell Copilot where to find your global prompts,`);
  console.log(`  instructions, and skills under: ${agentsDir}\n`);

  const updateAnswer = await ask("  Auto-update VS Code settings.json? (y/n): ");

  if (updateAnswer.trim().toLowerCase() === "y") {
    const settingsFile = vscodeSettingsPaths().find((p) => fs.existsSync(p));

    if (!settingsFile) {
      console.log(yellow("\n  ⚠️  Could not find VS Code settings.json. Falling back to manual instructions."));
    } else {
      const raw      = fs.readFileSync(settingsFile, "utf8").trim();
      const settings = raw ? JSON.parse(raw) : {};

      if (!settings["chat.promptFilesLocations"]) settings["chat.promptFilesLocations"] = {};
      settings["chat.promptFilesLocations"][promptsDir] = true;

      if (!settings["chat.instructionsFilesLocations"]) settings["chat.instructionsFilesLocations"] = {};
      settings["chat.instructionsFilesLocations"][instructionsDir] = true;

      if (!settings["chat.agentSkillsLocations"]) settings["chat.agentSkillsLocations"] = {};

      fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2) + "\n", "utf8");
      console.log(green(`\n  ✅ Updated: ${settingsFile}`));
    }
  } else {
    console.log(yellow("\n  Add the following to your VS Code settings.json:"));
    console.log(`\n  "chat.promptFilesLocations": {\n    "${promptsDir}": true\n  },`);
    console.log(`  "chat.instructionsFilesLocations": {\n    "${instructionsDir}": true\n  },`);
    console.log(`  "chat.agentSkillsLocations": {\n    "${skillsDir}": true\n  }`);
    console.log('\n  Open: ⌘⇧P (macOS) / Ctrl+Shift+P (Win/Linux) → "Open User Settings (JSON)"');
  }

  // 6. Done
  console.log(green("\n✅ Setup complete!\n"));
  console.log(`  ${agentsDir}/instructions/  — global Copilot instructions`);
  console.log(`  ${agentsDir}/prompts/       — reusable prompt files (clarify, remember, buildPrompt)`);
  console.log(`  ${agentsDir}/skills/        — agent skill definitions`);
  console.log(`  ${agentsDir}/notes/         — reference notes & cheat sheets`);
  console.log("\n  Next steps:");
  console.log("  1. Restart VS Code to pick up settings changes.");
  console.log("  2. Open Copilot Chat, type '/' and look for: clarify, remember, buildPrompt.");
  console.log(`  3. Add your own prompts to ${agentsDir}/prompts/ at any time.\n`);

  rl.close();
})();
