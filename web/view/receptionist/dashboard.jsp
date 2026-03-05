<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Dashboard | LuxStay HMS</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

        <!-- CSS project -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist/dashboard-styles.css"/>

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
                --terra:#c0614a;
                --terra-lt:#f5d8d2;
                --sage:#5a7a5c;
                --sage-lt:#d4e6d4;

                --checkin:#16a34a;
                --checkin-bg:#dcfce7;
                --checkin-br:#86efac;

                --checkout:#dc2626;
                --checkout-bg:#fee2e2;
                --checkout-br:#fca5a5;
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

            /* =========================
               STATS (FIX OVERLAP)
            ========================= */
            .stats-grid{
                display: grid;
                grid-template-columns: repeat(5, minmax(0, 1fr));
                gap: 18px;
                align-items: stretch;
            }

            .stat-card{
                background: var(--paper);
                border: 1px solid var(--border);
                border-radius: 22px;
                padding: 22px 24px;
                box-shadow: 0 4px 24px rgba(44,36,22,.07);
                position: relative;
                overflow: hidden;
                transition: transform .2s ease, box-shadow .2s ease;
                display:flex;
                align-items:center;
                gap: 14px;
                min-height: 92px;
                top: 10px; /* ✅ Chỉnh Badge nằm cao hơn một chút */
                right: 10px;
            }

            .btn-action {
                width: 135px; /* Độ dài cố định */
                height: 38px;
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center; /* Căn giữa nội dung */
                gap: 8px;
                font-weight: 900;
                font-size: 12px;
                text-transform: uppercase;
                text-decoration: none !important; /* ✅ Xóa gạch chân xanh lam */
                transition: all .18s ease;
                border: 1.5px solid transparent;
            }

            .btn-checkin {
                border-color: var(--checkin-br);
                background: var(--checkin-bg);
                color: var(--checkin) !important;
            }
            .btn-checkout {
                border-color: var(--checkout-br);
                background: var(--checkout-bg);
                color: var(--checkout) !important;
            }

            .stat-card:hover{
                transform: translateY(-3px);
                box-shadow: 0 14px 40px rgba(44,36,22,.10);
            }

            /* blob */
            .stat-card::after{
                content:'';
                position:absolute;
                right:-40px;
                bottom:-48px;
                width:140px;
                height:140px;
                border-radius:50%;
                background: var(--card-blob, rgba(181,131,42,.07));
                pointer-events:none;
            }
            .stat-card.sage-card  {
                --card-blob: rgba(90,122,92,.09);
            }
            .stat-card.terra-card {
                --card-blob: rgba(192,97,74,.08);
            }

            /* tag badge (góc phải) */
            .stat-card::before{
                content: attr(data-tag);
                position:absolute;
                top: 14px;
                right: 14px;
                font-size: 11px;
                font-weight: 800;
                letter-spacing: .12em;
                text-transform: uppercase;
                padding: 4px 12px;
                border-radius: 999px;
                background: var(--gold-bg);
                color: var(--gold);
                line-height: 1.1;
                z-index: 2;
            }
            .stat-card.sage-card::before{
                background: rgba(90,122,92,.10);
                color: var(--sage);
            }
            .stat-card.terra-card::before{
                background: rgba(192,97,74,.10);
                color: var(--terra);
            }

            .stat-icon-wrapper{
                width: 44px;
                height: 44px;
                border-radius: 14px;
                border: 1px solid var(--border);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size: 18px;
                flex-shrink: 0;
                z-index: 1;
            }

            .bg-blue-soft, .bg-indigo-soft{
                background: var(--gold-lt);
                color: var(--gold);
            }
            .bg-red-soft{
                background: var(--terra-lt);
                color: var(--terra);
            }
            .bg-checkin-icon{
                background: var(--sage-lt);
                color: var(--sage);
            }
            .bg-checkout-icon{
                background: #ffedd5;
                color: #9a3412;
            }

            .stat-data{
                display: flex;
                flex-direction: column;
                z-index: 1;
                min-width: 0;
                margin-top: 12px; /* ✅ Đẩy nội dung xuống để tránh bị Badge đè */
            }
            .stat-label{
                display:block;
                font-size: 11px;
                font-weight: 800;
                letter-spacing: .16em;
                text-transform: uppercase;
                color: var(--ink-soft);
                margin-bottom: 6px;
                line-height: 1.2;
                padding-right: 86px; /* chừa chỗ cho badge góc phải */
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .stat-value{
                font-family:'Fraunces', serif;
                font-size: 40px;
                font-weight: 800;
                color: var(--ink);
                line-height: 1;
                letter-spacing: -1.5px;
                margin: 0;
            }

            @media (max-width: 1200px){
                .stats-grid{
                    grid-template-columns: repeat(3, minmax(0, 1fr));
                }
            }
            @media (max-width: 820px){
                .hms-main{
                    margin-left: 0;
                    width: 100%;
                }
                .stats-grid{
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                }
            }
            @media (max-width: 520px){
                .stats-grid{
                    grid-template-columns: 1fr;
                }
            }

            /* =========================
               FILTER
            ========================= */
            /* ===== FILTER ACTIONS (Reset / Apply) ===== */
            /* =========================
               FILTER - FORCE STYLE (FIX UI FALLBACK)
            ========================= */
            .filter-card{
                background: var(--paper) !important;
                border: 1px solid var(--border) !important;
                border-radius: 20px !important;
                padding: 20px 22px !important;
                margin-bottom: 18px !important;
                box-shadow: 0 2px 12px rgba(44,36,22,.05) !important;
            }

            .filter-card .filter-row{
                display:grid !important;
                grid-template-columns: 2fr 1fr 1fr auto !important;
                gap: 16px !important;
                align-items:end !important;
            }

            .filter-card .f-field label{
                display:block !important;
                font-size: 10.5px !important;
                font-weight: 800 !important;
                letter-spacing: .16em !important;
                text-transform: uppercase !important;
                color: var(--ink-soft) !important;
                margin-bottom: 8px !important;
            }

            .filter-card .search-wrap{
                position:relative !important;
            }
            .filter-card .search-wrap i{
                position:absolute !important;
                left: 14px !important;
                top: 50% !important;
                transform: translateY(-50%) !important;
                color: var(--ink-soft) !important;
                font-size: 14px !important;
                pointer-events:none !important;
            }

            /* input/select đẹp lại */
            .filter-card .f-input,
            .filter-card .f-select{
                width: 100% !important;
                height: 46px !important;
                padding: 0 14px !important;
                border: 1.5px solid var(--border) !important;
                border-radius: 12px !important;
                background: var(--bg) !important;
                font-family: 'DM Sans', sans-serif !important;
                font-size: 14px !important;
                color: var(--ink) !important;
                outline:none !important;
                box-shadow: none !important;
                appearance:none !important;
            }

            .filter-card .f-input{
                padding-left: 40px !important;
            }

            .filter-card .f-input:focus,
            .filter-card .f-select:focus{
                border-color: var(--gold) !important;
                box-shadow: 0 0 0 3px rgba(181,131,42,.12) !important;
                background: var(--paper) !important;
            }

            /* Buttons */
            .filter-card .filter-actions{
                display:flex !important;
                justify-content:flex-end !important;
                gap: 12px !important;
                margin-top: 14px !important;
            }

            .filter-card .btn-filter{
                height: 42px !important;
                padding: 0 18px !important;
                border-radius: 12px !important;
                border: 1.5px solid var(--border) !important;
                background: var(--paper) !important;
                color: var(--ink-mid) !important;
                font-weight: 800 !important;
                font-size: 13px !important;
                letter-spacing: .06em !important;
                text-decoration:none !important;
                display:inline-flex !important;
                align-items:center !important;
                justify-content:center !important;
                cursor:pointer !important;
                transition: transform .15s ease, box-shadow .15s ease, background .15s ease, border-color .15s ease !important;
            }

            .filter-card .btn-filter:hover{
                transform: translateY(-1px) !important;
                box-shadow: 0 10px 22px rgba(44,36,22,.10) !important;
            }

            .filter-card .btn-filter.btn-apply{
                background: var(--ink) !important;
                border-color: var(--ink) !important;
                color: #fff !important;
            }

            .filter-card .btn-filter.btn-apply:hover{
                background: #241e14 !important;
                border-color: #241e14 !important;
            }

            @media (max-width: 980px){
                .filter-card .filter-row{
                    grid-template-columns: 1fr !important;
                }
                .filter-card .filter-actions{
                    justify-content:flex-start !important;
                }
            }

            /* =========================
               TABLE
            ========================= */
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
            .hms-table td {
                text-align: center !important;
                vertical-align: middle;
            }

            /* Class riêng để căn trái cho cột Guest Name */
            .hms-table .text-left {
                text-align: left !important;
            }

            /* Đảm bảo nút action cũng được căn giữa trong ô của nó */
            .action-cell {
                text-align: center !important;
            }

            .action-btns {
                display: flex;
                justify-content: center; /* Căn giữa các nút bên trong cell */
                gap: 8px;
            }

            .hms-table thead{
                background: var(--bg2);
                border-bottom: 1.5px solid var(--border);
            }
            .hms-table th{
                padding: 14px 18px;
                text-align:left;
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
                vertical-align: middle;
                overflow:hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .cell-id{
                color: var(--ink-mid);
                font-weight: 900;
                font-variant-numeric: tabular-nums;
            }
            .cell-name{
                font-weight: 800;
                color: var(--ink);
            }
            .cell-muted{
                color: var(--ink-soft);
                font-weight: 800;
            }

            .tag-pill{
                display:inline-flex;
                align-items:center;
                padding: 5px 12px;
                border-radius: 10px;
                font-weight: 900;
                font-size: 12px;
                background: var(--gold-bg);
                color: var(--gold);
            }

            .action-cell{
                text-align:right;
            }
            .action-btns{
                display:flex;
                justify-content:flex-end;
                gap: 8px;
                flex-wrap: wrap;
            }

            /* =========================
               ACTION BUTTONS (CLEAN)
            ========================= */
            .btn-action{
                height: 36px;
                padding: 0 12px;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                background: var(--paper);
                font-weight: 900;
                font-size: 12px;
                letter-spacing: .08em;
                text-transform: uppercase;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap: 8px;
                text-decoration:none !important;
                transition: transform .18s ease, box-shadow .18s ease, filter .18s ease;
                white-space: nowrap;
            }

            .btn-checkin{
                border-color: var(--checkin-br);
                background: var(--checkin-bg);
                color: var(--checkin) !important;
            }
            .btn-checkin:hover{
                transform: translateY(-1px);
                box-shadow: 0 12px 28px rgba(22,163,74,.18);
                filter: saturate(1.05);
            }

            .btn-checkout{
                border-color: var(--checkout-br);
                background: var(--checkout-bg);
                color: var(--checkout) !important;
            }
            .btn-checkout:hover{
                transform: translateY(-1px);
                box-shadow: 0 12px 28px rgba(220,38,38,.15);
                filter: saturate(1.05);
            }

            /* Footer */
            .table-footer{
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding: 16px 22px;
                border-top: 1px solid var(--border);
                background: var(--bg2);
                gap: 12px;
                flex-wrap:wrap;
            }
            .footer-left{
                display:flex;
                align-items:center;
                gap: 9px;
                font-size: 13px;
                font-weight: 600;
                color: var(--ink-mid);
            }
            .footer-left select{
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
            .pager{
                display:flex;
                align-items:center;
                gap: 8px;
            }
            .btn-ghost{
                height: 34px;
                padding: 0 14px;
                border-radius: 9px;
                border: 1.5px solid var(--border);
                background: var(--paper);
                color: var(--ink-mid);
                font-weight: 800;
                font-size: 13px;
                font-family: 'DM Sans', sans-serif;
                text-decoration:none;
                display:inline-flex;
                align-items:center;
                cursor:pointer;
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
                width: 34px;
                height: 34px;
                border-radius: 9px;
                background: var(--ink);
                color:#fff;
                font-weight: 900;
                font-size: 13px;
                font-family: 'DM Sans', sans-serif;
                display:inline-flex;
                align-items:center;
                justify-content:center;
            }


        </style>
    </head>

    <body>
        <div class="d-flex">
            <% request.setAttribute("active", "dashboard"); %>
            <jsp:include page="sidebar.jsp" />

            <main class="hms-main">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="dashboard-title">Daily Check-in</h1>
                        <p class="dashboard-date" id="live-clock"></p>
                    </div>
                    <a href="${pageContext.request.contextPath}/receptionist/booking/create">
                        <button class="btn-new-reservation" type="button">
                        <i class="bi bi-plus-lg"></i> New Reservation
                    </button>
                    </a>
                    
                </div>

                <!-- Stats -->
                <div class="stats-grid mb-4">
                    <div class="stat-card" data-tag="Guests">
                        <div class="stat-icon-wrapper bg-blue-soft"><i class="bi bi-people-fill"></i></div>
                        <div class="stat-data">
                            <span class="stat-label">TOTAL GUESTS</span>
                            <span class="stat-value">${stats.totalGuests}</span>
                        </div>
                    </div>

                    <div class="stat-card sage-card" data-tag="Booked">
                        <div class="stat-icon-wrapper bg-checkin-icon"><i class="bi bi-door-open-fill"></i></div>
                        <div class="stat-data">
                            <span class="stat-label">ROOMS BOOKED</span>
                            <span class="stat-value">${stats.roomsBooked}</span>
                        </div>
                    </div>

                    <div class="stat-card sage-card" data-tag="Checked">
                        <div class="stat-icon-wrapper bg-checkin-icon"><i class="bi bi-arrow-down-left"></i></div>
                        <div class="stat-data">
                            <span class="stat-label">CHECK-IN</span>
                            <span class="stat-value">${stats.checkInToday}</span>
                        </div>
                    </div>

                    <div class="stat-card" data-tag="Unchecked">
                        <div class="stat-icon-wrapper bg-checkout-icon"><i class="bi bi-arrow-up-right"></i></div>
                        <div class="stat-data">
                            <span class="stat-label">CHECK-OUT</span>
                            <span class="stat-value">${stats.checkOutToday}</span>
                        </div>
                    </div>

                    <div class="stat-card terra-card" data-tag="No-show">
                        <div class="stat-icon-wrapper bg-red-soft"><i class="bi bi-exclamation-triangle-fill"></i></div>
                        <div class="stat-data">
                            <span class="stat-label">NO-SHOW</span>
                            <span class="stat-value">${stats.noShowToday}</span>
                        </div>
                    </div>
                </div>

                <!-- FILTER -->

                <form class="filter-card" method="get" action="dashboard">
                    
                    <input type="hidden" name="index" value="1"> 
                    <input type="hidden" name="size" value="${currentSize}">
                    <div class="filter-row">
                        <div class="f-field">
                            <label>Search</label>
                            <div class="search-wrap">
                                <i class="bi bi-search"></i>
                                <input class="f-input" type="text"
                                       placeholder="Search by booking_id, guest name, or phone..."
                                       name="txtSearch"
                                       value="${searchValue}">
                            </div>
                        </div>

                        <div class="f-field">
                            <label>Status</label>
                            <select class="f-select" name="filterStatus">
                                <option value="0" ${statusValue == '0' ? 'selected' : ''}>All Status</option>
                                <option value="1" ${statusValue == '1' ? 'selected' : ''}>Reserved</option>
                                <option value="2" ${statusValue == '2' ? 'selected' : ''}>Checked-in</option>
                                <option value="3" ${statusValue == '3' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>

                        <div class="f-field">
                            <label>Sort</label>
                            <select class="f-select" name="filterSort">
                                <option value="Newest" ${sortValue == 'Newest' ? 'selected' : ''}>Newest</option>
                                <option value="Oldest" ${sortValue == 'Oldest' ? 'selected' : ''}>Oldest</option>
                            </select>
                        </div>

                        <!-- cột trống để giữ layout, không còn checkbox -->
                        <div class="f-field"></div>
                    </div>

                    <!-- Buttons -->
                    <div class="filter-actions">
                        <!-- Reset: về lại trang không có param -->
                        <a class="btn-filter btn-reset"
                           href="dashboard">Reset</a>

                        <!-- Apply: submit form -->
                        <button class="btn-filter btn-apply" type="submit">Apply Filter</button>
                    </div>
                </form>

                <!-- TABLE -->
                <div class="table-card">
                    <table class="hms-table">
                        <thead>
                            <tr>
                                <th style="width:120px">Booking ID</th>
                                <th class="text-left">Guest Name</th>
                                <th style="width:160px">Room Type</th>
                                <th style="width:180px">Time Stay</th>
                                <th style="width:110px">Number Room</th>
                                <th style="width:110px">Room Assign</th>
                                <th style="width:110px">Number Person</th>
                                <th style="width:200px; text-align:right">Action</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${listBookings}" var="b">
                                <tr>
                                    <td class="cell-id text-left">#${b.bookingId}</td>
                                    <td class="cell-name text-left">${b.guestName}</td>
                                    <td><span class="tag-pill">${b.roomTypeName}</span></td>
                                    <td class="cell-muted">${b.checkInDate} <br> ${b.checkOutDate}</td>
                                    <td>${b.numRooms}</td>
                                    <td class="cell-muted">${b.roomNo != null ? b.roomNo : "—"}</td>
                                    <td>${b.numPersons}</td>

                                    <td class="action-cell">
                                        <div class="action-btns">
                                            <c:choose>
                                                <c:when test="${b.bookingStatus == 1}">
                                                    <%-- Thêm class btn-action vào đây --%>
                                                    <a class="btn-action btn-checkin" href="assign-room?bookingId=${b.bookingId}">
                                                        <i class="bi bi-check2-circle"></i> Check-in
                                                    </a>
                                                </c:when>

                                                <c:when test="${b.assignmentStatus == 2}">
                                                    <%-- Thêm class btn-action vào đây --%>
                                                    <a class="btn-action btn-checkout" href="checkout?bookingId=${b.bookingId}">
                                                        <i class="bi bi-box-arrow-right"></i> Check-out
                                                    </a>
                                                </c:when>

                                                <c:otherwise>
                                                    <%-- Badge Completed cũng nên có width 135px cho đồng bộ --%>
                                                    <span class="badge bg-light text-dark border px-3 py-2" style="width: 135px; border-radius: 12px;">
                                                        COMPLETED
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listBookings}">
                                <tr>
                                    <td colspan="8" class="py-5 text-center text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-3 opacity-25"></i>
                                        No operations found for today.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <!-- Footer -->
                    <div class="table-footer">
                        <div class="footer-left">
                            Show
                            <select id="pageSizeSelect" onchange="changePageSize()">
                                <option value="10" ${currentSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${currentSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${currentSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                            entries per page
                        </div>

                                <div class="pager">
                                    <a class="btn-ghost ${tag <= 1 ? 'disabled' : ''}" 
                                       href="dashboard?index=${tag - 1}&size=${currentSize}&txtSearch=${searchValue}&filterStatus=${statusValue}&filterSort=${sortValue}">
                                        ← Prev
                                    </a>

                                    <span class="page-pill">${tag}</span> 

                                    <a class="btn-ghost ${tag >= endP ? 'disabled' : ''}" 
                                       href="dashboard?index=${tag + 1}&size=${currentSize}&txtSearch=${searchValue}&filterStatus=${statusValue}&filterSort=${sortValue}">
                                        Next →
                                    </a>
                                </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            function updateTime() {
                const now = new Date();
                const options = {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'};
                const timeString = now.toLocaleTimeString('en-GB', {hour12: false});
                const dateString = now.toLocaleDateString('en-US', options).toUpperCase();
                document.getElementById('live-clock').innerText = dateString + ' • ' + timeString;
            }
            setInterval(updateTime, 1000);
            updateTime();
            
            function changePageSize() {
                const size = document.getElementById("pageSizeSelect").value;
                // Khi đổi số lượng hiển thị, chúng ta nên quay về trang 1
                const url = "dashboard?index=1&size=" + size 
                            + "&txtSearch=${searchValue}" 
                            + "&filterStatus=${statusValue}" 
                            + "&filterSort=${sortValue}";
                window.location.href = url;
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>