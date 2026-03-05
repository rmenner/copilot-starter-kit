# VS Code AI Starter — Setup Script (PowerShell)
# Works on Windows, macOS, and Linux with PowerShell 7+

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Copilot Starter Kit — Setup Script      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$AgentsFolder = Read-Host "Agents folder name (default: .agents)"
if (-not $AgentsFolder) { $AgentsFolder = ".agents" }
$AgentsDir = Join-Path $HOME $AgentsFolder
Write-Host "  Using: $AgentsDir"
Write-Host ""
Write-Host "▶ Creating $AgentsDir folder structure..." -ForegroundColor Green
@("instructions", "prompts", "skills", "notes") | ForEach-Object {
  $dir = Join-Path $AgentsDir $_
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  Write-Host "  Created: $dir"
}

# ─── 2. Copy starter prompts ──────────────────────────────────────────────────
Write-Host "▶ Copying starter prompts to $AgentsDir/prompts/..." -ForegroundColor Green
Get-ChildItem -Path (Join-Path $ScriptDir "prompts") -Filter "*.prompt.md" | ForEach-Object {
  $dest = Join-Path $AgentsDir "prompts" $_.Name
  Copy-Item $_.FullName -Destination $dest -Force
  Write-Host "  Copied: $($_.Name)"
}

# ─── 3. Copy cheat sheet to notes ─────────────────────────────────────────────
Write-Host "▶ Copying cheat sheet to $AgentsDir/notes/..." -ForegroundColor Green
$cheatSheet = Join-Path $ScriptDir "notes" "vscode-ai-cheatsheet.md"
Copy-Item $cheatSheet -Destination (Join-Path $AgentsDir "notes" "vscode-ai-cheatsheet.md") -Force
Write-Host "  Copied: vscode-ai-cheatsheet.md"

# ─── 4. VS Code settings ──────────────────────────────────────────────────────
Write-Host ""
Write-Host "▶ VS Code settings" -ForegroundColor Yellow
Write-Host "  The setting 'chat.promptFiles.locations' tells Copilot where to find your"
Write-Host "  global prompts. It needs to point to: $AgentsDir\prompts"
Write-Host ""
$UpdateSettings = Read-Host "  Auto-update VS Code settings.json? (y/n)"

if ($UpdateSettings -match "^[Yy]$") {
  # Determine settings path by OS
  $SettingsPaths = @()
  if ($IsWindows -or $env:OS -eq "Windows_NT") {
    $SettingsPaths += Join-Path $env:APPDATA "Code\User\settings.json"
    $SettingsPaths += Join-Path $env:APPDATA "Code - Insiders\User\settings.json"
  } elseif ($IsMacOS) {
    $SettingsPaths += Join-Path $HOME "Library/Application Support/Code/User/settings.json"
    $SettingsPaths += Join-Path $HOME "Library/Application Support/Code - Insiders/User/settings.json"
  } else {
    $SettingsPaths += Join-Path $HOME ".config/Code/User/settings.json"
    $SettingsPaths += Join-Path $HOME ".config/Code - Insiders/User/settings.json"
  }

  $SettingsFile = $SettingsPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

  if (-not $SettingsFile) {
    Write-Host "  ⚠️  Could not find VS Code settings.json. Falling back to manual instructions." -ForegroundColor Yellow
  } else {
    $content = Get-Content $SettingsFile -Raw
    $settings = if ($content.Trim()) { $content | ConvertFrom-Json -AsHashtable } else { @{} }

    if (-not $settings.ContainsKey("chat.promptFiles.locations")) {
      $settings["chat.promptFiles.locations"] = @{}
    }
    $promptsPath = Join-Path $AgentsDir "prompts"
    $settings["chat.promptFiles.locations"][$promptsPath] = $true

    $settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
    Write-Host "  ✅ Updated: $SettingsFile" -ForegroundColor Green
  }
} else {
  Write-Host ""
  Write-Host "  Add the following to your VS Code settings.json:" -ForegroundColor Yellow
  Write-Host ""
  Write-Host '  "chat.promptFiles.locations": {'
  Write-Host "    `"$(Join-Path $AgentsDir 'prompts')`": true"
  Write-Host '  }'
  Write-Host ""
  Write-Host "  Open settings: Code → Settings → Open Settings (JSON)  or  Ctrl+Shift+P → 'Open User Settings JSON'"
}

# ─── Done ─────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  $AgentsDir/instructions/  — global Copilot instructions (auto-loaded by VS Code)"
Write-Host "  $AgentsDir/prompts/       — reusable prompt files (clarify, remember, buildPrompt)"
Write-Host "  $AgentsDir/skills/        — agent skill definitions"
Write-Host "  $AgentsDir/notes/         — personal reference notes & cheat sheets"
Write-Host ""
Write-Host "  Next steps:"
Write-Host "  1. Restart VS Code to pick up settings changes."
Write-Host "  2. Open Copilot Chat and run a prompt: type '/' and look for 'clarify', 'remember', or 'buildPrompt'."
Write-Host "  3. Add your own prompts to $AgentsDir/prompts/ at any time."
Write-Host ""
