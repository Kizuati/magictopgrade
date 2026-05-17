![ASCI Logo](pseudologo_asci.gif)                                                                                            
## ⚡MagicTopgrade   
Automated, silent system updates for Windows. Designed for power users who want a "set it and forget it" update loop using topgrade-rs. No manual intervention required.<br>
You obviously need Topgrade for this to work and actually update things.


 ## ⚠️Critical Warning 
**🚨This script actively fucks system security settings.** <br>
```UAC Bypass:``` Temporarily disables User Account Control (ConsentPromptBehaviorAdmin = 0) during execution to prevent update interruptions.<br>
```Why?```: This is a deliberate security risk for the sake of convenience. If misconfigured, it leaves your system vulnerable to privilege escalation.<br>
```Mitigations```: The script attempts to restore UAC immediately after completion and tells if you it thinks it failed.<br><br>


## Prerequisites 
| Requirements | Detail |
| :--- | :--- |
| OS | `Windows 10/11` |
| Permissions | `Administrator Access` |
| Dependency | `topgrade` installed via `winget` — Duh. |
| Config | A valid `topgrade.toml` located in `%APPDATA%` |<br>


## 🚀 Installation

Run this command in an **elevated PowerShell terminal**:
```powershell
iwr https://s.kizuati.com/magictopgrade_inst | iex powershell
```
🛑 Uninstallation
To remove the scheduled task and all associated files:
```powershell
iwr https://s.kizuati.com/magictopgrade_inst | iex -Uninstall 
```
## Configuration 
No configuration exists beyond what's natively available in topgrade.
Edit your topgrade.toml at %APPDATA%\topgrade.toml to customize update behavior.<br>

## Troubleshooting
| Issue | Solution |
| :--- | :--- |
| `Config not found` | Ensure `topgrade.toml` exists in `%APPDATA%`. |
| `Task not running` | Check **Event Viewer** > **Windows Logs** > **Application** for PowerShell errors. |
| `UAC stuck at 0` | Manually reset via:<br>`reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 3 /f` |
<br>

**🚨Use at your own risk. It's not my fault if the Iranian-Russian viruses kill you without your UAC condoms🚨**

