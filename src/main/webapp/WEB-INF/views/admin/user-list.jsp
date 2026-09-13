<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Người Dùng</title>
    <style>
        .user-avatar-cell {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e2e8f0;
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
            <h2 class="fw-bold mb-1 text-dark">Quản Lý Người Dùng</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Danh sách người dùng</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/user/add" class="btn btn-primary rounded-3 px-3 py-2 fw-semibold">
            <i class="fa-solid fa-user-plus me-1"></i> Thêm Người Dùng Mới
        </a>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="card-custom">
        <div class="card-custom-body py-3">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3 align-items-center">
                <input type="hidden" name="size" value="${size}" />
                <input type="hidden" name="sort" value="${sortField}" />
                <input type="hidden" name="direction" value="${direction}" />

                <div class="col-12 col-md-6 col-lg-5">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" name="keyword" value="${keyword}" class="form-control border-start-0 ps-0" placeholder="Tìm theo username, họ tên, email...">
                        <button type="submit" class="btn btn-primary px-3">Tìm kiếm</button>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/users?size=${size}" class="btn btn-outline-secondary">Xóa lọc</a>
                        </c:if>
                    </div>
                </div>

                <div class="col-12 col-md-6 col-lg-7 d-flex justify-content-md-end align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <label class="text-muted small text-nowrap">Hiển thị:</label>
                        <select class="form-select form-select-sm w-auto" onchange="location.href='${pageContext.request.contextPath}/admin/users?keyword=${keyword}&sort=${sortField}&direction=${direction}&size=' + this.value;">
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
                        <th class="ps-4" style="width: 70px;">
                            <a href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=${currentPage}&size=${size}&sort=id&direction=${sortField == 'id' ? reverseDirection : 'desc'}" class="text-dark text-decoration-none d-flex align-items-center gap-1">
                                ID <i class="fa-solid fa-sort small text-muted"></i>
                            </a>
                        </th>
                        <th style="width: 70px;">Avatar</th>
                        <th>
                            <a href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=${currentPage}&size=${size}&sort=username&direction=${sortField == 'username' ? reverseDirection : 'asc'}" class="text-dark text-decoration-none d-flex align-items-center gap-1">
                                Tài Khoản / Họ Tên <i class="fa-solid fa-sort small text-muted"></i>
                            </a>
                        </th>
                        <th>Liên Hệ (Email / Phone)</th>
                        <th style="width: 130px;">Vai Trò</th>
                        <th style="width: 150px;">Trạng Thái</th>
                        <th class="text-end pe-4" style="width: 160px;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty users}">
                            <c:forEach items="${users}" var="u">
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">#${u.id}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty u.avatar}">
                                                <img src="${u.avatar.startsWith('http') ? u.avatar : pageContext.request.contextPath.concat('/uploads/').concat(u.avatar)}" 
                                                     class="user-avatar-cell" alt="${u.username}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://ui-avatars.com/api/?name=${u.username}&background=random&color=fff&bold=true" 
                                                     class="user-avatar-cell" alt="${u.username}">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark fs-6">${u.username}</div>
                                        <div class="text-muted small">${u.fullname != null ? u.fullname : 'Chưa cập nhật tên'}</div>
                                    </td>
                                    <td>
                                        <div><i class="fa-regular fa-envelope me-1 text-muted"></i> ${u.email}</div>
                                        <c:if test="${not empty u.phone}">
                                            <div class="small text-muted"><i class="fa-solid fa-phone me-1 text-muted"></i> ${u.phone}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.roleId == 1}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-3 py-1.5 fw-semibold">
                                                    <i class="fa-solid fa-shield-halved me-1"></i> Admin
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-1.5 fw-semibold">
                                                    <i class="fa-solid fa-user me-1"></i> User
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2.5 py-1 fw-semibold">
                                                    <i class="fa-solid fa-circle-check me-1"></i> Hoạt động
                                                </span>
                                            </c:when>
                                            <c:when test="${u.status == 2}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-2.5 py-1 fw-semibold">
                                                    <i class="fa-solid fa-lock me-1"></i> Bị khóa
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill px-2.5 py-1 fw-semibold">
                                                    <i class="fa-solid fa-clock me-1"></i> Chờ duyệt
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-2">
                                            <!-- Nút đổi trạng thái nhanh -->
                                            <c:if test="${u.id != 1}">
                                                <a href="${pageContext.request.contextPath}/admin/user/toggle-status/${u.id}" 
                                                   class="action-btn btn ${u.status == 1 ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                   title="${u.status == 1 ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}">
                                                    <i class="fa-solid ${u.status == 1 ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                                </a>
                                            </c:if>

                                            <!-- Nút chỉnh sửa -->
                                            <a href="${pageContext.request.contextPath}/admin/user/edit/${u.id}" 
                                               class="action-btn btn btn-outline-primary" title="Chỉnh sửa">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <!-- Nút xóa -->
                                            <c:choose>
                                                <c:when test="${u.id != 1}">
                                                    <button type="button" class="action-btn btn btn-outline-danger" 
                                                            onclick="confirmDeleteUser(${u.id}, '${u.username}')" title="Xóa">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="action-btn btn btn-outline-secondary disabled" title="Không thể xóa Admin chính">
                                                        <i class="fa-solid fa-lock"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <div class="text-muted">
                                        <i class="fa-solid fa-user-slash fs-1 d-block mb-3 text-secondary"></i>
                                        <h5>Không tìm thấy người dùng nào</h5>
                                        <p class="small">Hãy thử tìm kiếm từ khóa khác hoặc thêm mới người dùng.</p>
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
                Hiển thị <strong>${userPage.numberOfElements}</strong> / <strong>${totalItems}</strong> người dùng
                (Trang <strong>${currentPage}</strong> / <strong>${totalPages > 0 ? totalPages : 1}</strong>)
            </div>

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <!-- Trang đầu -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=1&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angles-left"></i>
                            </a>
                        </li>
                        <!-- Trang trước -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=${currentPage - 1}&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angle-left"></i>
                            </a>
                        </li>

                        <!-- Các số trang -->
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=${p}&size=${size}&sort=${sortField}&direction=${direction}">${p}</a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <!-- Trang sau -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=${currentPage + 1}&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angle-right"></i>
                            </a>
                        </li>
                        <!-- Trang cuối -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&page=${totalPages}&size=${size}&sort=${sortField}&direction=${direction}">
                                <i class="fa-solid fa-angles-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <!-- Modal Xác Nhận Xóa User -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-body text-center p-4">
                    <div class="text-danger mb-3">
                        <i class="fa-solid fa-triangle-exclamation fs-1"></i>
                    </div>
                    <h4 class="fw-bold mb-2">Xác nhận xóa tài khoản?</h4>
                    <p class="text-muted mb-4" id="deleteUserMessageText">Bạn có chắc chắn muốn xóa tài khoản này khỏi hệ thống?</p>
                    <div class="d-flex justify-content-center gap-3">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <a href="#" id="confirmDeleteUserLink" class="btn btn-danger rounded-pill px-4">Xóa ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDeleteUser(id, username) {
            document.getElementById('deleteUserMessageText').innerHTML = 'Bạn có chắc chắn muốn xóa người dùng <strong>' + username + '</strong> (ID: #' + id + ')?';
            document.getElementById('confirmDeleteUserLink').href = '${pageContext.request.contextPath}/admin/user/delete/' + id;
            new bootstrap.Modal(document.getElementById('deleteUserModal')).show();
        }
    </script>

</body>
</html>
