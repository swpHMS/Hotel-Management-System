<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Kết quả thanh toán</title>

  <style>
    :root{
      --navy:#071a33;
      --muted:#6b7280;
      --line:#e5e7eb;
      --blue:#2563eb;
      --green:#16a34a;
      --red:#ef4444;
      --card:#ffffff;
      --bg:#f5f7fb;
      --shadow: 0 30px 70px rgba(2,6,23,.12);
      --radius: 28px;
    }

    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: Inter, system-ui, Arial;
      background: radial-gradient(1200px 600px at 30% 15%, rgba(37,99,235,.12), transparent 60%),
                  radial-gradient(1000px 550px at 70% 90%, rgba(22,163,74,.12), transparent 55%),
                  var(--bg);
      color: var(--navy);
      min-height:100vh;
      display:flex;
      align-items:center;
      justify-content:center;
      padding: 28px 16px;
    }

    .card{
      width: min(980px, 100%);
      background: var(--card);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      position:relative;
      overflow:hidden;
    }

    .card:before{
      content:"";
      position:absolute;
      inset:-60px -80px auto auto;
      width: 340px;
      height: 220px;
      background: radial-gradient(circle at 30% 30%, rgba(37,99,235,.18), transparent 60%);
      transform: rotate(12deg);
    }

    .header{
      display:flex;
      gap:16px;
      align-items:center;
      padding: 28px 30px 14px;
    }

    .icon{
      width:64px; height:64px;
      border-radius: 999px;
      display:grid;
      place-items:center;
      flex:0 0 auto;
      border: 2px solid rgba(15,23,42,.08);
      background: rgba(15,23,42,.02);
    }

    .icon svg{ width:34px; height:34px; }

    .title{
      line-height:1.1;
    }
    .title h1{
      margin:0;
      font-size: 42px;
      letter-spacing:.3px;
    }
    .title p{
      margin:6px 0 0;
      color: var(--muted);
      font-size: 16px;
    }

    .divider{
      height:1px;
      background: var(--line);
      margin: 10px 30px 0;
    }

    .grid{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 0;
      padding: 6px 30px 10px;
    }

    .row{
      display:flex;
      justify-content:space-between;
      align-items:baseline;
      gap:16px;
      padding: 14px 0;
      border-bottom: 1px solid var(--line);
    }

    .row:last-child{ border-bottom:none; }

    .label{
      color: var(--muted);
      font-weight: 700;
      letter-spacing: .6px;
      font-size: 13px;
      text-transform: uppercase;
      min-width: 140px;
    }

    .value{
      font-size: 18px;
      font-weight: 800;
      text-align:right;
      color: var(--navy);
      max-width: 360px;
      word-break: break-word;
    }

    .value.code{
      color: var(--blue);
    }

    .grid > .col{
      padding: 0 18px;
    }

    .grid > .col:first-child{
      border-right: 1px solid var(--line);
      padding-left:0;
    }
    .grid > .col:last-child{
      padding-right:0;
    }

    .statusWrap{
      display:flex;
      flex-direction:column;
      align-items:center;
      gap:10px;
      padding: 14px 30px 0;
    }

    .pill{
      display:inline-flex;
      align-items:center;
      gap:10px;
      padding: 10px 16px;
      border-radius: 999px;
      font-weight: 800;
      border: 1px solid rgba(2,6,23,.08);
      background: rgba(2,6,23,.02);
    }

    .hint{
      color: var(--muted);
      text-align:center;
      margin: 0;
      padding: 0 10px;
    }

    .actions{
      padding: 18px 30px 28px;
    }

    .btn{
      width:100%;
      display:block;
      text-align:center;
      text-decoration:none;
      padding: 18px 18px;
      border-radius: 16px;
      color:#fff;
      background: linear-gradient(180deg, #2f6bff, #1f55d6);
      font-weight: 900;
      letter-spacing: .8px;
      text-transform: uppercase;
      box-shadow: 0 16px 40px rgba(37,99,235,.25);
    }

    .success .icon{ background: rgba(22,163,74,.10); border-color: rgba(22,163,74,.25); }
    .success .pill{ color: var(--green); border-color: rgba(22,163,74,.25); background: rgba(22,163,74,.08); }

    .fail .icon{ background: rgba(239,68,68,.10); border-color: rgba(239,68,68,.25); }
    .fail .pill{ color: var(--red); border-color: rgba(239,68,68,.25); background: rgba(239,68,68,.08); }

    @media (max-width: 860px){
      .title h1{font-size:34px}
      .grid{ grid-template-columns: 1fr; }
      .grid > .col:first-child{ border-right:none; padding-right:0; }
      .grid > .col:last-child{ padding-left:0; }
    }
  </style>
</head>

<body>
  <c:set var="ok" value="${isOk}" />

  <div class="card ${ok ? 'success' : 'fail'}">
    <div class="header">
      <div class="icon" aria-hidden="true">
        <c:choose>
          <c:when test="${ok}">
            <!-- check -->
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M20 6L9 17l-5-5" stroke="var(--green)" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </c:when>
          <c:otherwise>
            <!-- warning -->
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M12 9v4" stroke="var(--red)" stroke-width="2.8" stroke-linecap="round"/>
              <path d="M12 17h.01" stroke="var(--red)" stroke-width="4" stroke-linecap="round"/>
              <path d="M10.3 4.6 2.6 18a2 2 0 0 0 1.7 3h15.4a2 2 0 0 0 1.7-3L13.7 4.6a2 2 0 0 0-3.4 0Z"
                    stroke="var(--red)" stroke-width="2" fill="rgba(239,68,68,.06)"/>
            </svg>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="title">
        <c:choose>
          <c:when test="${ok}">
            <h1>ĐẶT PHÒNG THÀNH CÔNG!</h1>
            <p>Thanh toán đã được xác nhận. Bạn có thể quay lại trang chủ.</p>
          </c:when>
          <c:otherwise>
            <h1>THANH TOÁN THẤT BẠI</h1>
            <p>Giao dịch không thành công hoặc chữ ký không hợp lệ. Vui lòng thử lại.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="divider"></div>

    <div class="grid">
      <div class="col">
        <div class="row">
          <div class="label">Mã đặt chỗ</div>
          <div class="value code">${bookingCode}</div>
        </div>
        <div class="row">
          <div class="label">Khách hàng</div>
          <div class="value">${customerEmail}</div>
        </div>
      </div>

      <div class="col">
        <div class="row">
          <div class="label">Phòng</div>
          <div class="value">${roomName}</div>
        </div>
        <div class="row">
          <div class="label">Ngày nhận phòng</div>
          <div class="value">${checkInDate}</div>
        </div>
        <div class="row">
          <div class="label">Số tiền</div>
          <div class="value">
            <fmt:formatNumber value="${amount}" maxFractionDigits="0" groupingUsed="true"/> ₫
          </div>
        </div>
      </div>
    </div>

    <div class="statusWrap">
      <div class="pill">
        <c:choose>
          <c:when test="${ok}">
            ✅ Thanh toán thành công
          </c:when>
          <c:otherwise>
            ❌ Thanh toán thất bại
          </c:otherwise>
        </c:choose>
      </div>

      <c:if test="${not ok}">
        <p class="hint">
          Nếu bị “Sai chữ ký”, kiểm tra lại cách tạo hash & secret key đang dùng.
        </p>
      </c:if>
    </div>

    <div class="actions">
      <a class="btn" href="${ctx}/home">Quay lại trang chủ</a>
    </div>
  </div>
</body>
</html>