# BT05 - Quản Lý CRUD Admin bằng Spring Boot 3, JSP/JSTL & SiteMesh 3

Dự án bài tập môn Lập trình Web - Học kỳ 1 Năm 3 (HCMUTE)
- **Sinh viên**: Đỗ Thành Tài
- **MSSV**: 24133050

## Các công nghệ áp dụng
- **Backend**: Spring Boot 3.3.3 (Java 21), Spring Data JPA, Hibernate ORM
- **Cơ sở dữ liệu**: Microsoft SQL Server (Database: `BT05`)
- **View & Layout**: JSP/JSTL, SiteMesh 3.2.2 Decorators
- **Giao diện**: Bootstrap 5.3.3, Google Font Plus Jakarta Sans, FontAwesome 6.5.2

## Chức năng hoàn thiện trong Role Admin
1. **Bảng điều khiển (Dashboard)**: Thống kê số lượng danh mục, người dùng, quản trị viên, người dùng hoạt động và các bảng dữ liệu mới nhất.
2. **Quản lý Danh mục (Categories CRUD)**:
   - Danh sách phân trang thông minh (tùy chọn 5, 10, 20 dòng/trang).
   - Tìm kiếm danh mục theo tên.
   - Thêm mới và chỉnh sửa có chức năng xem trước ảnh upload trực tiếp.
   - Xóa an toàn kèm modal xác nhận.
3. **Quản lý Người dùng (Users CRUD)**:
   - Danh sách phân trang và lọc dữ liệu.
   - Tìm kiếm đa trường (username, họ tên, email, số điện thoại).
   - Thêm mới, chỉnh sửa thông tin, đổi mật khẩu và avatar.
   - Nút bật/tắt nhanh trạng thái hoạt động của tài khoản.
   - Bảo vệ tài khoản quản trị chính (ID = 1).

## Hướng dẫn chạy
1. Đảm bảo dịch vụ SQL Server đang chạy và database `BT05` đã được cấu hình trong `src/main/resources/application.properties`.
2. Khởi chạy ứng dụng:
   ```bash
   mvn spring-boot:run
   ```
3. Mở trình duyệt và truy cập:
   ```
   http://localhost:8085/admin
   ```
