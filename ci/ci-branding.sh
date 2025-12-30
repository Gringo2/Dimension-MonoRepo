#!/usr/bin/env bash
# Codesphere CI Branding Script
# Performs asset injection and build script patching to preserve Codesphere identity.

set -e

# Define paths
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_DIR="$REPO_ROOT/ci"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"
BRANDING_DIR="$REPO_ROOT/branding"

# Load central environment (if not already loaded)
if [ -f "$CI_DIR/env.sh" ]; then
  . "$CI_DIR/env.sh"
fi

echo "🚀 Starting Codesphere branding application..."
echo "📦 Environment: $APP_NAME ($VSCODE_QUALITY)"

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
  
  # Ensure the product.json merge at the end doesn't overwrite our product.json if we want to be safe,
  # but our product.json IS the one we want to merge with anyway.
  
  echo "  ✅ prepare_vscode.sh patched"
fi

# Step 3: Patch build_cli.sh to handle macOS app renaming
if [ -f "$VSCODIUM_DIR/build_cli.sh" ]; then
  echo "🔧 Patching build_cli.sh for macOS app naming..."
  perl -pi -e 'print "  if [ -d \"../../VSCode-darwin-\${VSCODE_ARCH}/VSCodium.app\" ] && [ ! -d \"../../VSCode-darwin-\${VSCODE_ARCH}/\${NAME_SHORT}.app\" ]; then mv \"../../VSCode-darwin-\${VSCODE_ARCH}/VSCodium.app\" \"../../VSCode-darwin-\${VSCODE_ARCH}/\${NAME_SHORT}.app\"; fi\n" if /cp "target\/\${VSCODE_CLI_TARGET}\/release\/code"/' "$VSCODIUM_DIR/build_cli.sh"
  echo "  ✅ build_cli.sh patched"
fi

# Step 4: Patch build.sh to allow skipping prepare_vscode.sh if source is already prepared
if [ -f "$VSCODIUM_DIR/build.sh" ]; then
  echo "🔧 Patching build.sh to allow skipping redundant prepare_vscode.sh..."
  perl -pi -e 's/\. prepare_vscode.sh/if [ "\$SKIP_PREPARE" != "yes" ]; then . prepare_vscode.sh; fi/' "$VSCODIUM_DIR/build.sh"
  echo "  ✅ build.sh patched"
fi

echo "✨ Codesphere branding application complete!"
