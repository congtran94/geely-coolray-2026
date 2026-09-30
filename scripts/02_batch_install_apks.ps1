# ==============================================================================
# Script: 02_batch_install_apks.ps1
# Tác vụ: Tự động cài đặt toàn bộ APK trong thư mục /apks và phân quyền hệ thống
# ==============================================================================

$ErrorActionPreference = "Continue"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$AdbExe = Join-Path $ProjectRoot "tools\platform-tools\adb.exe"
$ApksDir = Join-Path $ProjectRoot "apks"

if (!(Test-Path $AdbExe)) {
    if (Get-Command adb -ErrorAction SilentlyContinue) {
        $AdbExe = "adb"
    } else {
        Write-Host "Loi: Khong tim thay adb.exe!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   CAI DAT HANG LOAT APKS & PHAN QUYEN CHO GEELY      " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Kiem tra ket noi thiet bi
$device = & $AdbExe devices | Select-String "device$"
if (!$device) {
    Write-Host "[LOI] Chua co thiet bi nao ket noi! Hay chay 01_connect_vehicle.ps1 truoc." -ForegroundColor Red
    exit 1
}

$apkFiles = Get-ChildItem -Path $ApksDir -Filter "*.apk"
if ($apkFiles.Count -eq 0) {
    Write-Host "[CANH BAO] Khong tim thay file .apk nao trong thu muc: $ApksDir" -ForegroundColor Yellow
    Write-Host "Vui long copy cac file APK can thiet vao thu muc tren va chay lai script." -ForegroundColor Yellow
    exit 1
}

Write-Host "Tim thay $($apkFiles.Count) file APK can cai dat.`n" -ForegroundColor Green

foreach ($apk in $apkFiles) {
    Write-Host "--> Dang cai dat: $($apk.Name)..." -ForegroundColor Yellow
    # Tren Flyme Auto 1.8 (Android 11/12), can co -g de tu cap toan bo quyen runtime permissions
    $installOutput = & $AdbExe install -r -d -g $apk.FullName
    if ($installOutput -match "Success") {
        Write-Host "    [THANH CONG] Da cai dat $($apk.Name)" -ForegroundColor Green
    } else {
        Write-Host "    [THAT BAI] Ket qua: $installOutput" -ForegroundColor Red
    }
}

Write-Host "`n--- TIEN HANH PHAN QUYEN HE THONG & CHAY NGAM (FLYME AUTO 1.8) ---" -ForegroundColor Cyan

# 1. Phan quyen cho VietMap Live
Write-Host "1. Cap quyen cho VietMap Live (GPS, Cua so noi, Pin, Chay ngam)..." -ForegroundColor Yellow
& $AdbExe shell pm grant vn.vietmap.live android.permission.ACCESS_FINE_LOCATION 2>$null
& $AdbExe shell pm grant vn.vietmap.live android.permission.ACCESS_COARSE_LOCATION 2>$null
& $AdbExe shell appops set vn.vietmap.live SYSTEM_ALERT_WINDOW allow 2>$null
& $AdbExe shell appops set vn.vietmap.live RUN_IN_BACKGROUND allow 2>$null
& $AdbExe shell appops set vn.vietmap.live RUN_ANY_IN_BACKGROUND allow 2>$null
& $AdbExe shell dumpsys deviceidle whitelist +vn.vietmap.live 2>$null
Write-Host "   -> Da cap quyen VietMap Live!" -ForegroundColor Green

# 2. Phan quyen cho Tro ly Kiki Auto
Write-Host "2. Cap quyen cho Tro ly Kiki Auto (Micro, Overlay, Pin, Chay ngam)..." -ForegroundColor Yellow
$kikiPkgs = @("ai.zalo.kiki.car", "com.zing.zalo.kikiauto")
foreach ($kpkg in $kikiPkgs) {
    & $AdbExe shell pm grant $kpkg android.permission.RECORD_AUDIO 2>$null
    & $AdbExe shell appops set $kpkg SYSTEM_ALERT_WINDOW allow 2>$null
    & $AdbExe shell appops set $kpkg RUN_IN_BACKGROUND allow 2>$null
    & $AdbExe shell appops set $kpkg RUN_ANY_IN_BACKGROUND allow 2>$null
    & $AdbExe shell dumpsys deviceidle whitelist +$kpkg 2>$null
}
Write-Host "   -> Da cap quyen Kiki Auto!" -ForegroundColor Green

# 3. Kich hoat Ban phim Laban Key
Write-Host "3. Kich hoat ban phim tieng Viet Laban Key lam ban phim mac dinh..." -ForegroundColor Yellow
& $AdbExe shell ime enable com.vng.inputmethod.labankey/.LabanKeyService 2>$null
& $AdbExe shell ime set com.vng.inputmethod.labankey/.LabanKeyService 2>$null
Write-Host "   -> Da kich hoat Laban Key!" -ForegroundColor Green

# 4. Cap quyen cho Button Mapper / Key Mapper (Gan phim vo lang)
Write-Host "4. Cap quyen WRITE_SECURE_SETTINGS cho Button/Key Mapper..." -ForegroundColor Yellow
& $AdbExe shell pm grant flar2.homebutton android.permission.WRITE_SECURE_SETTINGS 2>$null
& $AdbExe shell pm grant io.github.sds100.keymapper android.permission.WRITE_SECURE_SETTINGS 2>$null
Write-Host "   -> Da cap quyen Button/Key Mapper!" -ForegroundColor Green

# 5. Cap quyen cho MoreLocale 2 (Viet hoa Cap 1)
Write-Host "5. Cap quyen CHANGE_CONFIGURATION cho MoreLocale 2..." -ForegroundColor Yellow
& $AdbExe shell pm grant jp.co.c_lis.ccl.morelocale android.permission.CHANGE_CONFIGURATION 2>$null
Write-Host "   -> Da cap quyen MoreLocale 2!" -ForegroundColor Green

# 6. Tu dong ap dung he co tat khoa video khi xe chay (Driving Lock Bypass)
Write-Host "6. Tu dong nap he co ADB tat tinh nang khoa video khi xe chay..." -ForegroundColor Yellow
& "$PSScriptRoot\04_driving_lock_bypass.ps1"

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "   HOAN TAT CAI DAT VA PHAN QUYEN CHO MOI UNG DUNG!    " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Buoc tiep theo: Chay script 03_vietnamese_level1.ps1 de bat tieng Viet." -ForegroundColor Yellow
