<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>HMS Admin - Staff List</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:         #f5f0e8;
            --bg2:        #ede7da;
            --paper:      #faf7f2;
            --border:     #e0d8cc;
            --border2:    #cfc6b8;
            --ink:        #2c2416;
            --ink-mid:    #5a4e3c;
            --ink-soft:   #9c8e7a;
            --gold:       #b5832a;
            --gold-lt:    #f0ddb8;
            --gold-bg:    rgba(181,131,42,.09);
            --sage:       #5a7a5c;
            --sage-lt:    #d4e6d4;
            --terra:      #c0614a;
            --terra-lt:   #f5d8d2;
            --sidebar-w:  280px;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--ink);
        }

        /* Sidebar */
        .hms-sidebar, aside.hms-sidebar, aside {
            position: fixed !important;
            top: 0; left: 0;
            width: var(--sidebar-w) !important;
            height: 100vh !important;
            overflow-y: auto !important;
            z-index: 9999;
        }
        .app-shell { display: flex; }
        .hms-main  { flex: 1; margin-left: var(--sidebar-w); }

        .hms-page {
            padding: 40px 44px 64px;
            max-width: 1400px;
        }

        /* ── PAGE TOP ── */
        .page-top {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 32px;
            animation: fadeDown .4s ease both;
        }
        @keyframes fadeDown {
            from { opacity:0; transform:translateY(-10px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .page-eyebrow {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .2em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 7px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .page-eyebrow::before {
            content: '';
            display: block;
            width: 22px; height: 1.5px;
            background: var(--gold);
        }
        .hms-title {
            font-family: 'Fraunces', serif;
            font-size: 42px !important;
            font-weight: 800 !important;
            color: var(--ink) !important;
            letter-spacing: -1px !important;
            line-height: 1 !important;
            margin: 0 !important;
        }

        /* ── CREATE BUTTON ── */
        .btn-create {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 13px 22px;
            border-radius: 14px;
            background: var(--ink);
            color: #fff;
            font-family: 'DM Sans', sans-serif;
            font-weight: 700;
            font-size: 13.5px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 16px rgba(44,36,22,.2);
            transition: transform .18s ease, box-shadow .18s ease;
        }
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(44,36,22,.28);
            color: #fff;
        }

        /* ── FILTER CARD ── */
        .filter-card {
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 24px 28px;
            margin-bottom: 22px;
            box-shadow: 0 2px 12px rgba(44,36,22,.05);
            animation: slideUp .4s .05s ease both;
        }
        @keyframes slideUp {
            from { opacity:0; transform:translateY(16px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .filter-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 20px;
            align-items: end;
        }
        .field label {
            display: block;
            font-size: 10.5px;
            font-weight: 700;
            letter-spacing: .16em;
            text-transform: uppercase;
            color: var(--ink-soft);
            margin-bottom: 8px;
        }
        .field input[type="text"],
        .field select {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            background: var(--bg);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            color: var(--ink);
            outline: none;
            transition: border-color .18s, box-shadow .18s;
            appearance: none;
        }
        .field input[type="text"]:focus,
        .field select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            background: var(--paper);
        }
        .field input::placeholder { color: var(--ink-soft); }

        /* Search input wrapper with icon */
        .search-wrap { position: relative; }



        .filter-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }
        .btn-apply {
            padding: 11px 24px;
            border-radius: 12px;
            background: var(--ink);
            color: #fff;
            font-weight: 700;
            font-size: 13px;
            border: none;
            cursor: pointer;
            font-family: 'DM Sans', sans-serif;
            transition: opacity .18s;
        }
        .btn-apply:hover { opacity: .85; }
        .btn-reset {
            padding: 11px 22px;
            border-radius: 12px;
            background: transparent;
            color: var(--ink-mid);
            font-weight: 700;
            font-size: 13px;
            border: 1.5px solid var(--border);
            cursor: pointer;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: background .18s, border-color .18s;
        }
        .btn-reset:hover { background: var(--bg2); border-color: var(--border2); }

        /* ── TABLE CARD ── */
        .table-card {
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 2px 16px rgba(44,36,22,.06);
            animation: slideUp .4s .1s ease both;
        }

        .hms-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .hms-table thead {
            background: var(--bg2);
            border-bottom: 1.5px solid var(--border);
        }
        .hms-table th {
            padding: 14px 20px;
            text-align: left;
            font-size: 10.5px;
            font-weight: 800;
            letter-spacing: .14em;
            text-transform: uppercase;
            color: var(--ink-soft);
        }

        .hms-table tbody tr {
            border-bottom: 1px solid var(--border);
            transition: background .15s;
        }
        .hms-table tbody tr:last-child { border-bottom: none; }
        .hms-table tbody tr:hover { background: #f0ebe0; }

        .hms-table tbody td {
            padding: 16px 20px;
            font-size: 13.5px;
            color: var(--ink);
            vertical-align: middle !important;
        }

        .cell-no {
            font-size: 12px;
            color: var(--ink-soft);
            font-weight: 500;
        }
        .cell-id {
            font-size: 13px;
            color: var(--ink-mid);
            font-weight: 600;
            font-variant-numeric: tabular-nums;
        }
        .cell-name {
            font-weight: 600;
            color: var(--ink);
        }
        .cell-email {
            font-size: 13px;
            color: var(--ink-mid);
        }
        .cell-role {
            font-size: 12.5px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 8px;
            background: var(--gold-bg);
            color: var(--gold);
            display: inline-block;
        }

        /* Status pills */
        .pill {
            padding: 5px 14px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .pill::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
        }
        .pill-active  { background: var(--sage-lt);  color: var(--sage);  }
        .pill-active::before  { background: var(--sage); }
        .pill-inactive { background: var(--terra-lt); color: var(--terra); }
        .pill-inactive::before { background: var(--terra); }

        /* Action buttons */
        .action-btns {
            display: flex;
            justify-content: flex-end;
            gap: 7px;
        }
        .action-btn {
            width: 36px; height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            border: 1.5px solid var(--border);
            background: var(--paper);
            color: var(--ink-soft);
            text-decoration: none;
            transition: all .18s ease;
        }
        .action-btn:hover { transform: translateY(-1px); }
        .action-btn.btn-view:hover {
            color: var(--gold);
            background: var(--gold-lt);
            border-color: #d4a854;
        }
        .action-btn.btn-edit:hover {
            color: var(--sage);
            background: var(--sage-lt);
            border-color: #7aaa7c;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 60px 24px;
            color: var(--ink-soft);
        }
        .empty-state svg { margin-bottom: 14px; opacity: .4; }
        .empty-state p { font-size: 14px; font-weight: 500; }

        /* ── TABLE FOOTER ── */
        .table-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 22px;
            border-top: 1px solid var(--border);
            background: var(--bg2);
        }
        .footer-left {
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 13px;
            font-weight: 500;
            color: var(--ink-mid);
        }
        .footer-left select {
            height: 34px;
            padding: 0 10px;
            border: 1.5px solid var(--border);
            border-radius: 9px;
            background: var(--paper);
            font-size: 13px;
            color: var(--ink);
            font-family: 'DM Sans', sans-serif;
            outline: none;
        }
        .pager {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-ghost {
            height: 34px;
            padding: 0 14px;
            border-radius: 9px;
            border: 1.5px solid var(--border);
            background: var(--paper);
            color: var(--ink-mid);
            font-weight: 700;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            transition: background .15s, border-color .15s;
        }
        .btn-ghost:hover { background: var(--gold-lt); border-color: #d4a854; color: var(--gold); }
        .btn-ghost.disabled { opacity: .4; pointer-events: none; }
        .page-pill {
            width: 34px; height: 34px;
            border-radius: 9px;
            background: var(--ink);
            color: #fff;
            font-weight: 800;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 900px) {
            .filter-row { grid-template-columns: 1fr; }
            .hms-page { padding: 24px 20px 48px; }
        }
        @media (max-width: 768px) {
            .table-footer { flex-direction: column; gap: 12px; align-items: flex-start; }
            .pager { align-self: flex-end; }
        }
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/view/admin_layout/sidebar.jsp" %>

    <div class="hms-main">
        <main class="hms-page">

            <!-- Page Top -->
            <div class="page-top">
                <div>
                    <div class="page-eyebrow">Human Resources</div>
                    <h1 class="hms-title">Staff List</h1>
                </div>
                <a class="btn-create" href="${pageContext.request.contextPath}/admin/staff/create">
                    <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
                        <path d="M8 3V13M3 8H13" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/>
                    </svg>
                    Create Staff Account
                </a>
            </div>

            <!-- Filters -->
            <form class="filter-card" method="get" action="${pageContext.request.contextPath}/admin/staff">
                <div class="filter-row">
                    <div class="field search">
                        <label>Search</label>
                        <div class="search-wrap">
<input type="text" name="keyword" placeholder="Search by name " value="${keyword}"/>
                        </div>
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
                            <option value="1"   ${selectedStatus=='1'?'selected':''}>Active</option>
                            <option value="0"   ${selectedStatus=='0'?'selected':''}>Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="filter-actions">
                    <a class="btn-reset"
                       href="${pageContext.request.contextPath}/admin/staff?page=1&roleId=all&status=all&keyword=">
                        Reset
                    </a>
                    <button class="btn-apply" type="submit">Apply Filter</button>
                </div>
            </form>

            <!-- Table Card -->
            <div class="table-card">
                <table class="hms-table">
                    <thead>
                        <tr>
                            <th style="width:64px">No.</th>
                            <th style="width:110px">Staff ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th style="width:150px">Role</th>
                            <th style="width:130px">Status</th>
                            <th style="width:120px; text-align:right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}" varStatus="loop">
                            <tr>
                                <td class="cell-no">${(page - 1) * pageSize + loop.index + 1}</td>

                                <td class="cell-id">
                                    <c:choose>
                                        <c:when test="${u.staffId==0}">—</c:when>
                                        <c:otherwise>#${u.staffId}</c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="cell-name">
                                    <c:choose>
                                        <c:when test="${empty u.fullName}">—</c:when>
                                        <c:otherwise>${u.fullName}</c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="cell-email">${u.email}</td>

                                <td><span class="cell-role">${u.roleName}</span></td>

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
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                <circle cx="12" cy="12" r="3"/>
                                            </svg>
                                        </a>
                                        <a class="action-btn btn-edit"
                                           href="${pageContext.request.contextPath}/admin/staff/edit?id=${u.userId}"
                                           title="Edit Account">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                                <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                            </svg>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="1.5">
                                            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                                        </svg>
                                        <p>No staff members found matching your filters.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <!-- Footer -->
                <c:set var="ctx" value="${pageContext.request.contextPath}" />
                <div class="table-footer">
                    <div class="footer-left">
                        Show
                        <select onchange="window.location.href='${ctx}/admin/staff?page=1&size='+this.value+'&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}'">
                            <option value="10" ${pageSize==10?'selected':''}>10</option>
                            <option value="20" ${pageSize==20?'selected':''}>20</option>
                            <option value="50" ${pageSize==50?'selected':''}>50</option>
                        </select>
                        entries per page
                    </div>

                    <div class="pager">
                        <a class="btn-ghost ${page <= 1 ? 'disabled' : ''}"
                           href="${ctx}/admin/staff?page=${page-1}&size=${pageSize}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                            ← Prev
                        </a>
                        <span class="page-pill">${page}</span>
                        <a class="btn-ghost ${page >= totalPages ? 'disabled' : ''}"
                           href="${ctx}/admin/staff?page=${page+1}&size=${pageSize}&roleId=${selectedRoleId}&status=${selectedStatus}&keyword=${keyword}">
                            Next →
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
