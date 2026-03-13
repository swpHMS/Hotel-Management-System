<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager | Room Registry</title>
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

            --blue:#6b87a2;
            --blue-lt:#dfe8f2;

            --gray-status:#7a6f61;
            --gray-status-bg:#ece7df;
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

        .rr-content{
            margin-left: calc(var(--sidebar-width) + var(--content-gap));
            width: calc(100% - (var(--sidebar-width) + var(--content-gap)));
            min-height: 100vh;
            padding: 30px 24px 24px 0;
            background: var(--bg);
        }

        .rr-page{
            width:100%;
        }

        .rr-topbar{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:18px;
            margin-bottom:18px;
        }

        .rr-title-wrap .rr-kicker{
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

        .rr-title-wrap .rr-kicker::before{
            content:"";
            width:18px;
            height:2px;
            border-radius:999px;
            background:var(--gold);
            display:inline-block;
        }

        .rr-title{
            font-family:'Fraunces', serif;
            font-weight:800;
            letter-spacing:-1px;
            color:var(--ink);
            margin:0;
            font-size:38px;
            line-height:1.05;
        }

        .rr-btn-create{
            border:none;
            background:#2c2416;
            color:#fff;
            border-radius:14px;
            padding:12px 18px;
            font-weight:800;
            font-size:14px;
            display:inline-flex;
            align-items:center;
            gap:8px;
            box-shadow:0 10px 24px rgba(44,36,22,.12);
            transition:.18s ease;
            text-decoration:none;
            margin-top:6px;
        }

        .rr-btn-create:hover{
            transform:translateY(-1px);
            background:#201a10;
            color:#fff;
        }

        .rr-filter-card{
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 20px 22px;
            margin-bottom: 18px;
            box-shadow: 0 2px 12px rgba(44,36,22,.05);
        }

        .rr-filter-grid{
            display:grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 16px;
            align-items:end;
        }

        .rr-field label{
            display:block;
            font-size:10.5px;
            font-weight:800;
            letter-spacing:.16em;
            text-transform:uppercase;
            color:var(--ink-soft);
            margin-bottom:8px;
        }

        .rr-search-wrap{
            position:relative;
        }

        .rr-search-wrap i{
            position:absolute;
            left:14px;
            top:50%;
            transform:translateY(-50%);
            color:var(--ink-soft);
            font-size:14px;
            pointer-events:none;
        }

        .rr-input,
        .rr-select{
            width:100%;
            height:46px;
            padding:0 14px;
            border:1.5px solid var(--border);
            border-radius:12px;
            background:var(--bg);
            font-family:'DM Sans', sans-serif;
            font-size:14px;
            color:var(--ink);
            outline:none;
            box-shadow:none;
            appearance:none;
        }

        .rr-input{
            padding-left:40px;
        }

        .rr-input:focus,
        .rr-select:focus{
            border-color:var(--gold);
            box-shadow:0 0 0 3px rgba(181,131,42,.12);
            background:var(--paper);
        }

        .rr-filter-actions{
            display:flex;
            justify-content:flex-end;
            gap:12px;
            margin-top:14px;
        }

        .rr-btn-reset,
        .rr-btn-apply{
            height:42px;
            padding:0 18px;
            border-radius:12px;
            border:1.5px solid var(--border);
            background:var(--paper);
            color:var(--ink-mid);
            font-weight:800;
            font-size:13px;
            letter-spacing:.06em;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            cursor:pointer;
            transition:transform .15s ease, box-shadow .15s ease, background .15s ease, border-color .15s ease;
        }

        .rr-btn-reset:hover,
        .rr-btn-apply:hover{
            transform: translateY(-1px);
            box-shadow: 0 10px 22px rgba(44,36,22,.10);
        }

        .rr-btn-apply{
            background: var(--ink);
            border-color: var(--ink);
            color: #fff;
        }

        .rr-btn-apply:hover{
            background: #241e14;
            border-color: #241e14;
        }

        .rr-table-card{
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 2px 16px rgba(44,36,22,.06);
        }

        .rr-grid{
            display:grid;
            grid-template-columns: 110px 1fr 120px 150px 170px 130px;
            gap:12px;
            align-items:center;
        }

        .rr-table-header{
            background: var(--bg2);
            border-bottom: 1.5px solid var(--border);
            padding: 14px 18px;
            font-size: 10.5px;
            font-weight: 900;
            letter-spacing: .14em;
            text-transform: uppercase;
            color: var(--ink-soft);
        }

        .rr-table-header > div:nth-child(3),
        .rr-table-header > div:nth-child(4),
        .rr-table-header > div:nth-child(5),
        .rr-table-header > div:nth-child(6){
            text-align:center;
        }

        .rr-table-row{
            padding: 16px 18px;
            border-bottom: 1px solid var(--border);
            transition: background .15s;
            background: var(--paper);
        }

        .rr-table-row:hover{
            background:#f0ebe0;
        }

        .rr-table-row:last-child{
            border-bottom:none;
        }

        .rr-table-row > div:nth-child(3),
        .rr-table-row > div:nth-child(4),
        .rr-table-row > div:nth-child(5),
        .rr-table-row > div:nth-child(6){
            display:flex;
            justify-content:center;
            align-items:center;
        }

        .rr-suite-cell{
            display:flex;
            align-items:center;
        }

        .rr-suite-badge{
            min-width:44px;
            height:44px;
            padding:0 10px;
            border-radius:14px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            background: linear-gradient(180deg, #0d2240 0%, #08182d 100%);
            color:#f2b34b;
            font-size:16px;
            font-weight:900;
            box-shadow:0 7px 12px rgba(8,24,45,.14);
        }

        .rr-main-title{
            font-size:14px;
            font-weight:800;
            color:var(--ink);
            margin-bottom:4px;
            line-height:1.2;
        }

        .rr-sub-title{
            font-size:10px;
            letter-spacing:.14em;
            text-transform:uppercase;
            color:var(--ink-soft);
            font-weight:800;
            line-height:1.2;
        }

        .rr-pill{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:5px 12px;
            border-radius:10px;
            font-weight:900;
            font-size:11px;
            white-space:nowrap;
        }

        .rr-level-pill{
            background: var(--gold-bg);
            color: var(--gold);
            min-width: 80px;
        }

        .rr-price-pill{
            background: #f3ecdf;
            color: #8d6d3b;
            min-width: 110px;
        }

        .rr-status-pill{
            min-width:120px;
            height:28px;
        }

        .rr-status-pill.available{
            background: var(--sage-lt);
            color: var(--sage);
        }

        .rr-status-pill.occupied{
            background: var(--gray-status-bg);
            color: var(--gray-status);
        }

        .rr-status-pill.maintenance{
            background: var(--blue-lt);
            color: var(--blue);
        }

        .rr-status-pill.dirty{
            background: var(--gold-lt);
            color: var(--gold);
        }

        .rr-actions{
            display:flex;
            justify-content:center;
            gap:8px;
        }

        .rr-action-btn{
            width:40px;
            height:38px;
            border-radius:12px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            text-decoration:none;
            transition:all .18s ease;
            border:1.5px solid var(--border);
            background:var(--paper);
            color:var(--ink-soft);
        }

        .rr-action-btn:hover{
            transform:translateY(-1px);
            box-shadow:0 10px 22px rgba(44,36,22,.10);
            background:var(--gold-lt);
            border-color:#d4a854;
            color:var(--gold);
        }

        .rr-table-footer{
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding:16px 22px;
            border-top:1px solid var(--border);
            background:var(--bg2);
            gap:12px;
            flex-wrap:wrap;
        }

        .rr-page-size{
            display:flex;
            align-items:center;
            gap:9px;
            font-size:13px;
            font-weight:600;
            color:var(--ink-mid);
        }

        .rr-page-size select{
            height:34px;
            padding:0 10px;
            border:1.5px solid var(--border);
            border-radius:9px;
            background:var(--paper);
            font-size:13px;
            color:var(--ink);
            font-family:'DM Sans', sans-serif;
            outline:none;
        }

        .rr-pagination{
            display:flex;
            align-items:center;
            gap:8px;
        }

        .rr-page-btn{
            height:34px;
            padding:0 14px;
            border-radius:9px;
            border:1.5px solid var(--border);
            background:var(--paper);
            color:var(--ink-mid);
            font-weight:800;
            font-size:13px;
            font-family:'DM Sans', sans-serif;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            cursor:pointer;
            transition:background .15s, border-color .15s, color .15s;
        }

        .rr-page-btn:hover{
            background:var(--gold-lt);
            border-color:#d4a854;
            color:var(--gold);
        }

        .rr-page-btn.disabled{
            pointer-events:none;
            opacity:.5;
            background:#f3eee6;
        }

        .rr-page-current{
            width:34px;
            height:34px;
            border-radius:9px;
            background:var(--ink);
            color:#fff;
            font-weight:900;
            font-size:13px;
            font-family:'DM Sans', sans-serif;
            display:inline-flex;
            align-items:center;
            justify-content:center;
        }

        @media (max-width: 1100px){
            .rr-content{
                margin-left:0;
                width:100%;
                padding:20px 16px;
            }

            .rr-topbar{
                flex-direction:column;
                align-items:stretch;
            }

            .rr-btn-create{
                align-self:flex-start;
                margin-top:0;
            }

            .rr-filter-grid{
                grid-template-columns:1fr;
            }

            .rr-filter-actions{
                justify-content:flex-start;
            }

            .rr-table-card{
                overflow-x:auto;
            }

            .rr-table-header,
            .rr-table-row{
                min-width:1020px;
            }
        }

        @media (max-width: 768px){
            .rr-title{
                font-size:32px;
            }
        }
    </style>
</head>
<body>

    <%@include file="sidebar.jsp" %>

    <main class="rr-content">
        <div class="rr-page">

            <div class="rr-topbar">
                <div class="rr-title-wrap">
                    <div class="rr-kicker">Room Operations</div>
                    <h1 class="rr-title">Room Registry</h1>
                </div>

                <a href="${pageContext.request.contextPath}/manager/room-registry/create" class="rr-btn-create">
                    <i class="bi bi-plus-lg"></i> Create Room Entry
                </a>
            </div>

            <form class="rr-filter-card" action="${pageContext.request.contextPath}/manager/room-registry" method="get">
                <div class="rr-filter-grid">
                    <div class="rr-field">
                        <label>Search</label>
                        <div class="rr-search-wrap">
                            <i class="bi bi-search"></i>
                            <input class="rr-input" type="text" name="keyword"
                                   placeholder="Search by room number"
                                   value="${keyword}">
                        </div>
                    </div>

                    <div class="rr-field">
                        <label>Status</label>
                        <select name="status" class="rr-select">
                            <option value="">All Status</option>
                            <option value="1" ${status == '1' ? 'selected' : ''}>Available</option>
                            <option value="2" ${status == '2' ? 'selected' : ''}>Occupied</option>
                            <option value="3" ${status == '3' ? 'selected' : ''}>Maintenance</option>
                            <option value="4" ${status == '4' ? 'selected' : ''}>Dirty</option>
                        </select>
                    </div>

                    <div class="rr-field">
                        <label>Room Type</label>
                        <select name="roomType" class="rr-select">
                            <option value="">All Types</option>
                            <option value="Standard Single" ${roomType == 'Standard Single' ? 'selected' : ''}>Standard Single</option>
                            <option value="Standard Double" ${roomType == 'Standard Double' ? 'selected' : ''}>Standard Double</option>
                            <option value="Deluxe View Sea" ${roomType == 'Deluxe View Sea' ? 'selected' : ''}>Deluxe View Sea</option>
                            <option value="Deluxe View City" ${roomType == 'Deluxe View City' ? 'selected' : ''}>Deluxe View City</option>
                            <option value="Suite View Sea" ${roomType == 'Suite View Sea' ? 'selected' : ''}>Suite View Sea</option>
                            <option value="Suite View City" ${roomType == 'Suite View City' ? 'selected' : ''}>Suite View City</option>
                            <option value="Connecting Room" ${roomType == 'Connecting Room' ? 'selected' : ''}>Connecting Room</option>
                            <option value="Family Room" ${roomType == 'Family Room' ? 'selected' : ''}>Family Room</option>
                        </select>
                    </div>
                </div>

                <input type="hidden" name="page" value="1">

                <div class="rr-filter-actions">
                    <a class="rr-btn-reset" href="${pageContext.request.contextPath}/manager/room-registry">Reset</a>
                    <button type="submit" class="rr-btn-apply">Apply Filter</button>
                </div>
            </form>

            <div class="rr-table-card">
                <div class="rr-table-header rr-grid">
                    <div>Suite No</div>
                    <div>Classification</div>
                    <div>Level</div>
                    <div>Price</div>
                    <div>Status</div>
                    <div>Actions</div>
                </div>

                <c:forEach var="r" items="${listR}">
                    <div class="rr-table-row rr-grid">
                        <div class="rr-suite-cell">
                            <span class="rr-suite-badge">${r.roomNo}</span>
                        </div>
                        <div>
                            <div class="rr-main-title">${r.roomTypeName}</div>
                            <div class="rr-sub-title">Type ID: ${r.roomTypeId}</div>
                        </div>
                        <div><span class="rr-pill rr-level-pill">Floor ${r.floor}</span></div>
                        <div>
                            <span class="rr-pill rr-price-pill">
                                <fmt:formatNumber value="${r.price}" type="number" pattern="#,###"/> VND
                            </span>
                        </div>
                        <div>
                            <span class="rr-pill rr-status-pill ${r.statusClass}">
                                <i class="bi bi-dot"></i> ${r.statusText}
                            </span>
                        </div>
                        <div class="rr-actions">
                            <a href="${pageContext.request.contextPath}/manager/room-registry/detail?id=${r.roomId}" class="rr-action-btn" title="View">
                                <i class="bi bi-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/manager/room-registry/edit?id=${r.roomId}" class="rr-action-btn" title="Edit">
                                <i class="bi bi-pencil-square"></i>
                            </a>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty listR}">
                    <div class="p-5 text-center text-muted">No entries found matching your criteria.</div>
                </c:if>

                <div class="rr-table-footer">
                    <form action="${pageContext.request.contextPath}/manager/room-registry" method="get" class="rr-page-size">
                        <span>Show</span>
                        <input type="hidden" name="keyword" value="${keyword}">
                        <input type="hidden" name="status" value="${status}">
                        <input type="hidden" name="roomType" value="${roomType}">
                        <input type="hidden" name="page" value="1">

                        <select name="pageSize" onchange="this.form.submit()">
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                        <span>entries per page</span>
                    </form>

                    <div class="rr-pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a class="rr-page-btn"
                                   href="${pageContext.request.contextPath}/manager/room-registry?page=${currentPage - 1}&pageSize=${pageSize}&keyword=${keyword}&status=${status}&roomType=${roomType}">
                                    ← Prev
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="rr-page-btn disabled">← Prev</span>
                            </c:otherwise>
                        </c:choose>

                        <span class="rr-page-current">${currentPage}</span>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a class="rr-page-btn"
                                   href="${pageContext.request.contextPath}/manager/room-registry?page=${currentPage + 1}&pageSize=${pageSize}&keyword=${keyword}&status=${status}&roomType=${roomType}">
                                    Next →
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="rr-page-btn disabled">Next →</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </main>

</body>
</html>