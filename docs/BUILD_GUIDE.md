# ⚒️ Codesphere Build Guide

This guide provides detailed instructions for building Codesphere locally on your machine.

## 📋 Prerequisites

### Global Requirements
- **Node.js**: `v22.x` (Recommended)
- **Python**: `3.11+`
- **Git**: Latest version
- **Rust**: Required for building the VS Code CLI (use `rustup`)

### Platform-Specific Dependencies

#### 🪟 Windows
- **Visual Studio 2022** with "Desktop development with C++"
- **Git Bash** (Ensure it's in your PATH)
- **jq** (Recommended: `choco install jq`)

#### 🐧 Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential pkg-config \
  libx11-dev libxkbfile-dev \
  libsecret-1-dev libkrb5-dev \
  fakeroot rpm dpkg jq
```

#### 🍎 macOS
- **Xcode Command Line Tools** (`xcode-select --install`)
- **Homebrew** (for `jq` and other utilities)
```bash
brew install jq
```

---

## 🚀 Quick Start Build

### 1. Generate the Branding Patch
First time only - create the `codesphere-brand.patch`:
```bash
./ci/generate-brand-patch.sh
```

### 2. Apply Branding and Prepare Source
```bash
# Initialize submodules and fetch VS Code source
git submodule update --init --recursive
cd vendor/vscodium
./get_repo.sh

# Apply Codesphere branding
cd ../..
./ci/ci-branding.sh

# Run VSCodium preparation
cd vendor/vscodium
./prepare_vscode.sh
```

### 3. Build
```bash
cd vscode

# Install dependencies
yarn install --frozen-lockfile

# Compile
yarn compile

# Create packaged build (choose your platform)
# Windows: vscode-win32-x64-min
# macOS: vscode-darwin-arm64-min / vscode-darwin-x64-min
# Linux: vscode-linux-x64-min / vscode-linux-arm64-min
yarn gulp vscode-linux-x64-min
```

---

## ✅ Verifying the Build

Once complete, find the binaries in:
`vendor/vscodium/VSCode-[platform]-[arch]`

Launch and verify:
1. **App Name**: Should be "Codesphere" in the title bar
2. **Icons**: Should show the Codesphere logo
3. **About Dialog**: Should display "Codesphere" and build version

---

*Codesphere: A sovereign IDE distribution.*
