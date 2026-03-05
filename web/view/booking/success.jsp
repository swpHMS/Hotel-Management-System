<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Booking Success</title>
  <link rel="stylesheet" href="${ctx}/assets/css/booking/success.css"/>
</head>

<body>
  <div class="sc-wrap">
    <div class="sc-card">
      <div class="sc-icon">
        <div class="sc-ring">
          <span class="sc-check">✓</span>
        </div>
      </div>

      <h1 class="sc-title">ĐẶT PHÒNG THÀNH CÔNG!</h1>
      <div class="sc-sub">
        Mã đặt chỗ của bạn là:
        <b class="sc-code">#${bookingCode}</b>
      </div>

      <div class="sc-table">
        <div class="sc-row">
          <div class="sc-k">KHÁCH HÀNG</div>
          <div class="sc-v">${email}</div>
        </div>
        <div class="sc-row">
          <div class="sc-k">PHÒNG</div>
          <div class="sc-v">${roomName}</div>
        </div>
        <div class="sc-row">
          <div class="sc-k">NGÀY NHẬN PHÒNG</div>
          <div class="sc-v">${checkIn}</div>
        </div>
      </div>

      <div class="sc-note">
        Một email xác nhận đã được gửi đến <b>${email}</b>.<br/>
        Vui lòng kiểm tra hộp thư để biết thêm chi tiết.
      </div>

      <a class="sc-btn" href="${ctx}/home">QUAY LẠI TRANG CHỦ</a>
    </div>
  </div>
</body>
</html>