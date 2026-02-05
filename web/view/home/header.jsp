<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="isHome" value="${fn:contains(uri, '/home')}" />

<header class="header">
  <div class="container header-inner">

    <div class="brand">
      <div class="logo">HMS</div>
      <div>
        <div class="brand-name">
          <c:out value="${hotel != null ? hotel.name : 'HOTEL MANAGEMENT SYSTEM'}"/>
        </div>
        <div class="brand-sub">HOME</div>
      </div>
    </div>

    <nav class="nav">
      <a class="${isHome ? 'active' : ''}" href="${ctx}/home">Home</a>
      <a href="${isHome ? '#rooms' : (ctx + '/home#rooms')}">Rooms</a>
      <a href="${isHome ? '#contact' : (ctx + '/home#contact')}">Contact</a>
    </nav>

    <!-- ✅ ACTIONS (login / user dropdown) -->
    <div class="header-actions">
  <c:choose>
    <c:when test="${empty sessionScope.userAccount}">
      <a class="btn btn-navy" href="${ctx}/login">LOGIN</a>
      <button class="btn btn-gold" type="button">BOOK NOW</button>
    </c:when>

    <c:otherwise>
  <div class="header-user-row">
    <div class="user-menu" id="userMenu">
      <button class="user-trigger" type="button" id="userTrigger" aria-haspopup="menu" aria-expanded="false">
        <span class="user-role">
          <span class="user-role__label">WELCOME</span>
          <span class="user-role__sub">CUSTOMER</span>
        </span>

        <c:set var="email" value="${sessionScope.userAccount.email}" />
        <span class="user-avatar">
          ${fn:toUpperCase(fn:substring(email,0,2))}
        </span>

        <span class="user-caret" aria-hidden="true"></span>
      </button>

      <div class="user-dropdown" id="userDropdown" role="menu" aria-label="User menu">
        <div class="user-dd-head">
          <div class="user-dd-muted">SIGNED IN AS</div>
          <div class="user-dd-email">
            <c:out value="${sessionScope.userAccount.email}"/>
          </div>
        </div>

        <a class="user-dd-item" href="${ctx}/customer/dashboard">
          <span class="user-ico">👤</span>
          <span class="user-dd-text">MY PROFILE</span>
        </a>

        <a class="user-dd-item" href="${ctx}/booking/history">
          <span class="user-ico">🕒</span>
          <span class="user-dd-text">BOOKING HISTORY</span>
        </a>

        <div class="user-dd-divider"></div>

        <a class="user-dd-item danger" href="${ctx}/logout" role="menuitem">
          <span class="user-ico" aria-hidden="true">⎋</span>
          <span class="user-dd-text">SIGN OUT</span>
        </a>
      </div>
    </div>

    <!-- ✅ BOOK NOW cạnh user -->
    <a class="btn btn-gold btn-booknow" href="${ctx}/booking">BOOK NOW</a>
  </div>
</c:otherwise>
  </c:choose>
</div>


  </div>
</header>
