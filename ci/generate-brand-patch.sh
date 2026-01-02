#!/usr/bin/env bash
# Codesphere Patch Generator
# This script generates the codesphere-brand.patch file by applying branding changes
# to a clean VSCodium vscode checkout and creating a git diff.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"
VSCODE_DIR="$VSCODIUM_DIR/vscode"
PATCH_OUTPUT="$SCRIPT_DIR/patches/codesphere-brand.patch"

echo "🔧 Codesphere Brand Patch Generator"
echo "===================================="
echo ""

# Ensure we're in a git repo
if [ ! -d "$VSCODE_DIR/.git" ]; then
  echo "❌ Error: $VSCODE_DIR is not a git repository"
  echo "Please run vendor/vscodium/get_repo.sh first to initialize the vscode directory"
  exit 1
fi

cd "$VSCODE_DIR" || exit 1

# Make sure the working directory is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "⚠️  Warning: vscode directory has uncommitted changes"
  echo "Resetting to clean state..."
  git reset --hard HEAD
  git clean -fd
fi

echo "✅ Clean vscode checkout ready"
echo ""
echo "🎨 Applying Codesphere branding changes..."

# Apply all the branding replacements that were in enforce-branding.sh
# First, github.com/VSCodium -> github.com/Codesphere
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

echo "✅ Branding changes applied"
echo ""
echo "📝 Generating patch file..."

# Generate the patch
git add -A
git diff --cached > "$PATCH_OUTPUT"

# Reset the changes
git reset --hard HEAD
git clean -fd

echo ""
if [ -s "$PATCH_OUTPUT" ]; then
  PATCH_LINES=$(wc -l < "$PATCH_OUTPUT")
  echo "✅ Patch generated successfully!"
  echo "   File: $PATCH_OUTPUT"
  echo "   Lines: $PATCH_LINES"
else
  echo "❌ No changes detected - patch file is empty"
  exit 1
fi
