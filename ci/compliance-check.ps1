# Codesphere Automated Compliance Check (Windows)
# Ensures no VSCodium, Microsoft, or VS Code references remain in the codebase

$ErrorActionPreference = "Stop"

Write-Host "🔍 Running Codesphere Compliance Check..." -ForegroundColor Cyan
Write-Host ""

$RepoRoot = Split-Path -Parent $PSScriptRoot
$VscodeDir = Join-Path $RepoRoot "vendor\vscodium\vscode"
$Failed = $false

Set-Location $VscodeDir

# Define forbidden patterns
$Patterns = @(
    "VSCodium",
    "Visual Studio Code",
    "VS Code",
    "Microsoft Corporation"
)

Write-Host "Searching for forbidden brand references..."
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""

foreach ($pattern in $Patterns) {
    Write-Host "Checking for: `"$pattern`"" -ForegroundColor Yellow
    
    # Check if ripgrep is available
    $rgPath = Get-Command rg -ErrorAction SilentlyContinue
    
    if ($rgPath) {
        $matches = & rg --no-ignore --type-not json --type-not lock $pattern . 2>$null
    } else {
        # Fallback to Select-String
        $matches = Get-ChildItem -Recurse -File -Exclude *.json,*.lock |
            Where-Object { $_.FullName -notmatch "node_modules|\.git" } |
            Select-String -Pattern $pattern -SimpleMatch -ErrorAction SilentlyContinue
    }
    
    if ($matches) {
        Write-Host "  ❌ FOUND: $pattern" -ForegroundColor Red
        $matches | Select-Object -First 5 | ForEach-Object {
            Write-Host "    $_" -ForegroundColor Gray
        }
        Write-Host ""
        $Failed = $true
    } else {
        Write-Host "  ✅ Clear" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ($Failed) {
    Write-Host ""
    Write-Host "❌ COMPLIANCE CHECK FAILED" -ForegroundColor Red
    Write-Host "Forbidden brand references were found in the codebase."
    Write-Host "Please review and update the branding patch."
    exit 1
} else {
    Write-Host ""
    Write-Host "✅ COMPLIANCE CHECK PASSED" -ForegroundColor Green
    Write-Host "No forbidden brand references found."
    exit 0
}
