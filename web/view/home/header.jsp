<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!-- ✅ Home của bạn là /home (chuẩn theo file cũ) -->
<c:set var="isHome" value="${fn:endsWith(uri, '/home')}" />

<!-- ✅ Booking detect: vẫn giữ như bạn -->
<c:set var="isBooking" value="${requestScope.forceBookingHeader == true or fn:contains(uri, '/booking')}" />

<header class="header ${isBooking ? 'header--booking' : ''}">
  <div class="container header-inner">

    <div class="brand">
      <div class="diamond-icons" style="display:flex;align-items:center;margin-bottom:5px;">
        <!-- ✅ Logo -> về /home -->
        <a href="${ctx}/home"
           style="text-decoration:none !important;display:flex;gap:1px;border:none;outline:none;color:transparent !important;">
          <span style="color:#D4B78F !important;font-size:14px;line-height:1;margin-right:-2px;">◆</span>
          <span style="color:#FFABAB !important;font-size:14px;line-height:1;margin-right:-2px;">◆</span>
          <span style="color:#D4B78F !important;font-size:14px;line-height:1;">◆</span>
        </a>
      </div>

      <div>
        <div class="brand-name">
          <c:out value="${hotel != null ? hotel.name : 'HOTEL MANAGEMENT SYSTEM'}"/>
        </div>
        <div class="brand-sub">
          <c:choose>
            <c:when test="${isBooking}">BOOKING</c:when>
            <c:otherwise>HOME</c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <nav class="nav">
      <!-- ✅ Home luôn về /home -->
      <a class="${isHome ? 'active' : ''}" href="${ctx}/home">Home</a>

      <!-- ✅ Rooms/Contact: nếu đang ở home -> dùng anchor (#rooms/#contact),
             nếu ở trang khác -> nhảy về /home#rooms /home#contact -->
      <c:choose>
        <c:when test="${isHome}">
          <a href="#rooms">Rooms</a>
          <a href="#contact">Contact</a>
        </c:when>
        <c:otherwise>
          <a href="${ctx}/home#rooms">Rooms</a>
          <a href="${ctx}/home#contact">Contact</a>
        </c:otherwise>
      </c:choose>

      <!-- Policy là servlet riêng -->
      <a class="${fn:contains(uri, '/policy') ? 'active' : ''}" href="${ctx}/policy">Policy</a>
    </nav>

    <!-- ACTIONS: ẩn trên trang booking, nhưng giữ width để nav vẫn nằm giữa -->
    <c:choose>
      <c:when test="${isBooking}">
        <div class="header-actions header-actions--ghost" aria-hidden="true"></div>
      </c:when>

      <c:otherwise>
        <div class="header-actions">
          <c:choose>
            <c:when test="${empty sessionScope.userAccount}">
              <a class="btn btn-navy" href="${ctx}/login">LOGIN</a>
              <a class="btn btn-gold" href="${ctx}/booking">BOOK NOW</a>
            </c:when>

            <c:otherwise>
              <div class="header-user-row">
                <div class="user-menu" id="userMenu">
                  <button class="user-trigger" type="button" id="userTrigger" aria-haspopup="menu" aria-expanded="false">
                    <span class="user-role">
                      <span class="user-role__label">WELCOME</span>
                      <span class="user-role__sub">CUSTOMER</span>
                    </span>

                    <c:set var="u" value="${sessionScope.userAccount}" />
                    <c:set var="name" value="${empty u.fullName ? u.email : u.fullName}" />
                    <c:set var="parts" value="${fn:split(fn:trim(name), ' ')}" />

                    <c:choose>
                      <c:when test="${fn:length(parts) >= 2}">
                        <c:set var="first" value="${fn:toUpperCase(fn:substring(parts[0],0,1))}" />
                        <c:set var="last" value="${fn:toUpperCase(fn:substring(parts[fn:length(parts)-1],0,1))}" />
                        <c:set var="initials" value="${first}${last}" />
                      </c:when>
                      <c:otherwise>
                        <c:set var="initials" value="${fn:toUpperCase(fn:substring(name,0,2))}" />
                      </c:otherwise>
                    </c:choose>

                    <span class="user-avatar">
                      <c:out value="${initials}"/>
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
                      <span class="user-dd-text">DASHBOARD</span>
                    </a>

                    <div class="user-dd-divider"></div>

                    <a class="user-dd-item danger" href="${ctx}/logout" role="menuitem">
                      <span class="user-ico" aria-hidden="true">⎋</span>
                      <span class="user-dd-text">SIGN OUT</span>
                    </a>
                  </div>
                </div>

                <a class="btn btn-gold btn-booknow" href="${ctx}/booking">BOOK NOW</a>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</header>
