#!/usr/bin/env bash
set -e

echo "🔧 Applying CodeSphere branding to VSCodium submodule..."

# Define source and target paths
BRAND_DIR="./branding"
VSCODIUM_DIR="./vendor/vscodium"
VSCODIUM_RESOURCES="$VSCODIUM_DIR/src/stable/resources"

# Replace icons (Linux)
cp -f "$BRAND_DIR/code.png" "./resources/linux/code.png"
cp -f "$BRAND_DIR/code.png" "./resources/app/resources/linux/code.png"

# Replace icons (Windows)
cp -f "$BRAND_DIR/code.ico" "./resources/win32/code.ico"
cp -f "$BRAND_DIR/code.ico" "./resources/app/resources/win32/code.ico"

# Replace icons (macOS)
cp -f "$BRAND_DIR/code.icns" "./resources/darwin/code.icns"
cp -f "$BRAND_DIR/code.icns" "./resources/app/resources/darwin/code.icns"

# Replace product.json branding
if [ -f "$BRAND_DIR/product.json" ]; then
  cp -f "$BRAND_DIR/product.json" "$VSCODIUM_DIR/product.json"
fi

# Optional: update README with your branding (if template provided)
if [ -f "$BRAND_DIR/README.md" ]; then
  cp -f "$BRAND_DIR/README.md" "./README.md"
fi

# Optional: update license if customized
if [ -f "$BRAND_DIR/LICENSE.txt" ]; then
  cp -f "$BRAND_DIR/LICENSE.txt" "./LICENSE.txt"
fi

echo "✅ CodeSphere branding applied to VSCodium submodule successfully."