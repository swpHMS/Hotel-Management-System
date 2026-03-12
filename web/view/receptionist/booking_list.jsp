<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Booking List</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist/booking-list.css"/>

        <style>
            /* BOOKING FILTER BAR */
            .booking-filter-bar {
                background: #ece8e2;
                border: 1px solid #d8d0c4;
                border-radius: 22px;
                padding: 18px 18px 20px;
                box-shadow: 0 3px 10px rgba(50,35,20,.04);
            }
            /* GRID LAYOUT */
            .booking-filter-grid {
                display: grid;
                grid-template-columns: 2.2fr 1fr 1fr 1fr;
                gap: 16px;
                align-items: end;
            }
            /* FILTER ITEM */
            .booking-filter-item {
                display: flex;
                flex-direction: column;
            }
            /* LABEL */
            .booking-filter-label {
                font-size: 0.74rem;
                font-weight: 800;
                letter-spacing: .18em;
                color: #a18868;
                margin-bottom: 8px;
            }
            /* INPUT + SELECT */
            .booking-filter-control {
                width: 100%;
                height: 46px;
                border: 1px solid #d4cabd;
                border-radius: 14px;
                background: #f3efe8;
                padding: 0 14px;
                outline: none;
                box-shadow: none;
                color: #4d3720;
                font-weight: 500;
                font-size: 0.95rem;
                transition: all .15s ease;
            }
            .booking-filter-control:focus {
                border-color: #c4b7a3;
                background: #f7f4ee;
            }
            /* SEARCH BOX */
            .booking-search-box {
                position: relative;
            }
            .booking-search-icon {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: #9f8767;
                font-size: 1rem;
            }
            .booking-search-input {
                padding-left: 40px !important;
            }
            /* BUTTON AREA */
            .booking-filter-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 16px;
            }
            /* RESET BUTTON */
            .btn-booking-reset {
                height: 42px;
                padding: 0 18px;
                border-radius: 12px;
                border: 1px solid #d4cabd;
                background: #f1ece4;
                color: #5a4630;
                font-weight: 600;
                font-size: 0.92rem;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }
            .btn-booking-reset:hover {
                background: #ebe4da;
            }
            /* APPLY BUTTON */
            .btn-booking-apply {
                height: 42px;
                padding: 0 22px;
                border-radius: 12px;
                border: none;
                background: #3a2a15;
                color: white;
                font-weight: 700;
                font-size: 0.92rem;
                transition: all .15s ease;
            }
            .btn-booking-apply:hover {
                background: #2e2111;
                transform: translateY(-1px);
            }
            /* RESPONSIVE*/
            @media (max-width: 1200px) {
                .booking-filter-grid {
                    grid-template-columns: 1fr 1fr;
                }
            }
            @media (max-width: 768px) {
                .booking-filter-grid {
                    grid-template-columns: 1fr;
                }
                .booking-filter-actions {
                    flex-direction: column;
                    align-items: stretch;
                }
                .btn-booking-reset,
                .btn-booking-apply {
                    width: 100%;
                }
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <jsp:include page="sidebar.jsp"/>

            <main class="hms-main p-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="page-title mb-0">BOOKING LIST</h2>
                    <a href="${pageContext.request.contextPath}/receptionist/booking/create"
                       class="btn btn-dark fw-bold rounded-pill px-4">
                        <i class="bi bi-plus-lg me-1"></i> New Booking
                    </a>
                </div>

                <div class="booking-filter-bar mb-4">

                    <form method="get"
                          action="${pageContext.request.contextPath}/receptionist/bookings">
                        <div class="booking-filter-grid">
                            <!-- SEARCH -->
                            <div class="booking-filter-item booking-filter-search">
                                <label class="booking-filter-label">SEARCH</label>
                                <div class="booking-search-box">
                                    <i class="bi bi-search booking-search-icon"></i>
                                    <input type="text" name="keyword" value="${param.keyword}"
                                           class="booking-filter-control booking-search-input"
                                           placeholder="Search by booking_id, guest name">
                                </div>
                            </div>

                            <!-- STATUS -->
                            <div class="booking-filter-item">
                                <label class="booking-filter-label">STATUS</label>
                                <select name="status" class="booking-filter-control">
                                    <option value="">All Status</option>
                                    <option value="1" ${param.status == '1' ? 'selected' : ''}>
                                        Pending
                                    </option>
                                    <option value="2" ${param.status == '2' ? 'selected' : ''}>
                                        Confirmed
                                    </option>
                                    <option value="3" ${param.status == '3' ? 'selected' : ''}>
                                        Checked In
                                    </option>
                                    <option value="4" ${param.status == '4' ? 'selected' : ''}>
                                        Checked Out
                                    </option>
                                    <option value="5" ${param.status == '5' ? 'selected' : ''}>
                                        Cancelled
                                    </option>
                                    <option value="6" ${param.status == '6' ? 'selected' : ''}>
                                        No Show
                                    </option>
                                </select>
                            </div>

                            <!-- CHECK IN -->
                            <div class="booking-filter-item">
                                <label class="booking-filter-label">CHECK-IN</label>
                                <input type="date" name="checkInDate"
                                       value="${param.checkInDate}"
                                       class="booking-filter-control">
                            </div>

                            <!-- CHECK OUT -->
                            <div class="booking-filter-item">
                                <label class="booking-filter-label">CHECK-OUT</label>
                                <input type="date" name="checkOutDate"
                                       value="${param.checkOutDate}"
                                       class="booking-filter-control">
                            </div>
                        </div>

                        <!-- BUTTONS -->
                        <div class="booking-filter-actions">
                            <a href="${pageContext.request.contextPath}/receptionist/bookings"
                               class="btn-booking-reset">
                                Reset
                            </a>
                            <button type="submit" class="btn-booking-apply">
                                Apply Filter
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Fallback if servlet chưa set -->
                <c:if test="${empty page}">
                    <c:set var="page" value="1"/>
                </c:if>
                <c:if test="${empty size}">
                    <c:set var="size" value="10"/>
                </c:if>
                <c:if test="${empty totalPages}">
                    <c:set var="totalPages" value="1"/>
                </c:if>

                <!-- Table -->
                <div class="booking-table-container">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 custom-table">
                            <thead class="bg-light text-secondary">
                                <tr>
                                    <th class="px-4">BOOKING ID</th>
                                    <th>GUEST NAME</th>
                                    <th>PHONE</th>
                                    <th>CHECK-IN</th>
                                    <th>CHECK-OUT</th>
                                    <th>TOTAL AMOUNT</th>
                                    <th>STATUS</th>
                                    <th class="text-center">ACTION</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <tr>
                                        <td class="px-4 fw-bold text-primary">#${b.bookingId}</td>
                                        <td class="fw-bold">${b.customerName}</td>
                                        <td>${b.phone}</td>
                                        <td><fmt:formatDate value="${b.checkInDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${b.checkOutDate}" pattern="dd/MM/yyyy"/></td>
                                        <td class="fw-bold"><fmt:formatNumber value="${b.totalAmount}" type="number"/> đ</td>

                                        <!-- Status -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.status == '1'}">
                                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-2 fw-bold">PENDING</span>
                                                </c:when>
                                                <c:when test="${b.status == '2'}">
                                                    <span class="badge bg-info text-dark rounded-pill px-3 py-2 fw-bold">CONFIRMED</span>
                                                </c:when>
                                                <c:when test="${b.status == '3'}">
                                                    <span class="badge bg-primary rounded-pill px-3 py-2 fw-bold">CHECKED IN</span>
                                                </c:when>
                                                <c:when test="${b.status == '4'}">
                                                    <span class="badge bg-success rounded-pill px-3 py-2 fw-bold">CHECKED OUT</span>
                                                </c:when>
                                                <c:when test="${b.status == '5'}">
                                                    <span class="badge bg-danger rounded-pill px-3 py-2 fw-bold">CANCELLED</span>
                                                </c:when>
                                                <c:when test="${b.status == '6'}">
                                                    <span class="badge bg-dark rounded-pill px-3 py-2 fw-bold">NO SHOW</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary rounded-pill px-3 py-2 fw-bold">UNKNOWN (${b.status})</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Action -->
                                        <td class="text-center">
                                            <div class="d-flex gap-2 justify-content-center">
                                                <a href="${pageContext.request.contextPath}/receptionist/booking/detail?id=${b.bookingId}" 
                                                   class="btn btn-sm btn-light border" 
                                                   title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>

                                                <c:if test="${b.status == '1' || b.status == '2'}">
                                                    <a href="javascript:void(0);"
                                                       class="btn btn-sm btn-outline-danger"
                                                       title="Hủy Booking"
                                                       onclick="if (confirm('Bạn có chắc chắn muốn hủy đơn đặt phòng #${b.bookingId} không?\nPhòng sẽ được hoàn trả lại cho khách khác đặt.')) {
                                                                   window.location.href = '${pageContext.request.contextPath}/receptionist/booking/cancel?id=${b.bookingId}';
                                                                           }">
                                                        <i class="bi bi-x-circle"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty bookings}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">Chưa có đơn đặt phòng nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="table-footer">
                        <!-- LEFT -->
                        <form class="left" method="get" action="">
                            <span>Show</span>

                            <select name="size" onchange="this.form.submit()">
                                <option value="5"  ${size==5?'selected':''}>5</option>
                                <option value="10" ${size==10?'selected':''}>10</option>
                                <option value="20" ${size==20?'selected':''}>20</option>
                                <option value="50" ${size==50?'selected':''}>50</option>
                            </select>

                            <span>entries per page</span>
                            <input type="hidden" name="page" value="1"/>
                        </form>

                        <!-- RIGHT -->
                        <nav>
                            <ul class="pagination mb-0">
                                <li class="page-item ${page==1?'disabled':''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/receptionist/bookings?page=${page-1}&size=${size}&keyword=${param.keyword}&status=${param.status}&checkInDate=${param.checkInDate}&checkOutDate=${param.checkOutDate}">
                                        ← Prev
                                    </a>
                                </li>

                                <li class="page-item active">
                                    <span class="page-link">${page}</span>
                                </li>

                                <li class="page-item ${page>=totalPages?'disabled':''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/receptionist/bookings?page=${page+1}&size=${size}&keyword=${param.keyword}&status=${param.status}&checkInDate=${param.checkInDate}&checkOutDate=${param.checkOutDate}">
                                        Next →
                                    </a>                    
                                </li>
                            </ul>
                        </nav>
                    </div>

                </div>
            </main>
        </div>

        <!-- Toast success -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100">
                <div id="successToast" class="toast align-items-center text-white bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i> ${sessionScope.successMsg}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <!-- Toast error -->
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100">
                <div id="errorToast" class="toast align-items-center text-white bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold">
                            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> ${sessionScope.errorMsg}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                document.addEventListener("DOMContentLoaded", function () {
                                    var s = document.getElementById("successToast");
                                    if (s)
                                        new bootstrap.Toast(s, {delay: 4000}).show();

                                    var e = document.getElementById("errorToast");
                                    if (e)
                                        new bootstrap.Toast(e, {delay: 5000}).show();
                                });
        </script>
    </body>
</html>