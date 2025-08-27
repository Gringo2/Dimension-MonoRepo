# Dimension-MonoRepo
Open-source MonoRepo of Vscodium. Rebranding done easy.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/Gringo2/Dimension-MonoRepo/build.yml?branch=main&label=Build&logo=github&style=flat-square)
![GitHub Issues](https://img.shields.io/github/issues/Gringo2/Dimension-MonoRepo?style=flat-square)
![GitHub License](https://img.shields.io/github/license/Gringo2/Dimension-MonoRepo?style=flat-square)
![GitHub Repo Size](https://img.shields.io/github/repo-size/Gringo2/Dimension-MonoRepo?style=flat-square)
![GitHub Top Language](https://img.shields.io/github/languages/top/Gringo2/Dimension-MonoRepo?style=flat-square)

---

## Dimension-MonoRepo

**Open-source monorepo for VSCodium rebranding — rebranding made easy.**

> A unified repository designed to simplify customizing and rebranding VSCodium. Whether you want to create a white-label IDE, change product branding, or experiment with custom builds, Dimension-MonoRepo gives you the structure and tools to do it faster.

---

### 📖 Table of Contents
1. [About](#about)  
2. [Why Use Dimension-MonoRepo?](#why-use-dimension-monorepo)  
3. [Features](#features)  
4. [Repository Structure](#repository-structure)  
5. [Getting Started](#getting-started)  
6. [Usage](#usage)  
7. [Build & CI/CD](#build--cicd)  
8. [Roadmap](#roadmap)  
9. [Contributing](#contributing)  
10. [License](#license)  
11. [Contact](#contact)

---

### 🔹 About
Dimension-MonoRepo centralizes the full rebranding workflow of VSCodium. Instead of juggling scattered scripts or manual edits, you can rely on one monorepo that handles patches, build pipelines, and packaging consistently.

This project is **community-driven** and aims to lower the barrier for developers and organizations who need a custom-branded version of VSCodium.

---

### 💡 Why Use Dimension-MonoRepo?
- **Consistency** – Everything needed for rebranding lives in one place.  
- **Saves Time** – Skip the trial-and-error of modifying build scripts manually.  
- **Scalable** – Perfect for teams maintaining multiple branded IDEs.  
- **CI/CD Ready** – Works smoothly with GitHub Actions, GitLab CI, or any pipeline.  
- **Open Source** – BSD-2-Clause licensed for full flexibility.  

---

### ✨ Features
- Preconfigured **branding patches** (name, logos, metadata).  
- Ready-to-use **build automation scripts**.  
- Cross-platform compatibility (Linux, macOS, Windows).  
- Example workflows for GitHub Actions.  
- Centralized dependency management in a monorepo.  
- Extendable for custom themes, extensions, or settings.  

---

### 🗂 Repository Structure
Dimension-MonoRepo/
│
├── branding/ # Branding assets (logos, icons, names, about text)
├── patches/ # Patch scripts applied to VSCodium
├── build/ # Build automation scripts
├── ci/ # Example CI/CD workflows (GitHub Actions, etc.)
├── docs/ # Documentation & guides
├── scripts/ # Helper scripts (install, release, update)
└── LICENSE # BSD-2-Clause license

markdown
Copy
Edit

---

### 🚀 Getting Started

#### Prerequisites
- **Git** – clone and manage the repo  
- **Node.js** – needed for build scripts  
- **Yarn / npm** – package management  
- **Docker** *(optional)* – for containerized builds  
- **VSCodium build dependencies** (check [VSCodium docs](https://github.com/VSCodium/vscodium))  

#### Installation
bash
bash
bash
bash

git clone https://github.com/Gringo2/Dimension-MonoRepo.git
cd Dimension-MonoRepo

🛠 Usage
Customize Branding

Edit branding/ assets (icons, product name, about page).

Apply Patches

Run provided patch scripts:
./scripts/apply-patches.sh

Build

Use the build script:
./scripts/build.sh
Output binaries will be available in out/.

⚡ Build & CI/CD
This repo includes example GitHub Actions workflows to automate builds.

Windows, macOS, and Linux pipelines
Artifact upload for releases
Optional Docker image publishing

To trigger a manual build:
gh workflow run build.yml

📍 Roadmap
[+] Add macOS .dmg rebranding automation
[+]Extend Windows installer branding (icons, metadata, about page)
[+] Provide Docker images for branded builds
[+] Add CLI tool for “one-command rebranding”
[+] Community branding templates (starter packs)

🤝 Contributing
We welcome contributions! Please check out our CONTRIBUTING.md (if available) or open an issue before starting large changes.

Basic flow:
git checkout -b feature/my-feature
git commit -m "Add feature"
git push origin feature/my-feature
Then open a Pull Request 🚀

📜 License
This project is licensed under the BSD-2-Clause License – see LICENSE for details.

📬 Contact
Maintained by @Gringo2.
Questions, ideas, or issues? Open a GitHub issue or start a discussion in the repo.
