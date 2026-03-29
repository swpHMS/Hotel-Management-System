<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="dash-topbar mb-3">
    <div>
        <div class="dashboard-title">Management Intelligence</div>
        <div class="dashboard-date">Overseeing the legacy of excellence and property performance.</div>
    </div>
</div>

<div class="stats-grid mb-4">
    <div class="stat-card">
        <div class="stat-icon-wrapper bg-blue-soft"><i class="bi bi-door-open-fill"></i></div>
        <div>
            <span class="stat-label">TOTAL INVENTORY</span>
            <div class="stat-value">${kpi.totalInventory}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-green-soft"><i class="bi bi-check-circle-fill"></i></div>
        <div>
            <span class="stat-label">AVAILABLE</span>
            <div class="stat-value">${kpi.available}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-indigo-soft"><i class="bi bi-person-check-fill"></i></div>
        <div>
            <span class="stat-label">OCCUPIED</span>
            <div class="stat-value">${kpi.occupied}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-orange-soft"><i class="bi bi-stars"></i></div>
        <div>
            <span class="stat-label">DIRTY</span>
            <div class="stat-value">${kpi.dirty}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-red-soft"><i class="bi bi-gear-fill"></i></div>
        <div>
            <span class="stat-label">MAINTENANCE</span>
            <div class="stat-value">${kpi.maintenance}</div>
        </div>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-7 d-flex">
        <div class="stat-card h-100 w-100" style="flex-direction:column; align-items:stretch; min-height: 520px;">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <div>
                    <div style="font-weight:900; color:#0f172a;">OCCUPANCY TREND</div>
                </div>
                <div class="btn-group occupancy-toggle" role="group">
                    <button type="button" class="btn btn-sm occupancy-toggle-btn" id="btnDaily">DAILY</button>
                    <button type="button" class="btn btn-sm occupancy-toggle-btn" id="btnMonthly">MONTHLY</button>
                </div>
            </div>

            <div style="height:420px; flex:1; display:flex; align-items:center;">
                <canvas id="occupancyTrendChart"></canvas>
            </div>
        </div>
    </div>

    <div class="col-lg-5 d-flex">
        <div class="stat-card h-100 w-100" style="flex-direction:column; align-items:stretch; min-height: 520px;">
            <div class="mb-2">
                <div style="font-weight:900; color:#0f172a;">COMPOSITION</div>
                <div class="dashboard-date">INVENTORY STATUS</div>
            </div>

            <div style="height:260px;">
                <canvas id="compositionChart"></canvas>
            </div>

            <div class="mt-3">
                <div class="d-flex justify-content-between align-items-center py-2 px-3"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#c9a256;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">AVAILABLE</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${kpi.available}</span>
                </div>

                <div class="d-flex justify-content-between align-items-center py-2 px-3 mt-2"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#0f172a;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">OCCUPIED</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${kpi.occupied}</span>
                </div>

                <div class="d-flex justify-content-between align-items-center py-2 px-3 mt-2"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#f59e0b;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">DIRTY</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${kpi.dirty}</span>
                </div>

                <div class="d-flex justify-content-between align-items-center py-2 px-3 mt-2"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#94a3b8;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">MAINTENANCE</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${kpi.maintenance}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mt-1">
    <div class="col-12 d-flex">
        <div class="stat-card finance-overview-card h-100 w-100" style="flex-direction:column; align-items:stretch; min-height: 280px;">
            <div class="mb-3">
                <div style="font-weight:900; color:#0f172a;">FINANCIAL OVERVIEW</div>
                <div class="dashboard-date">HOTEL REVENUE SNAPSHOT</div>
            </div>

            <div class="finance-grid">
                <div class="finance-card finance-card--emerald">
                    <div class="finance-icon"><i class="bi bi-cash-stack"></i></div>
                    <div class="finance-label">TOTAL REVENUE</div>
                    <div class="finance-value">
                        <fmt:formatNumber value="${kpi.totalRevenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/>
                    </div>
                </div>

                <div class="finance-card finance-card--teal">
                    <div class="finance-icon"><i class="bi bi-graph-up-arrow"></i></div>
                    <div class="finance-label">REVENUE THIS MONTH</div>
                    <div class="finance-value">
                        <fmt:formatNumber value="${kpi.currentMonthRevenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<style>
    .occupancy-toggle {
        background: #f8fafc;
        border-radius: 14px;
        padding: 4px;
        gap: 4px;
    }

    .occupancy-toggle-btn {
        border: 0;
        border-radius: 10px;
        color: #64748b;
        font-weight: 800;
        letter-spacing: .06em;
        padding: .45rem .9rem;
        background: transparent;
        transition: background-color .2s ease, color .2s ease, box-shadow .2s ease;
    }

    .occupancy-toggle-btn:hover {
        color: #0f172a;
        background: rgba(201, 162, 86, .12);
    }

    .occupancy-toggle-btn.active {
        background: #c9a256;
        color: #fff;
        box-shadow: 0 10px 20px rgba(201, 162, 86, .25);
    }
</style>
<script>
    const dailyLabels = ${dailyTrend.labelsJs};
    const dailyData = ${dailyTrend.valuesJs};
    const monthlyLabels = ${monthlyTrend.labelsJs};
    const monthlyData = ${monthlyTrend.valuesJs};
    const initialTrendMode = "${initialTrendMode}";
    const btnDaily = document.getElementById("btnDaily");
    const btnMonthly = document.getElementById("btnMonthly");
    const initialLabels = initialTrendMode === "daily" ? dailyLabels : monthlyLabels;
    const initialData = initialTrendMode === "daily" ? dailyData : monthlyData;

    const getTrendMax = (values) => {
        const maxValue = Math.max(...values.map((value) => Number(value || 0)), 0);
        if (maxValue <= 0) {
            return 10;
        }
        return Math.min(100, Math.max(10, Math.ceil(maxValue / 5) * 5 + 5));
    };

    const setActiveTrendMode = (mode) => {
        btnDaily.classList.toggle("active", mode === "daily");
        btnMonthly.classList.toggle("active", mode === "monthly");
    };

    const ctxV = document.getElementById("occupancyTrendChart");
    const occupancyTrendChart = new Chart(ctxV, {
        type: "line",
        data: {
            labels: initialLabels,
            datasets: [{
                label: "Occupancy Rate",
                data: initialData,
                tension: 0.35,
                pointRadius: 4,
                pointHoverRadius: 5,
                pointBackgroundColor: "#c9a256",
                pointBorderColor: "#ffffff",
                pointBorderWidth: 2,
                borderWidth: 4,
                borderColor: "#c9a256",
                backgroundColor: "rgba(201,162,86,.18)",
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false } },
                y: {
                    beginAtZero: true,
                    suggestedMax: getTrendMax(initialData),
                    ticks: {
                        callback(value) {
                            return value + "%";
                        }
                    },
                    grid: { color: "rgba(15,23,42,.08)" }
                }
            }
        }
    });

    const ctxC = document.getElementById("compositionChart");
    const fullHouseText = "${fullHousePercentText}";
    const centerTextPlugin = {
        id: "centerTextPlugin",
        afterDatasetsDraw(chart) {
            const { ctx } = chart;
            const meta = chart.getDatasetMeta(0);
            if (!meta || !meta.data || !meta.data.length) {
                return;
            }

            const x = meta.data[0].x;
            const y = meta.data[0].y;

            ctx.save();
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillStyle = "#0f172a";
            ctx.font = "900 36px sans-serif";
            ctx.fillText(fullHouseText, x, y - 8);
            ctx.fillStyle = "#c9a256";
            ctx.font = "900 12px sans-serif";
            ctx.fillText("FULL HOUSE", x, y + 28);
            ctx.restore();
        }
    };

    new Chart(ctxC, {
        type: "doughnut",
        data: {
            labels: ["Available", "Occupied", "Dirty", "Maintenance"],
            datasets: [{
                data: [
                    Number("${kpi.available}"),
                    Number("${kpi.occupied}"),
                    Number("${kpi.dirty}"),
                    Number("${kpi.maintenance}")
                ],
                borderWidth: 0,
                spacing: 0,
                borderRadius: 0,
                backgroundColor: ["#c9a256", "#0f172a", "#f59e0b", "#94a3b8"]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "72%",
            plugins: { legend: { display: false } }
        },
        plugins: [centerTextPlugin]
    });

    const updateTrendChart = (labels, values) => {
        occupancyTrendChart.data.labels = labels;
        occupancyTrendChart.data.datasets[0].data = values;
        occupancyTrendChart.options.scales.y.suggestedMax = getTrendMax(values);
        occupancyTrendChart.update();
    };

    setActiveTrendMode(initialTrendMode);

    btnDaily.addEventListener("click", () => {
        setActiveTrendMode("daily");
        updateTrendChart(dailyLabels, dailyData);
    });

    btnMonthly.addEventListener("click", () => {
        setActiveTrendMode("monthly");
        updateTrendChart(monthlyLabels, monthlyData);
    });
</script>
