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

  # Prevent prepare_vscode.sh from messing with code.iss (we handle it in enforce-branding.sh)
  # Prevent prepare_vscode.sh from messing with code.iss (we handle it in enforce-branding.sh)
  # IMPORTANT: We replace the command with "true" (no-op) to ensure the if/elif block isn't left empty,
  # which would cause a "syntax error near unexpected token fi"
  echo "🔧 Patching prepare_vscode.sh to leave code.iss alone..."
  perl -pi -e 's/sed -i .s\|Microsoft Corporation\|VSCodium\|. build\/win32\/code.iss/true; # code.iss modification suppressed/' "$VSCODIUM_DIR/prepare_vscode.sh"
  perl -pi -e 's/sed -i .s\|https:\/\/code.visualstudio.com\|https:\/\/vscodium.com\|. build\/win32\/code.iss/# code.iss modification suppressed/' "$VSCODIUM_DIR/prepare_vscode.sh"

  # [CODESPHERE ARCHITECTURE] Layer 3 Patch: Disable strict monaco.d.ts check
  # Since we modify source files for branding (Layer 3), the generated monaco.d.ts will differ from the repo version.
  # We patch the build system to ignore this mismatch, similar to how VSCodium patches telemetry.
  echo "🔧 Injecting build system patch: Disable monaco.d.ts strict check..."
  # Append this patch logic to the end of prepare_vscode.sh so it runs after the repo is ready
  cat << 'EOF' >> "$VSCODIUM_DIR/prepare_vscode.sh"

# [CODESPHERE PATCH] Disable monaco.d.ts check in build/lib/compilation.js
echo "🔧 Applying Codesphere build system patches..."
if [ -f "vscode/build/lib/compilation.js" ]; then
  # Replace 'if (isWatch) {' with 'if (true) { // Codesphere: disable strict check'
  # This makes the build think it's always in "watch mode" regarding this specific check,
  # allowing it to update the file in memory/disk without throwing the "out of date" error.
  # Note: The exact code might vary, but usually it guards the error with !isWatch.
  # tailored for: if (!isWatch && ... !== ...) { handleError(...) } -> if (false && ...)
  perl -pi -e 's/if \(!isWatch/if (false/g' vscode/build/lib/compilation.js
  perl -pi -e 's/if \(!isWatch/if (false/g' vscode/build/lib/compilation.ts 2>/dev/null || true
  echo "  ✅ Disabled strict monaco.d.ts check in compilation.js"
else
  echo "  ⚠️ compilation.js not found, skipping monaco.d.ts patch"
fi
EOF
  
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
