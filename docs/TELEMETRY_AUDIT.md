# 🛡️ Codesphere Telemetry Audit & Privacy Report

This document outlines the specific technical measures taken to ensure that Codesphere is 100% free of Microsoft telemetry and proprietary tracking.

## 1. Zero-Telemetry Configuration (`product.json`)

We have explicitly disabled all built-in telemetry services at the product configuration level.

| Key | Value | Purpose |
| :--- | :--- | :--- |
| `telemetry.enableTelemetry` | `false` | Disables the primary telemetry reporting service. |
| `telemetry.enableCrashReporter` | `false` | Prevents crash dump uploads to external servers. |
| `extensionsGallery.serviceUrl` | `https://open-vsx.org/...` | Redirects extension discovery away from MS servers. |

## 2. Source-Level Endpoint Neutralization

The `ci/enforce-branding.sh` script performs a deep-scan and replacement of strings that could bypass configuration.

- **String Replacement**: The script removes references that link telemetry handlers back to corporate endpoints.
- **VSCodium Cleanup**: We benefit from the underlying [VSCodium source cleaning](https://github.com/VSCodium/vscodium/blob/master/undo_telemetry.sh) which strips proprietary telemetry libraries and their associated API keys from the VS Code core during the `get_repo.sh` phase.

## 3. Network Sovereignty

Codesphere is designed to be "silent" on the wire by default.

### Known Safe Connections
The following are the **ONLY** external connections Codesphere is designed to make:
1.  **Open VSX (`open-vsx.org`)**: When searching for or installing extensions.
2.  **GitHub (`github.com`)**: When checking for updates via the manual release channel (if enabled).

### Verified Redacted Endpoints
The following endpoints found in raw VS Code source are verified as **BLOCKED or REMOVED** in Codesphere:
- `vortex.data.microsoft.com`
- `mobile.pipe.aria.microsoft.com`
- `visualstudio-devdiv-crashes.azurewebsites.net`
- `*.telemetry.microsoft.com`

## 4. How to Verify for Yourself

We encourage independent audits of our distribution.

### Using MITMProxy (Linux/macOS)
1. Install `mitmproxy`.
2. Launch Codesphere with proxy settings:
   ```bash
   export HTTPS_PROXY=http://127.0.0.1:8080
   codesphere
   ```
3. Observe all outgoing traffic. You will see zero requests to Microsoft domains.

### Manual String Audit
```bash
# Scan the built source for any lingering Microsoft telemetry URIs
grep -r "vortex.data.microsoft.com" vendor/vscodium/vscode
```

---
*Codesphere remains committed to absolute developer privacy. No tracking. No telemetry. No exceptions.*
