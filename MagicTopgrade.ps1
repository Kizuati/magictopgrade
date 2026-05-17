# --- PRETTY MODE CONFIGURATION ---
$Host.UI.RawUI.WindowTitle = "⚡ MAGICTOPGRADE ⚡"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Cyan"

Clear-Host

# ASCII Banner
Write-Host @"
███╗   ███╗ █████╗  ██████╗ ██╗ ██████╗████████╗ ██████╗ ██████╗  ██████╗ ██████╗  █████╗ ██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝ ██║██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝
██╔████╔██║███████║██║  ███╗██║██║        ██║   ██║   ██║██████╔╝██║  ███╗██████╔╝███████║██║  ██║█████╗  
██║╚██╔╝██║██╔══██║██║   ██║██║██║        ██║   ██║   ██║██╔═══╝ ██║   ██║██╔══██╗██╔══██║██║  ██║██╔══╝  
██║ ╚═╝ ██║██║  ██║╚██████╔╝██║╚██████╗   ██║   ╚██████╔╝██║     ╚██████╔╝██║  ██║██║  ██║██████╔╝███████╗
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝
"@ -ForegroundColor "Red"

Write-Host "Starting MAGICTOPGRADE Update Script..." -ForegroundColor "Yellow"
Write-Host "Running as User: $env:USERNAME" -ForegroundColor "Gray"

# --- Non-interactive guard ---
$interactive = $Host.Name -match "ConsoleHost"

# --- Admin Check ---
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: Must run as Administrator." -ForegroundColor "Red"
    if ($interactive) { Read-Host "Press Enter to exit"; exit 1 } else { exit 1 }
}

# --- UAC Variables ---
$uacRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$uacKeyName = "ConsentPromptBehaviorAdmin"
$origUAC = $null

# --- Main Execution Block ---
try {
    # 1. Handle UAC
    try {
        $origUAC = (Get-ItemProperty $uacRegPath -Name $uacKeyName).$uacKeyName
        Write-Host "[+] Current UAC Value: $origUAC" -ForegroundColor "White"

        if ($origUAC -ne 0) {
            Write-Host "[!] Disabling UAC Prompts temporarily..." -ForegroundColor "Yellow"
            Set-ItemProperty -Path $uacRegPath -Name $uacKeyName -Value 0
            Write-Host "[✓] UAC Suppressed (was: $origUAC, now: 0)" -ForegroundColor "Green"
        } else {
            Write-Host "[!] UAC already at 0. Skipping modification." -ForegroundColor "Yellow"
        }
    } catch {
        Write-Host "[✗] CRITICAL: Failed to access UAC registry. $_" -ForegroundColor "Red"
        if ($interactive) { Read-Host "Press Enter to exit"; exit 1 } else { exit 1 }
    }

    # 2. Resolve Config Path
    $configPath = Join-Path $env:APPDATA "topgrade.toml"
    if (-not (Test-Path $configPath)) {
        Write-Host "[✗] ERROR: Config not found at $configPath" -ForegroundColor "Red"
        Write-Host "Create a topgrade.toml in %APPDATA%." -ForegroundColor "Gray"
        if ($interactive) { Read-Host "Press Enter to exit"; exit 1 } else { exit 1 }
    }

    # 3. Resolve Topgrade Binary
    $topgradeExe = $null
    
    $cmdInfo = Get-Command topgrade.exe -ErrorAction SilentlyContinue
    if ($cmdInfo) {
        $topgradeExe = $cmdInfo.Source
    } else {
        $pkgDir = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
        if (Test-Path $pkgDir) {
            # Recurse into subdirs — exe may not be at package root
            $found = Get-ChildItem $pkgDir -Directory -Filter "*topgrade*" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                $exe = Get-ChildItem $found.FullName -Filter "topgrade.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($exe) { $topgradeExe = $exe.FullName }
            }
        }
    }

    if (-not $topgradeExe -or -not (Test-Path $topgradeExe)) {
        Write-Host "[✗] ERROR: topgrade.exe not found in PATH or WinGet packages." -ForegroundColor "Red"
        Write-Host "Install via: winget install topgrade-rs.topgrade" -ForegroundColor "Gray"
        if ($interactive) { Read-Host "Press Enter to exit"; exit 1 } else { exit 1 }
    }

    # 4. Run Topgrade
    Write-Host "[>] Running MAGICTOPGRADE..." -ForegroundColor "Cyan"
    Write-Host "Config: $configPath" -ForegroundColor "DarkGray"
    Write-Host "Binary: $topgradeExe" -ForegroundColor "DarkGray"
    Write-Host "----------------------------------------" -ForegroundColor "DarkGray"

    & $topgradeExe --config $configPath --yes

    $exitCode = $LASTEXITCODE
    Write-Host "----------------------------------------" -ForegroundColor "DarkGray"

    if ($exitCode -ne 0) {
        Write-Host "[!] MAGICTOPGRADE exited with code: $exitCode" -ForegroundColor "Yellow"
    } else {
        Write-Host "[✓] MAGICTOPGRADE completed successfully." -ForegroundColor "Green"
    }

} finally {
    if ($null -ne $origUAC -and $origUAC -ne 0) {
        Write-Host "[!] Restoring UAC..." -ForegroundColor "Yellow"
        try {
            Set-ItemProperty -Path $uacRegPath -Name $uacKeyName -Value $origUAC
            Write-Host "[✓] UAC Restored to: $origUAC" -ForegroundColor "Green"
        } catch {
            Write-Host "[!] WARN: Failed to restore UAC automatically. $_" -ForegroundColor "Red"
            Write-Host "Manual fix: reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d $origUAC /f" -ForegroundColor "Gray"
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor "Green"
Write-Host "       MAGICTOPGRADE FINISHED" -ForegroundColor "Green"
Write-Host "========================================" -ForegroundColor "Green"
Write-Host ""
if ($interactive) {
    Read-Host "Press Enter to close window"
}