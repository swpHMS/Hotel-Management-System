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
            /* Enhanced Styles for Staff List Page */
            
            .hms-page {
                background: #f8f9fa;
                min-height: calc(100vh - 120px);
            }

            .hms-page__top {
                background: white;
                padding: 32px;
                border-radius: 12px;
                margin-bottom: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                gap: 24px;
            }

            .hms-breadcrumb {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: #6c757d;
                margin-bottom: 12px;
            }

            .hms-breadcrumb .sep {
                color: #dee2e6;
                font-weight: 300;
            }

            .hms-breadcrumb .current {
                color: #495057;
                font-weight: 500;
            }

            .hms-title {
                font-size: 28px;
                font-weight: 700;
                color: #212529;
                margin: 0 0 8px 0;
            }

            .hms-subtitle {
                font-size: 15px;
                color: #6c757d;
                margin: 0;
            }

            /* Alert Styles */
            .alert {
                padding: 16px 20px;
                border-radius: 8px;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .alert-danger {
                background: #fff5f5;
                border: 1px solid #feb2b2;
                color: #c53030;
            }

            /* Enhanced Filter Section */
            .hms-filter {
                background: white;
                padding: 24px;
                border-radius: 12px;
                margin-bottom: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
                display: flex;
                gap: 16px;
                align-items: flex-end;
                flex-wrap: wrap;
            }

            .hms-filter .field {
                display: flex;
                flex-direction: column;
                gap: 8px;
                min-width: 180px;
            }

            .hms-filter label {
                font-size: 14px;
                font-weight: 600;
                color: #495057;
            }

            .hms-filter select,
            .hms-filter input[type="text"] {
                padding: 10px 14px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.2s;
                background: white;
            }

            .hms-filter select:focus,
            .hms-filter input[type="text"]:focus {
                outline: none;
                border-color: #4f46e5;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

            /* Button Styles */
            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                border: none;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
                color: white;
                box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(79, 70, 229, 0.4);
            }

            .btn-light {
                background: #f8f9fa;
                color: #495057;
                border: 1px solid #dee2e6;
            }

            .btn-light:hover {
                background: #e9ecef;
                border-color: #adb5bd;
            }

            /* Enhanced Table */
            .hms-table-wrap {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
                margin-bottom: 24px;
            }

            .hms-table {
                width: 100%;
                border-collapse: collapse;
            }

            .hms-table thead {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            }

            .hms-table th {
                padding: 16px 20px;
                text-align: left;
                font-size: 13px;
                font-weight: 700;
                color: #495057;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 2px solid #dee2e6;
            }

            .hms-table td {
                padding: 16px 20px;
                font-size: 14px;
                color: #212529;
                border-bottom: 1px solid #f1f3f5;
            }

            .hms-table tbody tr {
                transition: background 0.2s;
            }

            .hms-table tbody tr:hover {
                background: #f8f9fa;
            }

            .cell-title {
                font-weight: 600;
                color: #212529;
            }

            .muted {
                color: #6c757d;
            }

            /* Pill Status Badges */
            .pill {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: inline-block;
            }

            .pill.green {
                background: #d1fae5;
                color: #065f46;
            }

            .pill.gray {
                background: #e5e7eb;
                color: #4b5563;
            }

            /* Links */
            .hms-link {
                color: #4f46e5;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                margin-left: 16px;
                transition: color 0.2s;
            }

            .hms-link:first-child {
                margin-left: 0;
            }

            .hms-link:hover {
                color: #6366f1;
                text-decoration: underline;
            }

            /* Enhanced Pagination */
            .hms-pagination {
                background: white;
                padding: 20px 24px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 16px;
            }

            .hms-pagination__info {
                font-size: 14px;
                color: #6c757d;
            }

            .hms-pagination__info b {
                color: #212529;
                font-weight: 600;
            }

            .hms-pagination__controls {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            .pg-btn {
                padding: 8px 14px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                color: #495057;
                background: white;
                border: 1px solid #dee2e6;
                transition: all 0.2s;
                min-width: 40px;
                text-align: center;
            }

            .pg-btn:hover:not(.disabled):not(.active) {
                background: #f8f9fa;
                border-color: #adb5bd;
                color: #212529;
            }

            .pg-btn.active {
                background: #4f46e5;
                color: white;
                border-color: #4f46e5;
            }

            .pg-btn.disabled {
                opacity: 0.5;
                cursor: not-allowed;
                color: #adb5bd;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .hms-page__top {
                    flex-direction: column;
                }

                .hms-filter {
                    flex-direction: column;
                    align-items: stretch;
                }

                .hms-filter .field {
                    width: 100%;
                }

                .hms-table-wrap {
                    overflow-x: auto;
                }

                .hms-pagination {
                    flex-direction: column;
                    text-align: center;
                }
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
                            <p class="hms-subtitle">View and filter staff accounts by role and status.</p>
                        </div>

                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/staff/create">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M8 3V13M3 8H13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                            Create Staff
                        </a>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                            </svg>
                            ${error}
                        </div>
                    </c:if>

                    <!-- Filters -->
                    
                    <form class="hms-filter" method="get" action="${pageContext.request.contextPath}/admin/staff">
                        <div class="field" style="flex:1; min-width:240px;">
                            <label>Search</label>
                            <input type="text" name="keyword" placeholder="Search by name " value="${keyword}" />
                        </div>
                        <div class="field">
                            <label>Role</label>
                            <select name="roleId">
                                <option value="all" ${selectedRoleId=='all'?'selected':''}>All Roles</option>
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.roleId}" ${selectedRoleId==r.roleId.toString()?'selected':''}>
                                        ${r.roleName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="field">
                            <label>Status</label>
                            <select name="status">
                                <option value="all" ${selectedStatus=='all'?'selected':''}>All Status</option>
                                <option value="1" ${selectedStatus=='1'?'selected':''}>Active</option>
                                <option value="0" ${selectedStatus=='0'?'selected':''}>Inactive</option>
                            </select>
                        </div>

                        <button class="btn btn-light" type="submit">Apply Filters</button>
                    </form>

                    <!-- Table -->
                    <div class="hms-table-wrap">
                        <table class="hms-table">
                            <thead>
                                <tr>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th style="text-align:right">Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td class="cell-title">
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
                                                    <span class="pill green">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="pill gray">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:right">
                                            <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff/detail?id=${u.userId}">View</a>
                                            <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff/edit?id=${u.userId}">Edit</a>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty users}">
                                    <tr>
                                        <td colspan="5" class="muted" style="text-align:center; padding:48px 24px;">
                                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" style="margin:0 auto 16px; opacity:0.3;">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                            </svg>
                                            <div style="font-size:16px; color:#495057; font-weight:500;">No users found</div>
                                            <div style="font-size:14px; margin-top:8px;">Try adjusting your filters or search criteria</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:set var="ctx" value="${pageContext.request.contextPath}" />

                    <div class="hms-pagination">
                        <div class="hms-pagination__info">
                            Showing page <b>${page}</b> of <b>${totalPages}</b> — Total: <b>${totalUsers}</b> users
                        </div>

                        <div class="hms-pagination__controls">
                            <c:choose>
                                <c:when test="${page <= 1}">
                                    <span class="pg-btn disabled">Previous</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="pg-btn"
                                       href="${ctx}/admin/staff?page=${page-1}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                                        Previous
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:choose>
                                    <c:when test="${p == page}">
                                        <span class="pg-btn active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="pg-btn"
                                           href="${ctx}/admin/staff?page=${p}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                                            ${p}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${page >= totalPages}">
                                    <span class="pg-btn disabled">Next</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="pg-btn"
                                       href="${ctx}/admin/staff?page=${page+1}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                                        Next
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </main>

                <%@ include file="/view/admin_layout/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
