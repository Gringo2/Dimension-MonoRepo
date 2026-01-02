#!/usr/bin/env bash
# Codesphere CI Branding Script
# Performs asset injection and applies branding patches to preserve Codesphere identity.

set -e

# Define paths
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_DIR="$REPO_ROOT/ci"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"
VSCODE_DIR="$VSCODIUM_DIR/vscode"
BRANDING_DIR="$REPO_ROOT/branding"
BRAND_PATCH="$CI_DIR/patches/codesphere-brand.patch"

# Load central environment (if not already loaded)
if [ -f "$CI_DIR/env.sh" ]; then
  . "$CI_DIR/env.sh"
fi

echo "🚀 Starting Codesphere branding application (Patch-Based)"
echo "📦 Environment: $APP_NAME ($VSCODE_QUALITY)"
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
  echo "  📷 Overwriting platform icons in src/stable/resources..."

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

echo ""

# Step 2: Apply Codesphere branding patch (VSCodium-style)
echo "🎨 Step 2: Applying Codesphere branding patch..."

if [ ! -f "$BRAND_PATCH" ]; then
  echo "❌ Error: Branding patch not found at $BRAND_PATCH"
  echo "Please run: ./ci/generate-brand-patch.sh to create it"
  exit 1
fi

cd "$VSCODE_DIR" || exit 1

# Apply the patch
if patch -p1 --forward --dry-run < "$BRAND_PATCH" > /dev/null 2>&1; then
  patch -p1 < "$BRAND_PATCH"
  echo "  ✅ Codesphere branding patch applied successfully"
else
  echo "  ⚠️  Patch already applied or conflicts detected - skipping"
fi

echo ""

# Step 3: Patch prepare_vscode.sh to prevent VSCodium from overwriting our branding
echo "🔧 Step 3: Patching prepare_vscode.sh..."

if [ -f "$VSCODIUM_DIR/prepare_vscode.sh" ]; then
  # Comment out hardcoded VSCodium branding parameters
  perl -pi -e 's/setpath \"product\" \"(nameShort|nameLong|applicationName|linuxIconName|urlProtocol|serverApplicationName|serverDataFolderName|darwinBundleIdentifier|win32AppUserModelId|win32DirName|win32MutexName|win32NameVersion|win32RegValueName|win32ShellNameShort)\" \".*\"/# branding parameter suppressed by Codesphere patch/' "$VSCODIUM_DIR/prepare_vscode.sh"

  # Prevent prepare_vscode.sh from modifying code.iss
  perl -pi -e 's/sed -i .s\|Microsoft Corporation\|VSCodium\|. build\/win32\/code.iss/true; # code.iss modification suppressed/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/sed -i .s\|https:\/\/code.visualstudio.com\|https:\/\/vscodium.com\|. build\/win32\/code.iss/# code.iss modification suppressed/' "$VSCODIUM_DIR/prepare_vscode.sh"
  
  echo "  ✅ prepare_vscode.sh patched to preserve Codesphere branding"
fi

echo ""
echo "✅ Codesphere branding application complete!"
echo "🎯 Next: Run the build (e.g., ./vendor/vscodium/build.sh)"
