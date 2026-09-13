<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Bảng Điều Khiển</title>
    <style>
        .stat-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid var(--card-border);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.06);
        }
        .stat-icon {
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .stat-val {
            font-size: 2rem;
            font-weight: 800;
            color: var(--dark);
            line-height: 1;
            margin-bottom: 4px;
        }
        .stat-label {
            color: var(--text-muted);
            font-size: 0.88rem;
            font-weight: 500;
        }
        .table-thumb {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>

    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1 text-dark">Tổng Quan Hệ Thống</h2>
            <p class="text-muted mb-0">Chào mừng trở lại! Dưới đây là thông tin quản trị mới nhất của hệ thống.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-primary rounded-3 px-3 py-2 fw-semibold">
                <i class="fa-solid fa-plus me-1"></i> Thêm Danh Mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/user/add" class="btn btn-outline-primary rounded-3 px-3 py-2 fw-semibold">
                <i class="fa-solid fa-user-plus me-1"></i> Thêm Người Dùng
            </a>
        </div>
    </div>

    <!-- Stat Cards Grid -->
    <div class="row g-4 mb-4">
        <!-- Total Categories -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="stat-val">${totalCategories}</div>
                    <div class="stat-label">Tổng Danh Mục</div>
                </div>
                <div class="stat-icon" style="background-color: #eef2ff; color: #4f46e5;">
                    <i class="fa-solid fa-layer-group"></i>
                </div>
            </div>
        </div>

        <!-- Total Users -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="stat-val">${totalUsers}</div>
                    <div class="stat-label">Tổng Tài Khoản</div>
                </div>
                <div class="stat-icon" style="background-color: #ecfeff; color: #0891b2;">
                    <i class="fa-solid fa-users"></i>
                </div>
            </div>
        </div>

        <!-- Admins -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="stat-val">${totalAdmins}</div>
                    <div class="stat-label">Quản Trị Viên</div>
                </div>
                <div class="stat-icon" style="background-color: #fef2f2; color: #ef4444;">
                    <i class="fa-solid fa-user-shield"></i>
                </div>
            </div>
        </div>

        <!-- Active Users -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="stat-val">${activeUsers}</div>
                    <div class="stat-label">Đang Hoạt Động</div>
                </div>
                <div class="stat-icon" style="background-color: #f0fdf4; color: #16a34a;">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Two Column Tables Section -->
    <div class="row g-4">
        <!-- Recent Categories -->
        <div class="col-12 col-lg-6">
            <div class="card-custom">
                <div class="card-custom-header">
                    <h5 class="card-custom-title"><i class="fa-solid fa-layer-group text-primary me-2"></i>Danh Mục Gần Đây</h5>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-sm btn-light rounded-pill px-3 fw-medium">Xem tất cả</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Ảnh</th>
                                <th>Tên Danh Mục</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentCategories}" var="cat">
                                <tr>
                                    <td class="ps-4 fw-semibold text-muted">#${cat.categoryId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cat.images}">
                                                <img src="${cat.images.startsWith('http') ? cat.images : pageContext.request.contextPath.concat('/uploads/').concat(cat.images)}"
                                                     class="table-thumb" alt="${cat.categoryname}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-thumb d-flex align-items-center justify-content-center bg-light text-muted">
                                                    <i class="fa-solid fa-image"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-semibold text-dark">${cat.categoryname}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cat.status == 1}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border rounded-pill">Tạm ẩn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Recent Users -->
        <div class="col-12 col-lg-6">
            <div class="card-custom">
                <div class="card-custom-header">
                    <h5 class="card-custom-title"><i class="fa-solid fa-users text-info me-2"></i>Người Dùng Mới Nhất</h5>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-light rounded-pill px-3 fw-medium">Xem tất cả</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Tài Khoản</th>
                                <th>Họ Tên</th>
                                <th>Vai Trò</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentUsers}" var="u">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-dark">${u.username}</div>
                                        <small class="text-muted">${u.email}</small>
                                    </td>
                                    <td>${u.fullname}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.roleId == 1}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill">User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Hoạt động</span>
                                            </c:when>
                                            <c:when test="${u.status == 2}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Bị khóa</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill">Chờ kích hoạt</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
