# ==============================================================================
# Script: open_download_links.ps1
# Tác vụ: Tự động mở các trang tải 5 APK còn lại trên trình duyệt máy tính
# ==============================================================================

Write-Host "Dang mo cac trang tai APK chinh thuc tren trinh duyet cua ban..." -ForegroundColor Cyan

$urls = @(
    "https://apkpure.net/vn/vietmap-live/vn.vietmap.live",
    "https://apkpure.net/vn/kiki-auto-tr%E1%BB%A3-l%C3%BD-gi%E1%BB%8Dng-n%C3%B3i/com.zing.zalo.kikiauto",
    "https://apkpure.net/vn/agama-car-launcher/altergames.carlauncher",
    "https://apkpure.net/vn/laban-key-%C4%91%C3%A1nh-ti%E1%BA%BFng-vi%E1%BB%87t/com.vng.inputmethod.labankey",
    "https://apkpure.net/vn/button-mapper-remap-your-keys/flar2.homebutton"
)

foreach ($url in $urls) {
    Start-Process $url
    Start-Sleep -Milliseconds 500
}

Write-Host "Da mo xong! Sau khi tai ve, ban copy 5 file APK vao thu muc:" -ForegroundColor Green
Write-Host "D:\CongTran\geely-coolray-project\apks" -ForegroundColor Yellow
