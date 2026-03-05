<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
  String userName = (String) session.getAttribute("adminName");
  if (userName == null) userName = "Administrator";
%>

<header class="hms-header">
  <div class="hms-header__left">
    <div class="hms-header__app">Hotel Management System</div>
    <div class="hms-header__hint">Admin Web Application</div>
  </div>

  <div class="hms-header__right">
    <div class="hms-user">
      <div class="hms-user__avatar">AD</div>
      <div class="hms-user__meta">
        <div class="hms-user__name"><%= userName %></div>
        <div class="hms-user__role">ADMIN</div>
      </div>

      <div class="hms-user__dropdown">
        <a class="hms-dd__item" href="${pageContext.request.contextPath}/admin/profile">Profile</a>
        <div class="hms-dd__divider"></div>
        <a class="hms-dd__item is-danger" href="${pageContext.request.contextPath}/logout">Logout</a>
      </div>
    </div>
  </div>
</header>
