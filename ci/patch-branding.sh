#!/usr/bin/env bash
# Codesphere Unified Branding Script (Linux/macOS)
# This script orchestrates the complete rebranding pipeline

set -e

echo "🚀 Starting Codesphere rebrand pipeline..."

# Define paths
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"
BRANDING_DIR="$REPO_ROOT/branding"
VSCODE_DIR="$VSCODIUM_DIR/vscode"

# Export environment variables for VSCodium build
export APP_NAME="Codesphere"
export APP_NAME_LC="codesphere"
export BINARY_NAME="codesphere"
export GH_REPO_PATH="Codesphere/codesphere"
export ORG_NAME="Codesphere"
export ASSETS_REPOSITORY="Codesphere/codesphere"
export VSCODE_QUALITY="stable"
export SHOULD_BUILD="yes"
export SHOULD_BUILD_REH="no"
export CI_BUILD="no"
export DISABLE_UPDATE="no"

echo "📦 Environment configured:"
echo "  APP_NAME: $APP_NAME"
echo "  BINARY_NAME: $BINARY_NAME"
echo "  VSCODE_QUALITY: $VSCODE_QUALITY"
echo ""

# Step 1: Fetch upstream VS Code
echo "📥 Step 1: Fetching upstream VS Code..."
cd "$VSCODIUM_DIR" || exit 1

if [ ! -d "vscode" ]; then
  echo "Running prepare_vscode.sh to fetch VS Code source..."
  ./prepare_vscode.sh
else
  echo "VS Code source already exists. Skipping fetch."
fi

# Step 2: Apply Codesphere product.json
echo "🎨 Step 2: Applying Codesphere product.json..."
if [ -f "$BRANDING_DIR/product.json" ]; then
  # Merge our branding with the existing product.json
  cd "$VSCODE_DIR" || exit 1
  
  if [ -f "product.json" ]; then
    # Backup original
    cp product.json product.json.bak
    
    # Merge using jq
    if command -v jq &> /dev/null; then
      jq -s '.[0] * .[1]' product.json "$BRANDING_DIR/product.json" > product.json.tmp
      mv product.json.tmp product.json
      echo "✅ Product.json merged successfully"
    else
      # If jq is not available, just replace
      cp "$BRANDING_DIR/product.json" product.json
      echo "✅ Product.json replaced (jq not available for merge)"
    fi
  else
    cp "$BRANDING_DIR/product.json" product.json
    echo "✅ Product.json copied"
  fi
fi

# Step 3: Replace icons and assets
echo "🖼️  Step 3: Replacing icons and assets..."
cd "$VSCODIUM_DIR" || exit 1

# Copy icons to the stable source directory
if [ -d "src/stable/resources" ]; then
  echo "Copying icons to src/stable/resources..."
  
  # Windows
  if [ -f "$BRANDING_DIR/code.ico" ]; then
    mkdir -p src/stable/resources/win32
    cp "$BRANDING_DIR/code.ico" src/stable/resources/win32/code.ico
    echo "  ✅ Windows icon copied"
  fi
  
  # macOS
  if [ -f "$BRANDING_DIR/code.icns" ]; then
    mkdir -p src/stable/resources/darwin
    cp "$BRANDING_DIR/code.icns" src/stable/resources/darwin/code.icns
    echo "  ✅ macOS icon copied"
  fi
  
  # Linux
  if [ -f "$BRANDING_DIR/code.png" ]; then
    mkdir -p src/stable/resources/linux
    cp "$BRANDING_DIR/code.png" src/stable/resources/linux/code.png
    echo "  ✅ Linux icon copied"
  fi
  
  # SVG
  if [ -f "$BRANDING_DIR/code.svg" ]; then
    cp "$BRANDING_DIR/code.svg" src/stable/resources/code.svg
    echo "  ✅ SVG icon copied"
  fi
fi

# Step 4: Run compliance check
echo "🔍 Step 4: Running compliance check..."
cd "$REPO_ROOT" || exit 1

if [ -f "ci/compliance-check.sh" ]; then
  ./ci/compliance-check.sh
else
  echo "⚠️  Compliance check script not found, skipping..."
fi

echo ""
echo "✨ Codesphere rebrand pipeline completed successfully!"
echo ""
echo "Next steps:"
echo "  1. Review the changes in vendor/vscodium/vscode/"
echo "  2. Run the build: cd vendor/vscodium && ./build.sh"
echo "  3. Test the built application"
