<%-- 
    Document   : sidebar_staff
    Created on : Mar 2, 2026, 1:26:35 AM
    Author     : Admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .staff-profile {
        position: relative;
        cursor: pointer;
    }

    .profile-menu {
        display: none;
        position: absolute;
        bottom: 60px;
        left: 0;
        background: #0f172a;
        border-radius: 12px;
        padding: 10px 0;
        width: 180px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.25);
    }

    .profile-menu a {
        display: block;
        padding: 10px 16px;
        color: white;
        text-decoration: none;
    }

    .profile-menu a:hover {
        background: rgba(255,255,255,0.08);
    }
</style>

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

    <div class="staff-profile" onclick="toggleProfileMenu()">
        <div class="avatar">AR</div>
        <div class="profile-txt">
            <div class="name">Alex Rivera</div>
            <div class="role">Service Staff</div>
        </div>

        <!-- Dropdown menu -->
        <div id="profileMenu" class="profile-menu">
            <a href="${pageContext.request.contextPath}/staff/profile">Profile</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>
</aside>
<script>
    function toggleProfileMenu() {
        var menu = document.getElementById("profileMenu");
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    }
</script>
