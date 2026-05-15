# MSYS2 Maintenance Manager
# Powered by PS_UI_Blueprint

$blueprintPath = "C:\Users\joty79\.agent-shared\templates\PS_UI_Blueprint.psm1"
if (-not (Test-Path $blueprintPath)) {
    Write-Error "Blueprint not found at $blueprintPath"
    exit 1
}

# Load blueprint with scope propagation (Fix #36)
Invoke-Expression (Get-Content -LiteralPath $blueprintPath -Raw)

$MSYS2_ROOT = "D:\Compilers\msys64"
$PACMAN = Join-Path $MSYS2_ROOT "usr\bin\pacman.exe"

function Run-Pacman {
    param([string]$Args)
    Clear-Host
    Write-Host "🔵 Running Pacman with args: $Args" -ForegroundColor Cyan
    # Use msys2_shell.cmd to ensure correct environment or just call pacman directly
    # Calling pacman directly usually works if root is set
    Start-Process -FilePath $PACMAN -ArgumentList $Args -Wait -NoNewWindow
    Write-Host "`n✅ Done. Press any key to return..." -ForegroundColor Green
    [Console]::ReadKey($true) | Out-Null
}

$Options = @(
    "🔄 Update Core & Packages (Syu)",
    "🛡️ Update Keyring (Fix GPG errors)",
    "🧹 Clean Package Cache (Scc)",
    "🔍 List Installed Packages",
    "⚙️ Check GCC Version",
    "🚪 Exit"
)

$Actions = @{
    0 = { Run-Pacman "-Syu --noconfirm" }
    1 = { Run-Pacman "-Sy --noconfirm msys2-keyring" }
    2 = { Run-Pacman "-Scc --noconfirm" }
    3 = { Run-Pacman "-Q" }
    4 = { 
        Clear-Host
        Write-Host "🔍 Checking GCC Version..." -ForegroundColor Cyan
        & (Join-Path $MSYS2_ROOT "ucrt64\bin\gcc.exe") --version
        Write-Host "`n✅ Press any key to return..." -ForegroundColor Green
        [Console]::ReadKey($true) | Out-Null
    }
}

Show-InteractiveMenu `
    -AppTitle "MSYS2 Manager" `
    -AppSubtitle "Maintenance for $MSYS2_ROOT" `
    -Options $Options `
    -Actions $Actions
