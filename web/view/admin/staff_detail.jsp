<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>HMS Admin - Staff Detail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

  <style>
   .detail-card{
  background:#fff;
  border:1px solid #e7edf6;
  border-radius:16px;
  padding:24px;
}

.detail-grid-3{
  display:grid;
  grid-template-columns: repeat(3, 1fr);
  gap:32px;
}

.detail-col{
  padding-right:24px;
  border-right:1px solid #eef2f7;
}

.detail-col:last-child{
  border-right:none;
  padding-right:0;
}

.detail-col__title{
  font-size:13px;
  font-weight:800;
  letter-spacing:.18em;
  color:#94a3b8;
  margin-bottom:18px;
}

.detail-item{
  margin-bottom:18px;
}

.detail-k{
  font-size:12px;
  font-weight:800;
  letter-spacing:.08em;
  color:#94a3b8;
  margin-bottom:4px;
}

.detail-v{
  font-size:16px;
  font-weight:800;
  color:#0f172a;
}

.detail-v.link{
  color:#2563eb;
}

/* Responsive */
@media (max-width: 900px){
  .detail-grid-3{
    grid-template-columns: 1fr;
  }
  .detail-col{
    border-right:none;
    padding-right:0;
    border-bottom:1px solid #eef2f7;
    padding-bottom:20px;
    margin-bottom:20px;
  }
  .detail-col:last-child{
    border-bottom:none;
    margin-bottom:0;
    padding-bottom:0;
  }
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
          <h1 class="hms-title">Staff Detail</h1>
          <p class="hms-subtitle">View full staff profile and account information.</p>
        </div>

        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/staff/edit?id=${staff.userId}">
          Edit Staff Account
        </a>
      </div>

      <section class="detail-card">
  <div class="detail-grid-3">

    <!-- BASIC INFO -->
    <div class="detail-col">
      <div class="detail-col__title">BASIC INFO</div>

      <div class="detail-item">
        <div class="detail-k">FULL NAME</div>
        <div class="detail-v">${staff.fullName}</div>
      </div>

      <div class="detail-item">
        <div class="detail-k">GENDER</div>
        <div class="detail-v">
          <c:choose>
            <c:when test="${staff.gender == 1}">Male</c:when>
            <c:when test="${staff.gender == 2}">Female</c:when>
            <c:otherwise>Other</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="detail-item">
        <div class="detail-k">DATE OF BIRTH</div>
        <div class="detail-v">
          <fmt:formatDate value="${staff.dateOfBirth}" pattern="yyyy-MM-dd"/>
        </div>
      </div>

      <div class="detail-item">
        <div class="detail-k">RESIDENCE ADDRESS</div>
        <div class="detail-v">${staff.residenceAddress}</div>
      </div>
    </div>

    <!-- IDENTITY & CONTACT -->
    <div class="detail-col">
      <div class="detail-col__title">IDENTITY & CONTACT</div>

      <div class="detail-item">
        <div class="detail-k">IDENTITY NUMBER</div>
        <div class="detail-v">${staff.identityNumber}</div>
      </div>

      <div class="detail-item">
        <div class="detail-k">PHONE</div>
        <div class="detail-v">${staff.phone}</div>
      </div>

      <div class="detail-item">
        <div class="detail-k">EMAIL ADDRESS</div>
        <div class="detail-v link">${staff.email}</div>
      </div>
    </div>

    <!-- ACCOUNT INFO -->
    <div class="detail-col">
      <div class="detail-col__title">ACCOUNT INFO</div>

      <div class="detail-item">
        <div class="detail-k">ACCOUNT STATUS</div>
        <div class="detail-v">
          <c:choose>
            <c:when test="${staff.status == 1}">
              <span class="pill green">Active</span>
            </c:when>
            <c:otherwise>
              <span class="pill gray">Inactive</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="detail-item">
        <div class="detail-k">ROLE</div>
        <div class="detail-v">${staff.roleName}</div>
      </div>

      <div class="detail-item">
        <div class="detail-k">USER ID</div>
        <div class="detail-v">${staff.userId}</div>
      </div>
    </div>

  </div>
</section>


      <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff">← Back to Staff List</a>
    </main>

    <%@ include file="/view/admin_layout/footer.jsp" %>
  </div>
</div>
</body>
</html>
