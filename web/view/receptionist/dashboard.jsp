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

                --blue:#3b5ccc;
                --blue-lt:#dfe7ff;
                --blue-bg:rgba(59,92,204,.10);

                --sage:#5a7a5c;
                --sage-lt:#d4e6d4;

                --orange:#c26a1b;
                --orange-lt:#ffe5c7;
                --orange-bg:rgba(194,106,27,.10);

                --purple:#7c4cc9;
                --purple-lt:#eadfff;
                --purple-bg:rgba(124,76,201,.10);

                --terra:#c0614a;
                --terra-lt:#f5d8d2;

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

            .btn-new-reservation{
                border:none;
                background:#2c2416;
                color:#fff;
                border-radius:14px;
                padding:12px 18px;
                font-weight:800;
                display:inline-flex;
                align-items:center;
                gap:8px;
                box-shadow:0 10px 24px rgba(44,36,22,.12);
                transition:.18s ease;
            }
            .btn-new-reservation:hover{
                transform:translateY(-1px);
                background:#201a10;
            }

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
                top: 10px;
                right: 10px;
            }

            .stat-card:hover{
                transform: translateY(-3px);
                box-shadow: 0 14px 40px rgba(44,36,22,.10);
            }

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

            .stat-card.gold-card{ --card-blob: rgba(181,131,42,.08); }
            .stat-card.blue-card{ --card-blob: rgba(59,92,204,.08); }
            .stat-card.green-card{ --card-blob: rgba(90,122,92,.09); }
            .stat-card.orange-card{ --card-blob: rgba(194,106,27,.08); }
            .stat-card.purple-card{ --card-blob: rgba(124,76,201,.08); }

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

            .stat-card.gold-card::before{ background: var(--gold-bg); color: var(--gold); }
            .stat-card.blue-card::before{ background: var(--blue-bg); color: var(--blue); }
            .stat-card.green-card::before{ background: rgba(90,122,92,.10); color: var(--sage); }
            .stat-card.orange-card::before{ background: var(--orange-bg); color: var(--orange); }
            .stat-card.purple-card::before{ background: var(--purple-bg); color: var(--purple); }

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

            .bg-guests-icon{ background: var(--gold-lt); color: var(--gold); }
            .bg-pending-icon{ background: var(--blue-lt); color: var(--blue); }
            .bg-checkin-icon{ background: var(--sage-lt); color: var(--sage); }
            .bg-checkout-icon{ background: var(--orange-lt); color: var(--orange); }
            .bg-arrival-icon{ background: var(--purple-lt); color: var(--purple); }

            .stat-data{
                display: flex;
                flex-direction: column;
                z-index: 1;
                min-width: 0;
                margin-top: 12px;
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
                padding-right: 86px;
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
                .stats-grid{ grid-template-columns: repeat(3, minmax(0, 1fr)); }
            }
            @media (max-width: 820px){
                .hms-main{
                    margin-left: 0;
                    width: 100%;
                }
                .stats-grid{ grid-template-columns: repeat(2, minmax(0, 1fr)); }
            }
            @media (max-width: 520px){
                .stats-grid{ grid-template-columns: 1fr; }
            }

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

            .filter-card .f-input{ padding-left: 40px !important; }

            .filter-card .f-input:focus,
            .filter-card .f-select:focus{
                border-color: var(--gold) !important;
                box-shadow: 0 0 0 3px rgba(181,131,42,.12) !important;
                background: var(--paper) !important;
            }

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
                .filter-card .filter-row{ grid-template-columns: 1fr !important; }
                .filter-card .filter-actions{ justify-content:flex-start !important; }
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
                text-align: center !important;
                vertical-align: middle;
            }

            .hms-table .text-left{ text-align: left !important; }
            .action-cell{ text-align: center !important; }

            .action-btns{
                display: flex;
                justify-content: center;
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
            .hms-table tbody tr:hover{ background:#f0ebe0; }
            .hms-table tbody tr:last-child{ border-bottom:none; }

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

            .action-cell{ text-align:right; }
            .action-btns{
                display:flex;
                justify-content:flex-end;
                gap: 8px;
                flex-wrap: wrap;
            }

            .btn-action{
                width: 135px;
                height: 38px;
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                font-weight: 900;
                font-size: 12px;
                text-transform: uppercase;
                text-decoration: none !important;
                transition: all .18s ease;
                border: 1.5px solid transparent;
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

            .booking-id-btn{
                border: none;
                background: transparent;
                padding: 0;
                font-weight: 900;
                color: #2f5bd3;
                cursor: pointer;
                text-decoration: none;
                transition: color .18s ease, transform .18s ease;
            }
            .booking-id-btn:hover{
                color: #1d4ed8;
                transform: translateY(-1px);
            }

            .booking-detail-overlay{
                position: fixed;
                inset: 0;
                background: rgba(24, 28, 35, 0.22);
                backdrop-filter: blur(4px);
                z-index: 1040;
                opacity: 0;
                visibility: hidden;
                transition: all .25s ease;
            }

            .booking-detail-drawer{
                position: fixed;
                top: 0;
                right: 0;
                width: 500px;
                max-width: 100%;
                height: 100vh;
                background: #fcfaf6;
                border-left: 1px solid #e6ddd0;
                box-shadow: -20px 0 50px rgba(36, 30, 20, 0.16);
                z-index: 1050;
                transform: translateX(100%);
                transition: transform .3s ease;
                display: flex;
                flex-direction: column;
            }

            .booking-detail-overlay.show{
                opacity: 1;
                visibility: visible;
            }

            .booking-detail-drawer.show{
                transform: translateX(0);
            }

            .booking-detail-header{
                padding: 24px 24px 20px;
                border-bottom: 1px solid #ece2d4;
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: #fcfaf6;
                flex-shrink: 0;
            }

            .booking-detail-title{
                margin: 0;
                font-size: 16px;
                font-weight: 900;
                color: #23324a;
                letter-spacing: .08em;
                text-transform: uppercase;
            }

            .booking-detail-close{
                width: 40px;
                height: 40px;
                border: none;
                background: transparent;
                border-radius: 12px;
                font-size: 22px;
                color: #94a3b8;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all .18s ease;
            }
            .booking-detail-close:hover{
                background: #f1ece4;
                color: #334155;
            }

            .booking-detail-body{
                flex: 1;
                overflow-y: auto;
                padding: 22px 24px 32px;
            }

            .detail-profile{
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 18px;
            }

            .detail-avatar{
                width: 70px;
                height: 70px;
                border-radius: 22px;
                background: linear-gradient(135deg, #2f66ff, #4f8cff);
                color: #fff;
                font-size: 28px;
                font-weight: 900;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
                box-shadow: 0 10px 24px rgba(47, 102, 255, .20);
            }

            .detail-profile-text{
                min-width: 0;
            }

            .detail-guest-name{
                font-size: 18px;
                font-weight: 900;
                color: #283548;
                line-height: 1.25;
                margin: 0 0 4px;
            }

            .detail-booking-code{
                font-size: 14px;
                color: #7c8aa0;
                font-weight: 800;
                margin: 0;
            }

            .detail-section-status{
                margin-bottom: 18px;
            }

            .detail-status-badge{
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 8px 14px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 900;
                letter-spacing: .08em;
                text-transform: uppercase;
                box-shadow: inset 0 0 0 1px rgba(0,0,0,.04);
            }

            .status-reserved{
                background: #fff4cf;
                color: #b7791f;
            }
            .status-checkin{
                background: #dcfce7;
                color: #15803d;
            }
            .status-completed{
                background: #e2e8f0;
                color: #475569;
            }
            .status-noshow{
                background: #fee2e2;
                color: #b91c1c;
            }
            .status-other{
                background: #ede9fe;
                color: #6d28d9;
            }

            .detail-grid{
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 18px 16px;
                margin-bottom: 22px;
            }

            .detail-grid > div{
                background: #fffdfa;
                border: 1px solid #eee4d6;
                border-radius: 18px;
                padding: 14px 16px;
            }

            .detail-item-label{
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 8px;
                font-size: 11px;
                font-weight: 900;
                letter-spacing: .08em;
                text-transform: uppercase;
                color: #94a3b8;
            }

            .detail-item-label i{
                font-size: 13px;
            }

            .detail-item-value{
                font-size: 16px;
                font-weight: 900;
                color: #273142;
                line-height: 1.45;
                white-space: normal;
                word-break: break-word;
            }

            .detail-section{
                margin-bottom: 22px;
            }

            .detail-section-title{
                margin: 0 0 10px;
                font-size: 12px;
                font-weight: 900;
                letter-spacing: .10em;
                text-transform: uppercase;
                color: #94a3b8;
            }

            .detail-contact-box{
                background: #f5f7fb;
                border: 1px solid #e5ebf3;
                border-radius: 20px;
                padding: 16px 18px;
            }

            .detail-contact-row{
                display: flex;
                align-items: center;
                gap: 12px;
                color: #334155;
                font-size: 15px;
                font-weight: 800;
                line-height: 1.5;
                white-space: normal;
                word-break: break-word;
            }

            .detail-contact-row + .detail-contact-row{
                margin-top: 12px;
            }

            .detail-contact-row i{
                color: #7c8aa0;
                font-size: 18px;
                width: 20px;
                text-align: center;
            }

            .detail-note-box{
                background: #fffaf0;
                border: 1px solid #edd9ab;
                border-radius: 18px;
                padding: 16px 18px;
                color: #9a5b1f;
                font-size: 15px;
                font-weight: 700;
                line-height: 1.7;
                min-height: 64px;
                white-space: normal;
                word-break: break-word;
            }

            #detailAssignedRoomDetails{
                background: #fffaf0;
                border: 1px solid #ead6a5;
                color: #9a6324;
            }

            @media (max-width: 768px){
                .booking-detail-drawer{
                    width: 100%;
                }

                .booking-detail-body{
                    padding: 20px 18px 28px;
                }

                .detail-grid{
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <% request.setAttribute("active", "dashboard"); %>
            <jsp:include page="sidebar.jsp" />

            <main class="hms-main">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="dashboard-title">Today Operation</h1>
                        <p class="dashboard-date" id="live-clock"></p>
                    </div>

                    <a href="${pageContext.request.contextPath}/receptionist/booking/create">
                        <button class="btn-new-reservation" type="button">
                            <i class="bi bi-plus-lg"></i> New Reservation
                        </button>
                    </a>
                </div>

                <div class="stats-grid mb-4">
                    <div class="stat-card gold-card" data-tag="Guests">
                        <div class="stat-icon-wrapper bg-guests-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div class="stat-data">
                            <span class="stat-label">TOTAL GUESTS</span>
                            <span class="stat-value">${stats.totalGuests}</span>
                        </div>
                    </div>

                    <div class="stat-card blue-card" data-tag="Pending">
                        <div class="stat-icon-wrapper bg-pending-icon">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                        <div class="stat-data">
                            <span class="stat-label">PENDING CHECK-IN</span>
                            <span class="stat-value">${stats.pendingCheckIn}</span>
                        </div>
                    </div>

                    <div class="stat-card green-card" data-tag="Checked">
                        <div class="stat-icon-wrapper bg-checkin-icon">
                            <i class="bi bi-box-arrow-in-right"></i>
                        </div>
                        <div class="stat-data">
                            <span class="stat-label">CHECK-IN</span>
                            <span class="stat-value">${stats.checkInToday}</span>
                        </div>
                    </div>

                    <div class="stat-card orange-card" data-tag="Departure">
                        <div class="stat-icon-wrapper bg-checkout-icon">
                            <i class="bi bi-box-arrow-right"></i>
                        </div>
                        <div class="stat-data">
                            <span class="stat-label">CHECK-OUT</span>
                            <span class="stat-value">${stats.checkOutToday}</span>
                        </div>
                    </div>

                    <div class="stat-card purple-card" data-tag="Arrival">
                        <div class="stat-icon-wrapper bg-arrival-icon">
                            <i class="bi bi-calendar-event-fill"></i>
                        </div>
                        <div class="stat-data">
                            <span class="stat-label">ARRIVAL TODAY</span>
                            <span class="stat-value">${stats.arrivalToday}</span>
                        </div>
                    </div>
                </div>

                <form class="filter-card" method="get" action="dashboard">
                    <input type="hidden" name="index" value="1">
                    <input type="hidden" name="size" value="${currentSize}">

                    <div class="filter-row">
                        <div class="f-field">
                            <label>Search</label>
                            <div class="search-wrap">
                                <i class="bi bi-search"></i>
                                <input class="f-input" type="text"
                                       placeholder="Search by booking_id, guest name, room number"
                                       name="txtSearch"
                                       value="${searchValue}">
                            </div>
                        </div>

                        <div class="f-field">
                            <label>Status</label>
                            <select class="f-select" name="filterStatus">
                                <option value="0" ${statusValue == '0' ? 'selected' : ''}>All Status</option>
                                <option value="2" ${statusValue == '2' ? 'selected' : ''}>Reserved</option>
                                <option value="3" ${statusValue == '3' ? 'selected' : ''}>Checked-in</option>
                                <option value="4" ${statusValue == '4' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>

                        <div class="f-field">
                            <label>Sort</label>
                            <select class="f-select" name="filterSort">
                                <option value="Newest" ${sortValue == 'Newest' ? 'selected' : ''}>Newest</option>
                                <option value="Oldest" ${sortValue == 'Oldest' ? 'selected' : ''}>Oldest</option>
                            </select>
                        </div>

                        <div class="f-field"></div>
                    </div>

                    <div class="filter-actions">
                        <a class="btn-filter btn-reset" href="dashboard">Reset</a>
                        <button class="btn-filter btn-apply" type="submit">Apply Filter</button>
                    </div>
                </form>

                <div class="table-card">
                    <table class="hms-table">
                        <thead>
                            <tr>
                                <th style="width:120px">Booking ID</th>
                                <th class="text-left">Guest Name</th>
                                <th style="width:160px">Booked Type</th>
                                <th style="width:180px">Time Stay</th>
                                <th style="width:110px">Number Room</th>
                                <th style="width:110px">Room Assign</th>
                                <th style="width:130px">Status</th>
                                <th style="width:200px; text-align:right">Action</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${listBookings}" var="b">
                                <tr>
                                    <td class="cell-id text-left">
                                        <button
                                            type="button"
                                            class="booking-id-btn"
                                            data-booking-id="${b.bookingId}"
                                            data-guest-name="${b.guestName}"
                                            data-booked-type="${b.roomTypeName}"
                                            data-checkin="${b.checkInDate}"
                                            data-checkout="${b.checkOutDate}"
                                            data-num-rooms="${b.numRooms}"
                                            data-room-no="${b.assignedRoomNos != null ? b.assignedRoomNos : '—'}"
                                            data-room-detail="${b.assignedRoomDetails != null ? b.assignedRoomDetails : '—'}"
                                            data-num-persons="${b.numPersons > 0 ? b.numPersons : '—'}"
                                            data-status="${b.bookingStatus}"
                                            data-phone="${b.phone != null ? b.phone : '—'}"
                                            data-email="${b.email != null ? b.email : '—'}">
                                            #${b.bookingId}
                                        </button>
                                    </td>

                                    <td class="cell-name text-left">${b.guestName}</td>
                                    <td><span class="tag-pill">${b.roomTypeName}</span></td>
                                    <td class="cell-muted">${b.checkInDate} <br> ${b.checkOutDate}</td>
                                    <td>${b.numRooms}</td>
                                    <td class="cell-muted">${b.assignedRoomNos != null ? b.assignedRoomNos : "—"}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.bookingStatus == 2}">
                                                <span class="tag-pill status-reserved">Reserved</span>
                                            </c:when>
                                            <c:when test="${b.bookingStatus == 3}">
                                                <span class="tag-pill status-checkin">Checked-in</span>
                                            </c:when>
                                            <c:when test="${b.bookingStatus == 4}">
                                                <span class="tag-pill status-completed">Completed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="tag-pill">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="action-cell">
                                        <div class="action-btns">
                                            <c:choose>
                                                <c:when test="${b.bookingStatus == 2}">
                                                    <a class="btn-action btn-checkin" href="assign-room?bookingId=${b.bookingId}">
                                                        <i class="bi bi-check2-circle"></i> Check-in
                                                    </a>
                                                </c:when>

                                                <c:when test="${b.bookingStatus == 3}">
                                                    <a class="btn-action btn-checkout" href="checkout-process?bookingId=${b.bookingId}">
                                                        <i class="bi bi-box-arrow-right"></i> Check-out
                                                    </a>
                                                </c:when>

                                                <c:when test="${b.bookingStatus == 4}">
                                                    <span class="badge bg-light text-dark border px-3 py-2" style="width: 135px; border-radius: 12px;">
                                                        COMPLETED
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="badge bg-light text-dark border px-3 py-2" style="width: 135px; border-radius: 12px;">
                                                        —
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

        <div id="bookingDetailOverlay" class="booking-detail-overlay"></div>

        <aside id="bookingDetailDrawer" class="booking-detail-drawer" aria-hidden="true">
            <div class="booking-detail-header">
                <h3 class="booking-detail-title">Chi tiết đặt phòng</h3>
                <button type="button" class="booking-detail-close" id="closeBookingDetail">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="booking-detail-body">
                <div class="detail-profile">
                    <div class="detail-avatar" id="detailAvatar">G</div>
                    <div class="detail-profile-text">
                        <h4 class="detail-guest-name" id="detailGuestName">Guest Name</h4>
                        <p class="detail-booking-code" id="detailBookingCode">BK-0000</p>
                    </div>
                </div>

                <div class="detail-section-status">
                    <span id="detailStatusBadge" class="detail-status-badge status-other">Status</span>
                </div>

                <div class="detail-grid">
                    <div>
                        <div class="detail-item-label">
                            <i class="bi bi-box-arrow-in-right"></i>
                            <span>Check-in</span>
                        </div>
                        <div class="detail-item-value" id="detailCheckin">—</div>
                    </div>

                    <div>
                        <div class="detail-item-label">
                            <i class="bi bi-box-arrow-right"></i>
                            <span>Check-out</span>
                        </div>
                        <div class="detail-item-value" id="detailCheckout">—</div>
                    </div>

                    <div>
                        <div class="detail-item-label">
                            <i class="bi bi-building"></i>
                            <span>Booked Type</span>
                        </div>
                        <div class="detail-item-value" id="detailBookedType">—</div>
                    </div>

                    <div>
                        <div class="detail-item-label">
                            <i class="bi bi-people"></i>
                            <span>Số khách</span>
                        </div>
                        <div class="detail-item-value" id="detailNumPersons">—</div>
                    </div>

                    <div>
                        <div class="detail-item-label">
                            <i class="bi bi-door-open"></i>
                            <span>Số phòng</span>
                        </div>
                        <div class="detail-item-value" id="detailNumRooms">—</div>
                    </div>

                    <div>
                        <div class="detail-item-label">
                            <i class="bi bi-houses"></i>
                            <span>Assigned Rooms</span>
                        </div>
                        <div class="detail-item-value" id="detailRoomNo">—</div>
                    </div>
                </div>

                <div class="detail-section">
                    <h5 class="detail-section-title">Chi tiết phòng đã gán</h5>
                    <div class="detail-note-box" id="detailAssignedRoomDetails">—</div>
                </div>

                <div class="detail-section">
                    <h5 class="detail-section-title">Thông tin liên hệ</h5>
                    <div class="detail-contact-box">
                        <div class="detail-contact-row">
                            <i class="bi bi-telephone"></i>
                            <a href="#" id="detailPhone" style="text-decoration:none; color:inherit;">—</a>
                        </div>
                        <div class="detail-contact-row">
                            <i class="bi bi-envelope"></i>
                            <a href="#" id="detailEmail" style="text-decoration:none; color:inherit;">—</a>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

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
                const url = "dashboard?index=1&size=" + size
                        + "&txtSearch=${searchValue}"
                        + "&filterStatus=${statusValue}"
                        + "&filterSort=${sortValue}";
                window.location.href = url;
            }

            const overlay = document.getElementById("bookingDetailOverlay");
            const drawer = document.getElementById("bookingDetailDrawer");
            const closeBtn = document.getElementById("closeBookingDetail");

            function getInitials(name) {
                if (!name) return "G";
                const parts = name.trim().split(/\s+/);
                if (parts.length === 1) {
                    return parts[0].charAt(0).toUpperCase();
                }
                return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
            }

            function mapStatus(status) {
                switch (String(status)) {
                    case "2":
                        return {text: "Reserved", className: "detail-status-badge status-reserved"};
                    case "3":
                        return {text: "Checked-in", className: "detail-status-badge status-checkin"};
                    case "4":
                        return {text: "Completed", className: "detail-status-badge status-completed"};
                    default:
                        return {text: "Other", className: "detail-status-badge status-other"};
                }
            }

            function openBookingDetail(btn) {
                const bookingId = btn.dataset.bookingId || "—";
                const guestName = btn.dataset.guestName || "—";
                const bookedType = btn.dataset.bookedType || "—";
                const checkin = btn.dataset.checkin || "—";
                const checkout = btn.dataset.checkout || "—";
                const numRooms = btn.dataset.numRooms || "—";
                const roomNo = btn.dataset.roomNo || "—";
                const roomDetail = btn.dataset.roomDetail || "—";
                const numPersons = btn.dataset.numPersons || "—";
                const status = btn.dataset.status || "";
                const phone = btn.dataset.phone || "—";
                const email = btn.dataset.email || "—";

                document.getElementById("detailAvatar").textContent = getInitials(guestName);
                document.getElementById("detailGuestName").textContent = guestName;
                document.getElementById("detailBookingCode").textContent = "BK-" + bookingId;
                document.getElementById("detailCheckin").textContent = checkin;
                document.getElementById("detailCheckout").textContent = checkout;
                document.getElementById("detailBookedType").textContent = bookedType;
                document.getElementById("detailNumPersons").textContent = numPersons;
                document.getElementById("detailNumRooms").textContent = numRooms;
                document.getElementById("detailRoomNo").textContent = roomNo;

                document.getElementById("detailAssignedRoomDetails").innerHTML =
                        (roomDetail || "—").split(", ").join("<br>");

                const phoneEl = document.getElementById("detailPhone");
                const emailEl = document.getElementById("detailEmail");

                phoneEl.textContent = phone;
                phoneEl.href = phone !== "—" ? "tel:" + phone : "#";

                emailEl.textContent = email;
                emailEl.href = email !== "—" ? "mailto:" + email : "#";

                const statusBadge = document.getElementById("detailStatusBadge");
                const statusInfo = mapStatus(status);
                statusBadge.textContent = statusInfo.text;
                statusBadge.className = statusInfo.className;

                overlay.classList.add("show");
                drawer.classList.add("show");
                drawer.setAttribute("aria-hidden", "false");
                document.body.style.overflow = "hidden";
            }

            function closeBookingDetail() {
                overlay.classList.remove("show");
                drawer.classList.remove("show");
                drawer.setAttribute("aria-hidden", "true");
                document.body.style.overflow = "";
            }

            document.querySelectorAll(".booking-id-btn").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    openBookingDetail(this);
                });
            });

            overlay.addEventListener("click", closeBookingDetail);
            closeBtn.addEventListener("click", closeBookingDetail);

            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape") {
                    closeBookingDetail();
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>