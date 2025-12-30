#!/usr/bin/env bash
# Codesphere Master Local Branding Script
# This script orchestrates the complete rebranding pipeline for local development.

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_DIR="$REPO_ROOT/ci"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"

echo "🚀 Starting Codesphere Master Branding Pipeline..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 1: Prepare Branding & Patch Build Scripts
echo "🎨 Step 1: Preparing branding environment..."
"$CI_DIR/ci-branding.sh"

# Step 2: Fetch VSCodium Source (if not already fetched)
echo ""
echo "📥 Step 2: Fetching VSCodium/VS Code Source..."
cd "$VSCODIUM_DIR" || exit 1
if [ ! -d "vscode" ]; then
    ./get_repo.sh
else
    echo "  ✅ Source already exists, skipping fetch."
fi

# Step 3: Enforce Source Code Branding
echo ""
echo "🔍 Step 3: Enforcing brand references in source code..."
"$CI_DIR/enforce-branding.sh"

# Step 4: Run Compliance Check
echo ""
echo "✅ Step 4: Running compliance verification..."
"$CI_DIR/compliance-check.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Codesphere branding pipeline completed successfully!"
echo ""
echo "Next Build Steps:"
echo "  1. cd vendor/vscodium"
echo "  2. ./build.sh (or run yarn gulp in the vscode directory)"
echo ""
