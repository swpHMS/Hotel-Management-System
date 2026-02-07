<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
  String active = (String) request.getAttribute("active");
  if (active == null) active = "";
%>

<aside class="hms-sidebar">
  <div class="hms-brand">
    <div class="hms-brand__title">HMS Admin</div>
    <div class="hms-brand__sub">ADMIN PANEL</div>
  </div>

  <nav class="hms-nav">
    <a class="hms-nav__item <%= "dashboard".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/dashboard">
      <span class="hms-nav__icon">🏠</span><span>Dashboard</span>
    </a>

    <div class="hms-nav__section">User Management</div>
    <a class="hms-nav__item <%= "staff_list".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/staff">
      <span class="hms-nav__icon">👥</span><span>Staff List</span>
    </a>
    <a class="hms-nav__item <%= "staff_create".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/staff/create">
      <span class="hms-nav__icon">➕</span><span>Create Staff</span>
    </a>

    <div class="hms-nav__section">Customer Management</div>
    <a class="hms-nav__item <%= "customers".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/customers">
      <span class="hms-nav__icon">🧾</span><span>Customer List</span>
    </a>

    <div class="hms-nav__section">System Configuration</div>
    <a class="hms-nav__item <%= "system".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/system">
      <span class="hms-nav__icon">⚙️</span><span>System Config</span>
    </a>
  </nav>

  <div class="hms-sidebar__footer">
    <div class="hms-small">Database: <b>Hotel_Management_System</b></div>
    <div class="hms-small">Tomcat 10 • Servlet + JSP</div>
  </div>
</aside>
