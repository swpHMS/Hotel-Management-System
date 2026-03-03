<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <title>HMS Admin | Customer Detail</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">

  <style>
    :root {
      --color-primary: #0f172a;
      --color-secondary: #1e293b;
      --color-accent: #3b82f6;
      --color-accent-light: #60a5fa;
      --color-success: #10b981;
      --color-border: #e2e8f0;
      --color-bg-subtle: #f8fafc;
      --color-text-primary: #0f172a;
      --color-text-secondary: #64748b;
      --color-text-tertiary: #94a3b8;
      --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
      --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
      --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
      --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    * { font-family: 'DM Sans', -apple-system, BlinkMacSystemFont, sans-serif; }

    body { background: var(--color-bg-subtle); }

    /* Page animation */
    .hms-page { animation: fadeIn 0.6s ease-out; }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Top header like Staff Detail */
    .hms-page__top{
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid var(--color-border);
      position: relative;
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap: 20px;
    }
    .hms-page__top::after{
      content:'';
      position:absolute;
      bottom:-2px; left:0;
      width:120px; height:2px;
      background: linear-gradient(90deg, var(--color-accent) 0%, var(--color-accent-light) 100%);
      animation: slideIn 0.8s ease-out;
    }
    @keyframes slideIn { from { width:0; } to { width:120px; } }

    .hms-title{
      font-family:'Playfair Display', serif;
      font-size:36px;
      font-weight:700;
      color: var(--color-primary);
      margin:0 0 8px 0;
      letter-spacing:-0.02em;
    }
    .hms-subtitle{
      font-size:15px;
      color: var(--color-text-secondary);
      font-weight:400;
      margin:0;
    }

    /* Top actions */
    .top-actions{
      display:flex;
      gap:12px;
      animation: slideInRight 0.6s ease-out 0.2s both;
      flex-wrap: wrap;
    }
    @keyframes slideInRight{
      from { opacity:0; transform: translateX(20px); }
      to { opacity:1; transform: translateX(0); }
    }

    /* Buttons (same hover shine) */
    .btn{
      padding:12px 24px;
      border-radius:10px;
      font-weight:600;
      font-size:14px;
      text-decoration:none;
      border:2px solid var(--color-border);
      background:white;
      color: var(--color-text-primary);
      transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
      box-shadow: var(--shadow-sm);
      position:relative;
      overflow:hidden;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      white-space: nowrap;
      height: 44px;
    }
    .btn::before{
      content:'';
      position:absolute;
      top:0; left:-100%;
      width:100%; height:100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
      transition:left 0.5s;
    }
    .btn:hover::before{ left:100%; }
    .btn:hover{
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
      border-color: var(--color-accent);
    }
    .btn-primary{
      background: linear-gradient(135deg, var(--color-accent) 0%, var(--color-accent-light) 100%);
      color:white;
      border:none;
    }
    .btn-primary:hover{
      transform: translateY(-2px);
      box-shadow: 0 12px 20px -5px rgba(59,130,246,0.4);
    }
    .btn[disabled], .btn:disabled{
      opacity:.55;
      cursor:not-allowed;
      pointer-events:none;
      transform:none !important;
      box-shadow: var(--shadow-sm) !important;
    }

    /* Detail card (same shimmer top bar) */
    .detail-card{
      background:white;
      border:none;
      border-radius:20px;
      padding:0;
      box-shadow: var(--shadow-xl);
      overflow:hidden;
      margin-bottom: 24px;
      animation: scaleIn 0.6s ease-out 0.3s both;
      position:relative;
    }
    @keyframes scaleIn{
      from { opacity:0; transform: scale(0.95); }
      to { opacity:1; transform: scale(1); }
    }
    .detail-card::before{
      content:'';
      position:absolute;
      top:0; left:0; right:0;
      height:6px;
      background: linear-gradient(90deg, var(--color-accent) 0%, var(--color-accent-light) 50%, var(--color-accent) 100%);
      background-size:200% 100%;
      animation: shimmer 3s infinite;
    }
    @keyframes shimmer{
      0% { background-position: 200% 0; }
      100% { background-position: -200% 0; }
    }

    /* 3 columns like Staff Detail */
    .detail-grid-3{
      display:grid;
      grid-template-columns: repeat(3, 1fr);
      gap:0;
      padding:40px;
    }

    .detail-col{
      padding: 0 32px;
      border-right: 1px solid var(--color-border);
      position:relative;
      animation: fadeInUp 0.6s ease-out both;
    }
    .detail-col:nth-child(1){ animation-delay: 0.4s; }
    .detail-col:nth-child(2){ animation-delay: 0.5s; }
    .detail-col:nth-child(3){ animation-delay: 0.6s; }

    @keyframes fadeInUp{
      from { opacity:0; transform: translateY(30px); }
      to { opacity:1; transform: translateY(0); }
    }

    .detail-col:first-child{ padding-left:0; }
    .detail-col:last-child{ border-right:none; padding-right:0; }

    .detail-col__title{
      font-size:11px;
      font-weight:700;
      letter-spacing:0.15em;
      color: var(--color-accent);
      margin-bottom:28px;
      text-transform:uppercase;
      position:relative;
      padding-bottom:12px;
    }
    .detail-col__title::after{
      content:'';
      position:absolute;
      bottom:0; left:0;
      width:40px; height:2px;
      background: var(--color-accent);
    }

    /* Item hover same style */
    .detail-item{
      margin-bottom:28px;
      transition: all 0.3s ease;
      padding:12px;
      margin-left:-12px;
      margin-right:-12px;
      border-radius:8px;
    }
    .detail-item:hover{
      background: var(--color-bg-subtle);
      transform: translateX(4px);
    }

    .detail-k{
      font-size:11px;
      font-weight:700;
      letter-spacing:0.08em;
      color: var(--color-text-tertiary);
      margin-bottom:6px;
      text-transform:uppercase;
    }
    .detail-v{
      font-size:16px;
      font-weight:600;
      color: var(--color-text-primary);
      line-height:1.5;
    }

    /* Link underline animation like Staff Detail */
    .detail-v.link{
      color: var(--color-accent);
      transition: all 0.3s ease;
      cursor:pointer;
      position:relative;
      text-decoration:none;
      display:inline-block;
    }
    .detail-v.link::after{
      content:'';
      position:absolute;
      bottom:-2px; left:0;
      width:0; height:2px;
      background: var(--color-accent);
      transition: width 0.3s ease;
    }
    .detail-v.link:hover::after{ width:100%; }

    /* Pills */
    .pill{
      display:inline-block;
      padding:6px 16px;
      border-radius:100px;
      font-size:13px;
      font-weight:600;
      letter-spacing:0.02em;
      transition: all 0.3s ease;
      line-height: 1.2;
    }
    .pill.green{
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color:white;
      box-shadow: 0 4px 12px rgba(16,185,129,0.3);
    }
    .pill.red{
      background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
      color:white;
      box-shadow: 0 4px 12px rgba(239,68,68,0.28);
    }
    .pill.gray{
      background:#e2e8f0;
      color: var(--color-text-secondary);
    }
    .pill:hover{ transform: scale(1.05); }

    /* Back link like Staff Detail */
    .hms-link{
      display:inline-flex;
      align-items:center;
      gap:8px;
      color: var(--color-text-secondary);
      text-decoration:none;
      font-weight:500;
      font-size:14px;
      transition: all 0.3s ease;
      padding:12px 20px;
      border-radius:10px;
      margin-top:16px;
    }
    .hms-link:hover{
      color: var(--color-accent);
      background: var(--color-bg-subtle);
      transform: translateX(-4px);
    }

    /* Error card */
    .error-message{
      background:white;
      border:1px solid rgba(15,23,42,.10);
      border-radius:16px;
      padding:28px;
      box-shadow: 0 8px 24px rgba(15,23,42,.06);
      color: var(--color-text-secondary);
      font-weight:600;
    }

    /* Decorative background (same) */
    .hms-page::before{
      content:'';
      position:fixed;
      top:0; right:0;
      width:600px; height:600px;
      background: radial-gradient(circle at center, rgba(59,130,246,0.08) 0%, transparent 70%);
      pointer-events:none;
      z-index:-1;
    }
    .hms-page::after{
      content:'';
      position:fixed;
      bottom:0; left:0;
      width:400px; height:400px;
      background: radial-gradient(circle at center, rgba(59,130,246,0.05) 0%, transparent 70%);
      pointer-events:none;
      z-index:-1;
    }

    /* Responsive */
    @media (max-width: 1024px){
      .detail-grid-3{ grid-template-columns:1fr; padding:24px; }
      .detail-col{
        border-right:none;
        padding:0;
        border-bottom:1px solid var(--color-border);
        padding-bottom:32px;
        margin-bottom:32px;
      }
      .detail-col:last-child{
        border-bottom:none;
        margin-bottom:0;
        padding-bottom:0;
      }
      .hms-page__top{ flex-direction:column; align-items:stretch; }
      .top-actions{ flex-direction:column; width:100%; }
      .btn{ width:100%; text-align:center; }
      .hms-title{ font-size:28px; }
    }
  </style>
</head>

<body class="admin-shell">
<div class="app-shell">
  <%@ include file="/view/admin_layout/sidebar.jsp" %>

  <main class="hms-main">
    <main class="hms-page" style="padding: 28px;">
      <div class="hms-page__top">
        <div>
          <h1 class="hms-title">Customer Profile</h1>
        </div>

        <div class="top-actions">
          <c:choose>
            <c:when test="${c != null && c.userId != null}">
              <a class="btn btn-primary"
                 href="${pageContext.request.contextPath}/admin/customer-status?id=${c.customerId}">
                Change Account Status
              </a>
            </c:when>
            <c:otherwise>
              <button class="btn btn-primary" disabled>Change Account Status</button>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <c:if test="${c == null}">
        <div class="error-message">Customer not found or has been removed.</div>
        <a class="hms-link" href="${pageContext.request.contextPath}/admin/customers">← Back to Customer List</a>
      </c:if>

      <c:if test="${c != null}">
        <section class="detail-card">
          <div class="detail-grid-3">

            <!-- BASIC INFORMATION -->
            <div class="detail-col">
              <div class="detail-col__title">Basic Information</div>

              <div class="detail-item">
                <div class="detail-k">Full Name</div>
                <div class="detail-v">${c.fullName}</div>
              </div>

              <div class="detail-item">
                <div class="detail-k">Gender</div>
                <div class="detail-v">
                  <c:choose>
                    <c:when test="${c.gender == 1}">Male</c:when>
                    <c:when test="${c.gender == 2}">Female</c:when>
                    <c:when test="${c.gender == 3}">Other</c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </div>
              </div>

              <div class="detail-item">
                <div class="detail-k">Date of Birth</div>
                <div class="detail-v">
                  <c:choose>
                    <c:when test="${c.dateOfBirth != null}">
                      <fmt:formatDate value="${c.dateOfBirth}" pattern="dd MMM yyyy"/>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </div>
              </div>

              <div class="detail-item">
                <div class="detail-k">Residence Address</div>
                <div class="detail-v">${c.residenceAddress != null ? c.residenceAddress : '—'}</div>
              </div>
            </div>

            <!-- CONTACT INFORMATION -->
            <div class="detail-col">
              <div class="detail-col__title">Contact Information</div>

              <div class="detail-item">
                <div class="detail-k">Phone Number</div>
                <div class="detail-v">${c.phone != null ? c.phone : '—'}</div>
              </div>

              <div class="detail-item">
                <div class="detail-k">Email Address</div>
                <div class="detail-v">
                  <c:choose>
                    <c:when test="${not empty c.email}">
                      <a class="detail-v link" href="mailto:${c.email}">${c.email}</a>
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>

            <!-- ACCOUNT DETAILS -->
            <div class="detail-col">
              <div class="detail-col__title">Account Details</div>

              <div class="detail-item">
                <div class="detail-k">Account Status</div>
                <div class="detail-v">
                  <c:choose>
                    <c:when test="${c.accountStatus == 'ACTIVE'}">
                      <span class="pill green">Active</span>
                    </c:when>
                    <c:when test="${c.accountStatus == 'INACTIVE'}">
                      <span class="pill red">Inactive</span>
                    </c:when>
                    <c:otherwise>
                      <span class="pill gray">No Account</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <div class="detail-item">
                <div class="detail-k">Customer ID</div>
                <div class="detail-v">#${c.customerId}</div>
              </div>

              <div class="detail-item">
                <div class="detail-k">User ID</div>
                <div class="detail-v">
                  <c:choose>
                    <c:when test="${c.userId != null}">#${c.userId}</c:when>
                    <c:otherwise>—</c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>

          </div>
        </section>

        <a class="hms-link" href="${pageContext.request.contextPath}/admin/customers">← Back to Customer List</a>
      </c:if>
    </main>
  </main>
</div>
</body>
</html>
