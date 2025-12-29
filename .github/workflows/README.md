# Codesphere CI/CD

This directory contains GitHub Actions workflows for automated building and testing of Codesphere.

## Workflows

### 🏗️ [`build.yml`](build.yml) - Full Build Pipeline
**Triggers**: Push to `main`, tags (`v*`), manual dispatch

**Platforms**:
- Linux (x64, arm64) → `.deb`, `.rpm`, `.tar.gz`
- Windows (x64, arm64) → `.exe`, `.zip`
- macOS (x64, arm64) → `.dmg`, `.zip`

**Process**:
1. Checkout with submodules
2. Setup Node.js 20.18 + Python 3.11
3. Apply Codesphere branding
4. Build VSCodium with Codesphere identity
5. Upload artifacts (retained 30 days)
6. **On tags**: Create GitHub release with all installers

**Artifacts**:
- `codesphere-linux-x64`
- `codesphere-linux-arm64`
- `codesphere-windows-x64`
- `codesphere-windows-arm64`
- `codesphere-macos-x64`
- `codesphere-macos-arm64`

### 🧪 [`test.yml`](test.yml) - Quick Validation
**Triggers**: Pull requests, manual dispatch

**Jobs**:
1. **Compliance Check**: Ensures no forbidden brand references (VSCodium, Microsoft)
2. **Test Build**: Compiles code on Linux x64 without full packaging

**Purpose**: Fast feedback before merging PRs

## Creating a Release

To trigger a full build and release:

```bash
# Tag the commit
git tag -a v1.0.0 -m "Codesphere v1.0.0"

# Push the tag
git push origin v1.0.0
```

The workflow will automatically:
1. Build installers for all platforms
2. Create a GitHub release
3. Upload all artifacts to the release

## Manual Workflow Dispatch

You can manually trigger builds from the GitHub Actions UI:
1. Go to **Actions** tab
2. Select `Build Codesphere` workflow
3. Click **Run workflow**
4. Choose branch and click **Run workflow**

## Environment Variables

All workflows use these variables:
- `APP_NAME`: "Codesphere"
- `BINARY_NAME`: "codesphere"
- `VSCODE_QUALITY`: "stable"

These are injected into the VSCodium build process via our branding scripts.

## Build Times (Estimated)

| Platform | Architecture | Build Time |
|:---------|:-------------|:-----------|
| Linux | x64 | ~15-20 min |
| Linux | arm64 | ~20-25 min |
| Windows | x64 | ~20-25 min |
| Windows | arm64 | ~25-30 min |
| macOS | x64 | ~25-30 min |
| macOS | arm64 | ~30-35 min |

**Total pipeline time**: ~30-40 minutes (parallel execution)

## Troubleshooting

### Build fails on compliance check
The compliance check found forbidden brand references. Review the logs to see which files contain "VSCodium", "Visual Studio Code", "VS Code", or "Microsoft Corporation".

**Fix**: Update `ci/compliance-check.sh` to exclude false positives or update the branding patch.

### Artifact upload fails
Check the build output artifacts exist at the expected paths. VSCodium's build script may have changed output locations.

**Fix**: Update artifact paths in the workflow.

### Release creation fails
Ensure the workflow has `contents: write` permission and that `GITHUB_TOKEN` is available.

## Security Notes

- Workflows run in isolated GitHub-hosted runners
- No credentials are required for building
- Release creation uses automatic `GITHUB_TOKEN`
- Artifacts are retained for 30 days (configurable)
