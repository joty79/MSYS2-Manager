# Project Rules: MSYS2 Manager

## 🔵 Project Overview
- **Objective:** Provide a lightweight, interactive TUI for maintaining the MSYS2 installation at `D:\Compilers\msys64`.
- **Tech Stack:** PowerShell 7, PS_UI_Blueprint.

## 🔵 Maintenance Guardrails
- **Elevation:** Pacman operations require Admin rights. The script should ideally be run as Administrator.
- **Root Path:** Always target `D:\Compilers\msys64`. Do NOT hardcode `C:\msys64`.
- **Atomic Updates:** Always use `--noconfirm` for TUI-triggered updates to avoid hanging the UI, but ensure the user sees the output.

## 🔵 Changelog
- **2026-05-15:** Initial creation of `Manage-MSYS2.ps1`. Implemented core update, keyring fix, and cache cleaning.
