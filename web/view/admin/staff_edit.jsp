<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>HMS Admin - Edit User</title>
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
            <span class="current">Edit User</span>
          </div>
          <h1 class="hms-title">Edit User Account</h1>
        </div>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/admin/staff/edit">
        <input type="hidden" name="id" value="${user.userId}"/>

        <section class="hms-panel">
          <h2 class="hms-h2">User Information</h2>
          <div class="hms-kv-grid">
            <div class="kv">
              <div class="kv__k">FULL NAME</div>
              <div class="kv__v"><c:out value="${user.fullName}"/></div>
            </div>

            <div class="kv">
              <div class="kv__k">EMAIL</div>
              <div class="kv__v"><c:out value="${user.email}"/></div>
            </div>
          </div>
        </section>

        <section class="hms-panel">
          <h2 class="hms-h2">Change Role</h2>
          <div class="field" style="max-width:420px;">
            <label>Role Selection</label>
            <select name="roleId">
              <c:forEach var="r" items="${roles}">
                <option value="${r.roleId}" ${r.roleId == user.roleId ? 'selected' : ''}>
                  ${r.roleName}
                </option>
              </c:forEach>
            </select>
            <div class="muted" style="margin-top:6px;">
              Changing the role will immediately affect the user's system permissions.
            </div>
          </div>
        </section>

        <section class="hms-panel">
          <h2 class="hms-h2">Change Account Status</h2>

          <div class="field" style="max-width:420px;">
            <label>Status</label>
            <select name="status">
              <option value="1" ${user.status == 1 ? 'selected' : ''}>ACTIVE</option>
              <option value="0" ${user.status == 0 ? 'selected' : ''}>INACTIVE</option>
            </select>

            <div class="muted" style="margin-top:6px;">
              Note: Inactive users are immediately restricted from logging into the HMS system.
            </div>
          </div>
        </section>

        <div class="hms-actions">
          <a class="btn btn-light"
             href="${pageContext.request.contextPath}/admin/staff/detail?id=${user.userId}">
             Cancel
          </a>
          <button class="btn btn-primary" type="submit">Save Changes</button>
        </div>
      </form>
    </main>

    <%@ include file="/view/layout/footer.jsp" %>
  </div>
</div>
</body>
</html>
