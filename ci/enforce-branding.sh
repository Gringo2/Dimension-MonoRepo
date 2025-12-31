#!/usr/bin/env bash
# Codesphere Source Branding Enforcement
# This script replaces brand references in the source code after get_repo.sh has run.

set -e

echo "🔍 Enforcing Codesphere branding in source code..."

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_DIR="$REPO_ROOT/ci"
VSCODE_DIR="$REPO_ROOT/vendor/vscodium/vscode"

# Load central environment
if [ -f "$CI_DIR/env.sh" ]; then
  . "$CI_DIR/env.sh"
fi

if [ ! -d "$VSCODE_DIR" ]; then
  echo "❌ Error: VS Code source directory not found at $VSCODE_DIR"
  exit 1
fi

cd "$VSCODE_DIR" || exit 1

# Define patterns to replace
# We use perl for its robust regex support (specifically negative lookbehind for URLs)
# Note: We avoid replacing "github.com/VSCodium" to keep repository links functional if needed,
# though we already updated product.json to point to Codesphere's own URLs.

echo "  Replacing 'VSCodium' -> 'Codesphere'..."
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/(?<!github.com\/)(?<!\@)VSCodium/Codesphere/g' {} +

echo "  Replacing 'vscodium' -> 'codesphere'..."
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/(?<!github.com\/)(?<!\@)vscodium/codesphere/g' {} +

echo "  Replacing 'Visual Studio Code' -> 'Codesphere IDE'..."
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/Visual Studio Code/Codesphere IDE/g' {} +

echo "  Replacing 'VS Code' -> 'Codesphere'..."
find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.html" -o -name "*.json" -o -name "*.md" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec perl -pi -e 's/VS Code/Codesphere/g' {} +

echo "✅ Source code branding enforcement complete!"
