<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="dash-topbar d-flex justify-content-between align-items-start gap-3 mb-3">
    <div>
        <div class="dashboard-title">Management Intelligence</div>
        <div class="dashboard-date">Overseeing the legacy of excellence and property performance.</div>
    </div>

    <button class="btn-new-reservation" type="button">
        <i class="bi bi-broadcast-pin me-2"></i> LIVE MONITORING SYSTEM
    </button>
</div>

<!-- KPI -->
<div class="stats-grid mb-4">
    <div class="stat-card">
        <div class="stat-icon-wrapper bg-blue-soft"><i class="bi bi-door-open-fill"></i></div>
        <div>
            <span class="stat-label">TOTAL INVENTORY</span>
            <div class="stat-value">${totalInventory}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-green-soft"><i class="bi bi-check-circle-fill"></i></div>
        <div>
            <span class="stat-label">AVAILABLE</span>
            <div class="stat-value">${liveSuites}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-indigo-soft"><i class="bi bi-crown-fill"></i></div>
        <div>
            <span class="stat-label">OCCUPIED</span>
            <div class="stat-value">${guestStays}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-orange-soft"><i class="bi bi-stars"></i></div>
        <div>
            <span class="stat-label">DIRTY</span>
            <div class="stat-value">${servicing}</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper bg-red-soft"><i class="bi bi-gear-fill"></i></div>
        <div>
            <span class="stat-label">MAINTENANCE</span>
            <div class="stat-value">${outOfOrder}</div>
        </div>
    </div>
</div>

<div class="row g-4">
    <!-- Booking Velocity -->
    <div class="col-lg-7">
        <div class="stat-card" style="flex-direction:column; align-items:stretch;">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <div>
                    <div style="font-weight:900; color:#0f172a;">BOOKING VELOCITY</div>
                    <div class="dashboard-date">OCCUPANCY TRENDS</div>
                </div>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-sm btn-light" id="btnDaily">DAILY</button>
                    <button type="button" class="btn btn-sm btn-light" id="btnMonthly">MONTHLY</button>
                </div>
            </div>

            <div style="height:260px;">
                <canvas id="velocityChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Composition -->
    <div class="col-lg-5">
        <div class="stat-card" style="flex-direction:column; align-items:stretch;">
            <div class="mb-2">
                <div style="font-weight:900; color:#0f172a;">COMPOSITION</div>
                <div class="dashboard-date">INVENTORY STATUS</div>
            </div>

            <div style="height:260px;">
                <canvas id="compositionChart"></canvas>
            </div>

            <c:set var="fullHousePercent"
                   value="${totalInventory == 0 ? 0 : (guestStays * 100 / totalInventory)}"/>

            <div class="text-center mt-2">
                <div style="font-size: 40px; font-weight: 900; color:#0f172a;">${fullHousePercent}%</div>
                <div style="font-size:.75rem; font-weight: 900; letter-spacing: 3px; color:#c9a256; margin-top:-8px;">
                    FULL HOUSE
                </div>
            </div>

            <!-- ✅ Legend trạng thái phòng (theo schema rooms.status) -->
            <div class="mt-3">
                <div class="d-flex justify-content-between align-items-center py-2 px-3"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#c9a256;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">AVAILABLE</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${liveSuites}</span>
                </div>

                <div class="d-flex justify-content-between align-items-center py-2 px-3 mt-2"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#0f172a;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">OCCUPIED</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${guestStays}</span>
                </div>

                <div class="d-flex justify-content-between align-items-center py-2 px-3 mt-2"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#f59e0b;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">DIRTY (SERVICING)</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${servicing}</span>
                </div>

                <div class="d-flex justify-content-between align-items-center py-2 px-3 mt-2"
                     style="background:#f8fafc;border-radius:14px;">
                    <span class="d-flex align-items-center gap-2">
                        <span style="width:10px;height:10px;border-radius:50%;background:#94a3b8;display:inline-block;"></span>
                        <span style="font-weight:800;color:#64748b;font-size:.75rem;letter-spacing:.08em;">MAINTENANCE</span>
                    </span>
                    <span style="font-weight:900;color:#0f172a;">${outOfOrder}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
    // ✅ TẤT CẢ TREND đều từ DB (room_type_inventory) - servlet set
    const dailyLabels   = ${dailyLabelsJs};
    const dailyData     = ${dailyValuesJs};

    const monthlyLabels = ${monthlyLabelsJs};
    const monthlyData   = ${monthlyValuesJs};

    // Booking Velocity chart
    const ctxV = document.getElementById("velocityChart");
    const velocityChart = new Chart(ctxV, {
        type: "line",
        data: {
            labels: monthlyLabels,
            datasets: [{
                label: "Booked Rooms",
                data: monthlyData,
                tension: 0.35,
                fill: true,
                pointRadius: 0,
                borderWidth: 4,
                borderColor: "#c9a256",
                backgroundColor: "rgba(201,162,86,.18)"
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false } },
                y: { grid: { color: "rgba(15,23,42,.08)" } }
            }
        }
    });

    // Composition chart từ dbo.rooms.status
    const ctxC = document.getElementById("compositionChart");
    new Chart(ctxC, {
        type: "doughnut",
        data: {
            labels: ["Available", "Occupied", "Dirty", "Maintenance"],
            datasets: [{
                data: [
                    Number("${liveSuites}"),
                    Number("${guestStays}"),
                    Number("${servicing}"),
                    Number("${outOfOrder}")
                ],
                borderWidth: 10,
                borderColor: "#ffffff",
                backgroundColor: ["#c9a256", "#0f172a", "#f59e0b", "#94a3b8"]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "72%",
            plugins: { legend: { display: false } }
        }
    });

    document.getElementById("btnDaily").addEventListener("click", () => {
        velocityChart.data.labels = dailyLabels;
        velocityChart.data.datasets[0].data = dailyData;
        velocityChart.update();
    });

    document.getElementById("btnMonthly").addEventListener("click", () => {
        velocityChart.data.labels = monthlyLabels;
        velocityChart.data.datasets[0].data = monthlyData;
        velocityChart.update();
    });
</script>
