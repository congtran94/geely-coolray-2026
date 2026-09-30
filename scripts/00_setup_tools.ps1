# ==============================================================================
# Script: 00_setup_tools.ps1
# Tác vụ: Tự động tải ADB Platform-tools (Google) và SmartTube APK mới nhất
# ==============================================================================

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ToolsDir = Join-Path $ProjectRoot "tools"
$ApksDir = Join-Path $ProjectRoot "apks"
$PlatformToolsZip = Join-Path $ToolsDir "platform-tools.zip"
$AdbExe = Join-Path $ToolsDir "platform-tools\adb.exe"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   CHUAN BI BO CONG CU CHO DU AN GEELY COOLRAY 2026   " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Kiem tra & Tai Google Platform-Tools (ADB)
if (!(Test-Path $AdbExe)) {
    Write-Host "[1/3] Dang tai Google Platform-Tools (chua ADB)..." -ForegroundColor Yellow
    $PlatformToolsUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    Invoke-WebRequest -Uri $PlatformToolsUrl -OutFile $PlatformToolsZip -UseBasicParsing
    
    Write-Host "      Giai nen Platform-Tools..." -ForegroundColor Green
    Expand-Archive -Path $PlatformToolsZip -DestinationPath $ToolsDir -Force
    Remove-Item $PlatformToolsZip -Force
} else {
    Write-Host "[1/3] Google Platform-Tools (ADB) da san sang tai: $AdbExe" -ForegroundColor Green
}

# 2. Tu dong tai SmartTube APK ban moi nhat tu GitHub
$SmartTubeApk = Join-Path $ApksDir "SmartTube.apk"
if (!(Test-Path $SmartTubeApk)) {
    Write-Host "[2/3] Dang lay thong tin phien ban SmartTube tu GitHub..." -ForegroundColor Yellow
    try {
        $Release = Invoke-RestMethod -Uri "https://api.github.com/repos/yuliskov/SmartTube/releases/latest" -UserAgent "PowerShell"
        $Asset = $Release.assets | Where-Object { $_.name -like "*arm64_v8a.apk" -or $_.name -like "*armeabi_v7a.apk" -or $_.name -like "*smarttube*.apk" } | Select-Object -First 1
        if ($Asset) {
            Write-Host "      Dang tai SmartTube APK ($($Asset.name))..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $SmartTubeApk -UseBasicParsing
            Write-Host "      Da tai xong SmartTube.apk!" -ForegroundColor Green
        } else {
            Write-Host "      Khong tim thay asset arm, vui long tai thu cong vao /apks" -ForegroundColor DarkYellow
        }
    } catch {
        Write-Host "      Loi khi tai SmartTube tu GitHub: $_" -ForegroundColor Red
    }
} else {
    Write-Host "[2/3] SmartTube.apk da co san trong thu muc apks!" -ForegroundColor Green
}

# 3. Kiem tra danh sach APKs
Write-Host "[3/3] Kiem tra danh sach APK can thiet trong thu muc /apks:" -ForegroundColor Yellow
$RequiredApks = @(
    "CarLauncher.apk",
    "SmartTube.apk",
    "VietMapLive.apk",
    "KikiAuto.apk",
    "LabanKey.apk",
    "MoreLocale2.apk",
    "ButtonMapper.apk"
)

foreach ($apk in $RequiredApks) {
    $apkPath = Join-Path $ApksDir $apk
    if (Test-Path $apkPath) {
        Write-Host "  [OK] $apk da co san" -ForegroundColor Green
    } else {
        Write-Host "  [CHUA CO] $apk - Vui long copy file vao: $ApksDir" -ForegroundColor Red
    }
}

Write-Host "`nHoan tat kiem tra! San sang cho buoc ket noi xe (01_connect_vehicle.ps1)." -ForegroundColor Cyan
