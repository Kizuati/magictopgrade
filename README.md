![ASCI Logo](pseudologo_asci.gif)                                                                                            
## ⚡MagicTopgrade   
A simple powershell script that runs on top of Topgrade, the popular update package available for MacOS,Linux and Windows. 
Obviously, this being powershell, we're on Windows. The script simply yells at topgrade to ignore all warnings and install everything fully-unattended.
It also automatically adds running topgrade in this mode to your Task Scheduler, so it runs on every log on. 
If you want a set and forget update experience with as many Windows things as possible, this would be it.

## Demo Video
[![Watch the video](./pseudologo_asci.gif)](https://www.youtube.com/watch?v=_-JKUOH8Yj8)

 ## ⚠️Critical Warning 
**🚨This script actively fucks system security settings.** <br>
```UAC Bypass:``` Temporarily disables User Account Control (ConsentPromptBehaviorAdmin = 0) during execution to prevent update interruptions.<br>
```Why?```: This is a deliberate security risk for the sake of convenience. If you want to skip constant UAC prompts, this is the price..<br>
```Mitigations```: The script attempts to restore UAC immediately after completion and tells if you if it thinks it failed.<br>
Though, speaking realistically, I personally find it unlikely that your system's security rests solely on the few minutes of unattended software updates. <br>

## 🐉 Here Be Dragons
**🚨 MagicTopgrade is beta "software". Issues and just not working are to be expected.** <br>
After tinkering a while with topgrade, I realized that I wanted to have something like this, and eventually got it working.<br>
Post using it, I realized I might as well publish it for usage for everyone and after some adaptation and vibe coding (Eugh, I know) - it's here.<br>
This should work for most people and most windows installs. But it might not. <br>


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
iwr https://s.kizuati.com/magictopgrade_inst | iex
```
🛑 Uninstallation
To remove the scheduled task and all associated files:
```powershell
iwr https://s.kizuati.com/magictopgrade_uninst | iex
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

