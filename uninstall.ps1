# MagicTopgrade Uninstaller

$ScriptPath = "C:\MagicTopgrade.ps1"
$TaskScriptPath = "C:\MagicTopgrade_Task.ps1"
$TaskName = "MAGICTOPGRADE"

# Admin Check
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "[✗] Run as Administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[>] Checking for MagicTopgrade..." -ForegroundColor Cyan

# Check if files and task exist
$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
$fileExists = Test-Path $ScriptPath
$taskFileExists = Test-Path $TaskScriptPath

if (-not $task -and -not $fileExists -and -not $taskFileExists) {
    Write-Host "[!] MagicTopgrade does not appear to be installed." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host "[!] Found:" -ForegroundColor Yellow
if ($task) { Write-Host "    - Scheduled Task: $TaskName" -ForegroundColor Gray }
if ($fileExists) { Write-Host "    - Script: $ScriptPath" -ForegroundColor Gray }
if ($taskFileExists) { Write-Host "    - Task Script: $TaskScriptPath" -ForegroundColor Gray }

Write-Host ""
$confirm = Read-Host "Are you sure you want to uninstall? (y/n)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "[!] Aborted." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host "[>] Uninstalling..." -ForegroundColor Yellow

# Remove Task
if ($task) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null
    Write-Host "[✓] Task removed." -ForegroundColor Green
}

# Remove Files
if ($fileExists) {
    Remove-Item $ScriptPath -Force
    Write-Host "[✓] Script removed." -ForegroundColor Green
}
if ($taskFileExists) {
    Remove-Item $TaskScriptPath -Force
    Write-Host "[✓] Task script removed." -ForegroundColor Green
}

Write-Host ""
Write-Host "[✓] Uninstallation complete." -ForegroundColor Green
Read-Host "Press Enter to close"