<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Danh Mục</title>
    <style>
        .category-thumb {
            width: 58px;
            height: 58px;
            border-radius: 12px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .category-thumb:hover {
            transform: scale(1.08);
        }
        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
    </style>
</head>
<body>

    <!-- Breadcrumb & Title -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1 text-dark">Quản Lý Danh Mục</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Danh mục sản phẩm</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-primary rounded-3 px-3 py-2 fw-semibold">
            <i class="fa-solid fa-plus me-1"></i> Thêm Danh Mục Mới
        </a>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="card-custom">
        <div class="card-custom-body py-3">
            <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="row g-3 align-items-center">
                <input type="hidden" name="size" value="${size}" />
                <input type="hidden" name="sort" value="${sortField}" />
                <input type="hidden" name="direction" value="${direction}" />

                <div class="col-12 col-md-6 col-lg-5">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" name="keyword" value="${keyword}" class="form-control border-start-0 ps-0" placeholder="Tìm theo tên danh mục...">
                        <button type="submit" class="btn btn-primary px-3">Tìm kiếm</button>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/categories?size=${size}" class="btn btn-outline-secondary">Xóa lọc</a>
                        </c:if>
                    </div>
                </div>

                <div class="col-12 col-md-6 col-lg-7 d-flex justify-content-md-end align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <label class="text-muted small text-nowrap">Hiển thị:</label>
                        <select class="form-select form-select-sm w-auto" onchange="location.href='${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&sort=${sortField}&direction=${direction}&size=' + this.value;">
                            <option value="5" ${size == 5 ? 'selected' : ''}>5 dòng</option>
                            <option value="10" ${size == 10 ? 'selected' : ''}>10 dòng</option>
                            <option value="20" ${size == 20 ? 'selected' : ''}>20 dòng</option>
                        </select>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Data Table Card -->
    <div class="card-custom">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4" style="width: 80px;">
                            <a href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=${currentPage}&size=${size}&sort=categoryId&direction=${sortField == 'categoryId' ? reverseDirection : 'desc'}" class="text-dark text-decoration-none d-flex align-items-center gap-1">
                                ID <i class="fa-solid fa-sort small text-muted"></i>
                            </a>
                        </th>
                        <th style="width: 100px;">Hình Ảnh</th>
                        <th>
                            <a href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=${currentPage}&size=${size}&sort=categoryname&direction=${sortField == 'categoryname' ? reverseDirection : 'asc'}" class="text-dark text-decoration-none d-flex align-items-center gap-1">
                                Tên Danh Mục <i class="fa-solid fa-sort small text-muted"></i>
                            </a>
                        </th>
                        <th style="width: 160px;">Trạng Thái</th>
                        <th class="text-end pe-4" style="width: 140px;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <c:forEach items="${categories}" var="cat">
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">#${cat.categoryId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cat.images}">
                                                <img src="${cat.images.startsWith('http') ? cat.images : pageContext.request.contextPath.concat('/uploads/').concat(cat.images)}"
                                                     class="category-thumb" alt="${cat.categoryname}"
                                                     onclick="showImageModal('${cat.images.startsWith('http') ? cat.images : pageContext.request.contextPath.concat('/uploads/').concat(cat.images)}', '${cat.categoryname}')">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="category-thumb d-flex align-items-center justify-content-center bg-light text-muted">
                                                    <i class="fa-solid fa-image"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark fs-6">${cat.categoryname}</div>
                                        <small class="text-muted">Mã định danh: CAT-${cat.categoryId}</small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cat.status == 1}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1.5 fw-semibold">
                                                    <i class="fa-solid fa-circle-check me-1"></i> Đang hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border rounded-pill px-3 py-1.5 fw-semibold">
                                                    <i class="fa-solid fa-circle-xmark me-1"></i> Tạm ẩn
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/category/edit/${cat.categoryId}" 
                                               class="action-btn btn btn-outline-primary" title="Chỉnh sửa">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <button type="button" class="action-btn btn btn-outline-danger" 
                                                    onclick="confirmDelete(${cat.categoryId}, '${cat.categoryname}')" title="Xóa">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <div class="text-muted">
                                        <i class="fa-solid fa-folder-open fs-1 d-block mb-3 text-secondary"></i>
                                        <h5>Không tìm thấy danh mục nào</h5>
                                        <p class="small">Hãy thử tìm kiếm với từ khóa khác hoặc thêm mới danh mục.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination Footer -->
        <div class="card-custom-header border-top border-bottom-0 py-3">
            <div class="text-muted small">
                Hiển thị <strong>${categoryPage.numberOfElements}</strong> / <strong>${totalItems}</strong> danh mục
                (Trang <strong>${currentPage}</strong> / <strong>${totalPages > 0 ? totalPages : 1}</strong>)
            </div>

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <!-- Trang đầu -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=1&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angles-left"></i>
                            </a>
                        </li>
                        <!-- Trang trước -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=${currentPage - 1}&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angle-left"></i>
                            </a>
                        </li>

                        <!-- Các số trang -->
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=${p}&size=${size}&sort=${sortField}&direction=${direction}">${p}</a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <!-- Trang sau -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=${currentPage + 1}&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angle-right"></i>
                            </a>
                        </li>
                        <!-- Trang cuối -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/categories?keyword=${keyword}&page=${totalPages}&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angles-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <!-- Modal Xem Ảnh Lớn -->
    <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 overflow-hidden border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="imageModalTitle">Xem Hình Ảnh</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center p-4">
                    <img src="" id="modalImageSrc" class="img-fluid rounded-3 shadow-sm" style="max-height: 400px;" alt="Preview">
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Xác Nhận Xóa -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-body text-center p-4">
                    <div class="text-danger mb-3">
                        <i class="fa-solid fa-triangle-exclamation fs-1"></i>
                    </div>
                    <h4 class="fw-bold mb-2">Xác nhận xóa danh mục?</h4>
                    <p class="text-muted mb-4" id="deleteMessageText">Bạn có chắc chắn muốn xóa danh mục này? Hành động này không thể hoàn tác.</p>
                    <div class="d-flex justify-content-center gap-3">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <a href="#" id="confirmDeleteLink" class="btn btn-danger rounded-pill px-4">Xóa ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showImageModal(src, title) {
            document.getElementById('modalImageSrc').src = src;
            document.getElementById('imageModalTitle').innerText = title;
            new bootstrap.Modal(document.getElementById('imagePreviewModal')).show();
        }

        function confirmDelete(id, name) {
            document.getElementById('deleteMessageText').innerHTML = 'Bạn có chắc chắn muốn xóa danh mục <strong>' + name + '</strong> (ID: #' + id + ')?';
            document.getElementById('confirmDeleteLink').href = '${pageContext.request.contextPath}/admin/category/delete/' + id;
            new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
        }
    </script>

</body>
</html>
