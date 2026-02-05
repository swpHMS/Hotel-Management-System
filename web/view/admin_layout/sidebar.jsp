<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
  String userName = (String) session.getAttribute("adminName");
  if (userName == null) userName = "Administrator";

  String active = (String) request.getAttribute("active");
  if (active == null) active = "";
%>

<aside class="hms-sidebar">
  <div class="hms-brand">
    <div class="hms-brand__title">HMS Admin</div>
    <div class="hms-brand__sub">ADMIN PANEL</div>
  </div>

  <nav class="hms-nav">
    <a class="hms-nav__item <%= "dashboard".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/dashboard">
      <span class="hms-nav__icon">🏠</span><span>Dashboard</span>
    </a>

    <div class="hms-nav__section">User Management</div>
    <a class="hms-nav__item <%= "staff_list".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/staff">
      <span class="hms-nav__icon">👥</span><span>Staff List</span>
    </a>
    <a class="hms-nav__item <%= "staff_create".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/staff/create">
      <span class="hms-nav__icon">➕</span><span>Create Staff Account</span>
    </a>

    <div class="hms-nav__section">Customer Management</div>
    <a class="hms-nav__item <%= "customers".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/customers">
      <span class="hms-nav__icon">🧾</span><span>Customer List</span>
    </a>

    <div class="hms-nav__section">System Configuration</div>
    <a class="hms-nav__item <%= "system".equals(active) ? "is-active" : "" %>"
       href="${pageContext.request.contextPath}/admin/system">
      <span class="hms-nav__icon">⚙️</span><span>System Config</span>
    </a>
  </nav>

  <div class="hms-sidebar-user">
    <div class="hms-user">
      <div class="hms-user__avatar">AD</div>
      <div class="hms-user__meta">
        <div class="hms-user__name"><%= userName %></div>
        <div class="hms-user__role">ADMIN</div>
      </div>

      <div class="hms-user__dropdown">
        <a class="hms-dd__item" href="${pageContext.request.contextPath}/admin/profile">Profile</a>
        <div class="hms-dd__divider"></div>
        <a class="hms-dd__item is-danger" href="${pageContext.request.contextPath}/logout">Logout</a>
      </div>
    </div>
  </div>
      
      <script>
  (function () {
    const user = document.querySelector('.hms-sidebar .hms-user');
    if (!user) return;

    // click vào user card để toggle
    user.addEventListener('click', function (e) {
      // nếu click vào link trong dropdown thì cho đi luôn
      if (e.target.closest('a')) return;
      e.stopPropagation();
      user.classList.toggle('is-open');
    });

    // click ra ngoài đóng dropdown
    document.addEventListener('click', function () {
      user.classList.remove('is-open');
    });

    // bấm ESC để đóng
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') user.classList.remove('is-open');
    });
  })();
</script>

</aside>
