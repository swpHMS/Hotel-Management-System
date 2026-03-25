<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="menu">
    <a class="${activeTab == 'current' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/customer/bookings/current">
        <span class="mi">📅</span>
        <span class="text">
            <span class="title">Current Bookings</span>
            <span class="desc">Your upcoming stays</span>
        </span>
    </a>

    <a class="${activeTab == 'past' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/customer/bookings/past">
        <span class="mi">🏨</span>
        <span class="text">
            <span class="title">Past Stays</span>
            <span class="desc">Stay history</span>
        </span>
    </a>

    <a class="${activeTab == 'viewProfile' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/customer/profile">
        <span class="mi">👤</span>
        <span class="text">
            <span class="title">View Profile</span>
            <span class="desc">Review your information</span>
        </span>
    </a>

    <a class="${activeTab == 'editProfile' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/customer/profile/edit">
        <span class="mi">✎</span>
        <span class="text">
            <span class="title">Edit Profile</span>
            <span class="desc">Update your information</span>
        </span>
    </a>

    <a class="${activeTab == 'changePassword' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/customer/change-password">
        <span class="mi">🔒</span>
        <span class="text">
            <span class="title">Change Password</span>
            <span class="desc">Keep your account secure</span>
        </span>
    </a>

    <a class="actionItem logout" href="${pageContext.request.contextPath}/logout">
        <span class="mi">⎋</span>
        <span class="text">
            <span class="title">Logout</span>
        </span>
    </a>
</div>

<div class="back">
    <a href="${pageContext.request.contextPath}/home">← Back to Home</a>
</div>
