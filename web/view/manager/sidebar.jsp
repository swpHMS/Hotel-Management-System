<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
    .sb{
        width: 260px;
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }

    .sb-nav{
        flex: 1 1 auto;
        overflow-y: auto;
        padding-bottom: 12px;
    }

    .sb-nav::-webkit-scrollbar{
        width: 6px;
    }

    .sb-nav::-webkit-scrollbar-thumb{
        background: rgba(148,163,184,.35);
        border-radius: 10px;
    }

    .sb-userwrap{
        flex: 0 0 auto;
        padding-top: 12px;
        padding-bottom: 12px;
        position: sticky;
        bottom: 0;
        background: #0f172a;
        border-top: 1px solid rgba(255,255,255,0.06);
    }

    .sb-user{
        width: calc(100% - 24px);
        margin: 0 12px;
        border: none;
        outline: none;
        background: #16233a;
        color: #fff;
        border-radius: 18px;
        padding: 14px 16px;
        display: flex;
        align-items: center;
        gap: 14px;
        cursor: pointer;
        transition: background .2s ease;
    }

    .sb-user:hover{
        background: #1b2b46;
    }

    .sb-avatar{
        width: 56px;
        height: 56px;
        border-radius: 18px;
        background: #24324a;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 18px;
        flex-shrink: 0;
    }

    .sb-userinfo{
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        text-align: left;
        min-width: 0;
        flex: 1;
    }

    .sb-username{
        font-size: 16px;
        font-weight: 600;
        line-height: 1.2;
        color: #fff;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 140px;
    }

    .sb-role{
        font-size: 11px;
        letter-spacing: .8px;
        color: #b6c2d1;
        margin-top: 3px;
    }

    .sb-user-chevron{
        font-size: 18px;
        color: #fff;
        transition: transform .25s ease;
        flex-shrink: 0;
    }

    .sb-userwrap.open .sb-user-chevron{
        transform: rotate(180deg);
    }

    .sb-dropdown{
        display: none;
        margin: 0 12px 12px 12px;
        background: #020b2a;
        border-radius: 18px;
        padding: 12px 0;
        box-shadow: 0 10px 30px rgba(0,0,0,0.25);
    }

    .sb-userwrap.open .sb-dropdown{
        display: block;
    }

    .sb-dropdown a{
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 18px;
        text-decoration: none;
        color: #ffffff;
        font-size: 15px;
        transition: background .2s ease, color .2s ease;
    }

    .sb-dropdown a:hover{
        background: rgba(255,255,255,0.04);
    }

    .sb-dropdown a i{
        font-size: 22px;
        line-height: 1;
    }

    .sb-dropdown a.danger{
        color: #ff6b6b;
    }
</style>

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
                ? ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase()
                : ("" + userName.charAt(0)).toUpperCase();
    }
%>

<aside class="sb">
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
        <a class="sb-item <%= "dashboard".equals(active) ? "active" : "" %>"
           href="${pageContext.request.contextPath}/manager/dashboard">
            <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
        </a>

        <a class="sb-item <%= "calendar".equals(active) ? "active" : "" %>" href="#">
            <i class="bi bi-calendar3"></i><span>Calendar</span>
        </a>

        <div class="sb-section">ACCOMMODATIONS</div>

        <a class="sb-item <%= "rooms".equals(active) ? "active" : "" %>"
           href="${pageContext.request.contextPath}/manager/rooms">
            <i class="bi bi-door-open-fill"></i><span>Rooms</span>
        </a>

        <a class="sb-item <%= "suiteTypes".equals(active) ? "active" : "" %>" href="#">
            <i class="bi bi-building"></i><span>Suite Types</span>
        </a>

        <a class="sb-item <%= "roomRegistry".equals(active)?"active":"" %>" href="${pageContext.request.contextPath}/manager/room-registry">
            <i class="bi bi-card-list"></i><span>Room Registry</span>
        </a>

        <a class="sb-item <%= "amenities".equals(active) ? "active" : "" %>" href="#">
            <i class="bi bi-stars"></i><span>Guest Amenities</span>
        </a>

        <div class="sb-section">OPERATIONS</div>

        <a class="sb-item <%= "services".equals(active) ? "active" : "" %>" href="#">
            <i class="bi bi-gem"></i><span>Services</span>
        </a>

        <a class="sb-item <%= "finance".equals(active) ? "active" : "" %>" href="#">
            <i class="bi bi-bar-chart-fill"></i><span>Finance</span>
        </a>

        <a class="sb-item <%= "propertyInfo".equals(active) ? "active" : "" %>"
   href="${pageContext.request.contextPath}/manager/property-info">
    <i class="bi bi-crown-fill"></i><span>Property Info</span>
</a>
    </nav>

    <div class="sb-userwrap" id="sbUserWrap">
        <div class="sb-dropdown" id="sbDropdown">
            <a href="${pageContext.request.contextPath}/staff-profile">
                <i class="bi bi-person"></i>
                <span>Profile</span>
            </a>

            <a class="danger" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-left"></i>
                <span>Logout</span>
            </a>
        </div>

        <button type="button" class="sb-user" id="sbUserBtn">
            <div class="sb-avatar"><%= initials %></div>

            <div class="sb-userinfo">
                <div class="sb-username"><%= userName %></div>
                <div class="sb-role">MANAGER</div>
            </div>

            <i class="bi bi-chevron-up sb-user-chevron"></i>
        </button>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const userWrap = document.getElementById("sbUserWrap");
        const userBtn = document.getElementById("sbUserBtn");

        if (!userWrap || !userBtn)
            return;

        userBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            userWrap.classList.toggle("open");
        });

        document.addEventListener("click", function (e) {
            if (!userWrap.contains(e.target)) {
                userWrap.classList.remove("open");
            }
        });
    });
</script>