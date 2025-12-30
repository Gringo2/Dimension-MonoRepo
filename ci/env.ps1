# Codesphere Central Environment Variables (PowerShell)

$env:APP_NAME = "Codesphere"
$env:APP_NAME_LC = "codesphere"
$env:BINARY_NAME = "codesphere"
$env:GH_REPO_PATH = "Codesphere/codesphere"
$env:ORG_NAME = "Codesphere"
$env:ASSETS_REPOSITORY = "Codesphere/codesphere"
if (-not $env:VSCODE_QUALITY) { $env:VSCODE_QUALITY = "stable" }
$env:SHOULD_BUILD = "yes"
$env:SHOULD_BUILD_REH = "no"
if (-not $env:CI_BUILD) { $env:CI_BUILD = "no" }
$env:DISABLE_UPDATE = "no"
$env:VSCODE_LATEST = "no" # Crucial: stick to VSCodium's validated versions to avoid patch failures

if (-not $env:OS_NAME) { $env:OS_NAME = "windows" }
