# ==============================================================================
# Script: build_overlay.ps1
# Tác vụ: Đóng gói và Kích hoạt Runtime Resource Overlay (RRO) Việt hóa Cấp độ 2
# ==============================================================================

$ErrorActionPreference = "Continue"
$OverlayDir = $PSScriptRoot
$ProjectRoot = Split-Path -Parent $OverlayDir
$AdbExe = Join-Path $ProjectRoot "tools\platform-tools\adb.exe"

if (!(Test-Path $AdbExe)) {
    if (Get-Command adb -ErrorAction SilentlyContinue) {
        $AdbExe = "adb"
    } else {
        Write-Host "Loi: Khong tim thay adb.exe!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   DONG GOI & KICH HOAT VIET HOA GEELY CAP DO 2 (RRO)   " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Kiem tra ket noi thiet bi
$device = & $AdbExe devices | Select-String "device$"
if (!$device) {
    Write-Host "[LOI] Chua co thiet bi nao ket noi! Hay chay 01_connect_vehicle.ps1 truoc." -ForegroundColor Red
    exit 1
}

Write-Host "1. Xac dinh package cai dat xe tren he thong Flyme Auto..." -ForegroundColor Yellow
$packages = & $AdbExe shell pm list packages | Select-String -Pattern "flyme|meizu|geely|ecarx|carsettings|pma"
Write-Host "Cac package xe phat hien duoc tren xe cua ban:" -ForegroundColor Gray
$packages | ForEach-Object { Write-Host "   $_" -ForegroundColor DarkGray }

# Tu dong chon target package phu hop nhat tren Flyme Auto
$targetPkg = "com.geely.carsettings"
if ($packages -match "com.meizu.flymeauto") {
    $targetPkg = "com.meizu.flymeauto"
} elseif ($packages -match "com.geely.pma.settings") {
    $targetPkg = "com.geely.pma.settings"
} elseif ($packages -match "com.flyme.car.settings") {
    $targetPkg = "com.flyme.car.settings"
} elseif ($packages -match "com.ecarx.settings") {
    $targetPkg = "com.ecarx.settings"
}

Write-Host "Target Package xac dinh cho Flyme Auto: $targetPkg" -ForegroundColor Green

$overlayApk = Join-Path $OverlayDir "GeelySettings_Overlay.apk"

if (Test-Path $overlayApk) {
    Write-Host "`n2. Dang cai dat file Overlay APK ($overlayApk)..." -ForegroundColor Yellow
    $installRes = & $AdbExe install -r $overlayApk
    Write-Host "Ket qua cai dat: $installRes" -ForegroundColor Green

    Write-Host "3. Dang kich hoat goi Overlay tieng Viet cho $targetPkg..." -ForegroundColor Yellow
    & $AdbExe shell cmd overlay enable com.geely.carsettings.vietnamese.overlay 2>$null
    Write-Host "   -> Da kich hoat Overlay thanh cong!" -ForegroundColor Green
} else {
    Write-Host "`n[LUU Y QUAN TRONG]" -ForegroundColor Yellow
    Write-Host "File $overlayApk chua duoc bien dich san."
    Write-Host "Cach bien dich RRO Overlay tu thu muc hien tai:" -ForegroundColor White
    Write-Host "1. Su dung Android Studio hoac aapt2/apktool:" -ForegroundColor Gray
    Write-Host "   aapt2 compile --dir res -o compiled_res.zip" -ForegroundColor Gray
    Write-Host "   aapt2 link -o GeelySettings_Overlay.apk -I android.jar --manifest AndroidManifest.xml compiled_res.zip" -ForegroundColor Gray
    Write-Host "2. Sau khi build ra GeelySettings_Overlay.apk, chay lai script nay de cai dat len xe." -ForegroundColor Green
}

Write-Host "`nLenh kiem tra trang thai Overlay tren xe:" -ForegroundColor Cyan
Write-Host "adb shell cmd overlay list" -ForegroundColor White
Write-Host "Lenh huy kich hoat khi can quay ve tieng Anh zin:" -ForegroundColor Cyan
Write-Host "adb shell cmd overlay disable com.geely.carsettings.vietnamese.overlay" -ForegroundColor White
