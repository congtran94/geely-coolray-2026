# ==============================================================================
# Script: run_all.ps1
# Tác vụ: Bảng điều khiển trung tâm (Dashboard CLI) cho toàn bộ quy trình dự án
# ==============================================================================

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ScriptsDir = Join-Path $ProjectRoot "scripts"

function Show-Menu {
    Clear-Host
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "     HE THONG TU DONG HOA CHO XE GEELY COOLRAY 2026           " -ForegroundColor Cyan
    Write-Host "   Sideload APKs | Viet Hoa Cap 1 & 2 | Giong Noi Kiki + Xe   " -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host " [0] Chuan bi cong cu & Tai APK SmartTube (00_setup_tools.ps1)" -ForegroundColor White
    Write-Host " [1] Ket noi ADB toi man hinh xe qua Wi-Fi / USB (01_connect)" -ForegroundColor White
    Write-Host " [2] Cai dat hang loat APKs & Phan quyen he thong (02_install)" -ForegroundColor White
    Write-Host " [3] Kich hoat Tieng Viet he thong Cap do 1 (03_vietnamese_l1)" -ForegroundColor White
    Write-Host " [4] Tat khoa Video khi xe chay (04_driving_lock_bypass)" -ForegroundColor White
    Write-Host " [5] Cau hinh Tro ly giong noi Kiki & Gan phim vo lang (05_voice)" -ForegroundColor White
    Write-Host " [6] Kich hoat Viet hoa Menu Cai dat xe Cap do 2 (RRO Overlay)" -ForegroundColor White
    Write-Host "----------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " [A] CHAY TOAN BO QUY TRINH TU DONG (BUOC 1 -> 5)" -ForegroundColor Green
    Write-Host " [Q] Thoat" -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Cyan
}

do {
    Show-Menu
    $choice = Read-Host "Moi ban chon thao tac (0-6, A, Q)"
    switch ($choice.ToUpper()) {
        "0" {
            & "$ScriptsDir\00_setup_tools.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "1" {
            & "$ScriptsDir\01_connect_vehicle.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "2" {
            & "$ScriptsDir\02_batch_install_apks.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "3" {
            & "$ScriptsDir\03_vietnamese_level1.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "4" {
            & "$ScriptsDir\04_driving_lock_bypass.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "5" {
            & "$ScriptsDir\05_kiki_voice_setup.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "6" {
            & "$ProjectRoot\overlay_level2\build_overlay.ps1"
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "A" {
            Write-Host "`n>>> BAT DAU CHAY TOAN BO QUY TRINH <<<" -ForegroundColor Green
            & "$ScriptsDir\01_connect_vehicle.ps1"
            & "$ScriptsDir\02_batch_install_apks.ps1"
            & "$ScriptsDir\03_vietnamese_level1.ps1"
            & "$ScriptsDir\04_driving_lock_bypass.ps1"
            & "$ScriptsDir\05_kiki_voice_setup.ps1"
            Write-Host "`n>>> HOAN TAT TOAN BO QUY TRINH! <<<" -ForegroundColor Green
            Read-Host "`nNhan Enter de tiep tuc..."
        }
        "Q" {
            Write-Host "Tam biet!" -ForegroundColor Yellow
            break
        }
        default {
            Write-Host "Lua chon khong hop le!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($choice.ToUpper() -ne "Q")
