<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Deposit Payment</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist/create-booking.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

  <style>
    .pay-overlay{
      position: fixed; inset: 0;
      background: rgba(2,6,23,.55);
      display:flex; align-items:center; justify-content:center;
      padding: 28px;
      z-index: 9999;
    }
    .pay-modal{
      width: min(980px, 96vw);
      max-height: 88vh;
      overflow:auto;
      background: #0b1220;
      border-radius: 18px;
      box-shadow: 0 20px 60px rgba(0,0,0,.45);
      color:#e2e8f0;
      padding: 18px;
      position: relative;
    }
    .pay-head{
      display:flex; align-items:flex-start; justify-content:space-between;
      padding: 6px 6px 14px 6px;
      border-bottom: 1px solid rgba(148,163,184,.18);
      margin-bottom: 14px;
    }
    .pay-grid{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px;
    }
    .pay-card{
      background: rgba(255,255,255,.03);
      border: 1px solid rgba(148,163,184,.14);
      border-radius: 16px;
      padding: 14px;
    }
    .pay-method{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }
    .method-btn{
      border-radius: 16px;
      border: 1px solid rgba(148,163,184,.18);
      background: rgba(255,255,255,.04);
      padding: 18px;
      color:#e2e8f0;
      width:100%;
    }
    .method-btn:hover{ background: rgba(255,255,255,.06); }
    
    .active-method {
    background: rgba(59,130,246,.2) !important;
    border-color: #3b82f6 !important;
    color: #60a5fa !important;
}
  </style>
</head>

<body>
<div class="d-flex">
  <% request.setAttribute("active", "create_booking"); %>
  <jsp:include page="sidebar.jsp"/>

  <main class="hms-main">
    <div class="d-flex align-items-center gap-2 mb-3">
      <a class="btn btn-light border" href="${pageContext.request.contextPath}/receptionist/booking/customer?holdId=${holdId}">
        <i class="bi bi-chevron-left"></i>
      </a>
      <div>
        <div class="fw-bold fs-4">DEPOSIT PAYMENT</div>
        <div class="text-secondary">Choose payment method to collect deposit.</div>
      </div>
    </div>

    

    <!-- Overlay modal always show (giống ảnh bạn) -->
    <div class="pay-overlay">
      <div class="pay-modal">
        <div class="pay-head">
          <div>
            <div class="fw-bold" style="font-size:18px;">FINAL BILL SUMMARY</div>
            <div class="small text-secondary">Hold: #${holdId}</div>
          </div>
          <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/receptionist/booking/customer?holdId=${holdId}">
            <i class="bi bi-x-lg"></i>
          </a>
        </div>
            
            <c:if test="${not empty errors}">
                    <div class="alert alert-danger mb-3 shadow-sm">
                        <c:forEach var="e" items="${errors}"><i class="bi bi-exclamation-triangle-fill me-2"></i><b>LỖI:</b> ${e}<br/></c:forEach>
                    </div>
                </c:if>
            

        <div class="pay-grid">
          <!-- LEFT -->
          <div class="pay-card">
            <div class="section-title mb-3">STAY DETAILS</div>

            <div class="d-flex justify-content-between">
              <div class="sum-k">Room Type</div>
              <div class="sum-v">${roomTypeName}</div>
            </div>
            <div class="d-flex justify-content-between mt-2">
              <div class="sum-k">Dates</div>
              <div class="sum-v">
                <fmt:formatDate value="${checkIn}" pattern="yyyy-MM-dd"/> -
                <fmt:formatDate value="${checkOut}" pattern="yyyy-MM-dd"/>
              </div>
            </div>
            <div class="d-flex justify-content-between mt-2">
              <div class="sum-k">Duration</div>
              <div class="sum-v">${nights} nights</div>
            </div>
            <div class="d-flex justify-content-between mt-2">
              <div class="sum-k">Rooms</div>
              <div class="sum-v">${rooms}</div>
            </div>

            <hr style="border-color:rgba(148,163,184,.18);" class="my-3">

            <div class="section-title mb-2">FINANCIAL SUMMARY</div>
            <div class="d-flex justify-content-between">
              <div class="sum-k">Rate / night</div>
              <div class="sum-v"><fmt:formatNumber value="${rate}" type="number"/> đ</div>
            </div>
            <div class="d-flex justify-content-between mt-2">
              <div class="sum-k">Total</div>
              <div class="sum-v"><fmt:formatNumber value="${total}" type="number"/> đ</div>
            </div>

            <div class="mt-3 p-3 rounded-3" style="background:rgba(59,130,246,.12);border:1px solid rgba(59,130,246,.25);">
              <div class="fw-bold" style="color:#93c5fd;">SỐ TIỀN CẦN ĐẶT CỌC (50%)</div>
              <div class="small" style="color:#cbd5e1;">Non-refundable deposit</div>
              <div class="mt-2 fw-bold" style="font-size:22px;color:#60a5fa;">
                <fmt:formatNumber value="${deposit}" type="number"/> đ
              </div>
            </div>
          </div>

          <!-- RIGHT -->
          <div class="pay-card">
            <div class="section-title mb-3">SELECT PAYMENT METHOD</div>

            <form id="paymentForm" method="post" action="${pageContext.request.contextPath}/receptionist/booking/deposit">
    <input type="hidden" name="holdId" value="${holdId}">
    
    <!-- Trường ẩn chứa phương thức thanh toán sẽ gửi lên server -->
    <input type="hidden" name="method" id="selectedMethodInput" value="CASH">

    <div class="pay-method">
        <!-- Nút chọn Tiền mặt (đổi type="button" để không submit ngay) -->
        <button class="method-btn" type="button" id="btnCash" onclick="selectMethod('CASH')">
            <div class="mb-2"><i class="bi bi-credit-card-2-front" style="font-size:26px;"></i></div>
            <div class="fw-bold">TIỀN MẶT</div>
        </button>

        <!-- Nút chọn QR -->
        <button class="method-btn" type="button" id="btnQR" onclick="selectMethod('QR')">
            <div class="mb-2"><i class="bi bi-qr-code" style="font-size:26px;"></i></div>
            <div class="fw-bold">MÃ QR</div>
        </button>
    </div>

    <!-- Khu vực hiển thị linh hoạt (hiện QR hoặc hướng dẫn thu tiền) -->
    <div id="dynamicPaymentArea" class="mt-4 text-center"></div>

    <!-- Nút xác nhận cuối cùng (Mặc định ẩn, chỉ hiện khi chọn phương thức) -->
    <button type="submit" class="btn btn-primary w-100 mt-4 fw-bold p-3" style="border-radius: 12px; display: none;" id="btnConfirmPayment">
        XÁC NHẬN ĐÃ NHẬN TIỀN <i class="bi bi-check-circle ms-2"></i>
    </button>
</form>
          </div>

        </div>
      </div>
    </div>

  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // CẤU HÌNH TÀI KHOẢN NGÂN HÀNG KHÁCH SẠN
    const BANK_ID = "TPB"; // Ví dụ: MB, VCB, TCB, ACB...
    const ACCOUNT_NO = "69168259369"; // Số tài khoản
    const ACCOUNT_NAME = "TRAN MINH DUC"; // Tên chủ tài khoản

    // Lấy số tiền và mã giữ phòng từ Server gửi xuống (JSP)
    const AMOUNT = "${deposit}"; 
    const ADD_INFO = "Coc phong Hold ${holdId}"; // Nội dung chuyển khoản

    function selectMethod(method) {
        // Cập nhật giá trị gửi lên server
        document.getElementById('selectedMethodInput').value = method;

        // Reset màu các nút
        document.getElementById('btnCash').classList.remove('active-method');
        document.getElementById('btnQR').classList.remove('active-method');

        const area = document.getElementById('dynamicPaymentArea');
        const btnConfirm = document.getElementById('btnConfirmPayment');

        if (method === 'CASH') {
            document.getElementById('btnCash').classList.add('active-method');
            area.innerHTML = 
                '<div class="p-4 rounded-3" style="background: rgba(255,255,255,.05); border: 1px dashed rgba(255,255,255,.2);">' +
                    '<i class="bi bi-cash-stack mb-2 d-block text-success" style="font-size: 2.5rem;"></i>' +
                    '<p class="mb-0 text-secondary">Vui lòng thu tiền mặt từ khách hàng:</p>' +
                    '<h3 class="fw-bold text-success mt-2"><fmt:formatNumber value="${deposit}" type="number"/> đ</h3>' +
                '</div>';
            btnConfirm.style.display = 'block';
            
        } else if (method === 'QR') {
            document.getElementById('btnQR').classList.add('active-method');
            
            // ĐÃ SỬA LỖI: Dùng cộng chuỗi (+) thay cho  để không bị Tomcat báo lỗi
            const qrUrl = "https://img.vietqr.io/image/" + BANK_ID + "-" + ACCOUNT_NO + "-compact2.png?amount=" + AMOUNT + "&addInfo=" + encodeURIComponent(ADD_INFO) + "&accountName=" + encodeURIComponent(ACCOUNT_NAME);
            
            area.innerHTML = 
                '<div class="p-3 rounded-3" style="background: #fff; display: inline-block;">' +
                    '<img src="' + qrUrl + '" alt="VietQR" style="max-width: 220px; border-radius: 8px;">' +
                    '<p class="mt-2 mb-0 fw-bold text-dark small">Quét mã để thanh toán</p>' +
                '</div>' +
                '<p class="mt-3 text-secondary small"><i class="bi bi-info-circle me-1"></i>Vui lòng kiểm tra ứng dụng ngân hàng để đảm bảo đã nhận được <b class="text-white"><fmt:formatNumber value="${deposit}" type="number"/> đ</b> trước khi bấm xác nhận.</p>';
            
            btnConfirm.style.display = 'block';
        }
    }
    // Mặc định chọn Tiền mặt khi load trang
    document.addEventListener("DOMContentLoaded", () => {
        selectMethod('CASH');
    });
</script>
</body>
</html>