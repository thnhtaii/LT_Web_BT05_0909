<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Mới Danh Mục</title>
    <style>
        .preview-box {
            width: 140px;
            height: 140px;
            border-radius: 16px;
            border: 2px dashed #cbd5e1;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background-color: #f8fafc;
            position: relative;
        }
        .preview-box img {
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
            <h2 class="fw-bold mb-1 text-dark">Thêm Danh Mục Mới</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/categories" class="text-decoration-none">Danh mục</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary rounded-3 px-3 py-2 fw-medium">
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
        <div class="col-12 col-lg-8">
            <div class="card-custom">
                <div class="card-custom-header">
                    <h5 class="card-custom-title"><i class="fa-solid fa-folder-plus text-primary me-2"></i>Thông Tin Danh Mục</h5>
                </div>
                <div class="card-custom-body">
                    <form action="${pageContext.request.contextPath}/admin/category/save" method="post" enctype="multipart/form-data">
                        
                        <!-- Tên danh mục -->
                        <div class="mb-4">
                            <label for="categoryname" class="form-label fw-semibold text-dark">
                                Tên danh mục <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control form-control-lg ${status.error ? 'is-invalid' : ''}" 
                                   id="categoryname" name="categoryname" value="${category.categoryname}" 
                                   placeholder="Ví dụ: Thiết bị điện tử, Thời trang nam..." required>
                            <div class="form-text text-muted">Nhập tên danh mục rõ ràng, không trùng lặp trong hệ thống.</div>
                        </div>

                        <!-- Trạng thái -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-dark d-block">Trạng thái hiển thị</label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="status" id="statusActive" value="1" ${category.status != 0 ? 'checked' : ''}>
                                    <label class="form-check-label fw-medium text-success" for="statusActive">
                                        <i class="fa-solid fa-circle-check me-1"></i> Hoạt động (Hiển thị)
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="status" id="statusInactive" value="0" ${category.status == 0 ? 'checked' : ''}>
                                    <label class="form-check-label fw-medium text-secondary" for="statusInactive">
                                        <i class="fa-solid fa-circle-xmark me-1"></i> Tạm ẩn (Khóa)
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Ảnh đại diện -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-dark">Hình ảnh danh mục</label>
                            <div class="d-flex align-items-center gap-4 flex-wrap">
                                <div class="preview-box" id="previewContainer">
                                    <span class="text-muted text-center small p-2" id="placeholderText">
                                        <i class="fa-solid fa-image fs-3 d-block mb-1 text-secondary"></i>
                                        Chưa chọn ảnh
                                    </span>
                                    <img src="" id="imagePreview" class="d-none" alt="Preview">
                                </div>
                                <div class="flex-grow-1">
                                    <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*" onchange="previewSelectedImage(this)">
                                    <div class="form-text text-muted mt-2">
                                        Hỗ trợ định dạng JPG, PNG, GIF, WEBP. Dung lượng tối đa 20MB.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4 text-secondary opacity-25">

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-3">
                            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-light rounded-3 px-4 py-2 fw-medium">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-primary rounded-3 px-4 py-2 fw-semibold">
                                <i class="fa-solid fa-floppy-disk me-1"></i> Lưu Danh Mục
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewSelectedImage(input) {
            const preview = document.getElementById('imagePreview');
            const placeholder = document.getElementById('placeholderText');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    preview.classList.remove('d-none');
                    placeholder.classList.add('d-none');
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.classList.add('d-none');
                placeholder.classList.remove('d-none');
            }
        }
    </script>

</body>
</html>
