# BÀI TẬP 05: XÂY DỰNG CHỨC NĂNG CRUD ROLE ADMIN VỚI SPRING BOOT, JSP/JSTL & SITEMESH 3

> **Môn học**: Lập trình Web  
> **Trường**: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)  
> **Sinh viên thực hiện**: Đỗ Thanh Tài  
> **Mã số sinh viên (MSSV)**: 24133050  
> **GitHub Repository**: [https://github.com/thnhtaii/LT_Web_BT05_0909](https://github.com/thnhtaii/LT_Web_BT05_0909)

---

## 📌 1. Giới thiệu Đề tài & Yêu cầu Bài tập

Dự án **BT05_0909** xây dựng module quản trị (**Role Admin**) cho hệ thống bán hàng và quản lý tài khoản, kế thừa và nâng cấp từ mô hình Servlet MVC lên **Spring Boot**. 

### Các yêu cầu trọng tâm:
1. **Khung ứng dụng (Framework)**: Áp dụng **Spring Boot 3** (Java 21 LTS) với kiến trúc phân lớp chuẩn (Entity - Repository - Service - Controller).
2. **Công nghệ View**: Sử dụng **JSP / JSTL** (Jakarta EE 10) với nhúng máy chủ nhúng Tomcat Jasper.
3. **Bố cục & Decorator**: Tích hợp **SiteMesh Decorators 3** để chuẩn hóa layout giao diện quản trị Admin.
4. **Giao diện người dùng**: Thiết kế hiện đại trên nền tảng **Bootstrap 5.3.3**, Font chữ Google *Plus Jakarta Sans*, và bộ biểu tượng *Font Awesome 6.5.2*.
5. **Nghiệp vụ cốt lõi**:
   - **Bảng Category (Danh mục)**: Đầy đủ chức năng CRUD, Upload hình ảnh (kèm xem trước trực tiếp), Tìm kiếm danh mục, Phân trang linh hoạt.
   - **Bảng User (Người dùng)**: Đầy đủ chức năng CRUD, Upload avatar, Tìm kiếm đa trường thông minh, Phân trang, Chuyển đổi trạng thái tài khoản nhanh (Kích hoạt/Khóa), Cơ chế bảo vệ tài khoản quản trị chính.
6. **Cơ sở dữ liệu độc lập**: Kết nối cơ sở dữ liệu riêng biệt **`BT05`** trên Microsoft SQL Server.

---

## 🛠️ 2. Công nghệ & Thư viện sử dụng

| Phân tầng | Công nghệ / Thư viện | Phiên bản | Ghi chú |
| :--- | :--- | :--- | :--- |
| **Backend** | Spring Boot | 3.3.3 | Core framework |
| **Ngôn ngữ** | Java (JDK) | 21 / 26 | Hỗ trợ tính năng Java hiện đại |
| **ORM / Data** | Spring Data JPA / Hibernate | 6.5.2.Final | Thao tác dữ liệu qua JpaRepository |
| **Database** | Microsoft SQL Server | 2022 / Express | Database riêng: `BT05` |
| **JDBC Driver** | mssql-jdbc | 12.6.3 | Driver kết nối SQL Server |
| **Web Server** | Embedded Apache Tomcat | 10.1.28 | Tích hợp sẵn `tomcat-embed-jasper` |
| **Template & View** | JSP & Jakarta JSTL | 3.0.0 | Render giao diện phía máy chủ |
| **Decorator** | SiteMesh 3 (Jakarta EE) | 3.2.2 | Quản lý layout giao diện |
| **Frontend** | Bootstrap & FontAwesome | 5.3.3 / 6.5.2 | Giao diện Responsive cao cấp |
| **File Handling** | Commons IO & Multipart | 2.16.1 | Quản lý upload và xóa file an toàn |
| **Build Tool** | Apache Maven | 3.9.16 | Quản lý vòng đời dự án |

---

## 📂 3. Cấu trúc Dự án

```
BT05_0909/
├── .gitignore
├── pom.xml                                  # Cấu hình Maven & dependencies
├── README.md                                # Tài liệu hướng dẫn dự án
├── uploads/                                 # Thư mục lưu trữ hình ảnh upload
│   ├── categories/                          # Ảnh danh mục sản phẩm
│   └── users/                               # Ảnh đại diện tài khoản
└── src/
    └── main/
        ├── java/
        │   └── vn/iotstar/
        │       ├── Bt050909Application.java # Lớp khởi chạy Spring Boot
        │       ├── config/
        │       │   ├── SiteMeshConfig.java  # Đăng ký FilterRegistrationBean cho SiteMesh 3
        │       │   └── WebMvcConfig.java    # ResourceHandler cho /uploads/** & static assets
        │       ├── controller/
        │       │   └── admin/
        │       │       ├── AdminHomeController.java # Dashboard & thống kê tổng quan
        │       │       ├── CategoryController.java  # CRUD, phân trang & tìm kiếm Category
        │       │       └── UserController.java      # CRUD, phân trang & tìm kiếm User
        │       ├── entity/
        │       │   ├── Category.java        # JPA Entity Category ánh xạ bảng categories
        │       │   └── User.java            # JPA Entity User ánh xạ bảng users
        │       ├── filter/
        │       │   └── MySiteMeshFilter.java# Cấu hình đường dẫn áp dụng Decorator
        │       ├── repository/
        │       │   ├── CategoryRepository.java # JpaRepository tìm kiếm & phân trang Category
        │       │   └── UserRepository.java     # JpaRepository tìm kiếm & phân trang User
        │       ├── service/
        │       │   ├── ICategoryService.java
        │       │   ├── IUserService.java
        │       │   └── impl/
        │       │       ├── CategoryServiceImpl.java
        │       │       └── UserServiceImpl.java
        │       └── utils/
        │           └── FileUploadUtil.java  # Tiện ích upload & xóa file vật lý an toàn
        ├── resources/
        │   └── application.properties       # Cấu hình kết nối DB BT05, JPA, View Resolver
        └── webapp/
            └── WEB-INF/
                ├── decorators/
                │   └── admin.jsp            # Template Layout chuẩn của SiteMesh 3 (Sidebar, Header, Footer)
                └── views/
                    └── admin/
                        ├── dashboard.jsp    # Giao diện Trang chủ Dashboard
                        ├── category-list.jsp# Bảng danh mục + Tìm kiếm + Phân trang
                        ├── category-add.jsp # Form thêm mới danh mục (Xem trước ảnh)
                        ├── category-edit.jsp# Form chỉnh sửa danh mục
                        ├── user-list.jsp    # Bảng người dùng + Tìm kiếm + Phân trang
                        ├── user-add.jsp     # Form thêm người dùng + Phân quyền
                        └── user-edit.jsp    # Form sửa người dùng + Đổi mật khẩu tùy chọn
```

---

## ✨ 4. Chi tiết các Tính năng Hoàn thiện

### 1. Bảng điều khiển Quản trị (Dashboard) - `/admin`
- Thẻ thống kê tổng số danh mục, tổng số người dùng, số lượng quản trị viên, và tài khoản đang hoạt động.
- Hiển thị 2 bảng dữ liệu rút gọn: Các danh mục gần đây và các tài khoản người dùng mới nhất.
- Nút truy cập nhanh thao tác thêm mới.

### 2. Quản lý Danh mục (Category Management) - `/admin/categories`
- **Hiển thị & Phân trang**: Phân trang tùy biến theo kích thước trang (5, 10, 20 danh mục/trang), thanh phân trang điều hướng trang trước, trang sau, trang đầu và cuối.
- **Tìm kiếm thông minh**: Tìm kiếm theo tên danh mục (không phân biệt hoa/thường), tự động duy trì từ khóa tìm kiếm khi chuyển qua lại giữa các trang.
- **Thêm mới**: Kiểm tra validation dữ liệu bắt buộc, kiểm tra trùng lặp tên danh mục, upload ảnh đại diện có **xem trước ảnh (preview)** trực tiếp.
- **Chỉnh sửa**: Tải lại dữ liệu cũ, hiển thị ảnh hiện tại, cho phép thay ảnh mới hoặc giữ nguyên ảnh cũ.
- **Xóa**: Modal xác nhận xóa an toàn hiển thị tên và ID danh mục, xóa file ảnh vật lý tương ứng khỏi hệ thống.
- **Xem ảnh lớn**: Nhấp vào ảnh thumbnail để phóng to ảnh xem chi tiết qua Bootstrap Modal.

### 3. Quản lý Người dùng (User Management) - `/admin/users`
- **Hiển thị & Phân trang**: Danh sách tài khoản kèm avatar (có fallback tự động qua UI-Avatars nếu chưa có ảnh), hiển thị badge vai trò (Admin / User) và badge trạng thái tài khoản.
- **Tìm kiếm đa trường**: Cho phép tìm kiếm đồng thời theo `username`, `fullname`, `email` hoặc `phone`.
- **Thêm mới**: Phân quyền tài khoản (Admin/User), thiết lập trạng thái khởi tạo, kiểm tra trùng lặp username/email.
- **Chỉnh sửa**: Cập nhật thông tin cá nhân, cập nhật avatar mới, hỗ trợ **đổi mật khẩu tùy chọn** (nếu để trống ô mật khẩu sẽ giữ nguyên mật khẩu cũ).
- **Khóa / Mở khóa nhanh**: Nút thao tác nhanh chuyển đổi trực tiếp trạng thái tài khoản (Hoạt động ↔ Bị khóa) ngay trên bảng danh sách.
- **Cơ chế an toàn**: Khóa cứng không cho phép xóa hoặc tước quyền tài khoản Quản trị viên mặc định (`ID = 1`).

### 4. Giao diện SiteMesh Decorator 3 & Bootstrap Template
- Layout `admin.jsp` chuẩn hóa toàn bộ khu vực quản trị:
  - **Sidebar cố định**: Logo thương hiệu, các mục menu điều hướng có hiệu ứng active nổi bật.
  - **Top Header**: Tiêu đề hệ thống, role badge, avatar quản trị viên và dropdown thao tác.
  - **Flash Messages (Toasts)**: Tự động hiển thị các thông báo thành công hoặc cảnh báo lỗi từ Spring MVC `RedirectAttributes`, tự động ẩn sau 5 giây.
  - **Footer**: Hiển thị thông tin hệ thống và trạng thái kết nối Database.

---

## 🗄️ 5. Cấu hình Cơ sở dữ liệu (Microsoft SQL Server)

Dự án kết nối tới database riêng biệt tên là **`BT05`**:

```properties
spring.datasource.url=jdbc:sqlserver://localhost:64590;databaseName=BT05;encrypt=true;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=22092006
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

# Hibernate naming giữ nguyên chính xác tên cột của bảng
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
spring.jpa.hibernate.naming.implicit-strategy=org.hibernate.boot.model.naming.ImplicitNamingStrategyLegacyJpaImpl
```

### Sơ đồ cấu trúc 2 bảng chính:

#### Bảng `categories`:
| Tên cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `categoryId` | INT | PRIMARY KEY, IDENTITY | Mã danh mục tự tăng |
| `categoryname` | NVARCHAR(255) | NOT NULL | Tên danh mục |
| `images` | NVARCHAR(255) | NULL | Đường dẫn file ảnh upload |
| `status` | INT | DEFAULT 1 | 1: Hoạt động, 0: Tạm ẩn |

#### Bảng `users`:
| Tên cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | INT | PRIMARY KEY, IDENTITY | Mã người dùng tự tăng |
| `username` | VARCHAR(50) | NOT NULL, UNIQUE | Tên đăng nhập |
| `password` | VARCHAR(255) | NOT NULL | Mật khẩu |
| `fullname` | NVARCHAR(100) | NULL | Họ và tên |
| `email` | VARCHAR(100) | NOT NULL, UNIQUE | Địa chỉ email |
| `phone` | VARCHAR(20) | NULL | Số điện thoại |
| `avatar` / `images`| NVARCHAR(255) | NULL | Ảnh đại diện |
| `roleId` | INT | DEFAULT 2 | 1: Admin, 2: User |
| `status` | INT | DEFAULT 1 | 1: Hoạt động, 0: Chờ duyệt, 2: Khóa |

---

## 🚀 6. Hướng dẫn Cài đặt & Khởi chạy

### Yêu cầu môi trường:
- Java JDK 17+ (Khuyên dùng JDK 21).
- Apache Maven 3.8+.
- Microsoft SQL Server đã cài đặt và đang chạy.

### Các bước thực hiện:

1. **Clone mã nguồn từ GitHub**:
   ```bash
   git clone https://github.com/thnhtaii/LT_Web_BT05_0909.git
   cd LT_Web_BT05_0909
   ```

2. **Cấu hình Database**:
   - Mở file `src/main/resources/application.properties`.
   - Kiểm tra và chỉnh sửa cổng port (mặc định `64590` hoặc `1433`) và mật khẩu `sa` phù hợp với máy của bạn.

3. **Biên dịch và chạy ứng dụng**:
   - **Cách 1: Chạy bằng dòng lệnh (Maven)**:
     ```bash
     mvn clean compile
     mvn spring-boot:run
     ```
   - **Cách 2: Chạy trong Spring Tool Suite (STS) / Eclipse**:
     - Chọn menu `File` ➔ `Import...` ➔ `Existing Maven Projects` ➔ Chọn thư mục dự án.
     - Nhấp chuột phải vào dự án `BT05_0909` ➔ `Run As` ➔ `Spring Boot App`.

4. **Truy cập các chức năng trên trình duyệt**:
   - **Bảng điều khiển (Dashboard)**: [http://localhost:8085/admin](http://localhost:8085/admin)
   - **Quản lý Danh mục**: [http://localhost:8085/admin/categories](http://localhost:8085/admin/categories)
   - **Thêm mới Danh mục**: [http://localhost:8085/admin/category/add](http://localhost:8085/admin/category/add)
   - **Quản lý Người dùng**: [http://localhost:8085/admin/users](http://localhost:8085/admin/users)
   - **Thêm mới Người dùng**: [http://localhost:8085/admin/user/add](http://localhost:8085/admin/user/add)

---

## 📈 7. Bảng Tổng kết Kết quả Thực hiện

| Yêu cầu đề bài | Trạng thái | Đánh giá |
| :--- | :---: | :--- |
| Spring Boot 3 + JSP/JSTL (Jakarta EE) | Hoàn thành | Ổn định, không xung đột thư viện |
| Áp dụng SiteMesh 3 Decorators Layout | Hoàn thành | Layout đồng bộ, chuẩn responsive |
| CRUD Category + Upload ảnh + Preview ảnh | Hoàn thành | Đầy đủ tính năng, kiểm tra trùng lặp |
| CRUD User + Phân quyền + Đổi mật khẩu | Hoàn thành | Đầy đủ tính năng, an toàn |
| Chức năng Tìm kiếm (Search) | Hoàn thành | Tìm kiếm tức thời, bảo lưu từ khóa |
| Chức năng Phân trang (Pagination) | Hoàn thành | Phân trang thông minh theo Pageable |
| Giao diện Bootstrap Template hiện đại | Hoàn thành | Thẩm mỹ cao, bo góc, modal, toast |
| Cơ sở dữ liệu riêng biệt `BT05` | Hoàn thành | Không ảnh hưởng đến các bài tập cũ |
| Quản lý phiên bản trên GitHub | Hoàn thành | Push sạch sẽ, commit chuẩn format |

---

