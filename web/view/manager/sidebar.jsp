<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<%
    Object obj = session.getAttribute("userAccount");
    String userName = "Manager";

    if (obj != null && obj instanceof model.User) {
        model.User u = (model.User) obj;
        userName = u.getFullName();
        if (userName == null || userName.trim().isEmpty()) {
            userName = u.getEmail();
        }
    }

    String active = (String) request.getAttribute("active");
    if (active == null) active = "dashboard";

    String initials = "M";
    if (userName != null && !userName.trim().isEmpty()) {
        String[] parts = userName.trim().split("\\s+");
        initials = parts.length >= 2
                ? ("" + parts[0].charAt(0) + parts[parts.length-1].charAt(0)).toUpperCase()
                : ("" + userName.charAt(0)).toUpperCase();
    }
%>
<style>
    .sb {
        display: flex;
        flex-direction: column;
    }

    .sb-nav {
        flex: 1;
    }

    .sb-userwrap {
        margin-top: auto;
        padding: 16px 0;
    }
</style>
<aside class="sb">

    <!-- BRAND (giữ nguyên style) -->
    <div class="sb-brand">
        <div class="diamond-icons" style="display:flex;align-items:center;margin-bottom:5px;">
            <a href="${pageContext.request.contextPath}/home"
               style="text-decoration:none;display:flex;gap:1px;align-items:center;">
                <span style="color:#FFD700;font-size:14px;">◆</span>
                <span style="color:#FF0000;font-size:18px;">◆</span>
                <span style="color:#FFD700;font-size:14px;">◆</span>
            </a>
        </div>
        <div class="sb-brand-text">
            <div class="sb-title">Regal Quintet Hotel</div>
            <div class="sb-sub">Manager Panel</div>
        </div>
    </div>

    <nav class="sb-nav">

        <a class="sb-item <%= "dashboard".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/manager/dashboard">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Dashboard</span>
        </a>

        <a class="sb-item <%= "calendar".equals(active)?"active":"" %>"
           href="#">
            <i class="bi bi-calendar3"></i>
            <span>Calendar</span>
        </a>

        <div class="sb-section">ACCOMMODATIONS</div>

        <a class="sb-item <%= "rooms".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/manager/rooms">
            <i class="bi bi-door-open-fill"></i>
            <span>Rooms</span>
        </a>

        <a class="sb-item" href="#">
            <i class="bi bi-building"></i>
            <span>Suite Types</span>
        </a>

        <a class="sb-item" href="#">
            <i class="bi bi-card-list"></i>
            <span>Room Registry</span>
        </a>

        <a class="sb-item" href="#">
            <i class="bi bi-stars"></i>
            <span>Guest Amenities</span>
        </a>

        <div class="sb-section">OPERATIONS</div>

        <a class="sb-item" href="#">
            <i class="bi bi-gem"></i>
            <span>Services</span>
        </a>

        <a class="sb-item" href="#">
            <i class="bi bi-bar-chart-fill"></i>
            <span>Finance</span>
        </a>

        <a class="sb-item" href="#">
            <i class="bi bi-crown-fill"></i>
            <span>Property Info</span>
        </a>

    </nav>

    <!-- USER -->
    <div class="sb-userwrap" id="sbUserWrap">
        <button type="button" class="sb-user" id="sbUserBtn">
            <div class="sb-avatar"><%= initials %></div>
            <div class="sb-userinfo">
                <div class="sb-username"><%= userName %></div>
                <div class="sb-role">MANAGER</div>
            </div>
            <i class="bi bi-chevron-up ms-auto small"></i>
        </button>

        <div class="sb-dropdown">
            <a href="${pageContext.request.contextPath}/profile">
                <i class="bi bi-person me-2"></i> Profile
            </a>
            <a class="danger" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-left me-2"></i> Logout
            </a>
        </div>
    </div>

</aside>