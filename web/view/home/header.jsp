<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!-- Home -->
<c:set var="isHome" value="${fn:endsWith(uri, '/home')}" />

<!-- Booking detect -->
<c:set var="isBooking" value="${requestScope.forceBookingHeader == true or fn:contains(uri, '/booking')}" />

<header class="header ${isBooking ? 'header--booking' : ''}">
    <div class="container header-inner">

        <div class="brand">
            <div class="diamond-icons" style="display:flex;align-items:center;margin-bottom:5px;">
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
            <a class="${isHome ? 'active' : ''}" href="${ctx}/home">Home</a>

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

            <a class="${fn:contains(uri, '/policy') ? 'active' : ''}" href="${ctx}/policy">Policy</a>
        </nav>

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

                                        <%-- Lấy user hiện tại từ session --%>
                                        <c:set var="u" value="${sessionScope.userAccount}" />

                                        <%-- Ưu tiên fullName, nếu rỗng thì fallback sang email --%>
                                        <c:set var="displayName" value="${empty u.fullName ? u.email : u.fullName}" />
                                        <c:set var="displayName" value="${fn:trim(displayName)}" />

                                        <%-- Chuẩn hóa initials --%>
                                        <c:choose>
                                            <%-- Có khoảng trắng => lấy chữ đầu và chữ cuối --%>
                                            <c:when test="${fn:contains(displayName, ' ')}">
                                                <c:set var="parts" value="${fn:split(displayName, ' ')}" />
                                                <c:set var="firstPart" value="${parts[0]}" />
                                                <c:set var="lastPart" value="${parts[fn:length(parts)-1]}" />

                                                <c:choose>
                                                    <c:when test="${not empty firstPart and not empty lastPart}">
                                                        <c:set var="firstInitial" value="${fn:toUpperCase(fn:substring(firstPart, 0, 1))}" />
                                                        <c:set var="lastInitial" value="${fn:toUpperCase(fn:substring(lastPart, 0, 1))}" />
                                                        <c:set var="initials" value="${firstInitial}${lastInitial}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="initials" value="U" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>

                                            <%-- Không có khoảng trắng => lấy 1-2 ký tự đầu --%>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${not empty displayName and fn:length(displayName) >= 2}">
                                                        <c:set var="initials" value="${fn:toUpperCase(fn:substring(displayName, 0, 2))}" />
                                                    </c:when>
                                                    <c:when test="${not empty displayName}">
                                                        <c:set var="initials" value="${fn:toUpperCase(fn:substring(displayName, 0, 1))}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="initials" value="U" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>

                                        <span class="user-avatar">
                                            <c:out value="${initials}" />
                                        </span>

                                        <span class="user-caret" aria-hidden="true"></span>
                                    </button>

                                    <div class="user-dropdown" id="userDropdown" role="menu" aria-label="User menu">
                                        <div class="user-dd-head">
                                            <div class="user-dd-muted">SIGNED IN AS</div>
                                            <div class="user-dd-email">
                                                <c:out value="${sessionScope.userAccount.email}" />
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