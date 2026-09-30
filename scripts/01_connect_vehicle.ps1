# ==============================================================================
# Script: 01_connect_vehicle.ps1
# Tác vụ: Kết nối ADB tới màn hình xe Geely Coolray qua Wi-Fi hoặc cáp USB
# ==============================================================================

param (
    [string]$VehicleIP = ""
)

$ErrorActionPreference = "Continue"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$AdbExe = Join-Path $ProjectRoot "tools\platform-tools\adb.exe"

if (!(Test-Path $AdbExe)) {
    if (Get-Command adb -ErrorAction SilentlyContinue) {
        $AdbExe = "adb"
    } else {
        Write-Host "Loi: Khong tim thay adb.exe! Hay chay script 00_setup_tools.ps1 truoc." -ForegroundColor Red
        exit 1
    }
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "     KET NOI ADB DEN XE GEELY COOLRAY 2026            " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Kiem tra thiet bi qua cap USB truoc
Write-Host "Dang kiem tra thiet bi ket noi qua cong USB..." -ForegroundColor Yellow
$usbDevices = & $AdbExe devices | Select-String "device$"

if ($usbDevices) {
    Write-Host "[THANH CONG] Phat hien xe ket noi qua cap USB!" -ForegroundColor Green
} else {
    Write-Host "Khong co thiet bi USB. Chuyen sang che do ket noi qua Wi-Fi..." -ForegroundColor Yellow
    if ([string]::IsNullOrWhiteSpace($VehicleIP)) {
        $VehicleIP = Read-Host "Nhap dia chi IP cua xe (Xem trong Cai dat Wi-Fi cua xe, VD: 192.168.43.105)"
    }

    if ([string]::IsNullOrWhiteSpace($VehicleIP)) {
        Write-Host "Dia chi IP khong hop le!" -ForegroundColor Red
        exit 1
    }

    Write-Host "Dang ket noi toi $VehicleIP:5555..." -ForegroundColor Yellow
    & $AdbExe disconnect | Out-Null
    $connectResult = & $AdbExe connect "$($VehicleIP):5555"
    Write-Host $connectResult

    if ($connectResult -notmatch "connected") {
        Write-Host "[THAT BAI] Khong the ket noi toi IP $VehicleIP qua cong 5555." -ForegroundColor Red
        Write-Host "Luu y:" -ForegroundColor Yellow
        Write-Host "1. Xe va laptop phai ket noi chung 1 mang Wi-Fi (hoac Hotspot dien thoai)."
        Write-Host "2. Ban phai bat ADB Switch / USB Debugging trong Engineering Mode tren xe."
        exit 1
    }
}

Write-Host "`n--- THONG TIN HE THONG MAN HINH XE (FLYME AUTO) ---" -ForegroundColor Cyan
$model = & $AdbExe shell getprop ro.product.model
$androidVer = & $AdbExe shell getprop ro.build.version.release
$sdkVer = & $AdbExe shell getprop ro.build.version.sdk
$brand = & $AdbExe shell getprop ro.product.brand
$build = & $AdbExe shell getprop ro.build.display.id
$flymeVer = & $AdbExe shell getprop ro.build.flyme.version
if (!$flymeVer) { $flymeVer = & $AdbExe shell getprop ro.flyme.version }

Write-Host "Brand/Hang       : $brand" -ForegroundColor Green
Write-Host "Model            : $model" -ForegroundColor Green
Write-Host "OS Platform      : Flyme Auto (Meizu & Geely)" -ForegroundColor Green
if ($flymeVer) {
    Write-Host "Flyme Auto Build : $flymeVer" -ForegroundColor Green
}
Write-Host "Android Version  : $androidVer (SDK API: $sdkVer)" -ForegroundColor Green
Write-Host "Build Display ID : $build" -ForegroundColor Green
Write-Host "---------------------------------------------------" -ForegroundColor Cyan
Write-Host "Ket noi san sang! Hay chay script: 02_batch_install_apks.ps1" -ForegroundColor Green
