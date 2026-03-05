<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Booking List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <!-- Load CSS chung cho Dashboard/Table -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
    </head>
    <body style="background: #f5f0e8;">

        <div class="d-flex">
            <jsp:include page="sidebar.jsp"/>

            <main class="hms-main p-4" style="margin-left: 260px; width: calc(100% - 260px);">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-0">BOOKING LIST</h2>
                        <div class="text-secondary small">Manage all reservations and guests</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/receptionist/booking/create" class="btn btn-dark fw-bold rounded-pill px-4">
                        + New Booking
                    </a>
                </div>

                <div class="bg-white rounded-4 shadow-sm overflow-hidden">
                    <table class="table table-hover align-middle mb-0 custom-table">
                        <thead class="bg-light text-secondary" style="font-size: 0.8rem;">
                            <tr>
                                <th class="py-3 px-4">BOOKING ID</th>
                                <th>GUEST NAME</th>
                                <th>PHONE</th>
                                <th>CHECK-IN</th>
                                <th>CHECK-OUT</th>
                                <th>TOTAL AMOUNT</th>
                                <th>STATUS</th>
                                <th>ACTION</th>
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
                                    <!-- CỘT STATUS: Dịch cả số và chữ thành nhãn màu sắc -->
                                    <!-- CỘT STATUS: Ánh xạ 6 trạng thái chuẩn từ Database -->
                                    <td>
                                        <c:choose>
                                            <%-- 1: PENDING (Chờ thanh toán/Đặt cọc) - Màu vàng --%>
                                            <c:when test="${b.status == '1'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-3 py-2" style="font-weight: 700;">PENDING</span>
                                            </c:when>

                                            <%-- 2: CONFIRMED (Đã xác nhận/Đã cọc) - Màu xanh lơ --%>
                                            <c:when test="${b.status == '2'}">
                                                <span class="badge bg-info text-dark rounded-pill px-3 py-2" style="font-weight: 700;">CONFIRMED</span>
                                            </c:when>

                                            <%-- 3: CHECKED_IN (Đang ở) - Màu xanh dương --%>
                                            <c:when test="${b.status == '3'}">
                                                <span class="badge bg-primary rounded-pill px-3 py-2" style="font-weight: 700;">CHECKED IN</span>
                                            </c:when>

                                            <%-- 4: CHECKED_OUT (Đã trả phòng) - Màu xanh lá --%>
                                            <c:when test="${b.status == '4'}">
                                                <span class="badge bg-success rounded-pill px-3 py-2" style="font-weight: 700;">CHECKED OUT</span>
                                            </c:when>

                                            <%-- 5: CANCELLED (Đã hủy) - Màu đỏ --%>
                                            <c:when test="${b.status == '5'}">
                                                <span class="badge bg-danger rounded-pill px-3 py-2" style="font-weight: 700;">CANCELLED</span>
                                            </c:when>

                                            <%-- 6: NO-SHOW (Không đến) - Màu đen --%>
                                            <c:when test="${b.status == '6'}">
                                                <span class="badge bg-dark rounded-pill px-3 py-2" style="font-weight: 700;">NO SHOW</span>
                                            </c:when>

                                            <%-- Phòng hờ trường hợp có mã trạng thái lạ --%>
                                            <c:otherwise>
                                                <span class="badge bg-secondary rounded-pill px-3 py-2" style="font-weight: 700;">UNKNOWN (${b.status})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- 2. SỬA CỘT ACTION: Thêm nút Hủy -->
                                    <td>
                                        <div class="d-flex gap-2 justify-content-center">
                                            <a href="#" class="btn btn-sm btn-light border" title="Xem chi tiết"><i class="bi bi-eye"></i></a>

                                            <!-- Chỉ cho phép hủy nếu đơn đang ở trạng thái 1 (PENDING) hoặc 2 (CONFIRMED) -->
                                            <c:if test="${b.status == '1' || b.status == '2'}">
                                                <a href="javascript:void(0);" 
                                                   onclick="if (confirm('Bạn có chắc chắn muốn hủy đơn đặt phòng #${b.bookingId} không?\\nPhòng sẽ được hoàn trả lại cho khách khác đặt.'))
                   window.location.href = '${pageContext.request.contextPath}/receptionist/booking/cancel?id=${b.bookingId}';" 
                                                   class="btn btn-sm btn-outline-danger" title="Hủy Booking">
                                                    <i class="bi bi-x-circle"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>

                                </tr>
                            </c:forEach>
                            <c:if test="${empty bookings}">
                                <tr><td colspan="8" class="text-center py-4 text-muted">Chưa có đơn đặt phòng nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- ============================================== -->
        <!-- POPUP THÔNG BÁO TẠO BOOKING THÀNH CÔNG TỪ SESSION -->
        <!-- ============================================== -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100">
                <div id="successToast" class="toast align-items-center text-white bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold" style="font-size: 15px;">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i> ${sessionScope.successMsg}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </div>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    var toast = new bootstrap.Toast(document.getElementById('successToast'), {delay: 4000});
                    toast.show();
                });
            </script>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <!-- POPUP LỖI KHI HỦY THẤT BẠI -->
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100">
                <div id="errorToast" class="toast align-items-center text-white bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold" style="font-size: 15px;">
                            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> ${sessionScope.errorMsg}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </div>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    var toast = new bootstrap.Toast(document.getElementById('errorToast'), {delay: 5000});
                    toast.show();
                });
            </script>
            <c:remove var="errorMsg" scope="session" />
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>