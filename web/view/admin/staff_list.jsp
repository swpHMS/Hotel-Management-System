<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>HMS Admin - Staff List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

    <style>
        /* ===== Page shell ===== */
        .hms-page{
            background:#f8f9fa;
            min-height:calc(100vh - 120px);
        }

        .hms-page__top{
            background:#fff;
            padding:32px;
            border-radius:12px;
            margin-bottom:24px;
            box-shadow:0 2px 8px rgba(0,0,0,0.04);
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:24px;
        }

        .hms-title{
            font-size:28px;
            font-weight:700;
            color:#212529;
            margin:0 0 8px 0;
        }

        .hms-subtitle{
            font-size:15px;
            color:#6c757d;
            margin:0;
        }

        /* ===== Filter (giữ như bạn đang dùng) ===== */
        .hms-filter{
            background:#fff;
            padding:22px 24px;
            border-radius:16px;
            box-shadow:0 2px 10px rgba(15,23,42,.06);
            display:block !important;
            margin-bottom:24px;
        }

        .hms-filter .filter-row{
            display:grid !important;
            grid-template-columns:2fr 1fr 1fr;
            gap:22px;
            align-items:end;
        }

        .hms-filter label{
            font-size:12px;
            font-weight:700;
            letter-spacing:.12em;
            text-transform:uppercase;
            color:#8a94a6;
        }

        .hms-filter input[type="text"],
        .hms-filter select{
            height:48px;
            padding:10px 14px;
            border:1px solid #e6eaf2;
            border-radius:14px;
            background:#fff;
            font-size:15px;
        }

        .hms-filter .filter-actions{
            display:flex;
            justify-content:flex-end;
            gap:12px;
            margin-top:16px;
            width:100%;
        }

        .btn{
            padding:10px 20px;
            border-radius:8px;
            font-size:14px;
            font-weight:600;
            border:none;
            cursor:pointer;
            transition:all .2s;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:8px;
        }

        .btn-primary{
            background:linear-gradient(135deg,#4f46e5 0%,#6366f1 100%);
            color:#fff;
            box-shadow:0 4px 12px rgba(79,70,229,.3);
        }

        /* giữ màu khi hover/focus */
        .btn-primary,
        .btn-primary:hover,
        .btn-primary:focus,
        .btn-primary:active,
        .btn-primary:focus-visible{
            background:linear-gradient(135deg,#4f46e5 0%,#6366f1 100%) !important;
            color:#fff !important;
            transform:none !important;
            box-shadow:0 4px 12px rgba(79,70,229,.3) !important;
            filter:none !important;
            opacity:1 !important;
        }

        .btn-reset{
            background:#fff;
            border:1px solid #e6eaf2;
            color:#111827;
            font-weight:600;
        }
        .btn-reset:hover{
            background:#f8fafc;
            border-color:#d7ddea;
        }

        @media (max-width: 900px){
            .hms-filter .filter-row{ grid-template-columns:1fr; }
            .hms-filter .filter-actions{ justify-content:stretch; }
            .hms-filter .filter-actions .btn,
            .hms-filter .filter-actions a.btn{
                width:100%;
                justify-content:center;
            }
        }

        /* ===== TABLE CARD ===== */
        .table-card{
            background:#fff;
            border-radius:16px;
            box-shadow:0 2px 8px rgba(0,0,0,0.04);
            overflow:hidden;
        }

        .table-card .hms-table{
            width:100%;
            border-collapse:collapse;
            table-layout:fixed;
        }

        .table-card .hms-table thead{
            background:linear-gradient(135deg,#f8f9fa 0%,#e9ecef 100%);
        }

        .table-card .hms-table th{
            padding:16px 20px;
            text-align:left;
            font-size:13px;
            font-weight:700;
            color:#495057;
            text-transform:uppercase;
            letter-spacing:.5px;
            border-bottom:2px solid #dee2e6;
        }

        .table-card .hms-table tbody td{
            vertical-align:middle !important;
            padding:16px 20px;
            font-size:14px;
            color:#212529;
            border-bottom:1px solid #f1f3f5;
        }

        .table-card .hms-table tbody tr:hover{
            background:#f8f9fa;
        }

        .muted{ color:#6c757d; }

        /* pill status */
        .pill{
            padding:8px 16px;
            border-radius:999px;
            font-size:14px;
            font-weight:700;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-width:92px;
        }
        .pill.pill-active{ background:#E8FFF2; color:#0F8A4B; }
        .pill.pill-inactive{ background:#FFE9EA; color:#C81E1E; }

        /* Actions */
        .action-btns{
            display:flex;
            justify-content:flex-end;
            gap:8px;
        }

        .action-btn{
            width:38px;
            height:38px;
            display:flex;
            align-items:center;
            justify-content:center;
            border-radius:10px;
            border:1px solid #e2e8f0;
            background:#fff;
            transition:all .2s ease;
            color:#64748b;
            text-decoration:none;
        }
        .action-btn:hover{
            background:#f8fafc;
            border-color:#cbd5e1;
            transform:translateY(-1px);
            box-shadow:0 4px 6px -1px rgba(0,0,0,.05);
        }
        .action-btn.btn-view:hover{ color:#4f46e5; background:#f5f3ff; }
        .action-btn.btn-edit:hover{ color:#d97706; background:#fffbeb; }

        /* ===== FOOTER (đồng bộ font-size như table) ===== */
        .table-footer{
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding:16px 20px;
            border-top:1px solid #e6eaf2;
            background:#fff;

            font-size:14px;
            color:#374151;
        }

        .table-footer .left{
            display:flex;
            align-items:center;
            gap:8px;
            font-size:14px;
            font-weight:500;
            color:#374151;
        }

        .table-footer .left select{
            height:36px;
            padding:4px 10px;
            border:1px solid #dee2e6;
            border-radius:8px;
            background:#fff;
            font-size:14px;
            color:#111827;
        }

        .table-footer .right.pager{
            display:flex;
            align-items:center;
            gap:10px;
        }

        .table-footer .btn.btn-ghost{
            height:36px;
            padding:0 14px;
            border-radius:10px;
            border:1px solid #dee2e6;
            background:#fff;
            color:#111827;
            font-weight:600;
            font-size:14px;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            justify-content:center;
        }

        .table-footer .btn.btn-ghost:hover{
            background:#f8fafc;
            border-color:#d7ddea;
        }

        .table-footer .btn.btn-ghost.disabled{
            opacity:.5;
            pointer-events:none;
        }

        .page-pill{
            width:36px;
            height:36px;
            border-radius:10px;
            background:#2563eb;
            color:#fff;
            font-weight:700;
            font-size:14px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
        }

        @media(max-width:768px){
            .table-footer{
                flex-direction:column;
                gap:14px;
                align-items:flex-start;
            }
            .table-footer .right.pager{ align-self:flex-end; }
        }
        
        /* 1. Xử lý cột Staff ID (đang bị class .cell-title làm đậm) */
.cell-title {
    font-weight: 400 !important;   /* Bỏ in đậm 900, về chữ thường */
    color: #212529 !important;     /* Dùng màu chuẩn của cột Full Name */
    font-size: 14px !important;
}

/* 2. Xử lý cột No. và Email (đang bị class .muted làm xám mờ) */
.muted {
    font-weight: 400 !important;
    color: #212529 !important;     /* Đổi từ màu xám nhạt #6c757d sang màu chuẩn */
    font-size: 14px !important;
}

.hms-title {
    font-size: 40px !important;       /* Tăng từ 28px lên 40px */
    letter-spacing: -0.5px !important; /* Thêm độ dồn chữ (tracking) */
    color: #0f172a !important;        /* Đổi màu sang mã #0f172a (xanh đen đậm) */
    font-weight: 700 !important;      /* Giữ in đậm */
    margin-bottom: 22px !important;   /* Căn lề dưới rộng hơn chút cho thoáng */
}
        
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/view/admin_layout/sidebar.jsp" %>

    <div class="hms-main">
        <main class="hms-page">

            <div class="hms-page__top">
                <div>
                    <h1 class="hms-title">Staff List</h1>
                </div>

                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/staff/create">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M8 3V13M3 8H13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                    Create Staff Account
                </a>
            </div>

            <!-- Filters -->
            <form class="hms-filter" method="get" action="${pageContext.request.contextPath}/admin/staff">

                <div class="filter-row">
                    <div class="field search">
                        <label>Search</label>
                        <input type="text" name="keyword" placeholder="Enter name" value="${keyword}" />
                    </div>

                    <div class="field role">
                        <label>Role</label>
                        <select name="roleId">
                            <option value="all" ${selectedRoleId=='all'?'selected':''}>All Roles</option>
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" ${selectedRoleId==r.roleId.toString() ? 'selected' : ''}>
                                    ${r.roleName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="field status">
                        <label>Status</label>
                        <select name="status">
                            <option value="all" ${selectedStatus=='all'?'selected':''}>All Status</option>
                            <option value="1" ${selectedStatus=='1'?'selected':''}>Active</option>
                            <option value="0" ${selectedStatus=='0'?'selected':''}>Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="filter-actions">
                    <button class="btn btn-primary" type="submit">Apply</button>
                    <a class="btn btn-reset"
                       href="${pageContext.request.contextPath}/admin/staff?page=1&roleId=all&status=all&keyword=">
                        Reset
                    </a>
                </div>
            </form>

            <!-- TABLE CARD -->
            <div class="table-card">
                <table class="hms-table">
                    <thead>
                        <tr>
                            <th style="width:80px">No.</th>
                            <th style="width:120px">Staff ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th style="width:140px">Role</th>
                            <th style="width:140px">Status</th>
                            <th style="width:140px; text-align:right">Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="u" items="${users}" varStatus="loop">
                            <tr>
                                <td class="muted">${(page - 1) * pageSize + loop.index + 1}</td>

                                <td class="cell-title">
                                    <c:choose>
                                        <c:when test="${u.staffId==0}">—</c:when>
                                        <c:otherwise>${u.staffId}</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${empty u.fullName}">—</c:when>
                                        <c:otherwise>${u.fullName}</c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="muted">${u.email}</td>

                                <td>${u.roleName}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 1}">
                                            <span class="pill pill-active">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inactive">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td style="text-align:right">
                                    <div class="action-btns">
                                        <a class="action-btn btn-view"
                                           href="${pageContext.request.contextPath}/admin/staff/detail?id=${u.userId}"
                                           title="View Detail">
                                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                 stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                 stroke-linejoin="round">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                        </a>

                                        <a class="action-btn btn-edit"
                                           href="${pageContext.request.contextPath}/admin/staff/edit?id=${u.userId}"
                                           title="Edit Account">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                 stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                 stroke-linejoin="round">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                            </svg>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="7" class="muted" style="text-align:center; padding:48px 24px;">
                                    No users found
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <!-- FOOTER -->
                <c:set var="ctx" value="${pageContext.request.contextPath}" />

                <div class="table-footer">
                    <div class="left">
                        Show
                        <select name="size"
                                onchange="window.location.href='${ctx}/admin/staff?page=1&size='+this.value+'&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}'">
                            <option value="10" ${pageSize==10?'selected':''}>10</option>
                            <option value="20" ${pageSize==20?'selected':''}>20</option>
                            <option value="50" ${pageSize==50?'selected':''}>50</option>
                        </select>
                        entries
                    </div>

                    <div class="right pager">
                        <a class="btn btn-ghost ${page <= 1 ? 'disabled' : ''}"
                           href="${ctx}/admin/staff?page=${page-1}&size=${pageSize}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                            Previous
                        </a>

                        <span class="page-pill">${page}</span>

                        <a class="btn btn-ghost ${page >= totalPages ? 'disabled' : ''}"
                           href="${ctx}/admin/staff?page=${page+1}&size=${pageSize}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                            Next
                        </a>
                    </div>
                </div>
            </div>

        </main>
        <%@ include file="/view/admin_layout/footer.jsp" %>
    </div>
</div>
</body>
</html>
