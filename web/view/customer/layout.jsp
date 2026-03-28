<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title><c:out value="${pageTitle}" default="Customer Dashboard"/></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer/layout.css"/>
        <c:choose>
            <c:when test="${not empty pageStyles}">
                <c:forEach var="pageStyle" items="${pageStyles}">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer/${pageStyle}"/>
                </c:forEach>
            </c:when>
            <c:when test="${activeTab == 'current'}">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer/current-bookings.css"/>
            </c:when>
            <c:when test="${activeTab == 'past'}">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer/past-stays.css"/>
            </c:when>
            <c:when test="${activeTab == 'viewProfile' || activeTab == 'editProfile'}">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer/pages.css"/>
            </c:when>
            <c:when test="${activeTab == 'changePassword'}">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer/change-password.css"/>
            </c:when>
        </c:choose>
    </head>

    <body>

        <div class="topbar">
            <div class="dash-avatar">
                <c:out value="${initials}" default="U"/>
            </div>

            <div class="welcome">
                <h1>Welcome, <c:out value="${profile.fullName}" default="User"/></h1>

                <div class="sub">
                    <span>&#9993; <c:out value="${profile.email}" default=""/></span>
                    <span>&#128205; <c:out value="${profile.residenceAddress}" default=""/></span>
                </div>
            </div>
        </div>

        <div class="wrap">
            <div class="container">
                <div class="sidebar">
                    <jsp:include page="/view/customer/sidebar.jsp"/>
                </div>

                <div class="content">
                    <c:choose>
                        <c:when test="${not empty contentPage}">
                            <jsp:include page="${contentPage}" />
                        </c:when>
                        <c:otherwise>
                            <div class="empty">
                                <div class="icon">!</div>
                                <h3>Missing content</h3>
                                <p>contentPage is empty.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </body>
</html>

