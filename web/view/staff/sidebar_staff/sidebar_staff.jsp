<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="model.User" %>
<%@ page import="dal.HotelInformationDAO" %>
<%@ page import="model.HotelInformation" %>
<%
    HotelInformation hotel = (HotelInformation) request.getAttribute("hotel");
    if (hotel == null) {
        hotel = new HotelInformationDAO().getSingleHotel();
        request.setAttribute("hotel", hotel);
    }
%>
<%
User user = (User) session.getAttribute("userAccount");

String userName = "Staff";
if (user != null && user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
    userName = user.getFullName().trim();
}

String active = (String) pageContext.findAttribute("currentPage");
if (active == null) active = "";

String[] parts = userName.trim().split("\\s+");
String initials = parts.length >= 2
        ? ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase()
        : ("" + userName.charAt(0)).toUpperCase();
%>
<aside class="sb">

    <div class="sb-brand">
        <div class="diamond-icons" style="display:flex;align-items:center;margin-bottom:5px;">
                <a href="${pageContext.request.contextPath}/home"
                   style="text-decoration:none !important;display:flex;gap:1px;border:none;outline:none;color:transparent !important;">
                    <span style="color:#D4B78F !important;font-size:14px;line-height:1;margin-right:-2px;">◆</span>
                    <span style="color:#FFABAB !important;font-size:14px;line-height:1;margin-right:-2px;">◆</span>
                    <span style="color:#D4B78F !important;font-size:14px;line-height:1;">◆</span>
                </a>
            </div>
        <div>
            <div class="sb-title">${hotel.name}</div>
            <div class="sb-sub">Hotel System</div>
        </div>
    </div>

    <nav class="sb-nav">

        <div class="sb-section">Operations</div>

        <a class="sb-item <%= "roomops".equals(active) ? "active" : "" %>"
           href="${pageContext.request.contextPath}/staff/room-operations">
            Room Operations
        </a>

        <a class="sb-item <%= "serviceorder".equals(active) ? "active" : "" %>"
           href="${pageContext.request.contextPath}/staff/service-orders">
            Manage Services
        </a>

    </nav>

    <div class="sb-userwrap" id="sbUserWrap">
        <button type="button" class="sb-user" id="sbUserBtn">

            <div class="sb-avatar"><%= initials %></div>

            <div class="sb-userinfo">
                <div class="sb-username"><%= userName %></div>
                <div class="sb-role">STAFF</div>
            </div>

        </button>

        <div class="sb-dropdown">
            <a href="${pageContext.request.contextPath}/staff-profile">Profile</a>
            <a class="danger" href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const wrap = document.getElementById("sbUserWrap");
            const btn = document.getElementById("sbUserBtn");

            if (btn && wrap) {
                btn.onclick = (e) => {
                    e.stopPropagation();
                    wrap.classList.toggle("open");
                };

                document.onclick = () => {
                    wrap.classList.remove("open");
                };

                document.addEventListener("keydown", (e) => {
                    if (e.key === "Escape") {
                        wrap.classList.remove("open");
                    }
                });
            }
        });
    </script>
</aside>
