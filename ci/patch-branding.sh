#!/usr/bin/env bash
# Codesphere Master Local Branding Script
# This script orchestrates the complete rebranding pipeline for local development.

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_DIR="$REPO_ROOT/ci"
VSCODIUM_DIR="$REPO_ROOT/vendor/vscodium"

# Load central environment
if [ -f "$CI_DIR/env.sh" ]; then
  . "$CI_DIR/env.sh"
fi

echo "🚀 Starting Codesphere Master Branding Pipeline..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 1: Ensure submodules are initialized
echo "📦 Step 1: Ensuring submodules are initialized..."
git submodule update --init --recursive

# Step 2: Fetch VS Code Source
echo ""
echo "📥 Step 2: Fetching VSCodium/VS Code Source..."
cd "$VSCODIUM_DIR" || exit 1
./get_repo.sh

# Step 3: Inject Branding Assets & Patch build scripts
# We do this now so that prepare_vscode.sh is already patched when we run it.
echo ""
echo "🎨 Step 3: Injecting branding and patching build tools..."
"$CI_DIR/ci-branding.sh"

# Step 4: Run VSCodium Preparation (Patches & Cleanup)
# IMPORTANT: This must run BEFORE enforce-branding.sh to avoid patch failures.
echo ""
echo "🔧 Step 4: Running VSCodium preparation (Patches & Cleanup)..."
echo "   (This may take several minutes as it runs npm install)"
cd "$VSCODIUM_DIR" || exit 1
./prepare_vscode.sh

# Step 5: Enforce Codesphere Source Code Branding
# This overrides VSCodium's branding with Codesphere's identity.
echo ""
echo "🔍 Step 5: Enforcing Codesphere branding in source code..."
"$CI_DIR/enforce-branding.sh"

# Step 6: Run Compliance Check
echo ""
echo "✅ Step 6: Running compliance verification..."
"$CI_DIR/compliance-check.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Codesphere branding pipeline completed successfully!"
echo ""
echo "Next Build Steps:"
echo "  1. cd vendor/vscodium"
echo "  2. ./build.sh (or run yarn gulp in the vscode directory)"
echo ""
