# Codesphere Rebranding Project

A sovereign developer IDE distribution based on VSCodium/VS Code with complete Microsoft independence.

## Architecture

Codesphere is a hardened, production-ready rebranding of VSCodium that enforces:
- **Complete identity sovereignty** (no Microsoft/VS Code branding)
- **Independent extension registry** (Open VSX by default)
- **Zero telemetry** (all Microsoft endpoints disabled)
- **Reproducible builds** (conflict-resistant upstream merges)

## Quick Start

### Prerequisites
- Node.js 20.18+
- Python 3.11+
- Git
- Bash (Git Bash on Windows)
- jq (optional, for JSON merging)

### Build Codesphere

#### Windows
```powershell
.\ci\patch-branding.ps1
```

#### Linux/macOS
```bash
./ci/patch-branding.sh
```

The script will:
1. Sync the VSCodium submodule
2. Fetch upstream VS Code source
3. Apply Codesphere branding
4. Replace all icons and assets
5. Run automated compliance checks

### Manual Build Steps

If you prefer manual control:

```bash
# 1. Set environment variables
export APP_NAME="Codesphere"
export BINARY_NAME="codesphere"
export VSCODE_QUALITY="stable"

# 2. Prepare VS Code source
cd vendor/vscodium
./prepare_vscode.sh

# 3. Apply branding
cd vscode
cp ../../../branding/product.json product.json

# 4. Build
yarn install --frozen-lockfile
yarn compile

# 5. Package (choose your platform)
yarn gulp vscode-win32-x64-min      # Windows
yarn gulp vscode-darwin-min         # macOS
yarn gulp vscode-linux-x64-min      # Linux
```

## Project Structure

```
Dimension-MonoRepo/
├── branding/              # Codesphere branding assets
│   ├── product.json       # Sovereign identity configuration
│   ├── code.ico           # Windows icon
│   ├── code.icns          # macOS icon
│   ├── code.png           # Linux icon
│   └── code.svg           # Vector logo
├── ci/                    # Automation scripts
│   ├── patch-branding.sh  # Linux/macOS pipeline
│   ├── patch-branding.ps1 # Windows pipeline
│   ├── compliance-check.sh
│   └── compliance-check.ps1
└── vendor/
    └── vscodium/          # Git submodule
```

## Branding Controls

All branding is controlled through:
1. **`branding/product.json`** - Product metadata, extension registry, telemetry settings
2. **`branding/icons/`** - Platform-specific icons
3. **Environment variables** - Runtime configuration (APP_NAME, BINARY_NAME, etc.)

### Key Configuration Points

#### Extension Registry
```json
"extensionsGallery": {
  "serviceUrl": "https://open-vsx.org/vscode/gallery",
  "itemUrl": "https://open-vsx.org/vscode/item"
}
```

#### Telemetry (Disabled)
```json
"telemetry.enableTelemetry": false,
"telemetry.enableCrashReporter": false
```

#### Platform Identifiers
- Windows: `Codesphere.Codesphere`
- macOS: `com.codesphere.ide`
- Linux: `codesphere`

## Verification

### Automated Compliance
```bash
./ci/compliance-check.sh
```

This checks for forbidden references to:
- "VSCodium"
- "Visual Studio Code"
- "VS Code"
- "Microsoft Corporation"

### Manual Verification
1. Launch the built IDE
2. Check **Help → About** shows "Codesphere IDE"
3. Verify window title shows "Codesphere"
4. Search for an extension (should use Open VSX)
5. Monitor network traffic (no Microsoft endpoints)

## Upstream Merge Strategy

Codesphere minimizes merge conflicts by isolating branding to:
- `product.json` (overwritten)
- Icon files (replaced)
- Environment variables (injected at build time)

When VSCodium updates:
1. Pull latest VSCodium: `git submodule update --remote`
2. Re-run branding pipeline: `./ci/patch-branding.sh`
3. Test and verify

## Development

### Adding New Branding Points
1. Update `branding/product.json` with new fields
2. Update `ci/patch-branding.sh` if new file replacements needed
3. Add patterns to `ci/compliance-check.sh` if new forbidden terms identified

### Testing Locally
The build can be tested without full packaging:
```bash
cd vendor/vscodium/vscode
yarn watch
./scripts/code.sh  # Linux/macOS
# or
.\scripts\code.bat  # Windows
```

## License

MIT License - See [LICENSE](LICENSE) for details.

Codesphere is a sovereign distribution of VS Code (MIT licensed) via VSCodium.
