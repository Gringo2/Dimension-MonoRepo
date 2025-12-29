#!/usr/bin/env bash
# Codesphere Automated Compliance Check
# Ensures no VSCodium, Microsoft, or VS Code references remain in the codebase

set -e

echo "🔍 Running Codesphere Compliance Check..."
echo ""

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VSCODE_DIR="$REPO_ROOT/vendor/vscodium/vscode"
FAILED=false

# Check if ripgrep is available
if command -v rg &> /dev/null; then
    GREP_CMD="rg --no-ignore --type-not json --type-not lock"
else
    echo "⚠️  ripgrep not found, falling back to grep"
    GREP_CMD="grep -r --exclude-dir=node_modules --exclude-dir=.git --exclude='*.json' --exclude='*.lock'"
fi

cd "$VSCODE_DIR" || exit 1

# Define forbidden patterns
PATTERNS=(
    "VSCodium"
    "Visual Studio Code"
    "VS Code"
    "Microsoft Corporation"
)

echo "Searching for forbidden brand references..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for pattern in "${PATTERNS[@]}"; do
    echo "Checking for: \"$pattern\""
    
    if command -v rg &> /dev/null; then
        matches=$(rg --no-ignore --type-not json --type-not lock "$pattern" . 2>/dev/null || true)
    else
        matches=$(grep -r --exclude-dir=node_modules --exclude-dir=.git --exclude='*.json' --exclude='*.lock' "$pattern" . 2>/dev/null || true)
    fi
    
    if [ -n "$matches" ]; then
        echo "  ❌ FOUND: $pattern"
        echo "$matches" | head -n 5
        echo ""
        FAILED=true
    else
        echo "  ✅ Clear"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$FAILED" = true ]; then
    echo ""
    echo "❌ COMPLIANCE CHECK FAILED"
    echo "Forbidden brand references were found in the codebase."
    echo "Please review and update the branding patch."
    exit 1
else
    echo ""
    echo "✅ COMPLIANCE CHECK PASSED"
    echo "No forbidden brand references found."
    exit 0
fi
