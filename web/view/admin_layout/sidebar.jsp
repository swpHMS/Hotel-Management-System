<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

<%
String userName = (String) session.getAttribute("adminName");
if (userName == null || userName.trim().isEmpty()) userName = "Administrator";

String active = (String) request.getAttribute("active");
if (active == null) active = "";

String[] parts = userName.trim().split("\\s+");
String initials = parts.length >= 2
        ? ("" + parts[0].charAt(0) + parts[parts.length-1].charAt(0)).toUpperCase()
        : ("" + userName.charAt(0)).toUpperCase();
%>

<aside class="sb">

    <div class="sb-brand">
        <div class="sb-logo">HMS</div>
        <div>
            <div class="sb-title">Admin Panel</div>
            <div class="sb-sub">Hotel System</div>
        </div>
    </div>

    <nav class="sb-nav">

        <a class="sb-item <%= "dashboard".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/admin/dashboard">
            Dashboard
        </a>

        <div class="sb-section">Users</div>

        <a class="sb-item <%= "staff_list".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/admin/staff">
            Staff List
        </a>

        <a class="sb-item <%= "staff_create".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/admin/staff/create">
            Create Staff
        </a>

        <div class="sb-section">Customers</div>

        <a class="sb-item <%= "customers".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/admin/customers">
            Customer List
        </a>

        <div class="sb-section">System</div>

        <a class="sb-item <%= "system".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/admin/system">
            System Config
        </a>

    </nav>

    <div class="sb-userwrap" id="sbUserWrap">
        <button type="button" class="sb-user" id="sbUserBtn">

            <div class="sb-avatar"><%= initials %></div>

            <div class="sb-userinfo">
                <div class="sb-username"><%= userName %></div>
                <div class="sb-role">ADMIN</div>
            </div>

        </button>

        <div class="sb-dropdown">
            <a href="${pageContext.request.contextPath}/admin/profile">Profile</a>
            <a class="danger" href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>

    </div>
    <script>
        document.addEventListener("DOMContentLoaded", () => {

            const wrap = document.getElementById("sbUserWrap");
            const btn = document.getElementById("sbUserBtn");

            btn.onclick = (e) => {
                e.stopPropagation();
                wrap.classList.toggle("open");
            };

            document.onclick = () => {
                wrap.classList.remove("open");
            };

            document.addEventListener("keydown", (e) => {
                if (e.key === "Escape")
                    wrap.classList.remove("open");
            });

        });

    </script>
</aside>
