<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.HotelInformation" %>
<%@ page import="dal.HotelInformationDAO" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%-- Link tới file CSS chung của hệ thống --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

<%
    HotelInformation hotel = (HotelInformation) request.getAttribute("hotel");
    if (hotel == null) {
        hotel = new HotelInformationDAO().getSingleHotel();
        request.setAttribute("hotel", hotel);
    }
%>
<%
    
    Object obj = session.getAttribute("userAccount");
    String userName = "Receptionist";

    if (obj != null && obj instanceof model.User) {
        
        model.User u = (model.User) obj;
        
        
        userName = u.getFullName(); 
        
        if (userName == null || userName.trim().isEmpty()) {
            userName = u.getEmail();
        }
    }

    // Xác định trạng thái active
    String active = (String) request.getAttribute("active");
if (active == null) active = "";

    // Xử lý tạo Avatar initials (Tên viết tắt)
    String initials = "R";
    if (userName != null && !userName.trim().isEmpty()) {
        String[] parts = userName.trim().split("\\s+");
        initials = parts.length >= 2
                ? ("" + parts[0].charAt(0) + parts[parts.length-1].charAt(0)).toUpperCase()
                : ("" + userName.charAt(0)).toUpperCase();
    }
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
        <div class="sb-brand-text">
            <div class="sb-title">${hotel.name}</div>
            <div class="sb-sub">Receptionist Panel</div>
        </div>
    </div>

    <nav class="sb-nav">

        <div class="sb-section">MAIN ACTIVITIES</div>

        <a class="sb-item <%= "dashboard".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/receptionist/dashboard">
           <i class="bi bi-grid-1x2-fill"></i>
           <span>Dashboard</span>
        </a>

        <a class="sb-item <%= "create_booking".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/receptionist/booking/create">
           <i class="bi bi-plus-circle"></i>
           <span>Create Booking</span>
        </a>

        <a class="sb-item <%= "checkout".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/receptionist/checkout">
           <i class="bi bi-box-arrow-right"></i>
           <span>Check-out</span>
        </a>

        <div class="sb-section">MANAGE</div>

        <a class="sb-item <%= "booking_list".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/receptionist/bookings">
           <i class="bi bi-journal-text"></i>
           <span>Booking List</span>
        </a>

<!--        <a class="sb-item <%= "room_dashboard".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/receptionist/rooms">
           <i class="bi bi-door-open"></i>
           <span>Room Dashboard</span>
        </a>-->

        <a class="sb-item <%= "guest_list".equals(active)?"active":"" %>"
           href="${pageContext.request.contextPath}/receptionist/guest-list">
           <i class="bi bi-people"></i>
           <span>Guest List</span>
        </a>

    </nav>

    <div class="sb-userwrap" id="sbUserWrap">
        <button type="button" class="sb-user" id="sbUserBtn">
            <div class="sb-avatar"><%= initials %></div>
            <div class="sb-userinfo">
                <div class="sb-username"><%= userName %></div>
                <div class="sb-role">RECEPTION</div>
            </div>
            <i class="bi bi-chevron-up ms-auto small"></i>
        </button>

        <div class="sb-dropdown">
            <a href="${pageContext.request.contextPath}/staff-profile"><i class="bi bi-person me-2"></i> Profile</a>
            <a class="danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-left me-2"></i> Logout</a>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const wrap = document.getElementById("sbUserWrap");
            const btn = document.getElementById("sbUserBtn");

            if(btn) {
                btn.onclick = (e) => {
                    e.stopPropagation();
                    wrap.classList.toggle("open");
                };
            }

            document.onclick = () => {
                if(wrap) wrap.classList.remove("open");
            };
        });
    </script>
</aside>