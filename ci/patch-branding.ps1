# Codesphere Unified Branding Script (Windows)
# This script orchestrates the complete rebranding pipeline

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting Codesphere rebrand pipeline..." -ForegroundColor Green

# Define paths
$RepoRoot = Split-Path -Parent $PSScriptRoot
$VscodiumDir = Join-Path $RepoRoot "vendor\vscodium"
$BrandingDir = Join-Path $RepoRoot "branding"
$VscodeDir = Join-Path $VscodiumDir "vscode"

# Export environment variables for VSCodium build
$env:APP_NAME = "Codesphere"
$env:APP_NAME_LC = "codesphere"
$env:BINARY_NAME = "codesphere"
$env:GH_REPO_PATH = "Codesphere/codesphere"
$env:ORG_NAME = "Codesphere"
$env:ASSETS_REPOSITORY = "Codesphere/codesphere"
$env:VSCODE_QUALITY = "stable"
$env:SHOULD_BUILD = "yes"
$env:SHOULD_BUILD_REH = "no"
$env:CI_BUILD = "no"
$env:DISABLE_UPDATE = "no"

Write-Host "📦 Environment configured:" -ForegroundColor Cyan
Write-Host "  APP_NAME: $($env:APP_NAME)"
Write-Host "  BINARY_NAME: $($env:BINARY_NAME)"
Write-Host "  VSCODE_QUALITY: $($env:VSCODE_QUALITY)"
Write-Host ""

# Step 1: Fetch upstream VS Code
Write-Host "📥 Step 1: Fetching upstream VS Code..." -ForegroundColor Yellow
Set-Location $VscodiumDir

if (-Not (Test-Path "vscode")) {
    Write-Host "Running prepare_vscode.sh to fetch VS Code source..."
    & bash ./prepare_vscode.sh
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to prepare VS Code source"
    }
} else {
    Write-Host "VS Code source already exists. Skipping fetch."
}

# Step 2: Apply Codesphere product.json
Write-Host "🎨 Step 2: Applying Codesphere product.json..." -ForegroundColor Yellow
$ProductJsonPath = Join-Path $BrandingDir "product.json"

if (Test-Path $ProductJsonPath) {
    Set-Location $VscodeDir
    
    if (Test-Path "product.json") {
        # Backup original
        Copy-Item "product.json" "product.json.bak" -Force
        
        # Check if jq is available
        $jqPath = Get-Command jq -ErrorAction SilentlyContinue
        
        if ($jqPath) {
            # Merge using jq
            $mergedJson = & jq -s '.[0] * .[1]' "product.json" $ProductJsonPath
            $mergedJson | Out-File -FilePath "product.json" -Encoding utf8 -Force
            Write-Host "✅ Product.json merged successfully" -ForegroundColor Green
        } else {
            # If jq is not available, just replace
            Copy-Item $ProductJsonPath "product.json" -Force
            Write-Host "✅ Product.json replaced (jq not available for merge)" -ForegroundColor Green
        }
    } else {
        Copy-Item $ProductJsonPath "product.json" -Force
        Write-Host "✅ Product.json copied" -ForegroundColor Green
    }
}

# Step 3: Replace icons and assets
Write-Host "🖼️  Step 3: Replacing icons and assets..." -ForegroundColor Yellow
Set-Location $VscodiumDir

$StableResourcesDir = "src\stable\resources"
if (Test-Path $StableResourcesDir) {
    Write-Host "Copying icons to $StableResourcesDir..."
    
    # Windows
    $windowsIcon = Join-Path $BrandingDir "code.ico"
    if (Test-Path $windowsIcon) {
        $win32Dir = Join-Path $StableResourcesDir "win32"
        New-Item -ItemType Directory -Force -Path $win32Dir | Out-Null
        Copy-Item $windowsIcon (Join-Path $win32Dir "code.ico") -Force
        Write-Host "  ✅ Windows icon copied" -ForegroundColor Green
    }
    
    # macOS
    $macosIcon = Join-Path $BrandingDir "code.icns"
    if (Test-Path $macosIcon) {
        $darwinDir = Join-Path $StableResourcesDir "darwin"
        New-Item -ItemType Directory -Force -Path $darwinDir | Out-Null
        Copy-Item $macosIcon (Join-Path $darwinDir "code.icns") -Force
        Write-Host "  ✅ macOS icon copied" -ForegroundColor Green
    }
    
    # Linux
    $linuxIcon = Join-Path $BrandingDir "code.png"
    if (Test-Path $linuxIcon) {
        $linuxDir = Join-Path $StableResourcesDir "linux"
        New-Item -ItemType Directory -Force -Path $linuxDir | Out-Null
        Copy-Item $linuxIcon (Join-Path $linuxDir "code.png") -Force
        Write-Host "  ✅ Linux icon copied" -ForegroundColor Green
    }
    
    # SVG
    $svgIcon = Join-Path $BrandingDir "code.svg"
    if (Test-Path $svgIcon) {
        Copy-Item $svgIcon (Join-Path $StableResourcesDir "code.svg") -Force
        Write-Host "  ✅ SVG icon copied" -ForegroundColor Green
    }
}

# Step 4: Run compliance check
Write-Host "🔍 Step 4: Running compliance check..." -ForegroundColor Yellow
Set-Location $RepoRoot

$complianceScript = Join-Path "ci" "compliance-check.ps1"
if (Test-Path $complianceScript) {
    & $complianceScript
} else {
    Write-Host "⚠️  Compliance check script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✨ Codesphere rebrand pipeline completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Review the changes in vendor\vscodium\vscode\"
Write-Host "  2. Run the build: cd vendor\vscodium && bash build.sh"
Write-Host "  3. Test the built application"
