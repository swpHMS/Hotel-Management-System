<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Guest List | LuxStay HMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

        <style>
            :root{
                --bg:#f5f0e8;
                --bg2:#ede7da;
                --paper:#faf7f2;
                --border:#e0d8cc;
                --border2:#cfc6b8;
                --ink:#2c2416;
                --ink-mid:#5a4e3c;
                --ink-soft:#9c8e7a;

                --gold:#b5832a;
                --gold-lt:#f0ddb8;
                --gold-bg:rgba(181,131,42,.09);

                --blue:#3b5ccc;
                --blue-lt:#dfe7ff;
                --blue-bg:rgba(59,92,204,.10);

                --sage:#5a7a5c;
                --sage-lt:#d4e6d4;

                --gray:#64748b;
                --gray-bg:#e2e8f0;
                --gray-br:#cbd5e1;
            }

            *{
                box-sizing:border-box;
            }

            body{
                font-family:'DM Sans', sans-serif;
                background: var(--bg);
                color: var(--ink);
            }

            .hms-main{
                margin-left: 260px;
                width: calc(100% - 260px);
                padding: 30px;
                min-height: 100vh;
                background: var(--bg);
            }

            .dashboard-title{
                font-family:'Fraunces', serif;
                font-weight: 800;
                letter-spacing: -1px;
                color: var(--ink);
                margin: 0;
            }

            .dashboard-date{
                color: var(--ink-soft);
                font-weight: 700;
                letter-spacing: .08em;
                text-transform: uppercase;
                margin: 8px 0 0;
            }

            .filter-card{
                background: var(--paper);
                border: 1px solid var(--border);
                border-radius: 20px;
                padding: 20px 22px;
                margin-bottom: 18px;
                box-shadow: 0 2px 12px rgba(44,36,22,.05);
            }

            .filter-grid{
                display:grid;
                grid-template-columns: 2.2fr 1fr 1fr 1fr;
                gap:16px;
                align-items:end;
            }

            .f-field{
                display:flex;
                flex-direction:column;
            }

            .f-field label{
                display:block;
                font-size:10.5px;
                font-weight:800;
                letter-spacing:.16em;
                text-transform:uppercase;
                color: var(--ink-soft);
                margin-bottom:8px;
            }

            .search-wrap{
                position:relative;
            }

            .search-wrap i{
                position:absolute;
                left:14px;
                top:50%;
                transform: translateY(-50%);
                color: var(--ink-soft);
                font-size:14px;
            }

            .f-input, .f-select{
                width:100%;
                height:46px;
                padding:0 14px;
                border:1.5px solid var(--border2);
                border-radius:14px;
                background:#f3efe8;
                font-family:'DM Sans', sans-serif;
                font-size:14px;
                color: var(--ink);
                outline:none;
                box-shadow:none;
            }

            .f-input{
                padding-left:40px;
            }

            .f-input:focus,
            .f-select:focus{
                border-color: var(--gold);
                box-shadow:0 0 0 3px rgba(181,131,42,.10);
                background:#f7f4ee;
            }

            .filter-actions{
                display:flex;
                justify-content:flex-end;
                gap:10px;
                margin-top:16px;
            }

            .btn-filter{
                height:42px;
                padding:0 18px;
                border-radius:12px;
                border:1.5px solid var(--border2);
                background:#f1ece4;
                color: var(--ink-mid);
                font-weight:700;
                font-size:14px;
                text-decoration:none;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                transition:all .15s ease;
            }

            .btn-filter:hover{
                background:#ebe4da;
                color: var(--ink);
            }

            .btn-apply{
                border:none;
                background:#3a2a15;
                color:#fff;
                font-weight:800;
                padding:0 22px;
            }

            .btn-apply:hover{
                background:#2e2111;
                transform:translateY(-1px);
                color:#fff;
            }

            .alert-error{
                background:#fff1f2;
                border:1px solid #fecdd3;
                color:#be123c;
                border-radius:14px;
                padding:12px 14px;
                margin-bottom:16px;
                font-weight:700;
            }

            .table-card{
                background: var(--paper);
                border: 1px solid var(--border);
                border-radius: 20px;
                overflow:hidden;
                box-shadow: 0 2px 16px rgba(44,36,22,.06);
            }

            .hms-table{
                width: 100%;
                border-collapse: collapse;
                table-layout: fixed;
            }

            .hms-table th,
            .hms-table td{
                text-align: center;
                vertical-align: middle;
            }

            .hms-table .text-left{
                text-align:left !important;
            }

            .hms-table thead{
                background: var(--bg2);
                border-bottom: 1.5px solid var(--border);
            }

            .hms-table th{
                padding: 14px 18px;
                font-size: 10.5px;
                font-weight: 900;
                letter-spacing: .14em;
                text-transform: uppercase;
                color: var(--ink-soft);
                white-space: nowrap;
            }

            .hms-table tbody tr{
                border-bottom: 1px solid var(--border);
                transition: background .15s;
            }

            .hms-table tbody tr:hover{
                background:#f0ebe0;
            }

            .hms-table tbody tr:last-child{
                border-bottom:none;
            }

            .hms-table td{
                padding: 16px 18px;
                font-size: 13.5px;
                color: var(--ink);
                overflow:hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .cell-name{
                font-weight: 800;
                color: var(--ink);
            }

            .cell-id{
                color: var(--ink-mid);
                font-weight: 900;
                font-variant-numeric: tabular-nums;
            }

            .cell-muted{
                color: var(--ink-soft);
                font-weight: 800;
            }

            .status-pill{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                padding:6px 12px;
                border-radius:999px;
                font-size:12px;
                font-weight:900;
                letter-spacing:.04em;
            }

            .status-inhouse{
                background:#dcfce7;
                color:#15803d;
                border:1px solid #86efac;
            }

            .status-ended{
                background:#e2e8f0;
                color:#475569;
                border:1px solid #cbd5e1;
            }

            .empty-state{
                padding: 48px 20px;
                text-align:center;
                color: var(--ink-soft);
            }

            .table-footer{
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:16px 22px;
                border-top: 1px solid var(--border);
                background: var(--bg2);
                gap:12px;
                flex-wrap:wrap;
            }

            .footer-left{
                display:flex;
                align-items:center;
                gap:9px;
                font-size:13px;
                font-weight:600;
                color: var(--ink-mid);
            }

            .footer-left select{
                height:34px;
                padding:0 10px;
                border:1.5px solid var(--border);
                border-radius:9px;
                background: var(--paper);
                font-size:13px;
                color: var(--ink);
                font-family:'DM Sans', sans-serif;
                outline:none;
            }

            .pager{
                display:flex;
                align-items:center;
                gap:8px;
            }

            .btn-ghost{
                height:34px;
                padding:0 14px;
                border-radius:9px;
                border:1.5px solid var(--border);
                background: var(--paper);
                color: var(--ink-mid);
                font-weight:800;
                font-size:13px;
                text-decoration:none;
                display:inline-flex;
                align-items:center;
                transition: background .15s, border-color .15s, color .15s;
            }

            .btn-ghost:hover{
                background: var(--gold-lt);
                border-color:#d4a854;
                color: var(--gold);
            }

            .btn-ghost.disabled{
                opacity:.4;
                pointer-events:none;
            }

            .page-pill{
                width:34px;
                height:34px;
                border-radius:9px;
                background: var(--ink);
                color:#fff;
                font-weight:900;
                font-size:13px;
                display:inline-flex;
                align-items:center;
                justify-content:center;
            }

            @media (max-width: 1200px){
                .filter-grid{
                    grid-template-columns: 1fr 1fr;
                }
            }

            @media (max-width: 900px){
                .hms-main{
                    margin-left:0;
                    width:100%;
                }
            }

            @media (max-width: 768px){
                .filter-grid{
                    grid-template-columns: 1fr;
                }

                .filter-actions{
                    flex-direction:column;
                    align-items:stretch;
                }

                .btn-filter,
                .btn-apply{
                    width:100%;
                }
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <% request.setAttribute("active", "guest-list"); %>
            <jsp:include page="sidebar.jsp"/>

            <main class="hms-main">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="dashboard-title">Guest List</h1>
                        <p class="dashboard-date">SEARCH AND TRACK IN-HOUSE OR ENDED GUESTS</p>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert-error">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                    </div>
                </c:if>

                <form id="guestFilterForm" class="filter-card" method="get"
                      action="${pageContext.request.contextPath}/receptionist/guest-list">
                    <input type="hidden" name="index" value="1">
                    <input type="hidden" name="size" value="${currentSize}">

                    <div class="filter-grid">
                        <div class="f-field">
                            <label>Search</label>
                            <div class="search-wrap">
                                <i class="bi bi-search"></i>
                                <input class="f-input"
                                       type="text"
                                       name="txtSearch"
                                       placeholder="Search by guest name or identity number"
                                       value="${searchValue}">
                            </div>
                        </div>

                        <div class="f-field">
                            <label>Status</label>
                            <select class="f-select" name="filterStatus">
                                <option value="0" ${statusValue == '0' ? 'selected' : ''}>All Status</option>
                                <option value="2" ${statusValue == '2' ? 'selected' : ''}>In-house</option>
                                <option value="3" ${statusValue == '3' ? 'selected' : ''}>Ended</option>
                            </select>
                        </div>

                        <div class="f-field">
                            <label>Check-in Date</label>
                            <input class="f-select" type="date" id="checkInDate" name="checkInDate" value="${checkInDateValue}">
                        </div>

                        <div class="f-field">
                            <label>Check-out Date</label>
                            <input class="f-select" type="date" id="checkOutDate" name="checkOutDate" value="${checkOutDateValue}">
                        </div>
                    </div>

                    <div class="filter-actions">
                        <a class="btn-filter" href="${pageContext.request.contextPath}/receptionist/guest-list">Reset</a>
                        <button class="btn-filter btn-apply" type="submit">Apply Filter</button>
                    </div>
                </form>

                <div class="table-card">
                    <table class="hms-table">
                        <thead>
                            <tr>
                                <th class="text-left" style="width:24%">Full Name</th>
                                <th style="width:20%">Identity Number</th>
                                <th style="width:12%">Room No</th>
                                <th style="width:16%">Check-in Date</th>
                                <th style="width:16%">Check-out Date</th>
                                <th style="width:12%">Status</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${listGuests}" var="g">
                                <tr>
                                    <td class="cell-name text-left">${g.fullName}</td>
                                    <td class="cell-id">${g.identityNumber}</td>
                                    <td>${g.roomNo}</td>
                                    <td class="cell-muted">${g.checkInDate}</td>
                                    <td class="cell-muted">${g.checkOutDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${g.status == 2}">
                                                <span class="status-pill status-inhouse">In-house</span>
                                            </c:when>
                                            <c:when test="${g.status == 3}">
                                                <span class="status-pill status-ended">Ended</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pill status-ended">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listGuests}">
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state">
                                            <i class="bi bi-inbox fs-1 d-block mb-3 opacity-25"></i>
                                            No guest records found.
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="table-footer">
                        <form class="footer-left" method="get" action="${pageContext.request.contextPath}/receptionist/guest-list">
                            <span>Show</span>

                            <select name="size" onchange="this.form.submit()">
                                <option value="10" ${currentSize==10?'selected':''}>10</option>
                                <option value="20" ${currentSize==20?'selected':''}>20</option>
                                <option value="50" ${currentSize==50?'selected':''}>50</option>
                            </select>

                            <span>entries per page</span>

                            <input type="hidden" name="index" value="1"/>
                            <input type="hidden" name="txtSearch" value="${searchValue}"/>
                            <input type="hidden" name="filterStatus" value="${statusValue}"/>
                            <input type="hidden" name="checkInDate" value="${checkInDateValue}"/>
                            <input type="hidden" name="checkOutDate" value="${checkOutDateValue}"/>
                        </form>

                        <div class="pager">
                            <a class="btn-ghost ${tag <= 1 ? 'disabled' : ''}"
                               href="${pageContext.request.contextPath}/receptionist/guest-list?index=${tag - 1}&size=${currentSize}&txtSearch=${searchValue}&filterStatus=${statusValue}&checkInDate=${checkInDateValue}&checkOutDate=${checkOutDateValue}">
                                ← Prev
                            </a>

                            <span class="page-pill">${tag}</span>

                            <a class="btn-ghost ${tag >= endP ? 'disabled' : ''}"
                               href="${pageContext.request.contextPath}/receptionist/guest-list?index=${tag + 1}&size=${currentSize}&txtSearch=${searchValue}&filterStatus=${statusValue}&checkInDate=${checkInDateValue}&checkOutDate=${checkOutDateValue}">
                                Next →
                            </a>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            document.getElementById("guestFilterForm").addEventListener("submit", function (e) {
                const checkIn = document.getElementById("checkInDate").value;
                const checkOut = document.getElementById("checkOutDate").value;

                if (checkIn && checkOut) {
                    if (new Date(checkOut) <= new Date(checkIn)) {
                        e.preventDefault();
                        alert("Check-out date must be greater than check-in date.");
                    }
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>