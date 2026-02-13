<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>HMS Admin | Customer List</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/customer.css"/>

        <style>
            .table-card .hms-table {
                table-layout: fixed;
                width: 100%;
            }

            .table-card .hms-table tbody td {
                vertical-align: middle !important;
                padding: 16px 12px;
            }

            .col-center {
                text-align: center !important;
            }
            .col-left {
                text-align: left !important;
            }

            .actions-wrapper {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
            }

            /* Khung icon vuông bo góc giống ảnh mẫu */
            .action-btn {
                width: 38px;
                height: 38px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 10px;
                border: 1px solid #e2e8f0;
                background-color: #ffffff;
                transition: all 0.2s ease;
                color: #64748b;
                text-decoration: none;
            }

            .action-btn:hover {
                background-color: #f8fafc;
                border-color: #cbd5e1;
                transform: translateY(-1px);
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            }

            .btn-view:hover {
                color: #4f46e5;
                background-color: #f5f3ff;
            }
            .btn-edit:hover {
                color: #0891b2;
                background-color: #ecfeff;
            }

            .badge {
                min-width: 85px;
                justify-content: center;
            }

            /* 1. Đổi màu chữ chung của các ô bảng sang màu xám đen nhẹ hơn (#212529) */
            .table-card .hms-table tbody td {
                color: #212529 !important; /* Màu của staff list [1] */
            }

            .cell-title {
                font-weight: 400 !important; /* Quan trọng: Đưa từ 800 về 400 (bình thường) */
                font-size: 14px !important;  /* Đảm bảo cỡ chữ bằng với cột Giới tính */
                color: #212529 !important;   /* Màu xám đen chuẩn của Staff List */
                margin-bottom: 2px !important;
            }

            /* 3. (Tùy chọn) Chỉnh màu chữ phụ (muted) cho giống hệt staff list */
            .muted, .cell-sub {
                color: #6c757d !important; /* Màu xám của staff list [5] */
            }

            .muted {
                font-weight: 400 !important; /* Chuyển từ 800 về bình thường */
                font-size: 14px !important;  /* Tăng từ 12px lên 14px cho bằng các cột khác */
                color: #6c757d !important;   /* Màu xám chuẩn của Staff List */
            }

            /* 1. Phá bỏ giới hạn chiều rộng, cho tràn màn hình */
            .admin-content {
                max-width: 100% !important;
                margin: 0 !important;
            }

            /* 2. Tạo khung trắng (Box) cho tiêu đề */
            .page-header-box {
                background: #fff;              /* Nền trắng */
                padding: 32px;                 /* Khoảng cách đệm giống Staff List */
                border-radius: 12px;           /* Bo góc */
                margin-bottom: 24px;           /* Cách bảng bên dưới */
                box-shadow: 0 2px 8px rgba(0,0,0,0.04); /* Đổ bóng nhẹ */

                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            /* 3. Chỉnh lại tiêu đề khi nằm trong khung */
            .page-title {
                margin: 0 !important;          /* Bỏ lề thừa */
                line-height: 1.1;
            }
        </style>
    </head>

    <body>
        <div class="admin-shell">
            <%@ include file="/view/admin_layout/sidebar.jsp" %>

            <main class="admin-main">
                <div class="admin-content">
                    <div class="page-header-box">
                        <div>
                            <h1 class="page-title">Customer List</h1>
                            <!-- Nếu muốn thêm dòng phụ đề nhỏ như Staff List thì thêm thẻ <p> vào đây -->
                        </div>
                    </div>

                    <form class="filter-card" method="get" action="${pageContext.request.contextPath}/admin/customers">
                        <div class="filter-grid">
                            <div class="field">
                                <label>Search</label>
                                <div class="search-wrap">
                                    <input type="text" name="q" placeholder="Name, Phone..." value="${fn:escapeXml(q)}"/>
                                </div>
                            </div>
                            <div class="field">
                                <label>Gender</label>
                                <select name="gender">
                                    <option value="all" ${gender == 'all' ? 'selected' : ''}>All Gender</option>
                                    <option value="1" ${gender == '1' ? 'selected' : ''}>Male</option>
                                    <option value="2" ${gender == '2' ? 'selected' : ''}>Female</option>
                                </select>
                            </div>
                            <div class="field">
                                <label>Status</label>
                                <select name="status">
                                    <option value="all" ${status == 'all' ? 'selected' : ''}>All Status</option>
                                    <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                    <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="filter-actions">
                            <button class="btn btn-primary" type="submit">Apply</button>
                            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/customers">Reset</a>
                        </div>
                    </form>

                    <div class="table-card">
                        <table class="hms-table">
                            <colgroup>
                                <col style="width: 60px">
                                <col style="width: 25%">
                                <col style="width: 20%">
                                <col style="width: 15%">
                                <col style="width: 10%">
                                <col style="width: 12%">
                                <col style="width: 130px">
                            </colgroup>

                            <thead>
                                <tr>
                                    <th class="col-center">No.</th>
                                    <th class="col-left">Full Name</th>
                                    <th class="col-left">Phone / Email</th>
                                    <th class="col-center">Date of Birth</th>
                                    <th class="col-center">Gender</th>
                                    <th class="col-center">Status</th>
                                    <th class="col-center">Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach items="${customers}" var="c" varStatus="loop">
                                    <tr>
                                        <td class="col-center muted">${(page - 1) * pageSize + loop.index + 1}</td>

                                        <td class="col-left">
                                            <div class="cell-title">${c.fullName}</div>
                                            <div class="cell-sub">${not empty c.residenceAddress ? c.residenceAddress : '—'}</div>
                                        </td>

                                        <td class="col-left">
                                            <div class="cell-title">${not empty c.phone ? c.phone : '—'}</div>
                                            <div class="cell-sub">
                                                <c:if test="${not empty c.email}">
                                                    <a class="link" href="mailto:${c.email}">${c.email}</a>
                                                </c:if>
                                            </div>
                                        </td>

                                        <td class="col-center muted">
                                            <fmt:formatDate value="${c.dateOfBirth}" pattern="yyyy-MM-dd"/>
                                        </td>

                                        <td class="col-center muted">
                                            ${c.gender == 1 ? 'Male' : (c.gender == 2 ? 'Female' : '—')}
                                        </td>

                                        <td class="col-center">
                                            <span class="badge ${c.accountStatus == 'ACTIVE' ? 'badge-green' : 'badge-red'}">
                                                ${c.accountStatus == 'ACTIVE' ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>

                                        <td class="col-center">
                                            <div class="actions-wrapper">
                                                <a class="action-btn btn-view" href="${pageContext.request.contextPath}/admin/customer-detail?id=${c.customerId}" title="View Details">
                                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                    <circle cx="12" cy="12" r="3"></circle>
                                                    </svg>
                                                </a>
                                                <a class="action-btn btn-edit" href="${pageContext.request.contextPath}/admin/customer-status?id=${c.customerId}" title="Change Status">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                    <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                    </svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div class="table-footer">
                            <div class="left">
                                Show 
                                <select name="size" onchange="window.location.href = '?size=' + this.value + '&q=${q}&gender=${gender}&status=${status}'">
                                    <option value="10" ${size == 10 ? 'selected' : ''}>10</option>
                                    <option value="25" ${size == 25 ? 'selected' : ''}>25</option>
                                </select>
                                entries
                            </div>
                            <div class="right pager">
                                <a class="btn btn-ghost ${page <= 1 ? 'disabled' : ''}" href="?page=${page-1}&size=${size}&q=${q}&gender=${gender}&status=${status}">Previous</a>
                                <span class="page-pill">${page}</span>
                                <a class="btn btn-ghost ${page >= totalPages ? 'disabled' : ''}" href="?page=${page+1}&size=${size}&q=${q}&gender=${gender}&status=${status}">Next</a>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="/view/admin_layout/footer.jsp" %>
            </main>
        </div>
    </body>
</html>