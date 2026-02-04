<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="isCustomerDashboard" value="${uri.contains('/customer/dashboard')}" />

<header class="hms-header">
  <div class="hms-inner">

    <a class="hms-brand" href="${pageContext.request.contextPath}/home">
      <span class="hms-logo">HMS</span>
      <span class="hms-brand-text">Regal Quintet Hotel</span>
    </a>

    <nav class="hms-nav" aria-label="Primary">
      <a href="${pageContext.request.contextPath}/home" class="hms-link">Home</a>
      <a href="${pageContext.request.contextPath}/rooms" class="hms-link">Rooms</a>
      <a href="${pageContext.request.contextPath}/contact" class="hms-link">Contact</a>
    </nav>

    <div class="hms-user">
      <span class="hms-username">
        <c:out value="${sessionScope.userName != null ? sessionScope.userName : 'USER'}"/>
      </span>
      <span class="hms-role">CUSTOMER</span>

      <button class="hms-avatarBtn" type="button" aria-haspopup="menu" aria-expanded="false">
        <span class="hms-avatar">
          <c:out value="${sessionScope.userInitials != null ? sessionScope.userInitials : 'LE'}"/>
        </span>
        <span class="hms-caret">▾</span>
      </button>

      <div class="hms-menu" role="menu">
        <c:if test="${not isCustomerDashboard}">
          <a role="menuitem" class="hms-item"
             href="${pageContext.request.contextPath}/customer/dashboard">
            Dashboard
          </a>
          <div class="hms-divider"></div>
        </c:if>

        <form class="hms-logoutForm"
              action="${pageContext.request.contextPath}/logout"
              method="post">
          <button type="submit" class="hms-item hms-danger" role="menuitem">
            Log out
          </button>
        </form>
      </div>
    </div>

  </div>
</header>

<div class="hms-headerSpacer"></div>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
<script defer src="${pageContext.request.contextPath}/assets/js/header.js"></script>
