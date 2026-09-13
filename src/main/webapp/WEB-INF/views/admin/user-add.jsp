<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Người Dùng Mới</title>
    <style>
        .preview-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 3px dashed #cbd5e1;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background-color: #f8fafc;
            position: relative;
        }
        .preview-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
</head>
<body>

    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1 text-dark">Thêm Người Dùng Mới</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/users" class="text-decoration-none">Người dùng</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary rounded-3 px-3 py-2 fw-medium">
            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <!-- Error Alert if any -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exclamation fs-5 text-danger"></i>
            <div>${errorMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Main Card Form -->
    <div class="row justify-content-center">
        <div class="col-12 col-lg-9">
            <div class="card-custom">
                <div class="card-custom-header">
                    <h5 class="card-custom-title"><i class="fa-solid fa-user-plus text-primary me-2"></i>Thông Tin Tài Khoản Người Dùng</h5>
                </div>
                <div class="card-custom-body">
                    <form action="${pageContext.request.contextPath}/admin/user/save" method="post" enctype="multipart/form-data">
                        
                        <div class="row g-4">
                            <!-- Cột Trái: Ảnh đại diện -->
                            <div class="col-12 col-md-4 text-center border-end">
                                <label class="form-label fw-semibold text-dark d-block mb-3">Ảnh đại diện (Avatar)</label>
                                <div class="d-flex flex-column align-items-center">
                                    <div class="preview-avatar mb-3" id="previewContainer">
                                        <span class="text-muted small text-center p-2" id="placeholderText">
                                            <i class="fa-solid fa-user fs-1 d-block mb-1 text-secondary"></i>
                                            Chọn ảnh
                                        </span>
                                        <img src="" id="avatarPreview" class="d-none" alt="Avatar Preview">
                                    </div>
                                    <input type="file" class="form-control form-control-sm w-100" id="avatarFile" name="avatarFile" accept="image/*" onchange="previewSelectedAvatar(this)">
                                    <div class="form-text text-muted mt-2 small">Định dạng JPG, PNG, WEBP.</div>
                                </div>
                            </div>

                            <!-- Cột Phải: Các trường dữ liệu -->
                            <div class="col-12 col-md-8">
                                <div class="row g-3">
                                    <!-- Username -->
                                    <div class="col-12 col-sm-6">
                                        <label for="username" class="form-label fw-semibold text-dark">
                                            Tên đăng nhập <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="username" name="username" value="${user.username}" 
                                               placeholder="Ví dụ: nguyenvana" required>
                                    </div>

                                    <!-- Password -->
                                    <div class="col-12 col-sm-6">
                                        <label for="password" class="form-label fw-semibold text-dark">
                                            Mật khẩu <span class="text-danger">*</span>
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="Mật khẩu khởi tạo" required>
                                    </div>

                                    <!-- Fullname -->
                                    <div class="col-12">
                                        <label for="fullname" class="form-label fw-semibold text-dark">Họ và tên đầy đủ</label>
                                        <input type="text" class="form-control" id="fullname" name="fullname" value="${user.fullname}" 
                                               placeholder="Ví dụ: Nguyễn Văn A">
                                    </div>

                                    <!-- Email -->
                                    <div class="col-12 col-sm-6">
                                        <label for="email" class="form-label fw-semibold text-dark">
                                            Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" value="${user.email}" 
                                               placeholder="example@domain.com" required>
                                    </div>

                                    <!-- Phone -->
                                    <div class="col-12 col-sm-6">
                                        <label for="phone" class="form-label fw-semibold text-dark">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}" 
                                               placeholder="0987654321">
                                    </div>

                                    <!-- Role -->
                                    <div class="col-12 col-sm-6">
                                        <label for="roleId" class="form-label fw-semibold text-dark">Phân quyền (Vai trò)</label>
                                        <select class="form-select" id="roleId" name="roleId">
                                            <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Người dùng (User)</option>
                                            <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Quản trị viên (Admin)</option>
                                        </select>
                                    </div>

                                    <!-- Status -->
                                    <div class="col-12 col-sm-6">
                                        <label for="status" class="form-label fw-semibold text-dark">Trạng thái tài khoản</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="1" ${user.status == 1 ? 'selected' : ''}>Đang hoạt động</option>
                                            <option value="0" ${user.status == 0 ? 'selected' : ''}>Chờ kích hoạt</option>
                                            <option value="2" ${user.status == 2 ? 'selected' : ''}>Bị khóa</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4 text-secondary opacity-25">

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-3">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-light rounded-3 px-4 py-2 fw-medium">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-primary rounded-3 px-4 py-2 fw-semibold">
                                <i class="fa-solid fa-floppy-disk me-1"></i> Lưu Người Dùng
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewSelectedAvatar(input) {
            const preview = document.getElementById('avatarPreview');
            const placeholder = document.getElementById('placeholderText');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    preview.classList.remove('d-none');
                    placeholder.classList.add('d-none');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

</body>
</html>
