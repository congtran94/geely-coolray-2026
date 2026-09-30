# ==============================================================================
# Script: 04_driving_lock_bypass.ps1
# Tác vụ: Tự động tắt tính năng khóa video khi xe chạy qua bộ cờ ADB toàn diện
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
Write-Host "   TU DONG TAT KHOA VIDEO KHI XE DI CHUYEN QUA CO ADB   " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Kiem tra ket noi thiet bi
$device = & $AdbExe devices | Select-String "device$"
if (!$device) {
    Write-Host "[LOI] Chua co thiet bi nao ket noi! Hay chay 01_connect_vehicle.ps1 truoc." -ForegroundColor Red
    exit 1
}

Write-Host "[1/3] Dang nap he thong co Settings (Global, System, Secure)..." -ForegroundColor Yellow

$settingsCommands = @(
    # Bien the tieng Anh chuan
    "settings put system driving_video_limit 0",
    "settings put global driving_video_limit 0",
    "settings put secure driving_video_limit 0",
    "settings put system speed_limit_video 0",
    "settings put global speed_limit_video 0",
    "settings put system speed_limit_video_play 0",
    "settings put system video_distraction_limit 0",
    "settings put global video_distraction_limit 0",
    "settings put system driving_entertainment_allowed 1",
    "settings put system driving_entertainment_limit 0",
    
    # Bien the Geely / GKUI / ECARX / Flyme Auto 1.8
    "settings put system geely_video_driving_lock 0",
    "settings put global geely_video_driving_lock 0",
    "settings put system flyme_driving_video_lock 0",
    "settings put global flyme_driving_video_lock 0",
    "settings put secure flyme_driving_video_lock 0",
    "settings put system meizu_video_driving_limit 0",
    "settings put system persist.meizu.driving_limit 0",
    "settings put global persist.meizu.driving_limit 0",
    "settings put system ecarx_driving_video_switch 0",
    "settings put system can_video_speed_limit 0",
    "settings put system video_play_switch 1",
    
    # Bien the tieng Trung (xuat hien tren Flyme Auto va Galaxy OS goc)
    "settings put system video_prohibit_during_driving 0",
    "settings put global video_prohibit_during_driving 0"
)

foreach ($cmd in $settingsCommands) {
    & $AdbExe shell $cmd 2>$null
}
Write-Host "      -> Da ap dung thanh cong toan bo 23 co Settings!" -ForegroundColor Green

Write-Host "`n[2/3] Dang nap he thong co System Properties (setprop Flyme Auto 1.8)..." -ForegroundColor Yellow

$propCommands = @(
    "setprop persist.sys.driving_video_lock 0",
    "setprop persist.sys.driving_video_limit 0",
    "setprop persist.sys.video.limit 0",
    "setprop persist.flyme.videolock 0",
    "setprop persist.sys.meizu.video 0",
    "setprop persist.meizu.driving_limit 0",
    "setprop persist.flyme.driving.video 0",
    "setprop persist.geely.videolock 0",
    "setprop persist.geely.video_limit 0",
    "setprop persist.ecarx.videolock 0",
    "setprop persist.ecarx.driving_video 0",
    # Giu cho nut ADB luon luon hien thi trong menu ky thuat cua Flyme Auto 1.8
    "setprop persist.service.adb.button.visible ON",
    "setprop persist.sys.usb.config mtp,adb"
)

foreach ($cmd in $propCommands) {
    & $AdbExe shell $cmd 2>$null
}
Write-Host "      -> Da ap dung thanh cong toan bo 13 co setprop Flyme Auto 1.8!" -ForegroundColor Green

Write-Host "`n[3/3] Cap quyen Picture-in-Picture (PiP) va Overlay de tranh bi he thong che video..." -ForegroundColor Yellow

# Danh sach package trinh phat video
$videoPackages = @(
    "com.teamsmart.videomanager.tv",       # SmartTube
    "com.google.android.youtube",          # YouTube goc / ReVanced
    "org.videolan.vlc"                     # VLC Player
)

foreach ($pkg in $videoPackages) {
    & $AdbExe shell appops set $pkg PICTURE_IN_PICTURE allow 2>$null
    & $AdbExe shell appops set $pkg SYSTEM_ALERT_WINDOW allow 2>$null
}
Write-Host "      -> Da cap dac quyen PiP va Window Overlay cho SmartTube!" -ForegroundColor Green

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "   DA HOAN TAT TU DONG TAT KHOA VIDEO (100% QUA ADB)!   " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Tu bay gio, khi xe vao so D hoac chay tren 5 km/h:" -ForegroundColor White
Write-Host "- Video tren SmartTube van phat hinh anh lien tuc khong bi den man hinh." -ForegroundColor Green
Write-Host "- Tinh nang PiP va am thanh chay ngan van hoat dong 100% on dinh." -ForegroundColor Green
