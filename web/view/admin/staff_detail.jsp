<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>HMS Admin - User Detail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
  <style>
    /* Enhanced Styles for User Detail Page */
    
    .hms-page {
      background: #f8f9fa;
      min-height: calc(100vh - 120px);
      padding-bottom: 40px;
    }

    .hms-page__top {
      background: white;
      padding: 32px;
      border-radius: 12px;
      margin-bottom: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 24px;
    }

    .hms-breadcrumb {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 14px;
      color: #6c757d;
      margin-bottom: 12px;
    }

    .hms-breadcrumb .sep {
      color: #dee2e6;
      font-weight: 300;
    }

    .hms-breadcrumb .current {
      color: #495057;
      font-weight: 500;
    }

    .hms-title {
      font-size: 28px;
      font-weight: 700;
      color: #212529;
      margin: 0;
    }

    /* Button Styles */
    .btn {
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .btn-primary {
      background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
      color: white;
      box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(79, 70, 229, 0.4);
    }

    /* Enhanced Panel */
    .hms-panel {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      overflow: hidden;
      margin-bottom: 24px;
    }

    /* Profile Section */
    .hms-profile {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 48px 32px;
      display: flex;
      align-items: center;
      gap: 24px;
      border-bottom: 4px solid rgba(255,255,255,0.2);
    }

    .hms-avatar {
      width: 96px;
      height: 96px;
      border-radius: 50%;
      background: white;
      color: #667eea;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 36px;
      font-weight: 700;
      box-shadow: 0 8px 24px rgba(0,0,0,0.15);
      border: 4px solid rgba(255,255,255,0.3);
    }

    .hms-profile__meta {
      flex: 1;
    }

    .hms-profile__name {
      font-size: 28px;
      font-weight: 700;
      color: white;
      margin-bottom: 8px;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .hms-profile__sub {
      font-size: 16px;
      color: rgba(255,255,255,0.9);
      font-weight: 500;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(255,255,255,0.2);
      padding: 6px 16px;
      border-radius: 20px;
      backdrop-filter: blur(10px);
    }

    /* Key-Value Grid */
    .hms-kv-grid {
      padding: 32px;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 32px;
    }

    .kv {
      display: flex;
      flex-direction: column;
      gap: 10px;
      padding: 20px;
      background: #f8f9fa;
      border-radius: 10px;
      border-left: 4px solid #4f46e5;
      transition: all 0.2s;
    }

    .kv:hover {
      background: #e9ecef;
      transform: translateX(4px);
    }

    .kv__k {
      font-size: 11px;
      font-weight: 700;
      color: #6c757d;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .kv__k::before {
      content: '';
      width: 4px;
      height: 4px;
      background: #4f46e5;
      border-radius: 50%;
    }

    .kv__v {
      font-size: 16px;
      font-weight: 600;
      color: #212529;
      word-break: break-word;
    }

    /* Pill Status Badges */
    .pill {
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .pill::before {
      content: '';
      width: 8px;
      height: 8px;
      border-radius: 50%;
      animation: pulse 2s infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    .pill.green {
      background: #d1fae5;
      color: #065f46;
    }

    .pill.green::before {
      background: #10b981;
    }

    .pill.gray {
      background: #e5e7eb;
      color: #4b5563;
    }

    .pill.gray::before {
      background: #6b7280;
    }

    /* Back Link */
    .hms-link {
      color: #4f46e5;
      text-decoration: none;
      font-weight: 600;
      font-size: 15px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 20px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      transition: all 0.2s;
    }

    .hms-link:hover {
      background: #f8f9fa;
      transform: translateX(-4px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    /* Info Cards Enhancement */
    .info-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 24px;
    }

    .info-card {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      border-left: 4px solid #4f46e5;
    }

    .info-card__label {
      font-size: 12px;
      color: #6c757d;
      font-weight: 600;
      text-transform: uppercase;
      margin-bottom: 8px;
    }

    .info-card__value {
      font-size: 20px;
      font-weight: 700;
      color: #212529;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .hms-page__top {
        flex-direction: column;
      }

      .hms-profile {
        flex-direction: column;
        text-align: center;
        padding: 32px 24px;
      }

      .hms-kv-grid {
        grid-template-columns: 1fr;
        padding: 24px;
        gap: 20px;
      }

      .hms-avatar {
        width: 80px;
        height: 80px;
        font-size: 32px;
      }

      .hms-profile__name {
        font-size: 24px;
      }
    }

    /* Action Buttons Section */
    .action-section {
      padding: 24px 32px;
      background: #f8f9fa;
      border-top: 1px solid #e9ecef;
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }

    .btn-secondary {
      background: white;
      color: #495057;
      border: 2px solid #dee2e6;
    }

    .btn-secondary:hover {
      background: #f8f9fa;
      border-color: #adb5bd;
    }

    .btn-danger {
      background: #dc3545;
      color: white;
    }

    .btn-danger:hover {
      background: #c82333;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 40px;
      color: #6c757d;
      font-style: italic;
    }

    /* Icons for sections */
    .section-icon {
      width: 20px;
      height: 20px;
      opacity: 0.5;
    }
  </style>
</head>
<body>
<div class="app-shell">
  <%@ include file="/view/layout/sidebar.jsp" %>
  <div class="hms-main">
    
    <main class="hms-page">
      <div class="hms-page__top">
        <div>
          <div class="hms-breadcrumb">
            <span>Admin</span><span class="sep">›</span>
            <span>User Management</span><span class="sep">›</span>
            <span class="current">User Detail</span>
          </div>
          <h1 class="hms-title">User Detail</h1>
        </div>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/staff/edit?id=${user.userId}">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M11.333 2.00004C11.5081 1.82494 11.716 1.68605 11.9447 1.59129C12.1735 1.49653 12.4187 1.44775 12.6663 1.44775C12.914 1.44775 13.1592 1.49653 13.3879 1.59129C13.6167 1.68605 13.8246 1.82494 13.9997 2.00004C14.1748 2.17513 14.3137 2.383 14.4084 2.61178C14.5032 2.84055 14.552 3.08575 14.552 3.33337C14.552 3.58099 14.5032 3.82619 14.4084 4.05497C14.3137 4.28374 14.1748 4.49161 13.9997 4.66671L5.33301 13.3334L1.33301 14.6667L2.66634 10.6667L11.333 2.00004Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Edit User Account
        </a>
      </div>

      <section class="hms-panel">
        <!-- Profile Header -->
        <div class="hms-profile">
          <div class="hms-avatar">
            <c:choose>
              <c:when test="${not empty user.fullName}">
                ${fn:substring(user.fullName,0,1)}
              </c:when>
              <c:otherwise>U</c:otherwise>
            </c:choose>
          </div>
          <div class="hms-profile__meta">
            <div class="hms-profile__name">
              <c:choose>
                <c:when test="${not empty user.fullName}">${user.fullName}</c:when>
                <c:otherwise>(No staff profile)</c:otherwise>
              </c:choose>
            </div>
            <div class="hms-profile__sub">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                <path d="M8 8a3 3 0 100-6 3 3 0 000 6zm2-3a2 2 0 11-4 0 2 2 0 014 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
              </svg>
              ${user.roleName}
            </div>
          </div>
        </div>

        <!-- User Information Grid -->
        <div class="hms-kv-grid">
          <div class="kv">
            <div class="kv__k">
              <svg class="section-icon" viewBox="0 0 16 16" fill="currentColor">
                <path d="M8 8a3 3 0 100-6 3 3 0 000 6zm2-3a2 2 0 11-4 0 2 2 0 014 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
              </svg>
              Full Name
            </div>
            <div class="kv__v">
              <c:choose>
                <c:when test="${not empty user.fullName}">
                  <c:out value="${user.fullName}"/>
                </c:when>
                <c:otherwise>
                  <span style="color: #adb5bd;">Not provided</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="kv">
            <div class="kv__k">
              <svg class="section-icon" viewBox="0 0 16 16" fill="currentColor">
                <path d="M.05 3.555A2 2 0 012 2h12a2 2 0 011.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 002 14h12a2 2 0 001.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/>
              </svg>
              Email Address
            </div>
            <div class="kv__v"><c:out value="${user.email}"/></div>
          </div>

          <div class="kv">
            <div class="kv__k">
              <svg class="section-icon" viewBox="0 0 16 16" fill="currentColor">
                <path fill-rule="evenodd" d="M1.885.511a1.745 1.745 0 012.61.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 00.178.643l2.457 2.457a.678.678 0 00.644.178l2.189-.547a1.745 1.745 0 011.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 01-7.01-4.42 18.634 18.634 0 01-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
              </svg>
              Phone Number
            </div>
            <div class="kv__v">
              <c:choose>
                <c:when test="${empty user.phone}">
                  <span style="color: #adb5bd;">Not provided</span>
                </c:when>
                <c:otherwise><c:out value="${user.phone}"/></c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="kv">
            <div class="kv__k">
              <svg class="section-icon" viewBox="0 0 16 16" fill="currentColor">
                <path d="M11 5a3 3 0 11-6 0 3 3 0 016 0zM8 7a2 2 0 100-4 2 2 0 000 4zm0 5.5a6.5 6.5 0 100-13 6.5 6.5 0 000 13z"/>
              </svg>
              Role
            </div>
            <div class="kv__v"><c:out value="${user.roleName}"/></div>
          </div>

          <div class="kv">
            <div class="kv__k">
              <svg class="section-icon" viewBox="0 0 16 16" fill="currentColor">
                <path fill-rule="evenodd" d="M8 1a3.5 3.5 0 00-3.5 3.5V7A1.5 1.5 0 003 8.5v5A1.5 1.5 0 004.5 15h7a1.5 1.5 0 001.5-1.5v-5A1.5 1.5 0 0011.5 7V4.5A3.5 3.5 0 008 1zm2 6V4.5a2 2 0 10-4 0V7h4z"/>
              </svg>
              Authentication Type
            </div>
            <div class="kv__v">${user.authProviderText}</div>
          </div>

          <div class="kv">
            <div class="kv__k">
              <svg class="section-icon" viewBox="0 0 16 16" fill="currentColor">
                <path d="M8 15A7 7 0 118 1a7 7 0 010 14zm0 1A8 8 0 108 0a8 8 0 000 16z"/>
                <path d="M10.97 4.97a.235.235 0 00-.02.022L7.477 9.417 5.384 7.323a.75.75 0 00-1.06 1.06L6.97 11.03a.75.75 0 001.079-.02l3.992-4.99a.75.75 0 00-1.071-1.05z"/>
              </svg>
              Account Status
            </div>
            <div class="kv__v">
              <c:choose>
                <c:when test="${user.status == 1}">
                  <span class="pill green">Active</span>
                </c:when>
                <c:otherwise>
                  <span class="pill gray">Inactive</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </section>

      <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M10 12L6 8L10 4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        Back to Staff List
      </a>
    </main>
    <%@ include file="/view/admin_layout/footer.jsp" %>
  </div>
</div>
</body>
</html>
