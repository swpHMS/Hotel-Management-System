<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Final Bill & Check-out | HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <!-- CSS Hệ thống -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
    
    <style>
        body {
            background-color: #f5f0e8; /* Nền ngoài sáng giống dashboard */
        }
        .hms-main {
            margin-left: 260px;
            width: calc(100% - 260px);
            padding: 30px;
            min-height: 100vh;
        }

        /* ===== DARK THEME CONTAINER (Giống Ảnh 3 & 4) ===== */
        .pay-modal {
            background: #0b1220;
            border-radius: 18px;
            box-shadow: 0 20px 60px rgba(0,0,0,.15);
            color: #e2e8f0;
            padding: 24px;
            position: relative;
            margin: 0 auto;
            max-width: 1000px;
        }
        .pay-head {
            display: flex; align-items: flex-start; justify-content: space-between;
            padding-bottom: 16px;
            border-bottom: 1px solid rgba(148,163,184,.18);
            margin-bottom: 20px;
        }
        .pay-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        .pay-card {
            background: rgba(255,255,255,.03);
            border: 1px solid rgba(148,163,184,.14);
            border-radius: 16px;
            padding: 20px;
        }

        /* ===== MÀU CHỮ & CÁC DÒNG THỐNG KÊ ===== */
        .section-title {
            font-size: 0.85rem;
            font-weight: 800;
            letter-spacing: 0.1em;
            color: #94a3b8;
            margin-bottom: 16px;
        }
        .sum-k { color: #94a3b8; font-weight: 600; font-size: 0.95rem; }
        .sum-v { font-weight: 800; color: #f8fafc; font-size: 0.95rem; text-align: right; }
        
        .service-list {
            background: rgba(0,0,0,0.2);
            border-radius: 8px;
            padding: 10px;
            margin-top: 5px;
        }

        /* ===== NÚT CHỌN PHƯƠNG THỨC THANH TOÁN ===== */
        .pay-method {
            display: grid; grid-template-columns: 1fr 1fr; gap: 12px;
        }
        .method-btn {
            border-radius: 16px;
            border: 1px solid rgba(148,163,184,.18);
            background: rgba(255,255,255,.04);
            padding: 18px;
            color: #e2e8f0;
            width: 100%;
            transition: all 0.2s;
        }
        .method-btn:hover { background: rgba(255,255,255,.08); }
        .active-method {
            background: rgba(59,130,246,.2) !important;
            border-color: #3b82f6 !important;
            color: #60a5fa !important;
        }

        /* ===== KHU VỰC TỔNG TIỀN ===== */
        .balance-box {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            border-radius: 12px;
            padding: 16px;
            margin-top: 20px;
        }
        
        /* Chỉnh nút confirm màu xanh lá mạ theo Mockup 5 */
        .btn-confirm-checkout {
            background: #10b981;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 800;
            letter-spacing: 0.5px;
            transition: all 0.2s;
        }
        .btn-confirm-checkout:hover { background: #059669; color: white; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="d-flex">
    <jsp:include page="sidebar.jsp"/>
    
    <main class="hms-main">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a class="btn btn-light border rounded-circle" href="${pageContext.request.contextPath}/receptionist/checkout" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                <i class="bi bi-arrow-left"></i>
            </a>
            <div>
                <h3 class="fw-bold mb-0 text-dark" style="font-family: 'Playfair Display', serif;">Check-out Process</h3>
                <div class="text-secondary small fw-semibold">Review final bill & collect payment</div>
            </div>
        </div>

        <div class="pay-modal">
            <!-- HEADER -->
            <div class="pay-head">
                <div>
                    <div class="fw-bold text-uppercase" style="font-size:1.2rem; letter-spacing: 1px;">FINAL BILL SUMMARY</div>
                    <div class="text-secondary mt-1">Booking: <b class="text-light">BK-${bill.bookingId}</b> - ${bill.customerName}</div>
                </div>
                <!-- Nút Refresh để Lễ tân cập nhật đồ Minibar do Staff vừa post -->
                <a href="${pageContext.request.contextPath}/receptionist/checkout-process?bookingId=${bill.bookingId}" 
                   class="btn btn-sm btn-outline-info fw-bold rounded-pill px-3">
                    <i class="bi bi-arrow-clockwise me-1"></i> Refresh Bill
                </a>
            </div>

            <div class="pay-grid">
                <!-- ================= TRÁI: STAY DETAILS & FINANCIAL ================= -->
                <div class="pay-card">
                    <!-- STAY DETAILS -->
                    <div class="section-title">STAY DETAILS</div>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <div class="sum-k"><i class="bi bi-door-closed me-2"></i>Room</div>
                        <div class="sum-v">${bill.roomTypeName} (x${bill.roomQuantity})</div>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <div class="sum-k"><i class="bi bi-clock-history me-2"></i>Duration</div>
                        <div class="sum-v">${bill.nights} nights</div>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <div class="sum-k"><i class="bi bi-calendar-event me-2"></i>Dates</div>
                        <div class="sum-v">
                            <fmt:formatDate value="${bill.checkInDate}" pattern="yyyy-MM-dd"/> &rarr; 
                            <fmt:formatDate value="${bill.checkOutDate}" pattern="yyyy-MM-dd"/>
                        </div>
                    </div>

                    <hr style="border-color:rgba(148,163,184,.18);" class="my-3">

                    <!-- FINANCIAL SUMMARY (CHUẨN MOCKUP 5) -->
                    <div class="section-title">FINANCIAL SUMMARY</div>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <div class="sum-k">Room Charges</div>
                        <div class="sum-v"><fmt:formatNumber value="${bill.roomCharges}" type="number"/> đ</div>
                    </div>

                    <!-- Hiển thị tiền dịch vụ + Chi tiết -->
                    <div class="d-flex justify-content-between mb-1 mt-3">
                        <div class="sum-k text-info">Service Charges (Minibar, Surcharge...)</div>
                        <div class="sum-v text-info"><fmt:formatNumber value="${bill.serviceCharges}" type="number"/> đ</div>
                    </div>
                    
                    <c:if test="${not empty bill.usedServices}">
                        <div class="service-list mb-3">
                            <c:forEach var="svc" items="${bill.usedServices}">
                                <div class="d-flex justify-content-between small text-secondary mt-1">
                                    <span>• ${svc.serviceName} (x${svc.quantity})</span>
                                    <span><fmt:formatNumber value="${svc.total}" type="number"/> đ</span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <hr style="border-color:rgba(148,163,184,.18);" class="my-3">

                    <!-- Tổng cộng và Tiền Cọc -->
                    <div class="d-flex justify-content-between mb-2">
                        <div class="sum-k text-white fw-bold">Total Amount</div>
                        <div class="sum-v text-white fs-5"><fmt:formatNumber value="${bill.totalAmount}" type="number"/> đ</div>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <div class="sum-k text-success fw-bold">DEPOSIT PAID</div>
                        <div class="sum-v text-success">- <fmt:formatNumber value="${bill.depositPaid}" type="number"/> đ</div>
                    </div>

                    <!-- BALANCE DUE (CẦN THU THÊM) -->
                    <div class="balance-box">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="fw-bold" style="color: #34d399; font-size: 0.9rem;">BALANCE DUE</div>
                                <div class="small text-muted">Amount to collect from guest</div>
                            </div>
                            <div class="fw-bold fs-3" style="color: #10b981;">
                                <fmt:formatNumber value="${bill.balanceDue}" type="number"/> đ
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ================= PHẢI: PAYMENT METHOD ================= -->
                <div class="pay-card">
                    <div class="section-title text-center">SELECT PAYMENT METHOD</div>
                    
                    <form id="checkoutForm" method="post" action="${pageContext.request.contextPath}/receptionist/checkout-process">
                        <input type="hidden" name="bookingId" value="${bill.bookingId}">
                        <input type="hidden" name="balanceDue" value="${bill.balanceDue}">
                        <!-- Field ẩn để Submit -->
                        <input type="hidden" name="method" id="selectedMethodInput" value="CASH">

                        <c:choose>
                            <c:when test="${bill.balanceDue > 0}">
                                <!-- Hiển thị lựa chọn thanh toán nếu khách còn nợ tiền -->
                                <div class="pay-method">
                                    <button class="method-btn" type="button" id="btnCash" onclick="selectMethod('CASH')">
                                        <div class="mb-2"><i class="bi bi-cash-stack" style="font-size:26px;"></i></div>
                                        <div class="fw-bold">TIỀN MẶT</div>
                                    </button>
                                    <button class="method-btn" type="button" id="btnQR" onclick="selectMethod('QR')">
                                        <div class="mb-2"><i class="bi bi-qr-code-scan" style="font-size:26px;"></i></div>
                                        <div class="fw-bold">MÃ QR</div>
                                    </button>
                                </div>
                                <div id="dynamicPaymentArea" class="mt-4 text-center" style="min-height: 200px;"></div>
                            </c:when>
                            
                            <c:when test="${bill.balanceDue < 0}">
                                <!-- Khách được hoàn tiền (Tiền cọc > Tổng chi phí) -->
                                <div class="text-center p-5 rounded-3 mt-3" style="background: rgba(239, 68, 68, 0.1); border: 1px dashed rgba(239, 68, 68, 0.3);">
                                    <i class="bi bi-arrow-return-left text-danger" style="font-size: 3rem;"></i>
                                    <h5 class="text-danger fw-bold mt-3">CẦN HOÀN TRẢ KHÁCH</h5>
                                    <h3 class="fw-bold text-white"><fmt:formatNumber value="${-bill.balanceDue}" type="number"/> đ</h3>
                                </div>
                            </c:when>
                            
                            <c:otherwise>
                                <!-- Balance = 0, Không cần thanh toán thêm -->
                                <div class="text-center p-5 rounded-3 mt-3" style="background: rgba(16, 185, 129, 0.1); border: 1px dashed rgba(16, 185, 129, 0.3);">
                                    <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
                                    <h5 class="text-success fw-bold mt-3">ĐÃ THANH TOÁN ĐỦ</h5>
                                    <p class="text-muted small">Khách không phát sinh thêm chi phí.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- NÚT CHỐT CHECKOUT GIỐNG ẢNH 5 -->
                        <button type="submit" class="btn w-100 btn-confirm-checkout mt-4" id="btnConfirmCheckout" 
                                onclick="return confirm('Xác nhận Check-out cho phòng này? Trạng thái phòng sẽ chuyển sang DIRTY và hóa đơn sẽ bị đóng.');">
                            XÁC NHẬN ĐÃ THU TIỀN & CHECK-OUT <i class="bi bi-check-circle ms-2"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- SCRIPTS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Config QR Ngân hàng (Giống màn hình Deposit Payment của bạn)
    const BANK_ID = "TPB";
    const ACCOUNT_NO = "69168259369";
    const ACCOUNT_NAME = "TRAN MINH DUC";
    
    // Lấy số tiền và mã hóa đơn từ Backend đẩy xuống JSP
    const AMOUNT = ${bill.balanceDue > 0 ? bill.balanceDue : 0};
    const ADD_INFO = "Thanh toan CheckOut BK" + ${bill.bookingId};

    function selectMethod(method) {
        if(AMOUNT <= 0) return; // Nếu ko nợ tiền thì ko cần render form thanh toán
        
        document.getElementById('selectedMethodInput').value = method;
        
        document.getElementById('btnCash').classList.remove('active-method');
        document.getElementById('btnQR').classList.remove('active-method');
        
        const area = document.getElementById('dynamicPaymentArea');
        const formattedAmount = new Intl.NumberFormat('vi-VN').format(AMOUNT) + " đ";

        if (method === 'CASH') {
            document.getElementById('btnCash').classList.add('active-method');
            area.innerHTML = 
                '<div class="p-4 rounded-3" style="background: rgba(255,255,255,.05); border: 1px dashed rgba(255,255,255,.2);">' +
                    '<i class="bi bi-cash-stack mb-2 d-block" style="color: #10b981; font-size: 2.5rem;"></i>' +
                    '<p class="mb-0 text-secondary">Vui lòng thu tiền mặt từ khách hàng:</p>' +
                    '<h3 class="fw-bold mt-2" style="color: #10b981;">' + formattedAmount + '</h3>' +
                '</div>';
        } else if (method === 'QR') {
            document.getElementById('btnQR').classList.add('active-method');
            const qrUrl = "https://img.vietqr.io/image/" + BANK_ID + "-" + ACCOUNT_NO + "-compact2.png?amount=" + AMOUNT + "&addInfo=" + encodeURIComponent(ADD_INFO) + "&accountName=" + encodeURIComponent(ACCOUNT_NAME);
            area.innerHTML = 
                '<div class="p-3 rounded-3" style="background: #fff; display: inline-block;">' +
                    '<img src="' + qrUrl + '" alt="VietQR" style="max-width: 220px; border-radius: 8px;">' +
                    '<p class="mt-2 mb-0 fw-bold text-dark small">Quét mã để thanh toán</p>' +
                '</div>' +
                '<p class="mt-3 text-secondary small"><i class="bi bi-info-circle me-1"></i>Vui lòng kiểm tra ứng dụng ngân hàng để đảm bảo đã nhận được <b class="text-white">' + formattedAmount + '</b> trước khi check-out.</p>';
        }
    }

    // Chạy mặc định khi trang load (nếu balance > 0)
    document.addEventListener("DOMContentLoaded", () => {
        if(AMOUNT > 0) {
            selectMethod('CASH');
        }
    });
</script>

</body>
</html>