<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <title>HMS Admin | Change Account Status</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <!-- app.css trước (layout + sidebar) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
  <!-- customer.css nếu bạn muốn reuse các biến/button chung -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/customer.css"/>

  <style>
    /* IMPORTANT: bỏ nền đen của body để giống ảnh 2 */
    body{ margin:0; font-family: Inter,system-ui,Arial,sans-serif; background: var(--bg, #f5f7fb); }

    /* ===== Overlay phải FIXED để phủ lên trang phía sau ===== */
    .overlay{
      position: fixed;
      inset: 0;
      display:flex;
      align-items:center;
      justify-content:center;
      padding:24px;
      background: rgba(15,23,42,.55);
      backdrop-filter: blur(6px);
      z-index: 999; /* đè lên sidebar + main */
    }

    .modal{
      width: 560px;
      max-width: 100%;
      background:#fff;
      border-radius: 18px;
      box-shadow: 0 20px 60px rgba(0,0,0,.25);
      overflow:hidden;
    }

    .modal-head{
      display:flex;
      align-items:center;
      justify-content:space-between;
      padding: 18px 22px;
    }
    .modal-title{
      font-size: 22px;
      font-weight: 900;
      margin:0;
      color:#0f172a;
    }

    /* close icon giống ảnh 2 (nhẹ, không quá “button”) */
    .xbtn{
      width:40px;height:40px;
      border-radius:12px;
      border:none;
      background:transparent;
      color:#98a2b3;
      cursor:pointer;
      display:flex;align-items:center;justify-content:center;
      font-size:26px;
      line-height:1;
    }
    .xbtn:hover{ background:#f8fafc; color:#64748b; }

    .modal-body{ padding: 0 22px 22px; }

    .card{
      background:#f8fafc;
      border:1px solid #eef2f7;
      border-radius: 16px;
      padding: 16px;
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap:12px;
      margin-bottom: 18px;
    }
    .label{
      font-size:12px;
      letter-spacing:.12em;
      text-transform:uppercase;
      font-weight:900;
      color:#98a2b3;
      margin-bottom:6px;
    }
    .name{ font-size:18px; font-weight:900; color:#0f172a; margin:0 0 6px; }
    .email a{ color:#2563eb; font-weight:800; text-decoration:none; }
    .email a:hover{ text-decoration:underline; }

    .pill{
      font-size: 12px;
      font-weight: 900;
      padding: 8px 12px;
      border-radius: 999px;
      background:#e9fbef;
      color:#137a3a;
      white-space: nowrap;
    }
    .pill.inactive{ background:#ffe9e9; color:#a11a1a; }
    .pill.noacc{ background:#f2f4f7; color:#344054; }

    .section{ margin-top: 8px; }
    .section h4{
      margin: 0 0 12px;
      color:#334155;
      font-size: 14px;
      font-weight: 900;
    }

    .chooser{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
    }

    /* OPTION giống ảnh 2: selected xanh, unselected trắng */
    .opt{
      border:1px solid #e6eaf2;
      border-radius: 16px;
      padding: 18px;
      cursor:pointer;
      display:flex;
      align-items:center;
      justify-content:center;
      gap: 10px;
      min-height: 94px;
      background:#fff;
      transition: .15s ease;
      user-select:none;
    }
    .opt:hover{ background:#f8fafc; }

    .opt.selected{
      border: 2px solid #16a34a;
      background:#ecfdf3;
    }

    /* icon: mặc định xám, selected xanh */
    .opt .icon{
      width: 40px;height:40px;border-radius:999px;
      display:flex;align-items:center;justify-content:center;
      background:#e5e7eb;
      color:#6b7280;
      font-weight:900;
      font-size:18px;
    }
    .opt.selected .icon{
      background:#16a34a;
      color:#fff;
    }

    .opt .txt{
      display:flex;
      flex-direction:column;
      gap:6px;
      align-items:center;
    }
    .opt .txt b{
      font-size: 14px;
      letter-spacing:.06em;
      text-transform:uppercase;
      color:#0f172a;
    }
    .opt.muted{
      opacity:.55;
      cursor:not-allowed;
    }

    .modal-foot{
      display:flex;
      gap: 14px;
      justify-content:space-between;
      padding: 18px 22px 22px;
      border-top: 1px solid #eef2f7;
      background:#fff;
    }
    .btn{
      height: 46px;
      border-radius: 14px;
      padding: 0 18px;
      font-weight: 900;
      border: 1px solid transparent;
      cursor:pointer;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      font-size: 14px;
      width: 100%;
      text-decoration:none;
    }
    .btn.cancel{
      background:#fff;
      border-color:#e6eaf2;
      color:#334155;
    }
    .btn.cancel:hover{ background:#f8fafc; }

    .btn.confirm{
      background:#16a34a;
      color:#fff;
      box-shadow: 0 16px 30px rgba(22,163,74,.18);
    }
    .btn.confirm:hover{ background:#15803d; }
    .btn:disabled{ opacity:.5; cursor:not-allowed; }

    .error{
      margin: 10px 0 0;
      color:#b91c1c;
      font-weight:800;
      font-size: 13px;
    }

    @media (max-width: 620px){
      .modal{ width: 100%; }
      .chooser{ grid-template-columns: 1fr; }
      .modal-foot{ flex-direction:column; }
    }
  </style>
</head>

<body class="admin-shell">
  <!-- Trang admin phía sau (để blur giống ảnh 2) -->
  <div class="app-shell">
    <%@ include file="/view/layout/sidebar.jsp" %>

    <main class="hms-main">
      <!-- Có thể để trống cũng được, hoặc để breadcrumb cho giống thật -->
      <div style="padding:24px;">
        <!-- optional -->
      </div>
    </main>
  </div>

  <!-- MODAL overlay -->
  <div class="overlay">
    <div class="modal">
      <div class="modal-head">
        <h3 class="modal-title">Change Account Status</h3>

        <a class="xbtn" title="Close"
           href="${pageContext.request.contextPath}/admin/customer-detail?id=${c.customerId}">
          ×
        </a>
      </div>

      <div class="modal-body">
        <div class="card">
          <div>
            <div class="label">Customer</div>
            <p class="name">${c.fullName}</p>
            <div class="email">
              <c:choose>
                <c:when test="${not empty c.email}">
                  <a href="mailto:${c.email}">${c.email}</a>
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </div>
          </div>

          <div>
            <c:choose>
              <c:when test="${c.accountStatus == 'ACTIVE'}">
                <span class="pill">CURRENT: ACTIVE</span>
              </c:when>
              <c:when test="${c.accountStatus == 'INACTIVE'}">
                <span class="pill inactive">CURRENT: INACTIVE</span>
              </c:when>
              <c:otherwise>
                <span class="pill noacc">CURRENT: NO ACCOUNT</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="section">
          <h4>Set New Status</h4>

          <form id="statusForm" method="post" action="${pageContext.request.contextPath}/admin/customer-status">
            <input type="hidden" name="id" value="${c.customerId}"/>
            <input type="hidden" id="statusInput" name="status"
                   value="${c.accountStatus == 'INACTIVE' ? 'INACTIVE' : 'ACTIVE'}"/>

            <div class="chooser">
              <div class="opt" id="optActive" onclick="chooseStatus('ACTIVE')">
                <div class="txt">
                  <div class="icon">✓</div>
                  <b>ACTIVE</b>
                </div>
              </div>

              <div class="opt" id="optInactive" onclick="chooseStatus('INACTIVE')">
                <div class="txt">
                  <div class="icon">×</div>
                  <b>INACTIVE</b>
                </div>
              </div>
            </div>

            <c:if test="${not empty error}">
              <div class="error">${error}</div>
            </c:if>

            <script>
              (function init(){
                var current = document.getElementById("statusInput").value;
                chooseStatus(current);

                var hasAccount = ${c.userId != null ? "true" : "false"};
                if(!hasAccount){
                  document.getElementById("optActive").classList.add("muted");
                  document.getElementById("optInactive").classList.add("muted");
                  document.getElementById("optActive").onclick = null;
                  document.getElementById("optInactive").onclick = null;
                }
              })();

              function chooseStatus(val){
                document.getElementById("statusInput").value = val;
                document.getElementById("optActive").classList.toggle("selected", val === "ACTIVE");
                document.getElementById("optInactive").classList.toggle("selected", val === "INACTIVE");
              }
            </script>
          </form>
        </div>
      </div>

      <div class="modal-foot">
        <a class="btn cancel"
           href="${pageContext.request.contextPath}/admin/customer-detail?id=${c.customerId}">
          Cancel
        </a>

        <button class="btn confirm" type="submit" form="statusForm"
                ${c.userId == null ? "disabled" : ""}>
          Confirm Changes
        </button>
      </div>

    </div>
  </div>
</body>
</html>
