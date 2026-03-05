<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- =========================================================
     ✅ SUCCESS.JSP (FIX EMAIL)
     Ưu tiên email theo HOLD (ổn định khi VNPay return):
       1) sessionScope["HOLD_{holdId}_email"]
       2) session user/account/currentUser/profile -> u.email
       3) request attribute: customerEmail / email
       4) param.email
       5) fallback "(không xác định)"
   ========================================================= --%>

<c:set var="holdId" value="${not empty param.holdId ? param.holdId : requestScope.holdId}" />
<c:set var="displayEmail" value="" />

<%-- (1) Email theo HOLD id --%>
<c:if test="${not empty holdId}">
  <c:set var="displayEmail" value="${sessionScope['HOLD_'.concat(holdId).concat('_email')]}" />
</c:if>

<%-- (2) Fallback: email từ session user (nếu có login) --%>
<c:if test="${empty displayEmail}">
  <c:set var="u" value="${sessionScope.user}" />
  <c:if test="${empty u}">
    <c:set var="u" value="${sessionScope.account}" />
  </c:if>
  <c:if test="${empty u}">
    <c:set var="u" value="${sessionScope.currentUser}" />
  </c:if>
  <c:if test="${empty u}">
    <c:set var="u" value="${sessionScope.profile}" />
  </c:if>

  <c:set var="displayEmail" value="${u.email}" />
</c:if>

<%-- (3) Fallback: request attribute (nếu servlet có set) --%>
<c:if test="${empty displayEmail}">
  <c:set var="displayEmail" value="${customerEmail}" />
</c:if>
<c:if test="${empty displayEmail}">
  <c:set var="displayEmail" value="${email}" />
</c:if>

<%-- (4) Fallback: query param --%>
<c:if test="${empty displayEmail}">
  <c:set var="displayEmail" value="${param.email}" />
</c:if>

<%-- (5) Fallback cuối --%>
<c:if test="${empty displayEmail}">
  <c:set var="displayEmail" value="(không xác định)" />
</c:if>

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
  <b class="sc-code">${bookingCode}</b>
</div>

      <div class="sc-table">
        <div class="sc-row">
          <div class="sc-k">MÃ ĐẶT CHỖ</div>
          <div class="sc-v">
            <c:choose>
  <c:when test="${not empty bookingCode}">${bookingCode}</c:when>
  <c:when test="${not empty holdId}">#HOLD-${holdId}</c:when>
  <c:otherwise>#N/A</c:otherwise>
</c:choose>
          </div>
        </div>

        <div class="sc-row">
          <div class="sc-k">KHÁCH HÀNG</div>
          <div class="sc-v">${displayEmail}</div>
        </div>

        <div class="sc-row">
          <div class="sc-k">PHÒNG</div>
          <div class="sc-v">${roomName}</div>
        </div>
        <div class="sc-row">
          <div class="sc-k">NGÀY NHẬN PHÒNG</div>
          <div class="sc-v">${checkIn}</div>
        </div>

        <c:if test="${not empty amount}">
          <div class="sc-row">
            <div class="sc-k">SỐ TIỀN</div>
            <div class="sc-v">${amount}</div>
          </div>
        </c:if>
      </div>

      <div class="sc-note">
        Một email xác nhận đã được gửi đến <b>${displayEmail}</b>.<br/>
        Vui lòng kiểm tra hộp thư để biết thêm chi tiết.
      </div>

      <a class="sc-btn" href="${ctx}/home">QUAY LẠI TRANG CHỦ</a>
    </div>
  </div>
</body>
</html>