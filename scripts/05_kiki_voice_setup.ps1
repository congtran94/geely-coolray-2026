# ==============================================================================
# Script: 05_kiki_voice_setup.ps1
# Tác vụ: Cấu hình Trợ lý giọng nói tiếng Việt Kiki Auto & Tích hợp phím vô lăng
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
Write-Host "   CAU HINH TRO LY GIONG NOI KIKI AUTO & PHIM VO LANG   " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Kiem tra ket noi thiet bi
$device = & $AdbExe devices | Select-String "device$"
if (!$device) {
    Write-Host "[LOI] Chua co thiet bi nao ket noi! Hay chay 01_connect_vehicle.ps1 truoc." -ForegroundColor Red
    exit 1
}

Write-Host "1. Dang thiet lap Kiki Auto lam Tro ly giong noi he thong..." -ForegroundColor Yellow

$kikiServices = @(
    "ai.zalo.kiki.car/.service.VoiceInteractionSessionService",
    "com.zing.zalo.kikiauto/.service.VoiceInteractionSessionService"
)

foreach ($srv in $kikiServices) {
    & $AdbExe shell settings put secure assistant $srv 2>$null
}

& $AdbExe shell settings put secure voice_interaction_service ai.zalo.kiki.car/.service.VoiceInteractionService 2>$null
& $AdbExe shell settings put secure voice_recognition_service ai.zalo.kiki.car/.service.VoiceRecognitionService 2>$null

# Cap quyen Micro, Ve tren ung dung khac va Bo toi uu pin
$kikiPkgs = @("ai.zalo.kiki.car", "com.zing.zalo.kikiauto")
foreach ($kpkg in $kikiPkgs) {
    & $AdbExe shell pm grant $kpkg android.permission.RECORD_AUDIO 2>$null
    & $AdbExe shell appops set $kpkg SYSTEM_ALERT_WINDOW allow 2>$null
    & $AdbExe shell dumpsys deviceidle whitelist +$kpkg 2>$null
}

Write-Host "   -> Da cau hinh Kiki Auto thanh cong!" -ForegroundColor Green

Write-Host "`n2. CAP QUYEN GHI HE THONG CHO BUTTON/KEY MAPPER (GAN PHIM VO LANG)..." -ForegroundColor Yellow
& $AdbExe shell pm grant flar2.homebutton android.permission.WRITE_SECURE_SETTINGS 2>$null
& $AdbExe shell pm grant io.github.sds100.keymapper android.permission.WRITE_SECURE_SETTINGS 2>$null
Write-Host "   -> Da cap quyen WRITE_SECURE_SETTINGS!" -ForegroundColor Green

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "   HUONG DAN CAI DAT TRUC TIEP TREN XE (2 PHUT)         " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "A. Thiet lap Kiki Auto:" -ForegroundColor White
Write-Host "   1. Mo Kiki Auto tren man hinh xe (thong qua Car Launcher)."
Write-Host "   2. Dang nhap tai khoan Zalo bang cach quet ma QR tren dien thoai."
Write-Host "   3. Vao 'Cai dat Kiki':"
Write-Host "      - Muc 'Ban do mac dinh': Chon 'VietMap Live'." -ForegroundColor Green
Write-Host "      - Muc 'Nhac mac dinh': Chon 'YouTube' hoac 'SmartTube'." -ForegroundColor Green

Write-Host "`nB. Gan nut Micro tren Vo lang cho Kiki (Bang Button Mapper):" -ForegroundColor White
Write-Host "   1. Mo app 'Button Mapper' tren man hinh xe."
Write-Host "   2. Chon 'Add Buttons' (+), sau do bam nut Micro tren vo lang xe."
Write-Host "   3. App se nhan dien nut vo lang -> Chon 'Single Tap' (Bam 1 lan)."
Write-Host "   4. Chon hanh dong la: 'Applications' -> Chon 'Kiki Auto'." -ForegroundColor Green

Write-Host "`nC. Khau lenh dieu khien than xe bang Tieng Anh voi 'Hi Geely':" -ForegroundColor White
Write-Host "   - Cua so troi : 'Hi Geely, open sunroof' / 'close sunroof'"
Write-Host "   - Cua kinh    : 'Hi Geely, open windows' / 'close windows'"
Write-Host "   - Dieu hoa    : 'Hi Geely, turn on AC' / 'Set temperature to 22 degrees'"
Write-Host "   - Muc gio     : 'Hi Geely, fan speed 3' / 'increase fan speed'"
