<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
  <style>
    /* Enhanced Styles for Edit User Page */
    
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
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .hms-title svg {
      opacity: 0.5;
    }

    /* Enhanced Panel */
    .hms-panel {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      padding: 32px;
      margin-bottom: 24px;
      border: 1px solid #e9ecef;
      transition: all 0.2s;
    }

    .hms-panel:hover {
      box-shadow: 0 4px 16px rgba(0,0,0,0.06);
      border-color: #dee2e6;
    }

    .hms-h2 {
      font-size: 20px;
      font-weight: 700;
      color: #212529;
      margin: 0 0 24px 0;
      padding-bottom: 16px;
      border-bottom: 2px solid #f1f3f5;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .hms-h2::before {
      content: '';
      width: 4px;
      height: 24px;
      background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
      border-radius: 2px;
    }

    /* Read-only Information Display */
    .hms-kv-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 20px;
      background: #f8f9fa;
      padding: 24px;
      border-radius: 10px;
      border: 2px dashed #dee2e6;
    }

    .kv {
      display: flex;
      flex-direction: column;
      gap: 8px;
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
      content: '🔒';
      font-size: 10px;
    }

    .kv__v {
      font-size: 16px;
      font-weight: 600;
      color: #212529;
      padding: 10px 12px;
      background: white;
      border-radius: 6px;
      border: 1px solid #e9ecef;
    }

    /* Enhanced Form Fields */
    .field {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .field label {
      font-size: 14px;
      font-weight: 700;
      color: #212529;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .field label::after {
      content: '*';
      color: #dc3545;
      font-size: 16px;
    }

    .field select {
      padding: 12px 16px;
      border: 2px solid #dee2e6;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 500;
      color: #212529;
      background: white;
      transition: all 0.2s;
      cursor: pointer;
      appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg width='12' height='8' viewBox='0 0 12 8' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 1.5L6 6.5L11 1.5' stroke='%23495057' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 16px center;
      padding-right: 48px;
    }

    .field select:hover {
      border-color: #adb5bd;
    }

    .field select:focus {
      outline: none;
      border-color: #4f46e5;
      box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
    }

    .field .muted {
      font-size: 13px;
      color: #6c757d;
      line-height: 1.6;
      padding: 10px 16px;
      background: #fff3cd;
      border-left: 4px solid #ffc107;
      border-radius: 6px;
      display: flex;
      align-items: flex-start;
      gap: 10px;
    }

    .field .muted::before {
      content: '⚠️';
      font-size: 16px;
      flex-shrink: 0;
      margin-top: 2px;
    }

    /* Enhanced Action Buttons */
    .hms-actions {
      display: flex;
      gap: 12px;
      padding: 24px 32px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      border: 1px solid #e9ecef;
      justify-content: flex-end;
      position: sticky;
      bottom: 20px;
    }

    .btn {
      padding: 12px 24px;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      min-width: 140px;
      justify-content: center;
    }

    .btn-primary {
      background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
      color: white;
      box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
    }

    .btn-primary:active {
      transform: translateY(0);
    }

    .btn-light {
      background: white;
      color: #495057;
      border: 2px solid #dee2e6;
    }

    .btn-light:hover {
      background: #f8f9fa;
      border-color: #adb5bd;
    }

    /* Info Box */
    .info-box {
      background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
      padding: 20px 24px;
      border-radius: 10px;
      margin-bottom: 24px;
      border-left: 4px solid #4f46e5;
      display: flex;
      gap: 16px;
      align-items: flex-start;
    }

    .info-box svg {
      flex-shrink: 0;
      margin-top: 2px;
    }

    .info-box__content {
      flex: 1;
    }

    .info-box__title {
      font-weight: 700;
      color: #212529;
      margin-bottom: 6px;
      font-size: 15px;
    }

    .info-box__text {
      font-size: 14px;
      color: #495057;
      line-height: 1.6;
    }

    /* Section Divider */
    .section-divider {
      height: 1px;
      background: linear-gradient(90deg, transparent, #dee2e6, transparent);
      margin: 32px 0;
    }

    /* Status Preview */
    .status-preview {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px;
      background: #f8f9fa;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      margin-top: 12px;
    }

    .status-preview.active {
      background: #d1fae5;
      color: #065f46;
    }

    .status-preview.inactive {
      background: #fee2e2;
      color: #991b1b;
    }

    .status-preview::before {
      content: '';
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: currentColor;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .hms-panel {
        padding: 24px 20px;
      }

      .hms-kv-grid {
        grid-template-columns: 1fr;
      }

      .hms-actions {
        flex-direction: column-reverse;
        position: static;
      }

      .btn {
        width: 100%;
      }
    }

    /* Loading State */
    .btn:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none !important;
    }

    /* Focus visible for accessibility */
    .btn:focus-visible {
      outline: 2px solid #4f46e5;
      outline-offset: 2px;
    }
    /* Keep primary button color unchanged on hover/focus/active */
.btn-primary,
.btn-primary:hover,
.btn-primary:focus,
.btn-primary:active,
.btn-primary:focus-visible{
  background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%) !important;
  color: #fff !important;
  transform: none !important;
  box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3) !important;
  outline: none !important;
}

/* If browser adds inner focus outline (sometimes on button) */
.btn-primary::-moz-focus-inner{
  border: 0;
}

  </style>
</head>
<body>
<div class="app-shell">
  <%@ include file="/view/admin_layout/sidebar.jsp" %>
  <div class="hms-main">
   
    <main class="hms-page">
      <div class="hms-page__top">
        <div>
          <h1 class="hms-title">
   
            Edit Account
          </h1>
        </div>
      </div>


      <form method="post" action="${pageContext.request.contextPath}/admin/staff/edit">
        <input type="hidden" name="id" value="${user.userId}"/>


        <!-- Change Role Section -->
        <section class="hms-panel">
          <h2 class="hms-h2">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" style="margin-left: -4px;">
              <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z"/>
            </svg>
            Edit Role
          </h2>
          <div class="field" style="max-width:500px;">
            <label>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                <path d="M11 5a3 3 0 11-6 0 3 3 0 016 0zM8 7a2 2 0 100-4 2 2 0 000 4zm0 5.5a6.5 6.5 0 100-13 6.5 6.5 0 000 13z"/>
              </svg>
              Role Selection
            </label>
            <select name="roleId" id="roleSelect">
              <c:forEach var="r" items="${roles}">
                <option value="${r.roleId}" ${r.roleId == user.roleId ? 'selected' : ''}>
                  ${r.roleName}
                </option>
              </c:forEach>
            </select>
            <div class="muted">
              Changing the role will immediately affect the user's system permissions and access levels.
            </div>
          </div>
        </section>

        <div class="section-divider"></div>

        <!-- Change Status Section -->
        <section class="hms-panel">
          <h2 class="hms-h2">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" style="margin-left: -4px;">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
            </svg>
            Edit Status
          </h2>
          <div class="field" style="max-width:500px;">
            <label>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                <path d="M8 15A7 7 0 118 1a7 7 0 010 14zm0 1A8 8 0 108 0a8 8 0 000 16z"/>
                <path d="M10.97 4.97a.235.235 0 00-.02.022L7.477 9.417 5.384 7.323a.75.75 0 00-1.06 1.06L6.97 11.03a.75.75 0 001.079-.02l3.992-4.99a.75.75 0 00-1.071-1.05z"/>
              </svg>
              Status
            </label>
            <select name="status" id="statusSelect">
              <option value="1" ${user.status == 1 ? 'selected' : ''}>ACTIVE</option>
              <option value="0" ${user.status == 0 ? 'selected' : ''}>INACTIVE</option>
            </select>
            <div class="muted">
              Inactive users are immediately restricted from logging into the HMS system and accessing any resources.
            </div>
            
            <!-- Status Preview -->
            <div id="statusPreview" class="status-preview ${user.status == 1 ? 'active' : 'inactive'}">
              ${user.status == 1 ? 'Active Account' : 'Inactive Account'}
            </div>
          </div>
        </section>

        <!-- Action Buttons -->
        <div class="hms-actions">
          <a class="btn btn-light"
    href="${pageContext.request.contextPath}/admin/staff"
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 4L4 12M4 4L12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            Cancel
          </a>
          <button class="btn btn-primary" type="submit">
            Save Changes
          </button>
        </div>
      </form>
    </main>
    <%@ include file="/view/admin_layout/footer.jsp" %>
  </div>
</div>

<script>
  // Update status preview dynamically
  const statusSelect = document.getElementById('statusSelect');
  const statusPreview = document.getElementById('statusPreview');
  
  if (statusSelect && statusPreview) {
    statusSelect.addEventListener('change', function() {
      if (this.value === '1') {
        statusPreview.className = 'status-preview active';
        statusPreview.textContent = 'Active Account';
      } else {
        statusPreview.className = 'status-preview inactive';
        statusPreview.textContent = 'Inactive Account';
      }
    });
  }
</script>
</body>
</html>
