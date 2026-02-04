<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>HMS Admin - Create Staff</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css"/>
</head>

<body>
<div class="app-shell">
  <%@ include file="/view/layout/sidebar.jsp" %>

  <div class="hms-main">
    <%@ include file="/view/layout/header.jsp" %>

    <main class="hms-page">
      <div class="hms-page__top">
        <div>
          <div class="hms-breadcrumb">
            <span>Admin</span><span class="sep">›</span>
            <span>User Management</span><span class="sep">›</span>
            <span class="current">Create Staff</span>
          </div>
          <h1 class="hms-title">Create Staff Account</h1>
          <p class="hms-subtitle">Create a new staff user and staff profile in the system.</p>
        </div>

        <a class="btn btn-light" href="${pageContext.request.contextPath}/admin/staff">Back to Staff List</a>
      </div>

      <!-- Global messages -->
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <c:if test="${not empty errors.common}">
        <div class="alert alert-danger">${errors.common}</div>
      </c:if>

      <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/admin/staff/create" class="hms-panel">
        <h2 class="hms-h2">Account Information</h2>

        <div class="hms-form-grid">
          <!-- ✅ EMAIL (fix chỗ bị trống) -->
          <div class="field">
            <label>Email *</label>
            <input type="email" name="email" required value="${email}">
            <c:if test="${not empty errors.email}">
              <div class="field-error">${errors.email}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Password *</label>
            <input type="password" name="password" required minlength="6">
            <div class="muted">Minimum 6 characters.</div>
            <c:if test="${not empty errors.password}">
              <div class="field-error">${errors.password}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Role *</label>
            <select name="roleId" required>
              <c:forEach var="r" items="${roles}">
                <option value="${r.roleId}" ${param.roleId == r.roleId.toString() ? 'selected' : ''}>
                  ${r.roleName}
                </option>
              </c:forEach>
            </select>
            <c:if test="${not empty errors.roleId}">
              <div class="field-error">${errors.roleId}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Status</label>
            <select name="status">
              <option value="1" ${empty param.status || param.status == '1' ? 'selected' : ''}>ACTIVE</option>
              <option value="0" ${param.status == '0' ? 'selected' : ''}>INACTIVE</option>
            </select>
          </div>
        </div>

        <hr class="hms-hr"/>

        <h2 class="hms-h2">Staff Profile</h2>
        <div class="hms-form-grid">
          <div class="field">
            <label>Full Name *</label>
            <input type="text" name="fullName" required value="${fullName}">
            <c:if test="${not empty errors.fullName}">
              <div class="field-error">${errors.fullName}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Phone *</label>
            <input type="text" name="phone" required value="${phone}">
            <c:if test="${not empty errors.phone}">
              <div class="field-error">${errors.phone}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Gender *</label>
            <select name="gender" required>
              <option value="1" ${empty param.gender || param.gender == '1' ? 'selected' : ''}>Male</option>
              <option value="2" ${param.gender == '2' ? 'selected' : ''}>Female</option>
              <option value="3" ${param.gender == '3' ? 'selected' : ''}>Other</option>
            </select>
          </div>

          <div class="field">
            <label>Date of Birth *</label>
            <input type="date" name="dob" required value="${dob}">
            <c:if test="${not empty errors.dob}">
              <div class="field-error">${errors.dob}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Identity Number *</label>
            <input type="text" name="identityNumber" required value="${identityNumber}">
            <c:if test="${not empty errors.identityNumber}">
              <div class="field-error">${errors.identityNumber}</div>
            </c:if>
          </div>

          <div class="field">
            <label>Residence Address</label>
            <input type="text" name="address" value="${address}">
          </div>
        </div>

        <div class="hms-actions">
          <a class="btn btn-light" href="${pageContext.request.contextPath}/admin/staff">Cancel</a>
          <button class="btn btn-primary" type="submit">Create Staff</button>
        </div>
      </form>
    </main>

    <%@ include file="/view/layout/footer.jsp" %>
  </div>
</div>
</body>
</html>
