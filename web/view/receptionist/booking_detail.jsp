<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Booking Detail | HMS</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

        <style>
            body {
                background: #f5f0e8;
                font-family: system-ui, -apple-system, sans-serif;
            }

            .hms-main {
                margin-left: 260px;
                width: calc(100% - 260px);
                padding: 30px;
                min-height: 100vh;
            }

            .page-title {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                color: #2d1f0f;
            }

            .card-custom {
                background: #fff;
                border: 1px solid #ece6dd;
                border-radius: 18px;
                box-shadow: 0 10px 24px rgba(15, 23, 42, .05);
            }

            .section-title {
                font-size: 1.2rem;
                font-weight: 700;
                color: #2d1f0f;
                margin-bottom: 18px;
            }

            .detail-label {
                font-size: 12px;
                color: #7b8794;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .05em;
                margin-bottom: 4px;
            }

            .detail-val {
                font-size: 1.05rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 18px;
            }

            .summary-line {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
                gap: 16px;
            }

            .summary-line .label {
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
                color: #7b8794;
                letter-spacing: .05em;
            }

            .summary-line .value {
                font-size: 1.2rem;
                font-weight: 800;
                color: #1e293b;
            }

            .box-room {
                border: 1px solid #ece6dd;
                border-radius: 14px;
                padding: 16px;
                background: #fcfaf7;
                margin-bottom: 14px;
            }

            .room-title {
                font-size: 1.05rem;
                font-weight: 800;
                color: #2d1f0f;
                margin-bottom: 6px;
            }

            .room-sub {
                font-size: .95rem;
                color: #6b7280;
                margin-bottom: 12px;
            }

            .guest-tag {
                display: inline-block;
                background: #f1ece4;
                border: 1px solid #e3dacc;
                color: #4b5563;
                border-radius: 999px;
                padding: 8px 12px;
                margin: 4px 6px 0 0;
                font-size: .92rem;
                font-weight: 600;
            }

            .table thead th {
                background: #f8f5f0;
                color: #6b7280;
                font-size: .85rem;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .badge-soft {
                padding: 8px 12px;
                border-radius: 999px;
                font-size: .8rem;
                font-weight: 700;
            }

            .badge-success-soft {
                background: #dcfce7;
                color: #166534;
            }

            .badge-warning-soft {
                background: #fef3c7;
                color: #92400e;
            }

            .badge-danger-soft {
                background: #fee2e2;
                color: #991b1b;
            }

            .badge-secondary-soft {
                background: #e5e7eb;
                color: #374151;
            }

            @media (max-width: 768px) {
                .hms-main {
                    margin-left: 0;
                    width: 100%;
                    padding: 18px;
                }
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <jsp:include page="sidebar.jsp"/>

            <main class="hms-main">
                <!-- Header -->
                <div class="d-flex align-items-center mb-4 gap-3">
                    <a href="${pageContext.request.contextPath}/receptionist/bookings"
                       class="btn btn-light rounded-circle shadow-sm">
                        <i class="bi bi-arrow-left"></i>
                    </a>
                    <h2 class="page-title mb-0">Booking Details</h2>
                </div>

                <!-- Thông tin booking -->
                <div class="card card-custom p-4 mb-4">
                    <div class="row">
                        <div class="col-md-6 border-end pe-md-4">
                            <h5 class="section-title text-primary">
                                <i class="bi bi-person-lines-fill me-2"></i>Guest Information
                            </h5>

                            <div class="detail-label">Guest Name</div>
                            <div class="detail-val">${booking.customerName}</div>

                            <div class="detail-label">Phone Number</div>
                            <div class="detail-val">${booking.phone}</div>
                        </div>

                        <div class="col-md-6 ps-md-4 mt-4 mt-md-0">
                            <h5 class="section-title text-success">
                                <i class="bi bi-calendar2-check-fill me-2"></i>Stay Details
                            </h5>

                            <div class="detail-label">Booking Code</div>
                            <div class="detail-val text-primary">BK-${booking.bookingId}</div>

                            <div class="detail-label">Room Type</div>
                            <div class="detail-val">
                                ${empty booking.roomTypeName ? '-' : booking.roomTypeName} x ${booking.quantity}
                            </div>

                            <div class="detail-label">Check-in Date</div>
                            <div class="detail-val">
                                <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/>
                            </div>

                            <div class="detail-label">Check-out Date</div>
                            <div class="detail-val">
                                <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Phòng nào có khách nào -->
                <div class="card card-custom p-4 mb-4">
                    <h5 class="section-title">
                        <i class="bi bi-door-open-fill me-2"></i>Phòng nào có khách nào đang ở
                    </h5>

                    <c:choose>
                        <c:when test="${empty assignedRooms}">
                            <div class="text-muted">Booking này hiện chưa có phòng được assign.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${assignedRooms}">
                                <div class="box-room">
                                    <div class="room-title">Phòng ${r.roomNo}</div>
                                    <div class="room-sub">${r.roomTypeName}</div>

                                    <c:choose>
                                        <c:when test="${empty r.guests}">
                                            <div class="text-muted">Chưa có khách nào trong phòng này.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="g" items="${r.guests}">
                                                <span class="guest-tag">
                                                    ${g.fullName}
                                                    <c:if test="${not empty g.identityNumber}">
                                                        - ${g.identityNumber}
                                                    </c:if>
                                                </span>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Thanh toán -->
                <div class="card card-custom p-4">
                    <h5 class="section-title">
                        <i class="bi bi-credit-card-2-front-fill me-2"></i>Thông tin thanh toán
                    </h5>

                    <div class="mb-4">
                        <div class="summary-line">
                            <span class="label">Total Amount</span>
                            <span class="value">
                                <fmt:formatNumber value="${booking.totalAmount}" type="number"/> đ
                            </span>
                        </div>

                        <div class="summary-line">
                            <span class="label">Deposit Paid</span>
                            <span class="value text-success">
                                <fmt:formatNumber value="${booking.deposit}" type="number"/> đ
                            </span>
                        </div>

                        <div class="summary-line border-top pt-3 mt-3">
                            <span class="label">Balance Due</span>
                            <span class="value text-danger">
                                <fmt:formatNumber value="${booking.totalAmount - booking.deposit}" type="number"/> đ
                            </span>
                        </div>
                    </div>

                    <h6 class="fw-bold mb-3">Payment History</h6>

                    <c:choose>
                        <c:when test="${empty payments}">
                            <div class="text-muted">Booking này chưa có lịch sử thanh toán.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Payment ID</th>
                                            <th>Paid At</th>
                                            <th>Method</th>
                                            <th>Status</th>
                                            <th class="text-end">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${payments}">
                                            <tr>
                                                <td>#${p.paymentId}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.paidAt != null}">
                                                            <fmt:formatDate value="${p.paidAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.method == 1}">Cash</c:when>
                                                        <c:when test="${p.method == 2}">Bank Transfer</c:when>
                                                        <c:when test="${p.method == 3}">Card</c:when>
                                                        <c:otherwise>${p.method}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.status == 1}">
                                                            <span class="badge-soft badge-success-soft">Success</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 0}">
                                                            <span class="badge-soft badge-warning-soft">Pending</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 2}">
                                                            <span class="badge-soft badge-danger-soft">Failed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-soft badge-secondary-soft">${p.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end fw-bold">
                                                    <fmt:formatNumber value="${p.amount}" type="number"/> đ
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </body>
</html>