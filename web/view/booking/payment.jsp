<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Payment | Regal Quintet Hotel</title>

  <link rel="stylesheet" href="${ctx}/assets/css/booking/payment.css"/>
</head>

<body>

<!-- ===== TOP HEADER (SAME AS CONFIRM) ===== -->
<header class="cf-header">
  <div class="cf-header__left">
    <div class="cf-logoMark">
      <span class="d1"></span><span class="d2"></span><span class="d3"></span>
    </div>
    <div class="cf-brandText">Regal Quintet Hotel</div>
  </div>

  <div class="cf-steps">
    <div class="cf-step">
      <span class="cf-dot is-done">1</span>
      <span class="cf-stepLabel">Billing Information</span>
      <span class="cf-line is-on"></span>
    </div>

    <div class="cf-step">
      <span class="cf-dot is-active">2</span>
      <span class="cf-stepLabel is-active">Payment</span>
      <span class="cf-line"></span>
    </div>

    <div class="cf-step">
      <span class="cf-dot">3</span>
      <span class="cf-stepLabel">Confirmation</span>
    </div>
  </div>

  <div class="cf-header__right">
    <span class="cf-guestDot">G</span>
    <span class="cf-guestText">Guest</span>
  </div>
</header>

<!-- ===== HOLD BANNER (SAME AS CONFIRM) ===== -->
<div class="cf-holdbar">
  <b>We are holding this price for you...</b>
  <span class="cf-clock">🕒</span>
  <span class="cf-timer" id="bannerTimer">--:--</span>
</div>

<main class="pay-wrap">

  <!-- LEFT: PAYMENT -->
  <section class="pay-card">
    <h2 class="pay-title">Deposit Payment</h2>
    <div class="pay-sub">WAITING FOR DEPOSIT PAYMENT</div>

    <div class="pay-qrBox">
      <!-- TODO: thay QR placeholder bằng <img src="data:image/png;base64,${qrBase64}"> -->
      <div class="pay-qrPlaceholder">QR</div>
    </div>

    <div class="pay-amount">
      <fmt:formatNumber value="${deposit}" type="number" groupingUsed="true"/> đ
    </div>

    <div class="pay-meta">
      <div class="pay-row">
        <span class="k">Transfer Content</span>
        <b class="v">HOLD-${holdId}</b>
      </div>
      <div class="pay-row">
        <span class="k">Hold Time</span>
        <span class="v pay-timer" id="holdTimer">--:--</span>
      </div>
    </div>

    <div class="pay-actions">

  <!-- Nút quay lại -->
  <a href="${ctx}/booking/confirm?holdId=${holdId}" class="pay-btn-secondary">
    QUAY LẠI
  </a>

  <!-- Nút xác nhận -->
  <form method="post" action="${ctx}/booking/payment" class="pay-form">
    <input type="hidden" name="holdId" value="${holdId}">
    <button type="submit" class="pay-btn" id="confirmBtn">
      XÁC NHẬN ĐÃ THANH TOÁN
    </button>
  </form>

</div>  </section>

  <!-- RIGHT: SUMMARY -->
  <aside class="pay-card sum-card">
  <div class="sum-dates">
    <div class="sum-date">
      <div class="sum-cap">CHECK-IN</div>
      <div class="sum-val">${checkIn}</div>
    </div>
    <div class="sum-date">
      <div class="sum-cap">CHECK-OUT</div>
      <div class="sum-val">${checkOut}</div>
    </div>
  </div>

  <div class="sum-room">
    <div class="sum-avatar">ROOM</div>
    <div class="sum-roomInfo">
      <div class="sum-roomTitle">1x ${roomTypeName}</div>
      <div class="sum-roomSub">${nights} nights • ${guests} adults</div>
    </div>
  </div>

  <div class="sum-money">
    <div class="sum-line">
      <span class="sum-left">TOTAL</span>
      <b class="sum-right">
        <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
      </b>
    </div>

    <div class="sum-line is-strong">
      <span class="sum-left">DEPOSIT (50%)</span>
      <b class="sum-right">
        <fmt:formatNumber value="${deposit}" type="number" groupingUsed="true"/> đ
      </b>
    </div>
  </div>
</aside>

</main>

<!-- JS needs these globals -->
<script>
  window.__PAY_EXPIRES_AT__ = Number("${expiresAtMillis}");
</script>
<script src="${ctx}/assets/js/booking/payment.js"></script>

</body>
</html>