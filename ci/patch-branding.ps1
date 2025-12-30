# Codesphere Master Local Branding Script (Windows)
# This script orchestrates the complete rebranding pipeline for local development.

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$CiDir = Join-Path $RepoRoot "ci"
$VscodiumDir = Join-Path $RepoRoot "vendor\vscodium"

Write-Host "🚀 Starting Codesphere Master Branding Pipeline..." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 1: Prepare Branding & Patch Build Scripts
Write-Host "🎨 Step 1: Preparing branding environment..." -ForegroundColor Cyan
& bash (Join-Path $CiDir "ci-branding.sh")

# Step 2: Fetch VSCodium Source (if not already fetched)
Write-Host ""
Write-Host "📥 Step 2: Fetching VSCodium/VS Code Source..." -ForegroundColor Yellow
Set-Location $VscodiumDir
if (-Not (Test-Path "vscode")) {
    & bash ./get_repo.sh
} else {
    Write-Host "  ✅ Source already exists, skipping fetch." -ForegroundColor Green
}

# Step 3: Enforce Source Code Branding
Write-Host ""
Write-Host "🔍 Step 3: Enforcing brand references in source code..." -ForegroundColor Cyan
& bash (Join-Path $CiDir "enforce-branding.sh")

# Step 4: Run Compliance Check
Write-Host ""
Write-Host "✅ Step 4: Running compliance verification..." -ForegroundColor Yellow
& powershell (Join-Path $CiDir "compliance-check.ps1")

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✨ Codesphere branding pipeline completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Build Steps:"
Write-Host "  1. cd vendor\vscodium"
Write-Host "  2. bash build.sh (or run yarn gulp in the vscode directory)"
Write-Host ""
