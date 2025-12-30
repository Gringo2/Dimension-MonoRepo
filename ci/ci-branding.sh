#!/usr/bin/env bash
# Codesphere CI Branding Script
# Simpler version for CI environments that integrates with VSCodium's build.sh

set -e

echo "🚀 Starting Codesphere CI branding..."

# Define paths
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"
BRANDING_DIR="$REPO_ROOT/branding"

# Export environment variables that VSCodium's scripts will use
export APP_NAME="Codesphere"
export APP_NAME_LC="codesphere"
export BINARY_NAME="codesphere"
export GH_REPO_PATH="Codesphere/codesphere"
export ORG_NAME="Codesphere"
export ASSETS_REPOSITORY="Codesphere/codesphere"
export VSCODE_QUALITY="${VSCODE_QUALITY:-stable}"
export SHOULD_BUILD="yes"
export SHOULD_BUILD_REH="no"
export CI_BUILD="yes"
export DISABLE_UPDATE="no"
export OS_NAME="${OS_NAME:-linux}"

echo "📦 Environment configured:"
echo "  APP_NAME: $APP_NAME"
echo "  BINARY_NAME: $BINARY_NAME"
echo "  VSCODE_QUALITY: $VSCODE_QUALITY"
echo "  OS_NAME: $OS_NAME"
echo ""

# Step 1: Copy Codesphere branding assets to VSCodium source locations
# These will be picked up by VSCodium's prepare_vscode.sh script
echo "📦 Step 1: Copying Codesphere assets to VSCodium..."
cd "$VSCODIUM_DIR" || exit 1

# Copy our custom product.json
if [ -f "$BRANDING_DIR/product.json" ]; then
  cp "$BRANDING_DIR/product.json" product.json
  echo "  ✅ Codesphere product.json copied"
fi

# Copy icons to VSCodium's icon locations
if [ -d "icons/stable" ]; then
  if [ -f "$BRANDING_DIR/code.png" ]; then
    cp "$BRANDING_DIR/code.png" icons/stable/codium_src.png
    echo "  ✅ Icons copied"
  fi
fi

echo ""

# Patch prepare_vscode.sh to prevent it from overwriting our branding
if [ -f "$VSCODIUM_DIR/prepare_vscode.sh" ]; then
  echo "🔧 Patching prepare_vscode.sh to preserve Codesphere branding..."
  
  # Comment out hardcoded VSCodium branding in the stable block
  perl -pi -e 's/setpath "product" "nameShort" "VSCodium"/# setpath "product" "nameShort" "VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "nameLong" "VSCodium"/# setpath "product" "nameLong" "VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "applicationName" "codium"/# setpath "product" "applicationName" "codium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "linuxIconName" "vscodium"/# setpath "product" "linuxIconName" "vscodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "urlProtocol" "vscodium"/# setpath "product" "urlProtocol" "vscodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "serverApplicationName" "codium-server"/# setpath "product" "serverApplicationName" "codium-server"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "serverDataFolderName" ".vscodium-server"/# setpath "product" "serverDataFolderName" ".vscodium-server"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "darwinBundleIdentifier" "com.vscodium"/# setpath "product" "darwinBundleIdentifier" "com.vscodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "win32AppUserModelId" "VSCodium.VSCodium"/# setpath "product" "win32AppUserModelId" "VSCodium.VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "win32DirName" "VSCodium"/# setpath "product" "win32DirName" "VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "win32MutexName" "vscodium"/# setpath "product" "win32MutexName" "vscodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "win32NameVersion" "VSCodium"/# setpath "product" "win32NameVersion" "VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "win32RegValueName" "VSCodium"/# setpath "product" "win32RegValueName" "VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/setpath "product" "win32ShellNameShort" "VSCodium"/# setpath "product" "win32ShellNameShort" "VSCodium"/' "$VSCODIUM_DIR/prepare_vscode.sh"
  
  echo "  ✅ prepare_vscode.sh patched"
fi

echo "✨ Codesphere branding setup complete!"
echo "VSCodium's build.sh will now integrate these into the build."

# Patch build_cli.sh to handle macOS app renaming if Gulp output defaults to VSCodium.app
if [ -f "$VSCODIUM_DIR/build_cli.sh" ]; then
  echo "🔧 Patching build_cli.sh for macOS app naming..."
  # Use perl for cross-platform in-place editing compatibility
  perl -pi -e 'print "  if [ -d \"../../VSCode-darwin-\${VSCODE_ARCH}/VSCodium.app\" ] && [ ! -d \"../../VSCode-darwin-\${VSCODE_ARCH}/\${NAME_SHORT}.app\" ]; then mv \"../../VSCode-darwin-\${VSCODE_ARCH}/VSCodium.app\" \"../../VSCode-darwin-\${VSCODE_ARCH}/\${NAME_SHORT}.app\"; fi\n" if /cp "target\/\${VSCODE_CLI_TARGET}\/release\/code"/' "$VSCODIUM_DIR/build_cli.sh"
  echo "  ✅ build_cli.sh patched"
fi
