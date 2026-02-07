<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>HMS Admin - Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css"/>
    </head>

    <body>
        <div class="app-shell">
            <%@ include file="/view/layout/sidebar.jsp" %>

            <div class="hms-main">
                <%@ include file="/view/layout/header.jsp" %>

                <main class="hms-page">
                    <div class="hms-page__top">
                        <div>
                            <div class="hms-breadcrumb">
                                <span>Admin</span><span class="sep">›</span><span class="current">Dashboard</span>
                            </div>
                            <h1 class="hms-title">Dashboard</h1>
                            <p class="hms-subtitle">Overview of system users, customers, and quick access controls.</p>

                            <c:if test="${not empty error}">
                                <div class="hms-alert hms-alert--danger">
                                    <b>Error:</b> ${error}
                                </div>
                            </c:if>
                        </div>

                        <div class="hms-sync">
                            LAST SYNCED: <span id="lastSynced">--:--:--</span>
                        </div>
                    </div>

                    <div class="hms-grid-3">
                        <div class="hms-card">
                            <div class="hms-card__label">Total Users</div>
                            <div class="hms-card__value">${totalUsers}</div>
                            <div class="hms-card__meta">
                                <span class="pill green">${activeUsers} Active</span>
                                <span class="pill gray">${inactiveUsers} Inactive</span>
                            </div>
                        </div>

                        <div class="hms-card">
                            <div class="hms-card__label">Total Customers</div>
                            <div class="hms-card__value">${totalCustomers}</div>
                            <div class="hms-card__meta">

                            </div>
                        </div>

                        <div class="hms-card">
                            <div class="hms-card__label">Avg. Engagement</div>
                            <div class="hms-card__value">${engagement}%</div>
                            <div class="hms-card__hint">System-wide active accounts (Users only)</div>
                        </div>
                    </div>

                    <!-- Nếu bạn CHƯA set recentUpdates trong servlet thì tạm ẩn bảng này -->
                    <c:if test="${not empty recentUpdates}">
                        <div class="hms-grid-main">
                            <section class="hms-panel hms-panel--wide">
                                <div class="hms-panel__head">
                                    <h2 class="hms-h2">Recent Account Updates</h2>
                                    <div class="hms-links">
                                        <a class="hms-link" href="${pageContext.request.contextPath}/admin/staff">Staff List</a>
                                        <a class="hms-link" href="${pageContext.request.contextPath}/admin/customers">Customer List</a>
                                    </div>
                                </div>

                                <div class="hms-table-wrap">
                                    <table class="hms-table">
                                        <thead>
                                            <tr>
                                                <th>Name</th><th>Type</th><th>Status</th><th>Last Updated</th><th style="text-align:right">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="it" items="${recentUpdates}">
                                                <tr>
                                                    <td>
                                                        <div class="cell-title">${it.name}</div>
                                                        <div class="cell-sub">
                                                            <c:choose>
                                                                <c:when test="${empty it.email}">—</c:when>
                                                                <c:otherwise>${it.email}</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>

                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${it.type == 'USER'}"><span class="tag blue">USER</span></c:when>
                                                            <c:otherwise><span class="tag indigo">CUSTOMER</span></c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td>
                                                        <span class="pill slate">${it.status}</span>
                                                    </td>

                                                    <td class="muted">${it.lastUpdated}</td>

                                                    <td style="text-align:right">
                                                        <a class="hms-link" href="${it.viewLink}">View</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </section>

                            <aside class="hms-panel">
                                <div class="hms-panel__head">
                                    <h2 class="hms-h2">Quick Access</h2>
                                </div>

                                <div class="hms-quick">
                                    <a class="hms-quick__item" href="${pageContext.request.contextPath}/admin/staff/create">
                                        <div><div class="q-title">Create Staff Account</div><div class="q-sub">Add new staff and assign role</div></div>
                                        <span class="q-icon">➕</span>
                                    </a>

                                    <a class="hms-quick__item" href="${pageContext.request.contextPath}/admin/staff">
                                        <div><div class="q-title">View Staff List</div><div class="q-sub">Filter staff by role/status</div></div>
                                        <span class="q-icon">👥</span>
                                    </a>

                                    <a class="hms-quick__item" href="${pageContext.request.contextPath}/admin/customers">
                                        <div><div class="q-title">View Customer List</div><div class="q-sub">Search customers</div></div>
                                        <span class="q-icon">🧾</span>
                                    </a>

                                    <a class="hms-quick__item" href="${pageContext.request.contextPath}/admin/system">
                                        <div><div class="q-title">Update System Config</div><div class="q-sub">Policies & email templates</div></div>
                                        <span class="q-icon">⚙️</span>
                                    </a>
                                </div>
                            </aside>
                        </div>
                    </c:if>

                    


                </main>

                <%@ include file="/view/layout/footer.jsp" %>
            </div>
        </div>

        <script>
            (function () {
                const el = document.getElementById("lastSynced");
                if (el)
                    el.textContent = new Date().toLocaleTimeString();
            })();
        </script>
    </body>
</html>
