# CẨM NANG HƯỚNG DẪN CHI TIẾT: NÂNG CẤP GEELY COOLRAY 2026

Tài liệu này hướng dẫn chi tiết từng bước thực hiện dự án: **Sideloading APKs, Việt hóa Cấp độ 1 & 2, Cài đặt YouTube, VietMap và Tích hợp Trợ lý giọng nói tiếng Việt kép** trên xe **Geely Coolray (2024 – 2026)**.

---

## 1. TỔNG QUAN HỆ THỐNG VÀ NGUYÊN LÝ HOẠT ĐỘNG

* **Hệ điều hành xe**: **Flyme Auto** (Được phát triển bởi liên minh Xingji Meizu & Geely trên nền tảng Android Automotive/AOSP mới nhất).
* **Đặc điểm của Flyme Auto tại Việt Nam**:
  * Giao diện đồ họa rất mượt và hiện đại, nhưng hệ sinh thái đóng kín, không có CH Play.
  * Tự động ẩn toàn bộ icon ứng dụng sideload (bắt buộc phải có Car Launcher để mở).
  * Chặn video khi xe di chuyển rất nghiêm ngặt (đã có kịch bản cờ ADB tự động mở).
* **Cơ chế an toàn**: Không can thiệp vào phân vùng gốc `/system` (không root), không can thiệp vào cụm đồng hồ ODO/MCU.
* **Cơ chế hoạt động của các tính năng**:
  * **YouTube**: Dùng **SmartTube**, loại bỏ 100% quảng cáo, không phụ thuộc GMS, hỗ trợ PiP và chạy nền.
  * **VietMap**: Dùng **VietMap Live**, kích hoạt chế độ **Widget nổi** (Mini floating widget) đè lên góc màn hình YouTube để vừa nghe nhạc vừa nhận cảnh báo tốc độ, camera phạt nguội.
  * **Trợ lý giọng nói kép**:
    * **Tiếng Việt (Kiki Auto)**: Nhận diện giọng nói tiếng Việt tự nhiên để mở bài hát YouTube và dẫn đường VietMap.
    * **Phần cứng xe ("Hi Geely / Flyme Assistant")**: Nhận khẩu lệnh ngắn để chỉnh cửa sổ trời, kính cửa, quạt gió, nhiệt độ điều hòa.

---

## 2. CHUẨN BỊ TRƯỚC KHI THỰC HIỆN

### 2.1. Thiết bị
1. **01 Laptop Windows** (đã có bộ dự án `geely-coolray-project`).
2. **01 Điện thoại** có 4G để phát Wi-Fi Hotspot.
3. Cáp kết nối Type-C (phòng khi không muốn kết nối qua Wi-Fi).

### 2.2. Trạng thái các file APK trong thư mục `apks/` (ĐÃ TẢI SẴN 100%)
Toàn bộ 7 file APK cần thiết **đã được tải sẵn** đầy đủ trong thư mục `geely-coolray-project/apks/`:
* `VietMapLive.apk` (~219 MB): Bản đồ dẫn đường & Cảnh báo tốc độ VietMap Live.
* `SmartTube.apk` (~26 MB): YouTube không quảng cáo, tối ưu cho màn hình xe hơi.
* `KikiAuto.apk` (~48 MB): Trợ lý giọng nói tiếng Việt Kiki Auto (bản xe hơi Zalo AI).
* `CarLauncher.apk` (~12 MB): Màn hình khởi chạy ô tô Agama Car Launcher.
* `LabanKey.apk` (~23 MB): Bàn phím tiếng Việt Laban Key.
* `MoreLocale2.apk` (~6.5 MB): Kích hoạt tiếng Việt hệ thống AOSP.
* `ButtonMapper.apk` (~14.7 MB): Công cụ gán nút Micro trên vô lăng cho Kiki.

*(Bạn không cần phải tải thêm bất kỳ file nào từ bên ngoài!)*

---

## 3. CÁC BƯỚC THỰC HIỆN TRỰC TIẾP TRÊN XE

### Bước 1: Mở Engineering Mode trên Flyme Auto 1.8
Phiên bản **Flyme Auto 1.8** siết chặt bảo mật hơn các bản cũ. Hãy thực hiện theo thứ tự ưu tiên sau:

1. **Cách 1: Bàn phím Điện thoại (Mã thời gian động chuẩn cho 1.8)**
   * Mở ứng dụng **Điện thoại (Phone/Dialer)** trên màn hình xe.
   * Nhập mã theo công thức thời gian thực:
     $$\mathbf{\#*(Tháng + 10)(Ngày)(Giờ)}$$
     *(Ví dụ: Ngày 20 tháng 9, lúc 10 giờ sáng: Tháng 9 + 10 = 19; Ngày = 20; Giờ = 10 -> Mã nhập: **`#*192010`**)*.
   * Nếu mã trên không phản hồi, hãy thử 3 mã tĩnh phổ biến của 1.8:
     * **`#*132821`**
     * **`#*30617`**
     * **`#*202008`**

2. **Cách 2: Gõ liên tục trong Cài đặt (Settings)**
   * Vào `Cài đặt (Settings)` > `Hệ thống / Giới thiệu (About/System)` > Tìm dòng **Flyme Auto Version (1.8.x)**.
   * Chạm liên tục **7 đến 10 lần** vào dòng phiên bản này hoặc biểu tượng xe.
   * Nếu đòi mật khẩu: Thử `jh3280` hoặc `802018`.

3. **Bật ADB trên Flyme Auto 1.8**:
   * Trong menu kỹ thuật: Gạt **ADB Switch / Wireless ADB** sang **ON**.
   * *Mẹo xử lý khi nút ADB bị ẩn trên Flyme Auto 1.8*: Nếu nút ADB bị xám hoặc không thấy nút bấm, hãy kết nối cáp USB từ laptop vào cổng USB truyền dữ liệu (cổng Type-A có ký hiệu điện thoại ở hộc dưới yên ngựa). Kịch bản `04_driving_lock_bypass.ps1` sẽ tự động kích hoạt cờ `persist.service.adb.button.visible ON` để nút ADB luôn luôn hiển thị vĩnh viễn.

### Bước 2: Kết nối Wi-Fi & Chạy công cụ tự động
1. Bật trạm phát Wi-Fi Hotspot từ điện thoại của bạn.
2. Cho cả **Màn hình xe Geely** và **Laptop** kết nối vào Wi-Fi này.
3. Xem IP của xe trong phần Cài đặt Wi-Fi (Ví dụ: `192.168.43.105`).
4. Trên Laptop, mở PowerShell và chạy file điều khiển:
   ```powershell
   cd D:\CongTran\geely-coolray-project\scripts
   powershell.exe -ExecutionPolicy Bypass -File .\run_all.ps1
   ```
5. Chọn **[A] Chạy toàn bộ quy trình tự động** hoặc chạy lần lượt các bước:
   * **Bước 1**: Nhập IP xe để kết nối ADB.
   * **Bước 2**: Tự động cài đặt 7 ứng dụng và phân quyền hệ thống.
   * **Bước 3**: Kích hoạt tiếng Việt Cấp độ 1.
   * **Bước 4**: Tắt khóa video khi xe di chuyển.
   * **Bước 5**: Cấu hình trợ lý Kiki Auto và phím vô lăng.

---

## 4. THIẾT LẬP HOÀN TẤT SAU KHI CÀI ĐẶT (TRONG XE)

### 4.1. Thiết lập Car Launcher làm màn hình chính
1. Nhấn nút Home trên màn hình xe.
2. Hệ thống sẽ hỏi chọn giao diện khởi chạy: Chọn **Car Launcher** (hoặc Agama) > Chọn **Always (Luôn luôn)**.
3. Giờ đây toàn bộ các icon app (SmartTube, VietMap, Kiki...) sẽ hiển thị rõ ràng trên màn hình.

### 4.2. Thiết lập VietMap Live chạy song song YouTube
1. Mở **VietMap Live** > Đăng nhập tài khoản.
2. Vào `Cài đặt VietMap Live` > Bật mục **"Cửa sổ nổi (Floating Widget)"**.
3. Mở **SmartTube** phát một video nhạc.
4. Bạn sẽ thấy ô widget cảnh báo tốc độ của VietMap nổi ở góc màn hình. Bạn có thể dùng ngón tay kéo ô này đến vị trí thuận tiện nhất để quan sát khi lái xe.

### 4.3. Thiết lập Trợ lý Kiki Auto
1. Mở app **Kiki Auto** trên xe > Dùng Zalo trên điện thoại quét mã QR để đăng nhập.
2. Trong cài đặt Kiki:
   * Bản đồ điều hướng: Chọn **VietMap Live**.
   * Trình phát nhạc: Chọn **YouTube** hoặc **SmartTube**.

### 4.4. Gán nút bấm Micro trên vô lăng cho Kiki
1. Mở app **Button Mapper** trên xe.
2. Chọn **Add Buttons (+)** > Bấm nút Micro trên vô lăng để app nhận diện.
3. Nhấp vào tên phím vừa thêm > Bật tùy chọn **Customize**.
4. Tại mục **Single tap (Bấm 1 lần)**: Chọn **Applications** > Chọn **Kiki Auto**.

---

## 5. BẢNG KHẨU LỆNH ĐIỀU KHIỂN THỰC TẾ

| Nhu cầu điều khiển | Bạn nói câu lệnh | Hệ thống xử lý |
| :--- | :--- | :--- |
| **Tìm bài hát / Video** | Bấm nút vô lăng, nói: *"Mở nhạc remix trẻ trên YouTube"* | Kiki bật SmartTube phát bài hát |
| **Dẫn đường & Tốc độ** | Bấm nút vô lăng, nói: *"Dẫn đường đến Hồ Gươm"* | Kiki mở VietMap Live vẽ đường |
| **Mở cửa sổ trời** | Nói: *"Hi Geely, open sunroof"* | Hệ thống điện xe mở cửa trời |
| **Đóng cửa sổ trời** | Nói: *"Hi Geely, close sunroof"* | Cửa trời đóng lại |
| **Hạ kính cửa sổ** | Nói: *"Hi Geely, open windows"* | Kính xe trượt xuống |
| **Bật điều hòa & Chỉnh nhiệt**| Nói: *"Hi Geely, set temperature to 22 degrees"* | Điều hòa tự chuyển sang 22°C |
| **Tăng mức gió quạt** | Nói: *"Hi Geely, fan speed 3"* (hoặc *increase fan speed*) | Tốc độ gió tăng lên mức 3 |

---

## 6. XỬ LÝ SỰ CỐ THƯỜNG GẶP (TROUBLESHOOTING)

### 1. Không kết nối được ADB qua Wi-Fi
* **Khắc phục**:
  * Kiểm tra xem cả Laptop và Xe đã cùng kết nối vào một trạm Wi-Fi Hotspot chưa.
  * Tắt tường lửa (Firewall) trên máy tính tạm thời.
  * Thử cắm cáp USB nối từ Laptop vào cổng dữ liệu của xe (cổng USB kết nối CarPlay dưới hộc để đồ).

### 2. Xe chạy bị đen màn hình video (Driving Lock)
* **Xử lý hoàn toàn tự động**:
  * Bộ kịch bản đã tự động nạp **24 cờ hệ thống ADB** và cấp đặc quyền **Picture-in-Picture (PiP)** ngay trong bước cài đặt (`02_batch_install_apks.ps1`).
  * Nếu vì lý do nào đó xe bị reset, bạn chỉ cần chạy lại file `04_driving_lock_bypass.ps1` là xong ngay trong 3 giây mà không cần thao tác tay trên màn hình xe.

### 3. VietMap Live không báo vị trí hoặc báo "Đang tìm tín hiệu GPS"
* **Khắc phục**:
  * Cho xe ra ngoài trời thoáng (không đỗ trong hầm bê tông kín).
  * Chạy lại lệnh cấp quyền:
    ```bash
    adb shell pm grant vn.vietmap.live android.permission.ACCESS_FINE_LOCATION
    ```
