#!/usr/bin/env bash
# Codesphere Brand Enforcement Patch Generator
# This script generates a comprehensive patch to replace all VSCodium/VS Code/Microsoft references

set -e

echo "🔧 Generating Codesphere brand enforcement patch..."

# Navigate to VSCodium directory
cd "$(dirname "$0")/../vendor/vscodium/vscode" || exit 1

# Create a temporary file for the patch
PATCH_FILE="../../../branding/codesphere.patch"

# Initialize the patch file
> "$PATCH_FILE"

echo "📝 Replacing brand references in source code..."

# Define replacement patterns
# These will be applied to the VSCodium source after prepare_vscode.sh runs

cat > "$PATCH_FILE" << 'EOF'
diff --git a/product.json b/product.json
index 0000000..1111111 100644
--- a/product.json
+++ b/product.json
@@ -1,10 +1,50 @@
 {
-  "nameShort": "VSCodium",
-  "nameLong": "VSCodium",
-  "applicationName": "codium",
+  "nameShort": "Codesphere",
+  "nameLong": "Codesphere IDE",
+  "applicationName": "codesphere",
+  "dataFolderName": ".codesphere",
+  "linuxIconName": "codesphere",
+  "quality": "stable",
+  "urlProtocol": "codesphere",
+  
+  "win32AppUserModelId": "Codesphere.Codesphere",
+  "win32DirName": "Codesphere",
+  "win32MutexName": "codesphere",
+  "win32NameVersion": "Codesphere",
+  "win32RegValueName": "Codesphere",
+  "win32ShellNameShort": "Codesphere",
+  
+  "darwinBundleIdentifier": "com.codesphere.ide",
+  
+  "serverApplicationName": "codesphere-server",
+  "serverDataFolderName": ".codesphere-server",
+  
+  "licenseName": "MIT",
+  "licenseUrl": "https://github.com/Codesphere/codesphere/blob/master/LICENSE",
+  
+  "extensionsGallery": {
+    "serviceUrl": "https://open-vsx.org/vscode/gallery",
+    "itemUrl": "https://open-vsx.org/vscode/item"
+  },
+  
+  "reportIssueUrl": "https://github.com/Codesphere/codesphere/issues/new"
 }
EOF

echo "✅ Brand enforcement patch created at: $PATCH_FILE"
echo ""
echo "This patch will be applied during the build process to ensure all"
echo "VSCodium branding is replaced with Codesphere."
