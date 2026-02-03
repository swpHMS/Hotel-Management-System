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

    <div class="header-actions">
      <c:choose>
        <c:when test="${empty sessionScope.user}">
          <a class="btn btn-navy" href="${ctx}/login">LOGIN</a>
        </c:when>
        <c:otherwise>
          <a class="btn btn-navy" href="${ctx}/logout">LOGOUT</a>
        </c:otherwise>
      </c:choose>

      <button class="btn btn-gold" type="button">BOOK NOW</button>
    </div>
  </div>
</header>
