# 🌌 Codesphere

**The Sovereign Developer IDE.**  
A hardened, corporate-independent distribution of VS Code built for developer sovereignty and privacy.

[![Linux Build](https://github.com/Codesphere/codesphere/actions/workflows/linux-build.yml/badge.svg)](https://github.com/Codesphere/codesphere/actions/workflows/linux-build.yml)
[![Windows Build](https://github.com/Codesphere/codesphere/actions/workflows/windows-build.yml/badge.svg)](https://github.com/Codesphere/codesphere/actions/workflows/windows-build.yml)
[![macOS Build](https://github.com/Codesphere/codesphere/actions/workflows/macos-build.yml/badge.svg)](https://github.com/Codesphere/codesphere/actions/workflows/macos-build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🏛️ Why Codesphere?

Codesphere is more than a rebrand; it's a **declaration of independence**. While many IDEs claim to be open-source, they often remain tethered to corporate telemetry, proprietary marketplaces, and branded lock-ins. Codesphere breaks these ties.

- **🛡️ Absolute Privacy**: Zero telemetry. Every Microsoft endpoint is explicitly blocked at the source level.
- **🗳️ Extension Sovereignty**: Powered by [Open VSX](https://open-vsx.org/), ensuring an open marketplace with no corporate gatekeeping.
- **🎨 Pure Identity**: A deep, source-level rebrand that removes all traces of legacy branding (VSCodium, VS Code, Microsoft).
- **⚙️ High-Performance CI/CD**: Optimized, platform-specific build pipelines with path-based triggers and isolated releases.

---

## 🚀 Quick Start

### Build Your Own Distribution

Codesphere is designed to be fully reproducible. You can build the entire IDE for your platform with a single command.

#### Windows (PowerShell)
```powershell
.\ci\ci-branding.sh
cd vendor/vscodium
.\build.sh
```

#### Linux & macOS (Bash)
```bash
./ci/ci-branding.sh
cd vendor/vscodium
./build.sh
```

*For detailed platform-specific requirements, see the [Build Guide](docs/BUILD_GUIDE.md).*

---

## 📂 Project Architecture

The project follows a **Layered Injection Architecture**, ensuring that we can stay up-to-date with upstream VS Code updates without manual code merges.

```text
Dimension-MonoRepo/
├── branding/          # 🎨 Custom Identity assets & product configuration
├── ci/                # 🛠️ Rebranding & Compliance automation scripts
├── docs/              # 📚 Technical documentation & standards
└── vendor/vscodium/   # 📦 Upstream core repository (Submodule)
```

For a deep dive into how we "connect the dots" between branding and binary, see [ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## 🧪 Verification & Compliance

We don't just claim rebranding; we enforce it. Our CI pipeline includes a dedicated compliance gate using high-performance search tools.

```bash
# Run the compliance scan manually
./ci/compliance-check.sh
```

**What we check for:**
- [x] No lingering "VSCodium" or "VS Code" strings in the UI.
- [x] Correct application names in window titles and menus.
- [x] No telemetry connections to `*.microsoft.com`.

---

## 🤝 Contributing

We welcome contributions to the Codesphere infrastructure! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to propose changes to the branding or build logic.

---

## ⚖️ License

Codesphere is a distribution of VS Code (MIT) via VSCodium. The build logic and branding in this repository are licensed under the **MIT License**.

---

*Codesphere: Your code, your workspace, your sovereignty.*
