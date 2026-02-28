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
        .hms-sidebar, aside.hms-sidebar, aside,
        .admin-shell .hms-sidebar {
            position: fixed !important;
            top: 0; left: 0;
            width: var(--sidebar-w) !important;
            height: 100vh !important;
            overflow-y: auto !important;
            z-index: 9999;
        }
        .admin-shell { display: flex; }
        .admin-main  { flex: 1; margin-left: var(--sidebar-w); }
        .admin-content {
            padding: 40px 44px 64px;
            max-width: 100% !important;
            margin: 0 !important;
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
        .page-title {
            font-family: 'Fraunces', serif !important;
            font-size: 42px !important;
            font-weight: 800 !important;
            color: var(--ink) !important;
            letter-spacing: -1px !important;
            line-height: 1 !important;
            margin: 0 !important;
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
        .filter-grid {
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
        .field input:focus,
        .field select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            background: var(--paper);
        }
        .field input::placeholder { color: var(--ink-soft); }

        .search-wrap { position: relative; }



        .filter-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }
        .btn {
            padding: 11px 22px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 13px;
            border: none;
            cursor: pointer;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all .18s ease;
        }
        .btn-primary {
            background: var(--ink);
            color: #fff;
            box-shadow: 0 4px 14px rgba(44,36,22,.2);
        }
        .btn-primary:hover { opacity: .85; color: #fff; }
        .btn-ghost {
            background: transparent;
            color: var(--ink-mid);
            border: 1.5px solid var(--border);
        }
        .btn-ghost:hover { background: var(--bg2); border-color: var(--border2); }
        .btn-ghost.disabled { opacity: .4; pointer-events: none; }

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
            padding: 14px 16px;
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
            padding: 15px 16px;
            font-size: 13.5px;
            color: var(--ink) !important;
            vertical-align: middle !important;
        }

        .col-center { text-align: center !important; }
        .col-left   { text-align: left !important; }

        /* Cell styles */
        .cell-no { font-size: 12px; color: var(--ink-soft) !important; font-weight: 500; }

        .cell-title {
            font-weight: 600 !important;
            font-size: 13.5px !important;
            color: var(--ink) !important;
            margin-bottom: 2px;
        }
        .cell-sub {
            font-size: 12px !important;
            color: var(--ink-soft) !important;
            font-weight: 400 !important;
            margin-top: 2px;
        }
        .cell-sub .link {
            color: var(--gold);
            text-decoration: none;
        }
        .cell-sub .link:hover { text-decoration: underline; }

        .cell-muted {
            font-size: 13px;
            color: var(--ink-mid) !important;
            font-weight: 400;
        }

        /* Gender tag */
        .gender-tag {
            font-size: 11.5px;
            font-weight: 700;
            padding: 3px 11px;
            border-radius: 8px;
            background: var(--gold-bg);
            color: var(--gold);
            display: inline-block;
        }
        .gender-tag.female {
            background: rgba(192,97,74,.08);
            color: var(--terra);
        }

        /* Status badges */
        .badge {
            padding: 5px 14px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            min-width: 0;
        }
        .badge::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .badge-green { background: var(--sage-lt);  color: var(--sage);  }
        .badge-green::before { background: var(--sage); }
        .badge-red   { background: var(--terra-lt); color: var(--terra); }
        .badge-red::before   { background: var(--terra); }

        /* Action buttons */
        .actions-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
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
        .btn-view:hover {
            color: var(--gold);
            background: var(--gold-lt);
            border-color: #d4a854;
        }
        .btn-edit:hover {
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
        .empty-state p { font-size: 14px; font-weight: 500; margin-top: 12px; }

        /* ── TABLE FOOTER ── */
        .table-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 22px;
            border-top: 1px solid var(--border);
            background: var(--bg2);
        }
        .table-footer .left {
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 13px;
            font-weight: 500;
            color: var(--ink-mid);
        }
        .table-footer .left select {
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
        .table-footer .btn-ghost {
            height: 34px;
            padding: 0 14px;
            border-radius: 9px;
            font-size: 13px;
        }
        .table-footer .btn-ghost:hover {
            background: var(--gold-lt);
            border-color: #d4a854;
            color: var(--gold);
        }
        .page-pill {
            width: 34px; height: 34px;
            border-radius: 9px;
            background: var(--ink);
            color: #fff;
            font-weight: 800;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 900px) {
            .filter-grid { grid-template-columns: 1fr; }
            .admin-content { padding: 24px 20px 48px; }
        }
        @media (max-width: 768px) {
            .table-footer { flex-direction: column; gap: 12px; align-items: flex-start; }
            .pager { align-self: flex-end; }
        }
    </style>
</head>

<body>
<div class="admin-shell">
    <%@ include file="/view/admin_layout/sidebar.jsp" %>

    <main class="admin-main">
        <div class="admin-content">

            <!-- Page Top -->
            <div class="page-top">
                <div>
                    <div class="page-eyebrow">Guest Management</div>
                    <h1 class="page-title">Customer List</h1>
                </div>
            </div>

            <!-- Filter -->
            <form class="filter-card" method="get" action="${pageContext.request.contextPath}/admin/customers">
                <div class="filter-grid">
                    <div class="field">
                        <label>Search</label>
                        <div class="search-wrap">
                            <input type="text" name="q" placeholder="Search by name or phone…" value="${fn:escapeXml(q)}"/>
                        </div>
                    </div>
                    <div class="field">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="all"  ${gender == 'all' ? 'selected' : ''}>All Gender</option>
                            <option value="1"    ${gender == '1'   ? 'selected' : ''}>Male</option>
                            <option value="2"    ${gender == '2'   ? 'selected' : ''}>Female</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Status</label>
                        <select name="status">
                            <option value="all"      ${status == 'all'      ? 'selected' : ''}>All Status</option>
                            <option value="ACTIVE"   ${status == 'ACTIVE'   ? 'selected' : ''}>Active</option>
                            <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="filter-actions">
                    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/customers">Reset</a>
                    <button class="btn btn-primary" type="submit">Apply Filter</button>
                </div>
            </form>

            <!-- Table -->
            <div class="table-card">
                <table class="hms-table">
                    <colgroup>
                        <col style="width:56px">
                        <col style="width:22%">
                        <col style="width:21%">
                        <col style="width:13%">
                        <col style="width:10%">
                        <col style="width:12%">
                        <col style="width:110px">
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
                                <td class="col-center cell-no">${(page - 1) * pageSize + loop.index + 1}</td>

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

                                <td class="col-center cell-muted">
                                    <fmt:formatDate value="${c.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                </td>

                                <td class="col-center">
                                    <c:choose>
                                        <c:when test="${c.gender == 1}">
                                            <span class="gender-tag">Male</span>
                                        </c:when>
                                        <c:when test="${c.gender == 2}">
                                            <span class="gender-tag female">Female</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="cell-muted">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="col-center">
                                    <span class="badge ${c.accountStatus == 'ACTIVE' ? 'badge-green' : 'badge-red'}">
                                        ${c.accountStatus == 'ACTIVE' ? 'Active' : 'Inactive'}
                                    </span>
                                </td>

                                <td class="col-center">
                                    <div class="actions-wrapper">
                                        <a class="action-btn btn-view"
                                           href="${pageContext.request.contextPath}/admin/customer-detail?id=${c.customerId}"
                                           title="View Details">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                <circle cx="12" cy="12" r="3"/>
                                            </svg>
                                        </a>
                                        <a class="action-btn btn-edit"
                                           href="${pageContext.request.contextPath}/admin/customer-status?id=${c.customerId}"
                                           title="Change Status">
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

                        <c:if test="${empty customers}">
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="1.5" color="#9c8e7a">
                                            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                                        </svg>
                                        <p>No customers found matching your filters.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <div class="table-footer">
                    <div class="left">
                        Show
                        <select onchange="window.location.href='?size='+this.value+'&q=${q}&gender=${gender}&status=${status}'">
                            <option value="10" ${size == 10 ? 'selected' : ''}>10</option>
                            <option value="25" ${size == 25 ? 'selected' : ''}>25</option>
                        </select>
                        entries per page
                    </div>
                    <div class="pager">
                        <a class="btn btn-ghost ${page <= 1 ? 'disabled' : ''}"
                           href="?page=${page-1}&size=${size}&q=${q}&gender=${gender}&status=${status}">← Prev</a>
                        <span class="page-pill">${page}</span>
                        <a class="btn btn-ghost ${page >= totalPages ? 'disabled' : ''}"
                           href="?page=${page+1}&size=${size}&q=${q}&gender=${gender}&status=${status}">Next →</a>
                    </div>
                </div>
            </div>

        </div>
        <%@ include file="/view/admin_layout/footer.jsp" %>
    </main>
</div>
</body>
</html>
