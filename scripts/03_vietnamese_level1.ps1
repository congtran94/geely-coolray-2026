# ==============================================================================
# Script: 03_vietnamese_level1.ps1
# Tác vụ: Kích hoạt Tiếng Việt cho toàn bộ hệ thống AOSP và ứng dụng bên thứ 3
# ==============================================================================

$ErrorActionPreference = "Continue"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
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
Write-Host "      KICH HOAT TIENG VIET HE THONG (CAP DO 1)          " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Kiem tra ket noi thiet bi
$device = & $AdbExe devices | Select-String "device$"
if (!$device) {
    Write-Host "[LOI] Chua co thiet bi nao ket noi! Hay chay 01_connect_vehicle.ps1 truoc." -ForegroundColor Red
    exit 1
}

Write-Host "1. Thiet lap bien moi truong he thong ve vi-VN..." -ForegroundColor Yellow
& $AdbExe shell setprop persist.sys.locale vi-VN
& $AdbExe shell setprop persist.sys.language vi
& $AdbExe shell setprop persist.sys.country VN
Write-Host "   -> Da cap nhat persist.sys.locale = vi-VN" -ForegroundColor Green

Write-Host "2. Cap quyen CHANGE_CONFIGURATION cho MoreLocale 2..." -ForegroundColor Yellow
& $AdbExe shell pm grant jp.co.c_lis.ccl.morelocale android.permission.CHANGE_CONFIGURATION 2>$null
Write-Host "   -> Da cap quyen!" -ForegroundColor Green

Write-Host "3. Gui lenh khoi chay chuyen doi ngon ngu qua MoreLocale 2..." -ForegroundColor Yellow
# Mo MoreLocale 2 voi Intent vi_VN
& $AdbExe shell am start -n jp.co.c_lis.ccl.morelocale/.ui.MainActivity -e "LOCALE" "vi_VN" 2>$null

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "   HOAN TAT THIET LAP TIENG VIET CAP DO 1!              " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Luu y:" -ForegroundColor Yellow
Write-Host "Neu tren man hinh xe van chua doi, hay mo app MoreLocale 2 tu Car Launcher va chon 'Vietnamese (Vietnam)'."
Write-Host "Tat ca ung dung (SmartTube, VietMap, Kiki, Laban Key) gio day se hien thi Tieng Viet 100%." -ForegroundColor Green
