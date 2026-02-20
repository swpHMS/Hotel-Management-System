<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>HMS Admin — Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700;9..144,800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:          #f5f0e8;
            --bg2:         #ede7da;
            --paper:       #faf7f2;
            --border:      #e0d8cc;
            --border2:     #cfc6b8;
            --ink:         #2c2416;
            --ink-mid:     #5a4e3c;
            --ink-soft:    #9c8e7a;
            --gold:        #b5832a;
            --gold-lt:     #f0ddb8;
            --gold-bg:     rgba(181,131,42,.09);
            --terracotta:  #c0614a;
            --terra-lt:    #f5d8d2;
            --sage:        #5a7a5c;
            --sage-lt:     #d4e6d4;
            --sidebar-w:   280px;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--ink);
            overflow-x: hidden;
        }

        .hms-sidebar, aside.hms-sidebar, aside {
            position: fixed !important;
            top: 0; left: 0;
            width: var(--sidebar-w) !important;
            height: 100vh !important;
            overflow-y: auto !important;
            z-index: 9999;
        }

        .app-shell { display: flex; }
        .hms-main  { flex: 1; margin-left: var(--sidebar-w); }

        .hms-page {
            padding: 40px 44px 64px;
            max-width: 1400px;
        }

        /* ── TOP BAR ── */
        .page-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 40px;
            animation: fadeDown .45s ease both;
        }
        @keyframes fadeDown {
            from { opacity:0; transform:translateY(-10px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .page-eyebrow {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .2em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .page-eyebrow::before {
            content: '';
            display: block;
            width: 24px; height: 1.5px;
            background: var(--gold);
        }
        .page-title {
            font-family: 'Fraunces', serif;
            font-size: 44px;
            font-weight: 800;
            color: var(--ink);
            line-height: 1;
            letter-spacing: -1px;
        }

        .sync-badge {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 11px 20px;
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 100px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .12em;
            color: var(--ink-soft);
            text-transform: uppercase;
            box-shadow: 0 2px 10px rgba(44,36,22,.06);
        }
        .sync-dot {
            width: 7px; height: 7px;
            background: var(--sage);
            border-radius: 50%;
            box-shadow: 0 0 6px var(--sage);
            animation: pulse 2.2s ease infinite;
        }
        @keyframes pulse {
            0%,100% { opacity:1; }
            50%      { opacity:.4; }
        }
        .sync-time { color: var(--ink-mid); }

        /* ── KPI GRID ── */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-bottom: 24px;
        }

        .kpi-card {
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 28px;
            position: relative;
            overflow: hidden;
            transition: transform .2s ease, box-shadow .2s;
            animation: slideUp .5s ease both;
        }
        .kpi-card:nth-child(1) { animation-delay: .08s; }
        .kpi-card:nth-child(2) { animation-delay: .16s; }
        .kpi-card:nth-child(3) { animation-delay: .24s; }
        @keyframes slideUp {
            from { opacity:0; transform:translateY(18px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .kpi-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 40px rgba(44,36,22,.1);
        }
        .kpi-card::after {
            content: '';
            position: absolute;
            bottom: -48px; right: -40px;
            width: 140px; height: 140px;
            border-radius: 50%;
            background: var(--card-blob, rgba(181,131,42,.07));
            pointer-events: none;
        }
        .kpi-card.sage-card  { --card-blob: rgba(90,122,92,.09); }
        .kpi-card.terra-card { --card-blob: rgba(192,97,74,.08); }

        .kpi-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .kpi-icon-wrap {
            width: 44px; height: 44px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            background: var(--icon-bg, var(--gold-lt));
            border: 1px solid var(--border);
        }
        .kpi-card.sage-card  .kpi-icon-wrap { --icon-bg: var(--sage-lt); }
        .kpi-card.terra-card .kpi-icon-wrap { --icon-bg: var(--terra-lt); }

        .kpi-tag {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .1em;
            text-transform: uppercase;
            padding: 4px 12px;
            border-radius: 100px;
            background: var(--gold-bg);
            color: var(--gold);
        }
        .kpi-card.sage-card  .kpi-tag { background: rgba(90,122,92,.1);  color: var(--sage); }
        .kpi-card.terra-card .kpi-tag { background: rgba(192,97,74,.1);  color: var(--terracotta); }

        .kpi-label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .16em;
            text-transform: uppercase;
            color: var(--ink-soft);
            margin-bottom: 6px;
        }
        .kpi-value {
            font-family: 'Fraunces', serif;
            font-size: 52px;
            font-weight: 800;
            color: var(--ink);
            line-height: 1;
            letter-spacing: -2px;
        }
        .kpi-pills {
            display: flex;
            gap: 8px;
            margin-top: 16px;
            flex-wrap: wrap;
        }
        .pill-g { font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 8px; background: var(--sage-lt);  color: var(--sage); }
        .pill-s { font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 8px; background: var(--bg2); color: var(--ink-soft); }

        /* ── CHARTS ── */
        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            animation: slideUp .5s .3s ease both;
        }

        .chart-card {
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 30px;
            position: relative;
            overflow: hidden;
        }
        .chart-card::before {
            content: '';
            position: absolute;
            top: 0; right: 0;
            width: 120px; height: 120px;
            background: repeating-linear-gradient(
                45deg,
                transparent,
                transparent 6px,
                rgba(181,131,42,.04) 6px,
                rgba(181,131,42,.04) 7px
            );
            border-radius: 0 22px 0 0;
            pointer-events: none;
        }

        .chart-head { margin-bottom: 24px; }
        .chart-title {
            font-family: 'Fraunces', serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--ink);
            margin-bottom: 3px;
        }
        .chart-sub { font-size: 12px; color: var(--ink-soft); font-weight: 400; }

        .donut-wrap {
            position: relative;
            width: 100%;
            height: 250px;
        }
        .donut-wrap canvas { width: 100% !important; height: 100% !important; }

        .donut-center {
            position: absolute; inset: 0;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            pointer-events: none;
            text-align: center;
        }
        .donut-big {
            font-family: 'Fraunces', serif;
            font-size: 40px;
            font-weight: 800;
            color: var(--ink);
            line-height: 1;
            letter-spacing: -1.5px;
        }
        .donut-small {
            margin-top: 5px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: .18em;
            text-transform: uppercase;
            color: var(--ink-soft);
        }

        .chart-legend {
            display: flex;
            gap: 18px;
            margin-top: 18px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            font-weight: 600;
            color: var(--ink-mid);
        }
        .legend-dot {
            width: 10px; height: 10px;
            border-radius: 3px;
            flex-shrink: 0;
        }

        .hms-alert {
            background: var(--terra-lt);
            border: 1px solid rgba(192,97,74,.3);
            color: var(--terracotta);
            padding: 12px 18px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
            margin-top: 12px;
        }

        .hms-footer { padding: 24px 44px; border-top: 1px solid var(--border); }
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/view/admin_layout/sidebar.jsp" %>

    <div class="hms-main">
        <main class="hms-page">

            <c:set var="activeCount"   value="${statusCounts['active']}" />
            <c:set var="inactiveCount" value="${statusCounts['inactive']}" />
            <c:set var="totalCount"    value="${activeCount + inactiveCount}" />
            <c:set var="activePctRaw"  value="${totalCount == 0 ? 0 : (activeCount * 100.0 / totalCount)}" />
            <fmt:formatNumber value="${activePctRaw}" maxFractionDigits="1" minFractionDigits="0" var="activePctText"/>

            <div class="page-top">
                <div>
                    <div class="page-eyebrow">Admin Portal</div>
                    <h1 class="page-title">Dashboard</h1>
                    <c:if test="${not empty error}">
                        <div class="hms-alert"><b>Error:</b> ${error}</div>
                    </c:if>
                </div>
                <div class="sync-badge">
                    <span class="sync-dot"></span>
                    Live &nbsp;·&nbsp; <span class="sync-time" id="lastSynced">--:--:--</span>
                </div>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap">👥</div>
                        <span class="kpi-tag">Staff</span>
                    </div>
                    <div class="kpi-label">Total Staff</div>
                    <div class="kpi-value">${staffTotal}</div>
                    <div class="kpi-pills">
                        <span class="pill-g">${staffActive} Active</span>
                        <span class="pill-s">${staffInactive} Inactive</span>
                    </div>
                </div>

                <div class="kpi-card sage-card">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap">🧑‍💼</div>
                        <span class="kpi-tag">Customers</span>
                    </div>
                    <div class="kpi-label">Total Customers</div>
                    <div class="kpi-value">${totalCustomers}</div>
                    <div class="kpi-pills">
                        <span class="pill-g">${customerActive} Active</span>
                        <span class="pill-s">${customerInactive} Inactive</span>
                    </div>
                </div>

                <div class="kpi-card terra-card">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap">🔑</div>
                        <span class="kpi-tag">Roles</span>
                    </div>
                    <div class="kpi-label">Total Roles</div>
                    <div class="kpi-value">${totalRoles}</div>
                    <div class="kpi-pills">
                        <span class="pill-s">System roles</span>
                    </div>
                </div>
            </div>

            <div class="charts-section">
                <div class="chart-card">
                    <div class="chart-head">
                        <div class="chart-title">User Status Overview</div>
                        <div class="chart-sub">Active vs inactive account breakdown</div>
                    </div>
                    <div class="donut-wrap">
                        <canvas id="userStatusDonut"></canvas>
                        <div class="donut-center">
                            <div class="donut-big">${activePctText}%</div>
                            <div class="donut-small">Active</div>
                        </div>
                    </div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <span class="legend-dot" style="background:#5a7a5c;"></span>
                            Active · ${activeCount}
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background:#cfc6b8;"></span>
                            Inactive · ${inactiveCount}
                        </div>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-head">
                        <div class="chart-title">Role Distribution</div>
                        <div class="chart-sub">User role structure overview</div>
                    </div>
                    <div class="donut-wrap">
                        <canvas id="roleChart"></canvas>
                    </div>
                </div>
            </div>

        </main>
        <%@ include file="/view/admin_layout/footer.jsp" %>
    </div>
</div>

<script>
    (function(){
        const el = document.getElementById('lastSynced');
        if (el) el.textContent = new Date().toLocaleTimeString('vi-VN');
    })();
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {

    const TOOLTIP = {
        displayColors: false,
        backgroundColor: '#2c2416',
        titleColor: '#faf7f2',
        bodyColor: '#faf7f2',
        borderColor: '#5a4e3c',
        borderWidth: 1,
        cornerRadius: 10,
        padding: 12
    };

    const uc = document.getElementById('userStatusDonut');
    if (uc) {
        new Chart(uc, {
            type: 'doughnut',
            data: {
                labels: ['Active', 'Inactive'],
                datasets: [{
                    data: [Number("${activeCount}"), Number("${inactiveCount}")],
                    backgroundColor: ['#5a7a5c', '#cfc6b8'],
                    borderWidth: 0,
                    hoverOffset: 10,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '73%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        displayColors: false,
                        backgroundColor: '#2c2416',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: '#5a4e3c',
                        borderWidth: 1,
                        cornerRadius: 10,
                        padding: 14,
                        callbacks: {
                            label: ctx => '  ' + ctx.label + ': ' + ctx.raw
                        }
                    }
                },
                animation: { duration: 900, easing: 'easeInOutQuart' }
            }
        });
    }

    const rc = document.getElementById('roleChart');
    if (rc) {
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

        new Chart(rc, {
            type: 'doughnut',
            data: {
                labels: roleLabels,
                datasets: [{
                    data: roleData,
                    backgroundColor: ['#b5832a','#5a7a5c','#c0614a','#8b7355','#a0956e','#7a9e7c'],
                    borderWidth: 0,
                    hoverOffset: 10,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '68%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12, boxHeight: 12,
                            padding: 16,
                            color: '#5a4e3c',
                            font: { family: 'DM Sans', size: 12, weight: '600' }
                        }
                    },
                    tooltip: TOOLTIP
                },
                animation: { duration: 900, easing: 'easeInOutQuart' }
            }
        });
    }
});
</script>
</body>
</html>
