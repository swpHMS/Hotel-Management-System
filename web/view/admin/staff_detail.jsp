<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>HMS Admin - User Detail</title>
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
            <span class="current">User Detail</span>
          </div>
          <h1 class="hms-title">User Detail</h1>
        </div>

        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/staff/edit?id=${user.userId}">
           Edit User Account
        </a>
      </div>

      <section class="hms-panel">
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
            <div class="hms-profile__sub">${user.roleName}</div>
          </div>
        </div>

        <div class="hms-kv-grid">
          <div class="kv">
            <div class="kv__k">FULL NAME</div>
            <div class="kv__v">
              <c:out value="${user.fullName}"/>
            </div>
          </div>

          <div class="kv">
            <div class="kv__k">EMAIL ADDRESS</div>
            <div class="kv__v"><c:out value="${user.email}"/></div>
          </div>

          <div class="kv">
            <div class="kv__k">PHONE NUMBER</div>
            <div class="kv__v">
              <c:choose>
                <c:when test="${empty user.phone}">—</c:when>
                <c:otherwise><c:out value="${user.phone}"/></c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="kv">
            <div class="kv__k">ROLE</div>
            <div class="kv__v"><c:out value="${user.roleName}"/></div>
          </div>

          <div class="kv">
            <div class="kv__k">AUTHENTICATION TYPE</div>
            <div class="kv__v">${user.authProviderText}</div>
          </div>

          <div class="kv">
            <div class="kv__k">ACCOUNT STATUS</div>
            <div class="kv__v">
              <c:choose>
                <c:when test="${user.status == 1}">
                  <span class="pill green">ACTIVE</span>
                </c:when>
                <c:otherwise>
                  <span class="pill gray">INACTIVE</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </section>

      <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff">← Back to Staff List</a>
    </main>

    <%@ include file="/view/layout/footer.jsp" %>
  </div>
</div>
</body>
</html>
