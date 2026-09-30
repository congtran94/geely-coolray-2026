# GEELY COOLRAY 2026 (FLYME AUTO) - BỘ CÔNG CỤ TỰ ĐỘNG HÓA VÀ NÂNG CẤP HỆ THỐNG

Dự án này cung cấp toàn bộ công cụ, kịch bản tự động hóa (PowerShell) và tài liệu kỹ thuật được tinh chỉnh chuyên biệt cho **hệ điều hành Flyme Auto** trên xe **Geely Coolray (2024 – 2026)** tại thị trường Việt Nam:
1. **Sideloading** các ứng dụng thiết yếu: **SmartTube (YouTube không quảng cáo)**, **VietMap Live (Cảnh báo tốc độ & Camera phạt nguội)**, **Car Launcher**, **Kiki Auto**, **Laban Key**.
2. **Việt hóa Cấp độ 1 & 2**: Kích hoạt tiếng Việt hệ thống Android và tạo lớp phủ giao diện **RRO Overlay** cho menu Cài đặt xe Flyme Auto (không can thiệp ODO, an toàn tuyệt đối).
3. **Điều khiển giọng nói kép**: Tiếng Việt (Kiki Auto) cho giải trí & dẫn đường + Trợ lý gốc Flyme Auto ("Hi Geely") cho thân xe (cửa sổ trời, kính, điều hòa).

---

## 📁 CẤU TRÚC THƯ MỤC DỰ ÁN

```
geely-coolray-project/
├── tools/
│   └── platform-tools/         # Chứa adb.exe chính thức từ Google (đã tải sẵn)
├── apks/                       # Nơi chứa các file APK để cài lên xe
│   └── SmartTube.apk           # Đã tự động tải bản mới nhất (arm64-v8a)
├── overlay_level2/             # Dự án RRO Overlay Việt hóa Cài đặt xe Geely
│   ├── AndroidManifest.xml
│   ├── build_overlay.ps1
│   └── res/
│       ├── values/strings.xml
│       └── values-vi/strings.xml
├── scripts/                    # Các kịch bản tự động hóa qua ADB
│   ├── 00_setup_tools.ps1      # Tải công cụ & APKs
│   ├── 01_connect_vehicle.ps1  # Kết nối xe qua Wi-Fi / USB
│   ├── 02_batch_install_apks.ps1 # Cài hàng loạt APK & tự cấp mọi quyền
│   ├── 03_vietnamese_level1.ps1  # Kích hoạt tiếng Việt Cấp 1
│   ├── 04_driving_lock_bypass.ps1# Tắt chặn video khi xe di chuyển
│   ├── 05_kiki_voice_setup.ps1 # Cấu hình Trợ lý Kiki & Phím vô lăng
│   └── run_all.ps1             # Bảng điều khiển một chạm chạy tự động
├── docs/
│   ├── HUONG_DAN_CHI_TIET.md   # Cẩm nang hướng dẫn đầy đủ từ A đến Z
│   └── CHECKLIST_NGHIEM_THU.md # Bảng kiểm tra nghiệm thu tính năng
└── README.md
```

---

## 🚀 CÁCH SỬ DỤNG NHANH

### Bước 1: Chuẩn bị APK
Copy các file APK cần cài vào thư mục `apks/`:
* `CarLauncher.apk` (hoặc Agama Car Launcher)
* `VietMapLive.apk`
* `KikiAuto.apk`
* `LabanKey.apk`
* `MoreLocale2.apk`
* `ButtonMapper.apk`
*(File `SmartTube.apk` đã được tự động tải sẵn)*.

### Bước 2: Chạy bảng điều khiển một chạm
Mở PowerShell trên máy tính:
```powershell
cd D:\CongTran\geely-coolray-project\scripts
powershell.exe -ExecutionPolicy Bypass -File .\run_all.ps1
```
Chọn **[A]** để hệ thống tự động kết nối xe, cài đặt toàn bộ ứng dụng, phân quyền và kích hoạt tiếng Việt.

---

📖 **Đọc hướng dẫn chi tiết:** Xem file [docs/HUONG_DAN_CHI_TIET.md](docs/HUONG_DAN_CHI_TIET.md) để biết mã mở Engineering Mode, cách gán phím vô lăng và bảng khẩu lệnh giọng nói.
