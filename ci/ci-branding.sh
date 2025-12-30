#!/usr/bin/env bash
# Codesphere CI Branding Script
# Comprehensive version that enforces identity across config, assets, and source code.

set -e

echo "🚀 Starting Codesphere CI branding..."

# Define paths
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"
BRANDING_DIR="$REPO_ROOT/branding"

# Export environment variables for VSCodium's scripts
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
echo ""

# Step 1: Copy Codesphere branding assets to VSCodium source locations
echo "📦 Step 1: Copying Codesphere assets to VSCodium..."
cd "$VSCODIUM_DIR" || exit 1

# Copy our custom product.json
if [ -f "$BRANDING_DIR/product.json" ]; then
  cp "$BRANDING_DIR/product.json" product.json
  echo "  ✅ Codesphere product.json copied"
fi

# Overwrite platform icons directly in the source tree
if [ -d "src/stable/resources" ]; then
  echo "  📷 overwriting platform icons in src/stable/resources..."

  # Windows Icon
  if [ -f "$BRANDING_DIR/code.ico" ]; then
    cp "$BRANDING_DIR/code.ico" src/stable/resources/win32/code.ico
    echo "    ✅ Windows icon (code.ico) overwritten"
  fi

  # macOS Icon
  if [ -f "$BRANDING_DIR/code.icns" ]; then
    cp "$BRANDING_DIR/code.icns" src/stable/resources/darwin/code.icns
    echo "    ✅ macOS icon (code.icns) overwritten"
  fi

  # Linux Icon
  if [ -f "$BRANDING_DIR/code.png" ]; then
    cp "$BRANDING_DIR/code.png" src/stable/resources/linux/code.png
    echo "    ✅ Linux icon (code.png) overwritten"
  fi
fi

# Step 2: Patch prepare_vscode.sh to prevent it from overwriting our branding
if [ -f "$VSCODIUM_DIR/prepare_vscode.sh" ]; then
  echo "🔧 Patching prepare_vscode.sh to preserve Codesphere branding..."
  
  # Comment out hardcoded VSCodium branding in the stable block
  # We use a broad replacement to ensure all setpaths for branding are neutralized
  perl -pi -e 's/setpath "product" "(nameShort|nameLong|applicationName|linuxIconName|urlProtocol|serverApplicationName|serverDataFolderName|darwinBundleIdentifier|win32AppUserModelId|win32DirName|win32MutexName|win32NameVersion|win32RegValueName|win32ShellNameShort)" ".*"/# branding parameter suppressed by Codesphere patch/' "$VSCODIUM_DIR/prepare_vscode.sh"
  
  echo "  ✅ prepare_vscode.sh patched"
fi

# Step 3: Brand Enforcement (Source Code Replacements)
# This will be run AFTER get_repo.sh but we can prepare the script or patch
# Since get_repo.sh hasn't run yet in the CI flow (it runs in a separate step),
# we will add a hook that can be called later or just perform replacements
# if the directory exists.
if [ -d "vscode" ]; then
  echo "🔍 Enforcing brand references in source code..."
  cd vscode
  # Replace VSCodium with Codesphere in UI strings, but avoid breaking URLs
  # This is a basic set of replacements; more can be added
  find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" \) -not -path "*/node_modules/*" -exec perl -pi -e 's/(?<!github.com\/)VSCodium/Codesphere/g' {} +
  find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" \) -not -path "*/node_modules/*" -exec perl -pi -e 's/(?<!github.com\/)vscodium/codesphere/g' {} +
  echo "  ✅ Source code branding enforced"
  cd ..
fi

# Patch build_cli.sh to handle macOS app renaming
if [ -f "$VSCODIUM_DIR/build_cli.sh" ]; then
  echo "🔧 Patching build_cli.sh for macOS app naming..."
  perl -pi -e 'print "  if [ -d \"../../VSCode-darwin-\${VSCODE_ARCH}/VSCodium.app\" ] && [ ! -d \"../../VSCode-darwin-\${VSCODE_ARCH}/\${NAME_SHORT}.app\" ]; then mv \"../../VSCode-darwin-\${VSCODE_ARCH}/VSCodium.app\" \"../../VSCode-darwin-\${VSCODE_ARCH}/\${NAME_SHORT}.app\"; fi\n" if /cp "target\/\${VSCODE_CLI_TARGET}\/release\/code"/' "$VSCODIUM_DIR/build_cli.sh"
  echo "  ✅ build_cli.sh patched"
fi

echo "✨ Codesphere branding setup complete!"
echo "VSCodium scripts will now produce a fully branded Codesphere IDE."
