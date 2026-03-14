<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Check-out Management | HMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,800&family=DM+Sans:wght@500;600;700;800;900&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist/dashboard-styles.css"/>

    <style>
        :root{
            --bg:#f5f0e8;
            --bg2:#ede7da;
            --paper:#faf7f2;
            --card:#f8f4ee;
            --thead:#efe8dc;
            --border:#e0d8cc;
            --line:#e7dfd3;
            --ink:#2c2416;
            --ink-mid:#5a4e3c;
            --ink-soft:#9c8e7a;
            --blue:#2f66ff;
            --pill:#e9e1d2;
            --checkout:#dc2626;
            --checkout-bg:#fee2e2;
            --checkout-br:#fca5a5;
            --shadow:0 4px 16px rgba(44,36,22,.05);
        }

        *{
            box-sizing:border-box;
        }

        body{
            background:var(--bg);
            font-family:'DM Sans', sans-serif;
            color:var(--ink);
            margin:0;
        }

        .hms-main{
            flex:1;
            padding:32px 28px;
        }

        .dashboard-title{
            font-family:'Fraunces', serif;
            color:#11284b;
            letter-spacing:.02em;
            margin:0;
        }

        /* ================= FILTER ================= */
        

        .search-pill:focus-within{
            border-color:#d1d5db;
            box-shadow:0 4px 16px rgba(0,0,0,0.06);
        }

        .search-pill i{
            color:#9ca3af;
            font-size:1.1rem;
            margin-right:14px;
        }

        .search-pill input{
            border:none;
            outline:none;
            background:transparent;
            width:100%;
            color:#111827;
            font-size:.95rem;
            font-weight:500;
        }

        .search-pill input::placeholder{
            color:#9ca3af;
        }


        .btn-apply-pill:hover{
            background:#1f2937;
            transform:translateY(-1px);
        }

        .btn-reset-txt:hover{
            color:#111827;
        }

        /* ================= TABLE CARD ================= */
        .table-card{
            background:var(--card);
            border:1px solid var(--border);
            border-radius:28px;
            overflow:hidden;
            box-shadow:var(--shadow);
        }

        .hms-table{
            width:100%;
            border-collapse:separate;
            border-spacing:0;
        }

        .hms-table thead th{
            background:var(--thead);
            color:#a17f5c;
            text-transform:uppercase;
            letter-spacing:.12em;
            font-size:.88rem;
            font-weight:800;
            padding:18px 22px;
            border-bottom:1px solid var(--border);
            white-space:nowrap;
        }

        .hms-table thead th:first-child{
            border-top-left-radius:28px;
        }

        .hms-table thead th:last-child{
            border-top-right-radius:28px;
        }

        .hms-table tbody td{
            padding:20px 22px;
            border-bottom:1px solid var(--line);
            vertical-align:middle;
            font-size:1rem;
            font-weight:600;
            color:var(--ink);
            background:transparent;
        }

        .hms-table tbody tr:last-child td{
            border-bottom:none;
        }

        .hms-table .text-left{
            text-align:left;
        }

        .cell-id{
            width:120px;
        }

        .booking-id-btn{
            color:var(--blue);
            font-weight:800;
            font-size:1rem;
            text-decoration:none;
        }

        .cell-name{
            color:var(--ink);
            font-weight:800;
        }

        .tag-pill{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-height:36px;
            padding:8px 16px;
            border-radius:14px;
            background:var(--pill);
            color:#b17a1d;
            font-weight:800;
            font-size:.92rem;
            white-space:nowrap;
        }

        .cell-muted{
            color:var(--ink);
            font-weight:700;
            line-height:1.5;
        }

        .deposit-value{
            font-weight:900;
            font-size:14px;
            color:var(--ink);
        }

        .deposit-status{
            font-size:.7rem;
            font-weight:900;
            letter-spacing:.05em;
            text-transform:uppercase;
            margin-top:4px;
        }

        .dep-ok{
            color:#10b981;
        }

        .dep-no{
            color:#ef4444;
        }

        .action-cell{
            text-align:right;
        }

        .action-btns{
            display:flex;
            justify-content:flex-end;
        }

        .btn-action{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap:10px;
            min-width:170px;
            height:48px;
            padding:0 20px;
            border-radius:16px;
            text-decoration:none;
            font-weight:800;
            font-size:1rem;
            transition:all .2s ease;
        }

        .btn-checkout{
            background:var(--checkout-bg);
            color:var(--checkout);
            border:1.5px solid var(--checkout-br);
        }

        .btn-checkout:hover{
            background:#ffd6d6;
            color:#dc2626;
        }

        /* ================= FOOTER / PAGINATION ================= */
        .table-footer{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:16px;
            padding:18px 22px 22px;
            border-top:1px solid var(--border);
            background:#fbf8f3;
            flex-wrap:wrap;
        }

        .footer-left{
            color:var(--ink-mid);
            font-weight:600;
            font-size:.95rem;
        }

        .footer-left form{
            margin:0;
        }

        .footer-left select{
            height:38px;
            border-radius:12px;
            border:1px solid #d6cab9;
            background:#fff;
            padding:0 10px;
            color:var(--ink);
            font-weight:700;
            outline:none;
        }

        .pager{
            display:flex;
            align-items:center;
            gap:10px;
        }

        .btn-ghost{
            height:40px;
            min-width:40px;
            padding:0 14px;
            border-radius:12px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            text-decoration:none;
            font-weight:700;
            background:#fff;
            border:1px solid #d6cab9;
            color:var(--ink-mid);
            transition:.2s ease;
        }

        .btn-ghost:hover{
            background:#f1eadf;
            color:var(--ink);
        }

        .btn-ghost.disabled{
            pointer-events:none;
            opacity:.45;
        }

        .page-pill{
            height:40px;
            min-width:40px;
            padding:0 14px;
            border-radius:12px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            font-weight:700;
            background:#3a2a16;
            color:#fff;
            border:1px solid #3a2a16;
        }

        @media (max-width: 992px){
            .hms-main{
                padding:20px 16px 24px;
            }

            .table-card{
                overflow-x:auto;
            }

            .hms-table{
                min-width:900px;
            }
        }
        
        /* ================= FILTER CARD - GIỐNG MẪU ================= */
.checkout-filter-card{
    background: #f8f5ef;
    border: 1px solid #ddd3c4;
    border-radius: 24px;
    padding: 16px 18px 18px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(44, 36, 22, 0.03);
}

.checkout-filter-grid{
    display: grid;
    grid-template-columns: 2.1fr 1fr 1fr;
    gap: 14px;
    align-items: end;
}

.checkout-filter-group{
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.checkout-filter-label{
    font-size: 0.78rem;
    font-weight: 800;
    letter-spacing: 0.16em;
    text-transform: uppercase;
    color: #a38360;
    margin: 0;
}

.checkout-search-box{
    position: relative;
}

.checkout-search-box i{
    position: absolute;
    top: 50%;
    left: 15px;
    transform: translateY(-50%);
    color: #a88f73;
    font-size: 0.95rem;
}

.checkout-search-box input,
        .checkout-select-box {
            width: 100%;
            height: 46px; /* Cân bằng chiều cao tuyệt đối */
            border: 1px solid #d8ccbb;
            border-radius: 14px;
            background: #f6f2ea;
            color: #2c2416;
            font-size: 0.92rem;
            font-weight: 600; /* Tăng độ đậm chữ lên một chút cho đồng bộ */
            outline: none;
            box-shadow: none;
            transition: all 0.2s ease;
            font-family: 'DM Sans', sans-serif;
        }

        .checkout-search-box input {
            padding: 0 14px 0 42px;
        }

        /* ===== ĐỒNG BỘ SELECT BOX (STATUS & SORT) ===== */
        .checkout-select-box {
            padding: 0 36px 0 16px; /* Chừa chỗ bên phải cho mũi tên */
            appearance: none; /* Xóa bỏ giao diện xấu mặc định của trình duyệt */
            -webkit-appearance: none;
            -moz-appearance: none;
            /* Thêm icon mũi tên màu nâu xám trùng tone màu thẻ search */
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%23a88f73' class='bi bi-chevron-down' viewBox='0 0 16 16'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 14px;
            cursor: pointer;
        }

        .checkout-search-box input:focus,
        .checkout-select-box:focus {
            border-color: #b89c79;
            background: #fbf8f3;
            box-shadow: 0 0 0 3px rgba(184, 156, 121, 0.15); /* Thêm viền sáng (glow) khi click vào */
        }

        .checkout-search-box input::placeholder {
            color: #9f8767; /* Đổi màu chữ gợi ý đồng bộ với theme */
            font-weight: 500;
        }
.checkout-filter-actions{
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 12px;
    margin-top: 14px;
}

.checkout-btn-reset{
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 82px;
    height: 42px;
    padding: 0 18px;
    border-radius: 14px;
    border: 1px solid #d8ccbb;
    background: #f8f5ef;
    color: #6f5d46;
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 800;
    transition: all 0.2s ease;
}

.checkout-btn-reset:hover{
    background: #f0eadd;
    color: #2c2416;
}

.checkout-btn-apply{
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 132px;
    height: 42px;
    padding: 0 20px;
    border: none;
    border-radius: 14px;
    background: #3b2a14;
    color: #ffffff;
    font-size: 0.92rem;
    font-weight: 800;
    transition: all 0.2s ease;
}

.checkout-btn-apply:hover{
    background: #4a3520;
}

@media (max-width: 1100px){
    .checkout-filter-grid{
        grid-template-columns: 1fr;
    }

    .checkout-filter-actions{
        justify-content: flex-start;
    }
}
    </style>
</head>
<body>

<div class="d-flex">
    <jsp:include page="sidebar.jsp"/>

    <main class="hms-main">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
    <h1 class="dashboard-title text-uppercase" style="font-size: 1.6rem;">Check-out / Departures</h1>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/receptionist/checkout?status=4" 
           class="btn fw-bold rounded-pill px-4" 
           style="background: ${param.status == '4' ? 'var(--ink)' : 'var(--paper)'}; 
                  color: ${param.status == '4' ? '#fff' : 'var(--ink-mid)'};
                  border: 1px solid ${param.status == '4' ? 'var(--ink)' : 'var(--border)'};">DEPARTURES</a>
                  
        <a href="${pageContext.request.contextPath}/receptionist/checkout?status=3" 
           class="btn fw-bold rounded-pill px-4" 
           style="background: ${param.status == '3' || empty param.status ? 'var(--ink)' : 'var(--paper)'}; 
                  color: ${param.status == '3' || empty param.status ? '#fff' : 'var(--ink-mid)'};
                  border: 1px solid ${param.status == '3' || empty param.status ? 'var(--ink)' : 'var(--border)'};">IN-HOUSE</a>

        <a href="${pageContext.request.contextPath}/receptionist/checkout?status=5" 
           class="btn fw-bold rounded-pill px-4" 
           style="background: ${param.status == '5' ? '#dc2626' : 'var(--paper)'}; 
                  color: ${param.status == '5' ? '#fff' : '#dc2626'};
                  border: 1px solid ${param.status == '5' ? '#dc2626' : '#fca5a5'};">OVERSTAY <i class="bi bi-exclamation-circle ms-1"></i></a>
    </div>
</div>

         <!-- FILTER CARD -->
        <div class="checkout-filter-card">
            <form method="get" action="${pageContext.request.contextPath}/receptionist/checkout">
                <div class="checkout-filter-grid">

                    <!-- SEARCH -->
                    <div class="checkout-filter-group checkout-filter-search">
                        <label class="checkout-filter-label">SEARCH</label>
                        <div class="checkout-search-box">
                            <i class="bi bi-search"></i>
                            <input 
                                type="text" 
                                name="keyword" 
                                value="${param.keyword}" 
                                placeholder="Search by Booking ID, Room No..." 
                            >
                        </div>
                    </div>

                    <!-- STATUS -->
                    <div class="checkout-filter-group">
                        <label class="checkout-filter-label">STATUS</label>
                        <select name="status" class="checkout-select-box">
                            <option value="">All Status</option>
                            <option value="3" ${param.status == '3' ? 'selected' : ''}>In-House</option>
                            <option value="4" ${param.status == '4' ? 'selected' : ''}>Departing Today</option>
                            <option value="5" ${param.status == '5' ? 'selected' : ''}>Overstay (Past due)</option>
                        </select>
                    </div>

                    <!-- SORT -->
                    <div class="checkout-filter-group">
                        <label class="checkout-filter-label">SORT</label>
                        <select name="sort" class="checkout-select-box">
                            <option value="Newest" ${param.sort == 'Newest' ? 'selected' : ''}>Newest</option>
                            <option value="Oldest" ${param.sort == 'Oldest' ? 'selected' : ''}>Oldest</option>
                        </select>
                    </div>

                </div>

                <div class="checkout-filter-actions">
                    <a href="${pageContext.request.contextPath}/receptionist/checkout" class="checkout-btn-reset">
                        Reset
                    </a>
                    <button type="submit" class="checkout-btn-apply">
                        Apply Filter
                    </button>
                </div>
            </form>
        </div>
        <!-- TABLE -->
        <div class="table-card mt-2">
            <table class="hms-table">
                <thead>
                    <tr>
                        <th style="width:140px" class="text-left">BOOKING ID</th>
                        <th class="text-left" style="width:280px">GUEST</th>
                        <th style="width:180px">ROOM</th>
                        <th style="width:190px">STAY</th>
                        <th style="width:170px">DEPOSIT</th>
                        <th style="width:220px; text-align:right">ACTION</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${checkoutList}">
                        <tr>
                            <td class="cell-id text-left">
                                <span class="booking-id-btn">#${c.bookingId}</span>
                            </td>

                            <td class="cell-name text-left">
                                <div>${c.customerName}</div>
                                <div style="font-size:12px; color:var(--ink-soft); font-weight:600;">
                                    ${c.phone != null ? c.phone : '—'}
                                </div>
                            </td>

                            <td>
                                <span class="tag-pill">${not empty c.roomNo ? c.roomNo : '—'}</span>
                            </td>

                            <td class="cell-muted">
                                <fmt:formatDate value="${c.checkInDate}" pattern="yyyy-MM-dd"/><br>
                                <fmt:formatDate value="${c.checkOutDate}" pattern="yyyy-MM-dd"/>
                            </td>

                            <td>
                                <div class="deposit-value">
                                    <fmt:formatNumber value="${c.depositPaid}" type="number"/> đ
                                </div>
                                <c:choose>
                                    <c:when test="${c.depositPaid > 0}">
                                        <div class="deposit-status dep-ok">DEPOSIT OK</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="deposit-status dep-no">NO DEPOSIT</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="action-cell">
                                <div class="action-btns">
                                    <a class="btn-action btn-checkout"
                                       href="${pageContext.request.contextPath}/receptionist/checkout-process?bookingId=${c.bookingId}">
                                        <i class="bi bi-box-arrow-right"></i> CHECK-OUT
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty checkoutList}">
                        <tr>
                            <td colspan="6" class="py-5 text-center text-muted fw-bold">No departures found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <!-- FOOTER -->
            <div class="table-footer">
                <div class="footer-left">
                    <form method="get" action="${pageContext.request.contextPath}/receptionist/checkout" id="sizeForm" style="display:flex; align-items:center; gap:8px;">
                        <input type="hidden" name="keyword" value="${param.keyword}">
                        <input type="hidden" name="status" value="${param.status}">
                        <input type="hidden" name="sort" value="${param.sort}">
                        <input type="hidden" name="page" value="1">
                        Show
                        <select name="size" onchange="document.getElementById('sizeForm').submit()">
                            <option value="5" ${size == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${size == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${size == 20 ? 'selected' : ''}>20</option>
                        </select>
                        entries per page
                    </form>
                </div>

                <div class="pager">
                    <a class="btn-ghost ${page <= 1 ? 'disabled' : ''}"
                       href="?page=${page-1}&size=${size}&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}">
                        ← Prev
                    </a>
                    <span class="page-pill">${page}</span>
                    <a class="btn-ghost ${page >= totalPages ? 'disabled' : ''}"
                       href="?page=${page+1}&size=${size}&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}">
                        Next →
                    </a>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>