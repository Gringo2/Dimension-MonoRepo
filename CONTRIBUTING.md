# Contributing to Codesphere

Thank you for your interest in helping make Codesphere the best sovereign IDE!

## Types of Contributions

We welcome contributions in several areas:
- **🛠️ Pipeline Improvements**: Enhancements to the `ci/` or branding injection logic.
- **🎨 Branding Assets**: New high-quality icons or UI asset improvements.
- **📚 Documentation**: Improving guides, translations, or technical reports.
- **🔍 Compliance Patterns**: Identifying new forbidden strings to add to our search patterns.

## Development Setup

To work on Codesphere, follow the [README.md](README.md) instructions to set up a local build environment.

### Code Style
- For shell scripts (`.sh`), we aim for POSIX compliance where possible, using `perl` for cross-platform string manipulation.
- For PowerShell (`.ps1`), follow standard Microsoft scripting guidelines.

## How to Submit a Change

1. **Fork** the repository and create your branch from `main`.
2. **Make your changes** in the appropriate directory (`branding/`, `ci/`, or `docs/`).
3. **Verify** your changes by running a local build and the compliance check: `./ci/compliance-check.sh`.
4. **Submit a Pull Request** with a clear description of what the change accomplishes.

---
*Note: This repository focuses on the **Codesphere distribution layer**. Changes to the VS Code core logic should generally be submitted to VSCodium or upstream VS Code.*
