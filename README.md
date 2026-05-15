<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Platform">
  <img src="https://img.shields.io/badge/Language-PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="Language">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
</p>

<h1 align="center">🛠️ MSYS2-Manager</h1>

<p align="center">
  <b>A premium, zero-flicker TUI for managing and maintaining MSYS2 installations.</b><br>
  <sub>Streamline your C++ development environment with one-click maintenance.</sub>
</p>

## ✨ What's Inside

| # | Tool | Description |
|:-:|------|-------------|
| 🔄 | **[MSYS2 Manager](#msys2-manager)** | Interactive maintenance console for updates and cleanup |
| 🛡️ | **[Auto-Cert-Fix](#auto-cert-fix)** | Automatic detection and repair of corrupted SSL certificates |
| 📄 | **[Logging System](#logging-system)** | Built-in auditing for every pacman operation |

---

## 🔄 MSYS2 Manager

> An interactive, flicker-free terminal interface for keeping your MSYS2 toolchain healthy.

### The Problem

- **Manual complexity** — Running `pacman -Syu` multiple times to ensure core system and packages are synced.
- **GPG/Signature errors** — Outdated keyrings often break the update process.
- **Disk bloat** — The pacman cache can grow to several gigabytes if not cleaned.
- **Visual clutter** — Standard PowerShell scripts often flicker or tear when redrawing the screen.

### The Solution

The manager uses a "Synchronized Render" technique that buffers the entire UI frame before displaying it, combined with automatic scrollbar management for a premium desktop-like experience.

```
[ User Input ] --> [ TUI Selection ] --> [ Admin Elevation (gsudo) ]
                                            |
                                            v
                                     [ pacman.exe ] <--- [ Auto-Cert-Fix ]
                                            |
                                            v
                                     [ Log Viewer ]
```

Every operation is wrapped in a robust execution block that captures output to both the screen and local log files.

### Usage

**From Antigravity/Terminal** — *Navigate to the scripts folder and execute the manager.*

**From terminal:**

```powershell
# Run the manager (Requires Admin for pacman operations)
pwsh -File .\Manage-MSYS2.ps1

# Run with gsudo for immediate elevation
gsudo pwsh -File .\Manage-MSYS2.ps1
```

---

## 🛡️ Auto-Cert-Fix

> Silent detection and recovery for common MSYS2 certificate corruption.

### The Problem

- **Broken Trust** — Corrupted (0-byte) `ca-bundle.crt` files prevent any connection to MSYS2 mirrors.
- **Circular Dependency** — You can't use pacman to fix the certificates if the certificates are broken.

### The Solution

The manager performs a pre-flight check on `/usr/ssl/certs/ca-bundle.crt`. If a 0-byte file is detected, it automatically downloads a fresh bundle using PowerShell's native `Invoke-WebRequest` (which uses the Windows Certificate Store) to bootstrap the environment.

---

## 📄 Logging System

> Comprehensive auditing for every maintenance session.

Every time a `pacman` command is executed via the manager, a detailed log is generated in the `logs/` directory.

- **Timestamped entries:** `pacman_YYYYMMdd_HHmmss.log`
- **Full capture:** Standard output and error streams are unified.
- **In-app viewer:** Quickly check the latest results without leaving the TUI.

---

## 📦 Installation

### Quick Setup

```powershell
# Clone the repository
git clone https://github.com/joty79/MSYS2-Manager.git

# Move to the project folder
cd MSYS2-Manager

# Run
.\Manage-MSYS2.ps1
```

### Requirements

| Requirement | Details |
|-------------|---------|
| **PowerShell 7** | Required for the TUI rendering engine |
| **Windows Terminal** | Recommended for the best visual experience |
| **MSYS2** | Must be installed at `D:\Compilers\msys64` (Configurable in script) |
| **gsudo** | Recommended for seamless elevation |

---

## 📁 Project Structure

```
MSYS2-Manager/
├── Manage-MSYS2.ps1     # Main TUI application logic
├── PROJECT_RULES.md     # Development and maintenance guidelines
├── README.md            # You are here
├── .gitignore           # Ignores logs and temporary files
└── logs/                # Session logs (Generated on first run)
```

---

## 🧠 Technical Notes

<details>
<summary><b>Why use "Synchronized Render" (Fix #33)?</b></summary>

Standard terminal redrawing (clearing and printing) causes visible "flicker". By using the `Mode 2026` escape sequence, we tell Windows Terminal to buffer all output and only render it once the frame is complete.

</details>

<details>
<summary><b>Why UCRT64 over MinGW64?</b></summary>

This manager is pre-configured to check the `ucrt64` environment by default, as it provides better compatibility with modern Windows C-runtime (UCRT) compared to the older MSVCRT used by traditional MinGW64.

</details>

---

<p align="center">
  <sub>Modern MSYS2 Maintenance · Zero-Flicker TUI · Built for Developers</sub>
</p>
