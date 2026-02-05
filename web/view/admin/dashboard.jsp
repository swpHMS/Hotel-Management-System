<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>HMS Admin - Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
        <style>
  .donut-wrap{
    position: relative;
    width: 320px;
    height: 260px;
  }
  #userStatusDonut{
    width: 100% !important;
    height: 100% !important;
  }
  .donut-center{
    position:absolute;
    inset:0;
    display:flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
    pointer-events:none;
    padding: 0 18px;
    text-align:center;
  }
  .donut-big{
    font-weight:800;
    line-height:1.05;
    font-size: clamp(20px, 4vw, 36px);
    white-space:nowrap;
    max-width:100%;
    overflow:hidden;
    text-overflow:ellipsis;
  }
  .donut-small{
    margin-top: 6px;
    font-weight:700;
    letter-spacing:.12em;
    font-size: 12px;
    color:#64748b;
  }
</style>

    </head>

    <body>
        <div class="app-shell">
            <%@ include file="/view/admin_layout/sidebar.jsp" %>

            <div class="hms-main">

                <main class="hms-page">
                    <div class="hms-page__top">
                        <div>

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

                    <!-- KPI cards -->
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
                            <div class="hms-card__meta"></div>
                        </div>

                        <div class="hms-card">
                            <div class="hms-card__label">Avg. Engagement</div>
                            <div class="hms-card__value">${engagement}%</div>
                            <div class="hms-card__hint">System-wide active accounts (Users only)</div>
                        </div>
                    </div>

                    <!-- Donut: User Status Overview (under KPI cards) -->
                    <c:set var="activeCount" value="${statusCounts['active']}" />
                    <c:set var="inactiveCount" value="${statusCounts['inactive']}" />
                    <c:set var="totalCount" value="${activeCount + inactiveCount}" />

                    <!-- ép về double bằng 100.0 -->
                    <c:set var="activePctRaw" value="${totalCount == 0 ? 0 : (activeCount * 100.0 / totalCount)}" />
                    <fmt:formatNumber value="${activePctRaw}" maxFractionDigits="2" minFractionDigits="0" var="activePctText"/>

                    <section class="hms-panel hms-panel--wide status-panel" style="margin-top:16px;">
                        <div class="hms-panel__head">
                            <div>
                                <h2 class="hms-h2">User Status Overview</h2>
                                <div class="status-sub">Active vs inactive system users</div>
                            </div>
                        </div>

                        <div class="status-body">
                            <div class="status-left">
                                <div class="donut-wrap">
                                <canvas id="userStatusDonut"></canvas>
                                <div class="donut-center">
                                   <div class="donut-big">${activePctText}%</div>

                                    <div class="donut-small">ACTIVE</div>
                                </div>
                            </div>
                            </div>

                                   <div class="status-right">
                                       <div class="status-metrics">
                                <div class="metric">
                                    <span class="dot dot-active"></span>
                                    <div>
                                        <div class="metric-label">Active Users</div>
                                        <div class="metric-value">${activeCount}</div>
                                    </div>
                                </div>

                                <div class="metric">
                                    <span class="dot dot-inactive"></span>
                                    <div>
                                        <div class="metric-label">Inactive Users</div>
                                        <div class="metric-value">${inactiveCount}</div>
                                    </div>
                                </div>

                                <div class="status-note">
                                    System health is optimal. <b>${activePctText}%</b> users are currently active.

                                </div>
                            </div>
                                   </div>
                        </div>
                    </section>

                </main>

                <%@ include file="/view/admin_layout/footer.jsp" %>
            </div>
        </div>

        <!-- lastSynced -->
        <script>
            (function () {
                const el = document.getElementById("lastSynced");
                if (el)
                    el.textContent = new Date().toLocaleTimeString();
            })();
        </script>

        <!-- Chart.js + Donut -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            (function () {
                const canvas = document.getElementById('userStatusDonut');
                if (!canvas)
                    return;

                const active = Number("${activeCount}");
                const inactive = Number("${inactiveCount}");

                new Chart(canvas, {
                    type: 'doughnut',
                    data: {
                        labels: ['Active', 'Inactive'],
                        datasets: [{
                                data: [active, inactive],
                                backgroundColor: ['#22c55e', '#94a3b8'],
                                borderWidth: 0,
                                hoverOffset: 8
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        animation: {duration: 900, easing: 'easeOutQuart'},
                        plugins: {
                            legend: {display: false},
                            tooltip: {
                                displayColors: false,
                                backgroundColor: 'rgba(15, 23, 42, 0.92)',
                                padding: 10,
                                callbacks: {
                                    label: (ctx) => `${ctx.label}: ${ctx.formattedValue}`
                                                            }
                                                        }
                                                    }
                                                }
                                            });
                                        })();
        </script>
    </body>
</html>
