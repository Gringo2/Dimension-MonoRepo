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

## 🚀 The Fast Track (Recommended)

We provide a master orchestration script that handles everything from fetching the source to running the compliance check.

### On Linux/macOS:
```bash
# Apply branding and prepare source
./ci/patch-branding.sh

# Run the final build
cd vendor/vscodium
./build.sh
```

### On Windows (PowerShell):
```powershell
# Apply branding and prepare source
.\ci\patch-branding.ps1

# Run the final build
cd vendor/vscodium
.\build.sh
```

---

## 🛠️ Granular Build Steps

If you need more control over the build process, you can run the steps manually:

### 1. Sync Submodules
```bash
git submodule update --init --recursive
```

### 2. Prepare Source
```bash
cd vendor/vscodium
./get_repo.sh
```

### 3. Apply Rebranding
```bash
cd ../..
./ci/ci-branding.sh
./ci/enforce-branding.sh
```

### 4. Verify Compliance
```bash
./ci/compliance-check.sh
```

### 5. Compile & Package
```bash
cd vendor/vscodium/vscode

# Install dependencies
yarn install --frozen-lockfile

# Compile
yarn compile

# Create Minified Build (Package)
# Use your platform's target:
# Windows: vscode-win32-x64-min
# macOS: vscode-darwin-arm64-min / vscode-darwin-x64-min
# Linux: vscode-linux-x64-min / vscode-linux-arm64-min
yarn gulp vscode-linux-x64-min
```

---

## 🧪 Testing the Build

Once the build is complete, you can find the binaries in:
`vendor/vscodium/VSCode-[platform]-[arch]`

Launch the executable and verify:
1. **App Name**: Should be "Codesphere" in the title bar.
2. **Icons**: Should show the Codesphere logo in the taskbar/dock.
3. **About Dialog**: Should display "Codesphere" and your specific build version.

---
*Codesphere: A sovereign IDE distribution.*
