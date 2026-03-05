<%-- 
    Document   : sidebar_staff
    Created on : Mar 2, 2026, 1:26:35 AM
    Author     : Admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="staff-sidebar">
  <div class="sb-brand">
        <div class="sb-logo">HMS</div>
        <div>
            <div class="sb-title">Staff Panel</div>
            <div class="sb-sub">Hotel System</div>
        </div>
    </div>

  <nav class="staff-nav">
    <a class="staff-nav__item ${page eq 'roomops' ? 'active' : ''}" href="#">
      <span class="ico">🏨</span>
      <span>Room Operations</span>
    </a>

    <a class="staff-nav__item ${page eq 'serviceorder' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/service-orders">
      <span class="ico">🧾</span>
      <span>Service Orders</span>
    </a>
  </nav>

  <div class="staff-profile">
    <div class="avatar">AR</div>
    <div class="profile-txt">
      <div class="name">Alex Rivera</div>
      <div class="role">Service Staff</div>
    </div>
  </div>
</aside>
