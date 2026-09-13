<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - DT Admin Portal</title>

    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome 6.5.2 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --primary-light: #eef2ff;
            --secondary: #0ea5e9;
            --dark: #0f172a;
            --dark-surface: #1e293b;
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
            --sidebar-active: #4f46e5;
            --bg-canvas: #f8fafc;
            --card-border: #e2e8f0;
            --text-main: #334155;
            --text-muted: #64748b;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-canvas);
            color: var(--text-main);
            margin: 0;
            min-height: 100vh;
            display: flex;
        }

        /* Sidebar Styling */
        .admin-sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            color: #94a3b8;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            position: sticky;
            top: 0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1040;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sidebar-brand {
            padding: 24px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #ffffff;
            font-weight: 800;
            font-size: 1.25rem;
            text-decoration: none;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .brand-icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 1.2rem;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.35);
        }

        .sidebar-menu {
            list-style: none;
            padding: 16px 12px;
            margin: 0;
            flex-grow: 1;
        }

        .sidebar-heading {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #64748b;
            font-weight: 700;
            padding: 12px 14px 6px;
        }

        .sidebar-item {
            margin-bottom: 4px;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 16px;
            color: #94a3b8;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 500;
            font-size: 0.92rem;
            transition: all 0.2s ease;
        }

        .sidebar-link i {
            font-size: 1.1rem;
            width: 22px;
            text-align: center;
            transition: transform 0.2s ease;
        }

        .sidebar-link:hover {
            color: #ffffff;
            background-color: var(--sidebar-hover);
        }

        .sidebar-link:hover i {
            transform: scale(1.15);
        }

        .sidebar-link.active {
            color: #ffffff;
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.4);
        }

        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            font-size: 0.8rem;
            color: #64748b;
        }

        /* Main Content Layout */
        .admin-main {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            min-height: 100vh;
        }

        /* Header / Navbar */
        .admin-header {
            background-color: #ffffff;
            height: 70px;
            border-bottom: 1px solid var(--card-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            position: sticky;
            top: 0;
            z-index: 1020;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);
        }

        .header-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .admin-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e0e7ff;
        }

        .admin-info {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .admin-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--dark);
            line-height: 1.2;
        }

        .admin-role {
            font-size: 0.75rem;
            color: var(--text-muted);
        }

        /* Content Area */
        .admin-body {
            padding: 30px;
            flex-grow: 1;
        }

        /* Footer */
        .admin-footer {
            background-color: #ffffff;
            border-top: 1px solid var(--card-border);
            padding: 16px 30px;
            font-size: 0.85rem;
            color: var(--text-muted);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Common Custom Cards & Badges */
        .card-custom {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--card-border);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            margin-bottom: 24px;
        }

        .card-custom-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--card-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .card-custom-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }

        .card-custom-body {
            padding: 24px;
        }

        /* Flash Message Alert */
        .alert-custom {
            border-radius: 12px;
            border: none;
            padding: 14px 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
        }
    </style>

    <sitemesh:write property='head'/>
</head>
<body>

    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
        <a href="${pageContext.request.contextPath}/admin" class="sidebar-brand">
            <div class="brand-icon">
                <i class="fa-solid fa-shapes"></i>
            </div>
            <span>DT Admin</span>
        </a>

        <ul class="sidebar-menu">
            <li class="sidebar-heading">TỔNG QUAN</li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${activeMenu == 'dashboard' ? 'active' : ''}">
                    <i class="fa-solid fa-chart-pie"></i>
                    <span>Bảng điều khiển</span>
                </a>
            </li>

            <li class="sidebar-heading">QUẢN LÝ HỆ THỐNG</li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link ${activeMenu == 'categories' ? 'active' : ''}">
                    <i class="fa-solid fa-layer-group"></i>
                    <span>Quản lý Danh mục</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link ${activeMenu == 'users' ? 'active' : ''}">
                    <i class="fa-solid fa-users-gear"></i>
                    <span>Quản lý Người dùng</span>
                </a>
            </li>

            <li class="sidebar-heading">HỆ THỐNG</li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <i class="fa-solid fa-database"></i>
                    <span>Database: BT05</span>
                </a>
            </li>
        </ul>

        <div class="sidebar-footer">
            <div><i class="fa-solid fa-code-branch me-2"></i>Spring Boot 3.3 &amp; JSP</div>
            <small class="text-secondary">© 2026 HCMUTE - BT05</small>
        </div>
    </aside>

    <!-- Main Content Wrapper -->
    <div class="admin-main">
        <!-- Top Header / Navbar -->
        <header class="admin-header">
            <div class="d-flex align-items-center gap-3">
                <h1 class="header-title">Hệ Thống Quản Trị DT Admin</h1>
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2.5 py-1">Role Admin</span>
            </div>

            <div class="header-actions">
                <div class="dropdown">
                    <div class="admin-info dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://ui-avatars.com/api/?name=Admin+Tai&background=4f46e5&color=fff&bold=true" alt="Admin" class="admin-avatar">
                        <div class="d-none d-md-block">
                            <div class="admin-name">Đỗ Thanh Tài</div>
                            <div class="admin-role">Administrator</div>
                        </div>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-line me-2 text-primary"></i>Dashboard</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-user-gear me-2 text-info"></i>Quản lý tài khoản</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/admin"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Dynamic Body Area injected by SiteMesh -->
        <main class="admin-body">
            <!-- Global Flash Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check fs-5 text-success"></i>
                    <div>${message}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-exclamation fs-5 text-danger"></i>
                    <div>${error}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- SITEMESH INJECTED CONTENT -->
            <sitemesh:write property='body'/>
        </main>

        <!-- Footer -->
        <footer class="admin-footer">
            <div>
                <strong>DT Admin Portal</strong> — Bài tập Lập trình Web BT05 (Spring Boot 3 + JSP + SiteMesh 3)
            </div>
            <div>
                Database: <span class="badge bg-success-subtle text-success border border-success-subtle">SQL Server BT05</span>
            </div>
        </footer>
    </div>

    <!-- Bootstrap 5.3.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Tự động ẩn thông báo sau 5 giây
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert-custom');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
