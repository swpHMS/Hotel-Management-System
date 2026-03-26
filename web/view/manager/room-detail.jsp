<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager | Room Detail</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root{
            --sidebar-width: 260px;
            --content-gap: 26px;

            --bg:#f5f0e8;
            --bg2:#ede7da;
            --paper:#faf7f2;
            --border:#e0d8cc;
            --ink:#2c2416;
            --ink-mid:#5a4e3c;
            --ink-soft:#9c8e7a;
            --gold:#b5832a;
            --gold-lt:#f0ddb8;
            --gold-bg:rgba(181,131,42,.09);

            --sage:#5a7a5c;
            --sage-lt:#d4e6d4;

            --blue:#6b87a2;
            --blue-lt:#dfe8f2;

            --gray-status:#7a6f61;
            --gray-status-bg:#ece7df;

            --danger:#b84c3a;
            --danger-bg:#f8dfda;
        }

        *{
            box-sizing:border-box;
        }

        html, body{
            margin:0;
            padding:0;
            background:var(--bg);
            font-family:'DM Sans', sans-serif;
            color:var(--ink);
        }

        body{
            min-height:100vh;
        }

        .rd-content{
            margin-left: calc(var(--sidebar-width) + var(--content-gap));
            width: calc(100% - (var(--sidebar-width) + var(--content-gap)));
            min-height:100vh;
            padding:30px 24px 24px 0;
            background:var(--bg);
        }

        .rd-page{
            width:100%;
        }

        .rd-topbar{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:18px;
            margin-bottom:18px;
        }

        .rd-kicker{
            display:flex;
            align-items:center;
            gap:10px;
            margin-bottom:6px;
            font-size:12px;
            font-weight:800;
            letter-spacing:.16em;
            text-transform:uppercase;
            color:var(--gold);
        }

        .rd-kicker::before{
            content:"";
            width:18px;
            height:2px;
            border-radius:999px;
            background:var(--gold);
            display:inline-block;
        }

        .rd-title{
            font-family:'Fraunces', serif;
            font-weight:800;
            letter-spacing:-1px;
            color:var(--ink);
            margin:0;
            font-size:38px;
            line-height:1.05;
        }

        .rd-subtitle{
            margin-top:10px;
            color:var(--ink-soft);
            font-size:14px;
        }

        .rd-top-actions{
            display:flex;
            gap:12px;
            flex-wrap:wrap;
        }

        .rd-btn{
            border:1.5px solid var(--border);
            background:var(--paper);
            color:var(--ink-mid);
            border-radius:14px;
            padding:12px 18px;
            font-weight:800;
            font-size:14px;
            display:inline-flex;
            align-items:center;
            gap:8px;
            text-decoration:none;
            transition:.18s ease;
        }

        .rd-btn:hover{
            transform:translateY(-1px);
            box-shadow:0 10px 22px rgba(44,36,22,.10);
        }

        .rd-btn.back:hover{
            background:var(--gold-lt);
            border-color:#d4a854;
            color:var(--gold);
        }

        .rd-btn.edit{
            background:var(--ink);
            color:#fff;
            border-color:var(--ink);
        }

        .rd-btn.edit:hover{
            background:#241e14;
            border-color:#241e14;
            color:#fff;
        }

        .rd-layout{
            display:grid;
            grid-template-columns: 380px 1fr;
            gap:20px;
            align-items:start;
        }

        .rd-card{
            background:var(--paper);
            border:1px solid var(--border);
            border-radius:22px;
            box-shadow:0 2px 16px rgba(44,36,22,.06);
            overflow:hidden;
        }

        .rd-hero{
            padding:28px 24px;
            background:linear-gradient(180deg, #0d2240 0%, #08182d 100%);
            color:#fff;
            position:relative;
        }

        .rd-room-badge{
            min-width:86px;
            height:86px;
            padding:0 16px;
            border-radius:24px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            background:rgba(255,255,255,.10);
            border:1px solid rgba(255,255,255,.12);
            color:#f2b34b;
            font-size:30px;
            font-weight:900;
            box-shadow:0 10px 24px rgba(0,0,0,.18);
            margin-bottom:18px;
        }

        .rd-hero-title{
            font-family:'Fraunces', serif;
            font-size:28px;
            font-weight:800;
            line-height:1.1;
            margin-bottom:8px;
        }

        .rd-hero-sub{
            font-size:13px;
            text-transform:uppercase;
            letter-spacing:.14em;
            color:rgba(255,255,255,.72);
            font-weight:800;
        }

        .rd-hero-pills{
            margin-top:18px;
            display:flex;
            flex-wrap:wrap;
            gap:10px;
        }

        .rd-pill{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:7px 12px;
            border-radius:10px;
            font-size:12px;
            font-weight:800;
            white-space:nowrap;
        }

        .rd-pill.floor{
            background:rgba(242,179,75,.14);
            color:#f2b34b;
            border:1px solid rgba(242,179,75,.18);
        }

        .rd-pill.price{
            background:rgba(255,255,255,.10);
            color:#fff;
            border:1px solid rgba(255,255,255,.12);
        }

        .rd-status{
            min-width:120px;
        }

        .rd-status.available{
            background: var(--sage-lt);
            color: var(--sage);
        }

        .rd-status.occupied{
            background: var(--gray-status-bg);
            color: var(--gray-status);
        }

        .rd-status.maintenance{
            background: var(--blue-lt);
            color: var(--blue);
        }

        .rd-status.dirty{
            background: var(--gold-lt);
            color: var(--gold);
        }

        .rd-section{
            padding:22px 24px;
            border-top:1px solid var(--border);
        }

        .rd-section:first-child{
            border-top:none;
        }

        .rd-section-title{
            font-size:13px;
            font-weight:900;
            letter-spacing:.14em;
            text-transform:uppercase;
            color:var(--ink-soft);
            margin-bottom:14px;
        }

        .rd-info-list{
            display:grid;
            gap:14px;
        }

        .rd-info-row{
            display:grid;
            grid-template-columns: 160px 1fr;
            gap:14px;
            align-items:center;
            padding:12px 0;
            border-bottom:1px dashed #ddd2c3;
        }

        .rd-info-row:last-child{
            border-bottom:none;
            padding-bottom:0;
        }

        .rd-label{
            font-size:12px;
            font-weight:800;
            text-transform:uppercase;
            letter-spacing:.12em;
            color:var(--ink-soft);
        }

        .rd-value{
            font-size:15px;
            font-weight:700;
            color:var(--ink);
        }

        .rd-highlight-grid{
            display:grid;
            grid-template-columns: repeat(3, 1fr);
            gap:16px;
        }

        .rd-highlight{
            background:#f7f2ea;
            border:1px solid var(--border);
            border-radius:18px;
            padding:18px;
        }

        .rd-highlight-icon{
            width:42px;
            height:42px;
            border-radius:14px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            background:var(--gold-bg);
            color:var(--gold);
            font-size:18px;
            margin-bottom:12px;
        }

        .rd-highlight-label{
            font-size:11px;
            text-transform:uppercase;
            letter-spacing:.14em;
            font-weight:900;
            color:var(--ink-soft);
            margin-bottom:6px;
        }

        .rd-highlight-value{
            font-size:18px;
            font-weight:900;
            color:var(--ink);
        }

        .rd-empty{
            padding:30px;
            text-align:center;
            color:var(--danger);
            background:var(--danger-bg);
            border:1px solid #efc5bd;
            border-radius:20px;
            font-weight:700;
        }

        @media (max-width: 1100px){
            .rd-content{
                margin-left:0;
                width:100%;
                padding:20px 16px;
            }

            .rd-layout{
                grid-template-columns:1fr;
            }

            .rd-topbar{
                flex-direction:column;
                align-items:stretch;
            }

            .rd-top-actions{
                justify-content:flex-start;
            }

            .rd-highlight-grid{
                grid-template-columns:1fr;
            }
        }

        @media (max-width: 768px){
            .rd-title{
                font-size:32px;
            }

            .rd-info-row{
                grid-template-columns:1fr;
                gap:8px;
            }
        }
    </style>
</head>
<body>

    <%@include file="sidebar.jsp" %>

    <main class="rd-content">
        <div class="rd-page">

            <c:choose>
                <c:when test="${not empty roomDetail}">

                    <div class="rd-topbar">
                        <div>
                            <div class="rd-kicker">Room Operations</div>
                            <h1 class="rd-title">Room Detail</h1>
                            <div class="rd-subtitle">
                                Inspect room identity, classification, floor, pricing, and current operational status.
                            </div>
                        </div>

                        <div class="rd-top-actions">
                            <a href="${pageContext.request.contextPath}/manager/room-registry" class="rd-btn back">
                                <i class="bi bi-arrow-left"></i>
                                Back to Registry
                            </a>
                            <a href="${pageContext.request.contextPath}/manager/room-registry/update?id=${roomDetail.roomId}" class="rd-btn edit">
                                <i class="bi bi-pencil-square"></i>
                                Edit Room
                            </a>
                        </div>
                    </div>

                    <div class="rd-layout">

                        <!-- Left summary card -->
                        <div class="rd-card">
                            <div class="rd-hero">
                                <div class="rd-room-badge">${roomDetail.roomNo}</div>
                                <div class="rd-hero-title">${roomDetail.roomTypeName}</div>
                                <div class="rd-hero-sub">Room ID: ${roomDetail.roomId}</div>

                                <div class="rd-hero-pills">
                                    <span class="rd-pill floor">Floor ${roomDetail.floor}</span>
                                    <span class="rd-pill price">
                                        <fmt:formatNumber value="${roomDetail.price}" type="number" pattern="#,###"/> VND
                                    </span>
                                    <span class="rd-pill rd-status ${roomDetail.statusClass}">
                                        ${roomDetail.statusText}
                                    </span>
                                </div>
                            </div>

                            <div class="rd-section">
                                <div class="rd-section-title">Quick Overview</div>
                                <div class="rd-info-list">
                                    <div class="rd-info-row">
                                        <div class="rd-label">Room Number</div>
                                        <div class="rd-value">${roomDetail.roomNo}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Room Type</div>
                                        <div class="rd-value">${roomDetail.roomTypeName}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Floor</div>
                                        <div class="rd-value">${roomDetail.floor}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Status</div>
                                        <div class="rd-value">${roomDetail.statusText}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right detailed card -->
                        <div class="rd-card">
                            <div class="rd-section">
                                <div class="rd-section-title">Registry Information</div>

                                <div class="rd-highlight-grid">
                                    <div class="rd-highlight">
                                        <div class="rd-highlight-icon">
                                            <i class="bi bi-door-open"></i>
                                        </div>
                                        <div class="rd-highlight-label">Room Number</div>
                                        <div class="rd-highlight-value">${roomDetail.roomNo}</div>
                                    </div>

                                    <div class="rd-highlight">
                                        <div class="rd-highlight-icon">
                                            <i class="bi bi-grid-1x2"></i>
                                        </div>
                                        <div class="rd-highlight-label">Type ID</div>
                                        <div class="rd-highlight-value">${roomDetail.roomTypeId}</div>
                                    </div>

                                    <div class="rd-highlight">
                                        <div class="rd-highlight-icon">
                                            <i class="bi bi-cash-stack"></i>
                                        </div>
                                        <div class="rd-highlight-label">Price</div>
                                        <div class="rd-highlight-value">
                                            <fmt:formatNumber value="${roomDetail.price}" type="number" pattern="#,###"/> VND
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="rd-section">
                                <div class="rd-section-title">Detailed Attributes</div>
                                <div class="rd-info-list">
                                    <div class="rd-info-row">
                                        <div class="rd-label">Database Room ID</div>
                                        <div class="rd-value">${roomDetail.roomId}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Room Number</div>
                                        <div class="rd-value">${roomDetail.roomNo}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Room Type ID</div>
                                        <div class="rd-value">${roomDetail.roomTypeId}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Room Type Name</div>
                                        <div class="rd-value">${roomDetail.roomTypeName}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Floor</div>
                                        <div class="rd-value">${roomDetail.floor}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Status Code</div>
                                        <div class="rd-value">${roomDetail.status}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Status Display</div>
                                        <div class="rd-value">${roomDetail.statusText}</div>
                                    </div>
                                    <div class="rd-info-row">
                                        <div class="rd-label">Current Price</div>
                                        <div class="rd-value">
                                            <fmt:formatNumber value="${roomDetail.price}" type="number" pattern="#,###"/> VND
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </c:when>

                <c:otherwise>
                    <div class="rd-empty">
                        Room detail not found.
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </main>

</body>
</html>