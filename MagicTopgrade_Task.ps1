
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

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null

Write-Host "[+] Creating scheduled task: $TaskName" -ForegroundColor Cyan

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest -LogonType Interactive

try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Force | Out-Null
    Write-Host "[✓] Task created successfully." -ForegroundColor Green
    Write-Host "    Trigger: At logon (as $env:USERNAME, elevated)" -ForegroundColor DarkGray
    Write-Host "    Script:  $ScriptPath" -ForegroundColor DarkGray
} catch {
    Write-Host "[✗] ERROR: Failed to create task: $_" -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host "[>] Running task now as test..." -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor DarkGray

Start-ScheduledTask -TaskName $TaskName

Write-Host "----------------------------------------" -ForegroundColor "DarkGray"
Write-Host "[✓] Task triggered. Check for the MAGICTOPGRADE window." -ForegroundColor Green
Write-Host ''
Read-Host "Press Enter to close"