<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>HMS Admin - Staff List</title>
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
            <span class="current">Staff List</span>
          </div>
          <h1 class="hms-title">Staff List</h1>
          <p class="hms-subtitle">View and filter staff accounts by role/status.</p>
        </div>

        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/staff/create">Create Staff</a>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <!-- Filters (ONLY 1 FORM) -->
      <form class="hms-filter" method="get" action="${pageContext.request.contextPath}/admin/staff">
        <div class="field">
          <label>Role</label>
          <select name="roleId">
            <option value="all" ${selectedRoleId=='all'?'selected':''}>All</option>
            <c:forEach var="r" items="${roles}">
              <option value="${r.roleId}" ${selectedRoleId==r.roleId.toString()?'selected':''}>
                ${r.roleName}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="field">
          <label>Status</label>
          <select name="status">
            <option value="all" ${selectedStatus=='all'?'selected':''}>All</option>
            <option value="1" ${selectedStatus=='1'?'selected':''}>ACTIVE</option>
            <option value="0" ${selectedStatus=='0'?'selected':''}>INACTIVE</option>
          </select>
        </div>

        <button class="btn btn-light" type="submit">Apply</button>
      </form>

      <!-- Table -->
      <div class="hms-table-wrap">
        <table class="hms-table">
          <thead>
            <tr>
              <th>Full Name</th>
              <th>Email</th>
              <th>Role</th>
              <th>Status</th>
              <th style="text-align:right">Actions</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="u" items="${users}">
              <tr>
                <td class="cell-title">
                  <c:choose>
                    <c:when test="${empty u.fullName}">—</c:when>
                    <c:otherwise>${u.fullName}</c:otherwise>
                  </c:choose>
                </td>
                <td class="muted">${u.email}</td>
                <td>${u.roleName}</td>
                <td>
                  <c:choose>
                    <c:when test="${u.status == 1}">
                      <span class="pill green">ACTIVE</span>
                    </c:when>
                    <c:otherwise>
                      <span class="pill gray">INACTIVE</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td style="text-align:right">
                  <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff/detail?id=${u.userId}">View</a>
                  <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff/edit?id=${u.userId}">Edit</a>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty users}">
              <tr>
                <td colspan="5" class="muted" style="text-align:center; padding:24px;">
                  No users found matching the selected filters.
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <!-- Pagination (KEEP FILTERS) -->
      <c:set var="ctx" value="${pageContext.request.contextPath}" />

      <div class="hms-pagination">
        <div class="hms-pagination__info">
          Showing page <b>${page}</b> / <b>${totalPages}</b> — Total: <b>${totalUsers}</b> users
        </div>

        <div class="hms-pagination__controls">
          <c:choose>
            <c:when test="${page <= 1}">
              <span class="pg-btn disabled">Previous</span>
            </c:when>
            <c:otherwise>
              <a class="pg-btn"
                 href="${ctx}/admin/staff?page=${page-1}&roleId=${selectedRoleId}&status=${selectedStatus}">
                Previous
              </a>
            </c:otherwise>
          </c:choose>

          <c:forEach begin="1" end="${totalPages}" var="p">
            <c:choose>
              <c:when test="${p == page}">
                <span class="pg-btn active">${p}</span>
              </c:when>
              <c:otherwise>
                <a class="pg-btn"
                   href="${ctx}/admin/staff?page=${p}&roleId=${selectedRoleId}&status=${selectedStatus}">
                  ${p}
                </a>
              </c:otherwise>
            </c:choose>
          </c:forEach>

          <c:choose>
            <c:when test="${page >= totalPages}">
              <span class="pg-btn disabled">Next</span>
            </c:when>
            <c:otherwise>
              <a class="pg-btn"
                 href="${ctx}/admin/staff?page=${page+1}&roleId=${selectedRoleId}&status=${selectedStatus}">
                Next
              </a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </main>

    <%@ include file="/view/layout/footer.jsp" %>
  </div>
</div>
</body>
</html>
