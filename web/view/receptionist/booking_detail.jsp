<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Booking Detail | HMS</title>
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
            .card-custom {
                background: #fff;
                border: 1px solid #eef2f7;
                border-radius: 18px;
                box-shadow: 0 10px 30px rgba(15, 23, 42, .06);
            }
            .detail-label {
                font-size: 12px;
                color: #64748b;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 4px;
            }
            .detail-val {
                font-size: 1.1rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="d-flex">
            <jsp:include page="sidebar.jsp"/>

            <main class="hms-main">
                <!-- Header -->
                <div class="d-flex align-items-center mb-4 gap-3">
                    <a href="${pageContext.request.contextPath}/receptionist/bookings" class="btn btn-light rounded-circle shadow-sm">
                        <i class="bi bi-arrow-left"></i>
                    </a>
                    <h2 class="fw-bold m-0" style="font-family: 'Playfair Display', serif; color: #2d1f0f;">
                        Booking Details
                    </h2>
                </div>

                <!-- Detail Card -->
                <div class="card card-custom p-5">
                    <div class="row">
                        <!-- Cột trái: Thông tin khách -->
                        <div class="col-md-6 border-end pe-4">
                            <h5 class="fw-bold mb-4 text-primary"><i class="bi bi-person-lines-fill me-2"></i>Guest Information</h5>
<!--
                            <div class="detail-label">Booking ID</div>
                            <div class="detail-val text-primary">#${booking.bookingId}</div> -->

                            <div class="detail-label">Guest Name</div>
                            <div class="detail-val">${booking.customerName}</div>

                            <div class="detail-label">Phone Number</div>
                            <div class="detail-val">${booking.phone}</div>
                        </div>

                        <!-- Cột phải: Thông tin Booking & Tiền cọc -->
                        <div class="col-md-6 ps-4">
                            <h5 class="fw-bold mb-4 text-success"><i class="bi bi-calendar2-check-fill me-2"></i>Stay Details</h5>

                            <div class="detail-label">Booking Code</div>
                            <div class="detail-val text-primary">BK-${booking.bookingId}</div>

                            <div class="detail-label">Room Type</div>
                            <div class="detail-val">${empty booking.roomTypeName ? '-' : booking.roomTypeName} x ${booking.quantity}</div>

                            <!-- 
                            <div class="detail-label">Rooms</div>
                            <div class="detail-val">${booking.quantity}</div>    -->

                            <div class="detail-label">Check-in Date</div>
                            <div class="detail-val"><fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/></div>

                            <div class="detail-label">Check-out Date</div>
                            <div class="detail-val mb-4"><fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/></div>

                            <hr class="mb-4">

                            <div class="d-flex justify-content-between mb-2">
                                <span class="detail-label m-0">Total Amount</span>
                                <span class="fw-bold fs-5 text-dark"><fmt:formatNumber value="${booking.totalAmount}" type="number"/> đ</span>
                            </div>

                            <div class="d-flex justify-content-between mb-2">
                                <span class="detail-label m-0">Deposit Paid</span>
                                <span class="fw-bold fs-5 text-success">- <fmt:formatNumber value="${booking.deposit}" type="number"/> đ</span>
                            </div>

                            <div class="d-flex justify-content-between mt-3 pt-3 border-top">
                                <span class="detail-label m-0">Balance Due (Còn thiếu)</span>
                                <span class="fw-bold fs-3 text-danger"><fmt:formatNumber value="${booking.totalAmount - booking.deposit}" type="number"/> đ</span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>