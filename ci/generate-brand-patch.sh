#!/usr/bin/env bash
# Codesphere Patch Generator
# Generates codesphere-brand.patch by applying branding to a clean VSCodium checkout.
# Uses a temporary directory to avoid modifying the VSCodium submodule source.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
VSCODIUM_SUBMODULE="$REPO_ROOT/vendor/vscodium"
PATCH_OUTPUT="$SCRIPT_DIR/patches/codesphere-brand.patch"

# Load central environment (if not already loaded)
if [ -f "$REPO_ROOT/ci/env.sh" ]; then
  . "$REPO_ROOT/ci/env.sh"
fi

# Temporary workspace vars
TEMP_ROOT="$REPO_ROOT/build_temp"
TEMP_VSCODIUM="$TEMP_ROOT/vscodium"
TEMP_VSCODE="$TEMP_VSCODIUM/vscode"

echo "🔧 Codesphere Brand Patch Generator"
echo "===================================="
echo "Working directory: $TEMP_ROOT"

# Cleanup any previous run
rm -rf "$TEMP_ROOT"
mkdir -p "$TEMP_VSCODIUM"

# 1. Copy VSCodium scripts to temp dir (so we can fix CRLF safely)
echo "📦 Copying VSCodium scripts to temp workspace..."
cp -r "$VSCODIUM_SUBMODULE/"* "$TEMP_VSCODIUM/"

# 2. Fix CRLF line endings in the temp scripts (crucial for Windows/WSL)
echo "🔧 Fixing CRLF line endings in temp scripts..."
find "$TEMP_VSCODIUM" -name "*.sh" -type f -exec sed -i 's/\r$//' {} +

# 3. Fetch VS Code source using the temp scripts
echo "📥 Fetching VS Code source (this may take time)..."
cd "$TEMP_VSCODIUM" || exit 1
# Force bash usage to ensuring expected behavior
bash ./get_repo.sh

# 4. Verify fetch success
if [ ! -d "$TEMP_VSCODE/.git" ]; then
  echo "❌ Error: Failed to fetch vscode source in temp dir"
  exit 1
fi

echo "✅ Clean vscode checkout ready in temp dir"
echo ""
echo "🎨 Applying Codesphere branding changes..."

cd "$TEMP_VSCODE" || exit 1

# Apply branding replacements (Regex logic from original enforce-branding.sh)

# github.com/VSCodium -> github.com/Codesphere
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/github\.com\/VSCodium/github.com\/Codesphere/g' {} + 2>/dev/null || true

# VSCodium -> Codesphere (excluding GitHub URLs and @mentions)
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/(?<!github\.com\/)(?<!\@)VSCodium/Codesphere/g' {} + 2>/dev/null || true

# vscodium -> codesphere (lowercase)
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/(?<!github\.com\/)(?<!\@)vscodium/codesphere/g' {} + 2>/dev/null || true

# Visual Studio Code -> Codesphere IDE
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/Visual Studio Code/Codesphere IDE/g' {} + 2>/dev/null || true

# VS Code -> Codesphere
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/VS Code/Codesphere/g' {} + 2>/dev/null || true

# Microsoft Corporation -> Codesphere
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/Microsoft Corporation/Codesphere/g' {} + 2>/dev/null || true

# code.visualstudio.com -> codesphere.com
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" -o -name "*.iss" -o -name "*.xml" -o -name "*.spec.template" -o -name "*.yaml" -o -name "*.template" -o -name "*.rs" -o -name "*.isl" -o -name "*.txt" -o -name "*.toml" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/code\.visualstudio\.com/codesphere.com/g' {} + 2>/dev/null || true

echo "✅ Branding changes applied to temp source"
echo ""
echo "📝 Generating patch file..."

# Generate the patch from the temp repo
git add -A
git diff --cached > "$PATCH_OUTPUT"

echo ""
if [ -s "$PATCH_OUTPUT" ]; then
  PATCH_LINES=$(wc -l < "$PATCH_OUTPUT")
  echo "✅ Patch generated successfully!"
  echo "   File: $PATCH_OUTPUT"
  echo "   Lines: $PATCH_LINES"
  
  # Cleanup
  echo "🧹 Cleaning up temp workspace..."
  cd "$REPO_ROOT"
  rm -rf "$TEMP_ROOT"
  echo "✨ Done."
else
  echo "❌ No changes detected - patch file is empty"
  exit 1
fi
