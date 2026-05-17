# MagicTopgrade Installer
# Usage: .\install.ps1 [-Uninstall]

param([switch]$Uninstall)

$RepoUrl = "https://raw.githubusercontent.com/Kizuati/magictopgrade/main"
$InstallDir = "$env:ProgramFiles\MagicTopgrade"
$ScriptPath = Join-Path $InstallDir "MagicTopgrade.ps1"
$TaskName = "MAGICTOPGRADE"

# Admin Check
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "[✗] Run as Administrator." -ForegroundColor Red; exit 1
}

if ($Uninstall) {
    Write-Host "[>] Uninstalling..." -ForegroundColor Yellow
    schtasks /Delete /TN $TaskName /F 2>$null
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
    Invoke-WebRequest -Uri "$RepoUrl/MagicTopgrade.ps1" -OutFile $ScriptPath
    Invoke-WebRequest -Uri "$RepoUrl/MagicTopgrade_Task.ps1" -OutFile (Join-Path $InstallDir "MagicTopgrade_Task.ps1")
} catch {
    Write-Host "[✗] Download failed. Check repo URL." -ForegroundColor Red; exit 1
}

# 3. Create Scheduled Task
Write-Host "[+] Registering scheduled task..." -ForegroundColor Gray
schtasks /Delete /TN $TaskName /F 2>$null
$Action = "powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`""
schtasks /Create /TN $TaskName /RU "SYSTEM" /RL HIGHEST /SC ONLOGON /TR $Action /F

if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Installed successfully." -ForegroundColor Green
    Write-Host "    Task: $TaskName (Runs at logon)" -ForegroundColor DarkGray
    Write-Host "    Files: $InstallDir" -ForegroundColor DarkGray
    Write-Host "    To uninstall: .\install.ps1 -Uninstall" -ForegroundColor DarkGray
} else {
    Write-Host "[✗] Task creation failed." -ForegroundColor Red; exit 1
}