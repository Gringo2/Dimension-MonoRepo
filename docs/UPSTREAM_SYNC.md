# 🔄 Upstream Sync Guide

Maintaining Codesphere requires keeping the `vendor/vscodium` submodule synchronized with upstream while ensuring our rebranding pipeline remains robust.

## 1. Monitoring Upstream

VSCodium releases follow VS Code releases (usually monthly). You can monitor for new tags here:
[VSCodium Releases](https://github.com/VSCodium/vscodium/releases)

---

## 2. The Sync Process

When a new version of VSCodium is released, follow these steps to update Codesphere.

### Step A: Update the Submodule
```bash
# Update the vscodium submodule to the latest commit on its main branch
git submodule update --remote vendor/vscodium
```

### Step B: Local Validation Build
Check if our branding pipeline still works with the new source.

```bash
# Apply branding prep
./ci/ci-branding.sh

# Run the fetch and build
cd vendor/vscodium
./get_repo.sh
./build.sh
```

### Step C: Compliance Verification
If the build completes, run the compliance check to ensure no new "VSCodium" or "VS Code" strings have been introduced in the new version.

```bash
cd ../..
./ci/compliance-check.sh
```

---

## 3. Handling Regression / Failures

If the **Compliance Check Fails**:
- This means upstream added new UI strings that aren't covered by `enforce-branding.sh`.
- **Fix**: Identify the new strings and add their patterns to the `find ... sed` block in `ci/enforce-branding.sh`.

If the **Build Fails**:
- Upstream might have changed filenames or the structure of `prepare_vscode.sh`.
- **Fix**: Update the `perl` patching logic in `ci/ci-branding.sh` to match the new line patterns in the upstream script.

---

## 4. Committing the Update

Once verified, commit the submodule pointer change:

```bash
git add vendor/vscodium
git add ci/*.sh  # If you had to fix patches
git commit -m "chore(upstream): Sync with VSCodium v1.XX.X"
git push
```

---
*By following this process, Codesphere can stay up-to-date with VS Code features while maintaining 100% rebranding integrity.*
