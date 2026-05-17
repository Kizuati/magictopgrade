# MagicTopgrade Task Setup
param(
    [string]$ScriptPath = "C:\MagicTopgrade.ps1",
    [string]$TaskName = "MAGICTOPGRADE"
)

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[✗] ERROR: Must run as Administrator." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ScriptPath)) {
    Write-Host "[✗] ERROR: Script not found at $ScriptPath" -ForegroundColor Red
    exit 1
}

schtasks /Delete /TN $TaskName /F 2>$null

Write-Host "[+] Creating scheduled task: $TaskName" -ForegroundColor Cyan

$createResult = schtasks /Create /TN $TaskName /RU "BUILTIN\Administrators" /RL HIGHEST /SC ONLOGON /TR "powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`"" /F 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "[✗] ERROR: Failed to create task." -ForegroundColor Red
    Write-Host $createResult -ForegroundColor DarkGray
    exit 1
}

Write-Host "[✓] Task created successfully." -ForegroundColor Green
Write-Host '    Trigger: At logon (any Administrator)' -ForegroundColor DarkGray
Write-Host "    Script:  $ScriptPath" -ForegroundColor DarkGray
Write-Host ''

Write-Host "[>] Running task now as test..." -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor DarkGray

schtasks /Run /TN $TaskName

Write-Host "----------------------------------------" -ForegroundColor DarkGray
Write-Host "[✓] Task triggered. Check for the MAGICTOPGRADE window." -ForegroundColor Green
Write-Host ''
Write-Host "Press Enter to close..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
