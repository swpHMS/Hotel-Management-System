<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <title>HMS Admin | Customer List</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/customer.css"/>
</head>

<body>
  <div class="app-shell">

    <%@ include file="/view/admin_layout/sidebar.jsp" %>

    <main class="hms-main">

      <div class="hms-page">
        <div class="admin-content">

          <h1 class="page-title">Customer List</h1>

          <!-- FILTER -->
          <form class="filter-card" method="get" action="${pageContext.request.contextPath}/admin/customers">
            <div class="filter-grid">
              <div class="field">
                <label>Search</label>
                <div class="search-wrap">
                  <span class="ico" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18">
                      <path fill="currentColor"
                        d="M10 2a8 8 0 1 1 5.293 14.293l4.707 4.707-1.414 1.414-4.707-4.707A8 8 0 0 1 10 2zm0 2a6 6 0 1 0 0 12a6 6 0 0 0 0-12z"/>
                    </svg>
                  </span>
                  <input type="text" name="q" placeholder="Name, Phone, ID"
                         value="${fn:escapeXml(q)}"/>
                </div>
              </div>

              <div class="field">
                <label>Gender</label>
                <select name="gender">
                  <option value="all" ${gender == 'all' ? 'selected' : ''}>All</option>
                  <option value="1" ${gender == '1' ? 'selected' : ''}>Male</option>
                  <option value="2" ${gender == '2' ? 'selected' : ''}>Female</option>
                </select>
              </div>

              <div class="field">
                <label>Status</label>
                <select name="status">
                  <option value="all" ${status == 'all' ? 'selected' : ''}>All</option>
                  <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                  <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                </select>
              </div>
            </div>

            <input type="hidden" name="size" value="${size}"/>

            <div class="filter-actions">
              <button class="btn btn-primary" type="submit">Apply</button>
              <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/customers">Reset</a>
            </div>
          </form>

          <!-- TABLE -->
          <div class="table-card">
            <table class="hms-table">
              <thead>
                <tr>
                  <th>Customer Name</th>
                  <th>Identity Number</th>
                  <th>Phone / Email</th>
                  <th>Date of Birth</th>
                  <th class="col-gender">Gender</th>
                  <th>Status</th>
                  <th class="text-right">Actions</th>
                </tr>
              </thead>

              <tbody>
                <c:forEach items="${customers}" var="c">
                  <tr>
                    <td>
                      <div class="cell-title">${c.fullName}</div>
                      <div class="cell-sub">${c.residenceAddress != null ? c.residenceAddress : '—'}</div>
                    </td>

                    <td class="muted">${c.identityNumber != null ? c.identityNumber : '—'}</td>

                    <td>
                      <div class="cell-title">${c.phone != null ? c.phone : '—'}</div>
                      <div class="cell-sub">
                        <c:choose>
                          <c:when test="${not empty c.email}">
                            <a class="link" href="mailto:${c.email}">${c.email}</a>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </div>
                    </td>

                    <td class="muted">
                      <c:choose>
                        <c:when test="${c.dateOfBirth != null}">
                          <fmt:formatDate value="${c.dateOfBirth}" pattern="yyyy-MM-dd"/>
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </td>

                    <td class="col-gender muted">
                      <c:choose>
                        <c:when test="${c.gender == 1}">Male</c:when>
                        <c:when test="${c.gender == 2}">Female</c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </td>

                    <td>
                      <c:choose>
                        <c:when test="${c.accountStatus == 'ACTIVE'}">
                          <span class="badge badge-green">Active</span>
                        </c:when>
                        <c:when test="${c.accountStatus == 'INACTIVE'}">
                          <span class="badge badge-red">Inactive</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge">—</span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <td class="text-right">
                      <a class="link" href="${pageContext.request.contextPath}/admin/customer-detail?id=${c.customerId}">Detail</a>
                      <span class="sep">|</span>
                      <c:choose>
                        <c:when test="${c.userId != null}">
                          <a class="link" href="${pageContext.request.contextPath}/admin/customer-status?id=${c.customerId}">Change Status</a>
                        </c:when>
                        <c:otherwise>
                          <span class="link disabled">Change Status</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty customers}">
                  <tr><td class="empty" colspan="7">No data</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>

        </div>
      </div>

      <%@ include file="/view/admin_layout/footer.jsp" %>
    </main>

  </div>
</body>
</html>
