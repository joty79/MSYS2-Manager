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

$LOG_DIR = Join-Path $PSScriptRoot "logs"
if (-not (Test-Path $LOG_DIR)) { New-Item -ItemType Directory -Path $LOG_DIR -Force | Out-Null }

function Fix-Certificates {
    $certFile = Join-Path $MSYS2_ROOT "usr\ssl\certs\ca-bundle.crt"
    if ((Test-Path $certFile) -and (Get-Item $certFile).Length -eq 0) {
        Write-Host "⚠️ Corrupted (0-byte) certificate bundle detected! Attempting auto-fix..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri 'https://curl.se/ca/cacert.pem' -OutFile $certFile -ErrorAction SilentlyContinue
        if ((Get-Item $certFile).Length -gt 0) {
            Write-Host "✅ Certificates restored." -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to restore certificates automatically." -ForegroundColor Red
        }
    }
}

function Run-Pacman {
    param([string]$CommandArgs)
    Clear-Host
    Fix-Certificates
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $logFile = Join-Path $LOG_DIR "pacman_$timestamp.log"
    
    Write-Host "🔵 Running Pacman with args: $CommandArgs" -ForegroundColor Cyan
    Write-Host "📁 Log: $logFile" -ForegroundColor Gray
    
    $argList = $CommandArgs -split ' ' | Where-Object { $_ -ne "" }
    
    # Run and capture output to both screen and file
    & $PACMAN $argList 2>&1 | Tee-Object -FilePath $logFile
    
    Write-Host "`n✅ Done. Press any key to return..." -ForegroundColor Green
    [Console]::ReadKey($true) | Out-Null
}



$Options = @(
    "🔄 Update Core & Packages (Syu)",
    "🛡️ Update Keyring (Fix GPG errors)",
    "🧹 Clean Package Cache (Scc)",
    "🔍 List Installed Packages",
    "⚙️ Check GCC Version",
    "📄 View Latest Log",
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
    5 = {
        $latestLog = Get-ChildItem $LOG_DIR -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latestLog) {
            Clear-Host
            Write-Host "📄 Viewing Latest Log: $($latestLog.Name)" -ForegroundColor Cyan
            Get-Content $latestLog.FullName -Tail 50
            Write-Host "`n✅ Press any key to return..." -ForegroundColor Green
            [Console]::ReadKey($true) | Out-Null
        } else {
            Write-Host "❌ No logs found." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}

Show-InteractiveMenu `
    -AppTitle "MSYS2 Manager" `
    -AppSubtitle "Maintenance for $MSYS2_ROOT" `
    -Options $Options `
    -Actions $Actions

