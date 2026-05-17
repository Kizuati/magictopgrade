# MagicTopgrade Installer
# Usage: .\install.ps1 [-Uninstall]

param([switch]$Uninstall)

$RepoUrl = "https://raw.githubusercontent.com/Kizuati/magictopgrade/main"
$InstallDir = "$env:ProgramFiles\MagicTopgrade"
$ScriptPath = Join-Path $InstallDir "MagicTopgrade.ps1"
$TaskName = "MAGICTOPGRADE"

# TLS 1.2 enforcement — PS 5.1 defaults to TLS 1.0, GitHub rejects it
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Admin Check
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "[✗] Run as Administrator." -ForegroundColor Red; exit 1
}

if ($Uninstall) {
    Write-Host "[>] Uninstalling..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null
    if (Test-Path $InstallDir) { Remove-Item $InstallDir -Recurse -Force }
    Write-Host "[✓] Removed task and files." -ForegroundColor Green; exit 0
}

# Install Logic
Write-Host "[>] Installing MagicTopgrade..." -ForegroundColor Cyan

# 1. Create Directory
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

# 2. Download Scripts
Write-Host "[+] Downloading scripts..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri "$RepoUrl/MagicTopgrade.ps1" -UseBasicParsing -OutFile $ScriptPath
    Invoke-WebRequest -Uri "$RepoUrl/MagicTopgrade_Task.ps1" -UseBasicParsing -OutFile (Join-Path $InstallDir "MagicTopgrade_Task.ps1")
} catch {
    Write-Host "[✗] Download failed: $_" -ForegroundColor Red; exit 1
}

# 3. Create Scheduled Task (interactive, current user, highest privileges)
Write-Host "[+] Registering scheduled task..." -ForegroundColor Gray
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest -LogonType Interactive

try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Force | Out-Null
    Write-Host "[✓] Installed successfully." -ForegroundColor Green
    Write-Host "    Task: $TaskName (Runs at logon as $env:USERNAME)" -ForegroundColor DarkGray
    Write-Host "    Files: $InstallDir" -ForegroundColor DarkGray
    Write-Host "    To uninstall: .\install.ps1 -Uninstall" -ForegroundColor DarkGray
} catch {
    Write-Host "[✗] Task creation failed: $_" -ForegroundColor Red; exit 1
}