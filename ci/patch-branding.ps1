# Codesphere Master Local Branding Script (Windows)
# This script orchestrates the complete rebranding pipeline for local development.

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$CiDir = Join-Path $RepoRoot "ci"
$VscodiumDir = Join-Path $RepoRoot "vendor\vscodium"

# Load central environment
if (Test-Path (Join-Path $CiDir "env.ps1")) {
    . (Join-Path $CiDir "env.ps1")
}

Write-Host "🚀 Starting Codesphere Master Branding Pipeline..." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 1: Ensure submodules are initialized
Write-Host "📦 Step 1: Ensuring submodules are initialized..." -ForegroundColor Cyan
git submodule update --init --recursive

# Step 2: Fetch VS Code Source
Write-Host ""
Write-Host "📥 Step 2: Fetching VSCodium/VS Code Source..." -ForegroundColor Yellow
Set-Location $VscodiumDir
& bash ./get_repo.sh

# Step 3: Inject Branding Assets & Patch build scripts
Write-Host ""
Write-Host "🎨 Step 3: Injecting branding and patching build tools..." -ForegroundColor Cyan
& bash (Join-Path $CiDir "ci-branding.sh")

# Step 4: Run VSCodium Preparation (Patches & Cleanup)
Write-Host ""
Write-Host "🔧 Step 4: Running VSCodium preparation (Patches & Cleanup)..." -ForegroundColor Yellow
Write-Host "   (This may take several minutes as it runs npm install)"
Set-Location $VscodiumDir
& bash ./prepare_vscode.sh

# Step 5: Enforce Codesphere Source Code Branding
Write-Host ""
Write-Host "🔍 Step 5: Enforcing Codesphere branding in source code..." -ForegroundColor Cyan
& bash (Join-Path $CiDir "enforce-branding.sh")

# Step 6: Run Compliance Check
Write-Host ""
Write-Host "✅ Step 6: Running compliance verification..." -ForegroundColor Yellow
& powershell (Join-Path $CiDir "compliance-check.ps1")

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✨ Codesphere branding pipeline completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Build Steps:"
Write-Host "  1. cd vendor\vscodium"
Write-Host "  2. bash build.sh (or run yarn gulp in the vscode directory)"
Write-Host ""
