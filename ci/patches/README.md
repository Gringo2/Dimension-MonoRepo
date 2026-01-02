# Codesphere Branding Patches

This directory contains git patches for applying Codesphere branding to the VSCodium source code.

## Patch Generation

To generate the `codesphere-brand.patch` file:

```bash
cd /path/to/Dimension-MonoRepo
./ci/generate-brand-patch.sh
```

This script will:
1. Verify the VSCodium vscode directory is a clean git checkout
2. Apply all Codesphere branding changes
3. Generate a git diff patch at `ci/patches/codesphere-brand.patch`
4. Reset the vscode directory to its original state

## Patch Application

The patch is automatically applied during the build process by `ci/ci-branding.sh`:

```bash
cd vendor/vscodium/vscode
patch -p1 < ../../../ci/patches/codesphere-brand.patch
```

## What Gets Replaced

The patch performs the following replacements:
- `github.com/VSCodium` → `github.com/Codesphere`
- `VSCodium` → `Codesphere` (excluding URLs)
- `vscodium` → `codesphere` (lowercase)
- `Visual Studio Code` → `Codesphere IDE`
- `VS Code` → `Codesphere`
- `Microsoft Corporation` → `Codesphere`
- `code.visualstudio.com` → `codesphere.com`

## Architecture

This approach aligns with VSCodium's own patch-based methodology:
- **VSCodium** uses `patches/brand.patch` to rebrand VS Code → VSCodium
- **Codesphere** uses `patches/codesphere-brand.patch` to rebrand VSCodium → Codesphere

Benefits:
- ✅ Version-controlled and reviewable
- ✅ No build system integrity issues
- ✅ Maintainable across VSCodium updates
- ✅ Clean architectural layering
