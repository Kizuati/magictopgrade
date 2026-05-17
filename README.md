
                                                                                                          
⚡ **MagicTopgrade**
Automated, silent system updates for Windows.
Designed for power users who want a "set it and forget it" update loop using topgrade-rs. No manual intervention required.

⚠️ **Critical Warning**
This script actively fucks system security settings.
```UAC Bypass:``` Temporarily disables User Account Control (ConsentPromptBehaviorAdmin = 0) during execution to prevent update interruptions.
```Why?```: This is a deliberate security risk for the sake of convenience. If misconfigured, it leaves your system vulnerable to privilege escalation.
```Mitgations```: The script attempts to restore UAC immediately after completion and tells if you it thinks it failed.

**Prerequisites**
OS: ```Windows 10/11```
Permissions: ```Administrator Access```
Dependency: ```topgrade installed via winget``` - Duh.
Config: ```A valid topgrade.toml located in %APPDATA%```

🚀 **Installation**
Run this command in an elevated PowerShell terminal:
```iwr https://s.kizuati.com/magictopgrade_inst | iex```
🛑 **Uninstallation**
To remove the scheduled task and all associated files:
```iwr https://s.kizuati.com/magictopgrade_inst | iex -Uninstall```


**Configuration**
No configuration exists beyond what's natively available in topgrade.
Edit your topgrade.toml at %APPDATA%\topgrade.toml to customize update behavior.
**Troubleshooting**
```Config not found``` ->	```Ensure topgrade.toml exists in %APPDATA%.```
```Task not running``` -> ```Check Event Viewer > Windows Logs > Application for PowerShell errors.```
```UAC stuck at 0```	 -> ```Manually reset via reg add HKLM\...\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 3 /f```

**Use at your own risk. It's not my fault if the Iranian-Russian viruses kill you without your UAC condoms.**
