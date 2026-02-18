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
            .chart-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
            }

            .summary-container {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 24px;
            }

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
            /* Ghi đè tiêu đề Dashboard cho giống Customer List */
            .hms-title {
                font-size: 40px !important;       /* Tăng từ 28px lên 40px */
                font-weight: 700 !important;      /* Giảm độ đậm từ 900 xuống 700 cho thanh thoát */
                letter-spacing: -0.5px !important; /* Dồn chữ nhẹ */
                color: #0f172a !important;        /* Màu xanh đen đậm chuẩn */
                margin-bottom: 8px !important;    /* Căn lề dưới */
                line-height: 1.1 !important;
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
                            <div class="hms-card__label">Total Staff</div>
                            <div class="hms-card__value">${staffTotal}</div>
                            <div class="hms-card__meta">
                                <span class="pill green">${staffActive} Active</span>
                                <span class="pill gray">${staffInactive} Inactive</span>   
                            </div>
                        </div>

                        <div class="hms-card">
                            <div class="hms-card__label">Total Customers</div>
                            <div class="hms-card__value">${totalCustomers}</div>
                            <div class="hms-card__meta"></div>
                            <span class="pill green">${customerActive} Active</span>
                            <span class="pill gray">${customerInactive} Inactive</span>

                        </div>

                        <div class="hms-card">
                            <div class="hms-card__label">Total Roles</div>
                            <div class="hms-card__value">${totalRoles}</div>

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
                                <h2 class="hms-h2">System User Health</h2>
                                <div class="status-sub">Account activity & role structure overview</div>
                            </div>
                        </div>

                        <div class="status-body">
                            <!-- Left: User Status -->
                            <div class="hms-panel">
                                <h2 class="hms-h2">User Status Overview</h2>
                                <div class="donut-wrap">
                                    <canvas id="userStatusDonut"></canvas>
                                    <div class="donut-center">
                                        <div class="donut-big">${activePctText}%</div>
                                        <div class="donut-small">ACTIVE</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right: Role Distribution -->
                            <div class="hms-panel">
                                <h2 class="hms-h2">Role Distribution</h2>
                                <div class="donut-wrap">
                                    <canvas id="roleChart"></canvas>
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
            document.addEventListener("DOMContentLoaded", function () {

                /* ================= USER STATUS DONUT ================= */
                const userCanvas = document.getElementById('userStatusDonut');
                if (userCanvas) {

                    const active = Number("${activeCount}");
                    const inactive = Number("${inactiveCount}");

                    new Chart(userCanvas, {
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
                            plugins: {
                                legend: {display: false},
                                tooltip: {
                                    displayColors: false,
                                    backgroundColor: '#1e293b',
                                    titleColor: '#fff',
                                    bodyColor: '#fff',
                                    borderColor: '#334155',
                                    borderWidth: 1,
                                    cornerRadius: 8,
                                    callbacks: {
                                        label: function (ctx) {
                                            return ctx.label + ": " + ctx.raw;
                                        }
                                    }
                                }
                            }
                        }
                    });
                }


                /* ================= ROLE DISTRIBUTION DONUT ================= */

                const roleCanvas = document.getElementById('roleChart');
                if (roleCanvas) {

                const roleLabels = [
            <c:forEach var="entry" items="${roleDistribution}" varStatus="loop">
                "${entry.key}"${!loop.last ? "," : ""}
            </c:forEach>
                ];

                const roleData = [
            <c:forEach var="entry" items="${roleDistribution}" varStatus="loop">
                ${entry.value}${!loop.last ? "," : ""}
            </c:forEach>
                ];

                new Chart(roleCanvas, {
                    type: 'doughnut',
                    data: {
                        labels: roleLabels,
                        datasets: [{
                                data: roleData,
                                backgroundColor: [
                                    '#1f2937',
                                    '#4f46e5',
                                    '#10b981',
                                    '#f59e0b',
                                    '#9ca3af'
                                ],
                                borderWidth: 0
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '65%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    boxWidth: 14,
                                    padding: 16
                                }
                            }
                        }
                    }
                });
                }

            });
        </script>



    </body>
</html>
