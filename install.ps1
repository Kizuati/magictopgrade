# MagicTopgrade Installer

$RepoUrl = "https://github.com/Kizuati/magictopgrade"
$ScriptPath = "C:\MagicTopgrade.ps1"
$TaskScriptPath = "C:\MagicTopgrade_Task.ps1"
$TaskName = "MAGICTOPGRADE"

# TLS 1.2 enforcement
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Admin Check
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "[✗] Run as Administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[>] Installing MagicTopgrade..." -ForegroundColor Cyan

# 1. Download Scripts to C:\ root
Write-Host "[+] Downloading scripts..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri "$RepoUrl/raw/main/MagicTopgrade.ps1" -UseBasicParsing -OutFile $ScriptPath
    Invoke-WebRequest -Uri "$RepoUrl/raw/main/MagicTopgrade_Task.ps1" -UseBasicParsing -OutFile $TaskScriptPath
} catch {
    Write-Host "[✗] Download failed: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# 2. Register Scheduled Task
Write-Host "[+] Registering scheduled task..." -ForegroundColor Gray
try {
    & powershell.exe -ExecutionPolicy Bypass -File "`"$TaskScriptPath`"" -ScriptPath "`"$ScriptPath`"" -TaskName "`"$TaskName`""
    
    Write-Host "[✓] Installed successfully." -ForegroundColor Green
    Write-Host "    Task: $TaskName (Runs at logon)" -ForegroundColor DarkGray
    Write-Host "    Files: C:\" -ForegroundColor DarkGray
} catch {
    Write-Host "[✗] Task registration failed: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}