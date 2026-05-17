# ⚡ MagicTopgrade
Automated, silent system updates for Windows using `topgrade-rs`. Designed for power users who want a "set it and forget it" update loop without manual intervention.

## ⚠️ Warning
**This script fuckie-wuckies system security settings.**
- **UAC Bypass:** Temporarily disables UAC prompts (`ConsentPromptBehaviorAdmin = 0`) during execution to prevent update interruptions. If this gets fucked up, very sad. This is the cost of convenience.
- 
## Prerequisites
- **Windows 10/11**
- **Administrator Access**
- **Topgrade installed:** `winget install topgrade-rs.topgrade`
- **Configuration:** A valid `topgrade.toml` in `%APPDATA%`

## Installation
Run the following command in an **elevated PowerShell terminal**:
`iex 
