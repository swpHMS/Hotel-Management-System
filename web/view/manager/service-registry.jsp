<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* --- BỘ STYLE DÙNG CHUNG (Kế thừa từ Room Registry) --- */
    :root {
        --bg2: #ede7da; --paper: #faf7f2; --border: #e0d8cc;
        --ink: #2c2416; --ink-mid: #5a4e3c; --ink-soft: #9c8e7a;
        --gold: #b5832a; --gold-lt: #f0ddb8; --gold-bg: rgba(181,131,42,.09);
        --sage: #5a7a5c; --sage-lt: #d4e6d4;
        --gray-status: #7a6f61; --gray-status-bg: #ece7df;
    }

    /* Lọc & Phân trang */
    .rr-filter-card { background: var(--paper); border: 1px solid var(--border); border-radius: 20px; padding: 20px 22px; margin-bottom: 18px; box-shadow: 0 2px 12px rgba(44,36,22,.05); }
    .rr-filter-grid { display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 16px; align-items: end; }
    .rr-field label { display: block; font-size: 10.5px; font-weight: 800; letter-spacing: .16em; text-transform: uppercase; color: var(--ink-soft); margin-bottom: 8px; }
    .rr-search-wrap { position: relative; }
    .rr-search-wrap i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--ink-soft); font-size: 14px; pointer-events: none; }
    .rr-input, .rr-select { width: 100%; height: 46px; padding: 0 14px; border: 1.5px solid var(--border); border-radius: 12px; background: #f5f0e8; font-size: 14px; color: var(--ink); outline: none; box-shadow: none; appearance: none; }
    .rr-input { padding-left: 40px; }
    .rr-input:focus, .rr-select:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(181,131,42,.12); background: var(--paper); }
    .rr-filter-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 14px; }
    .rr-btn-reset, .rr-btn-apply { height: 42px; padding: 0 18px; border-radius: 12px; border: 1.5px solid var(--border); background: var(--paper); color: var(--ink-mid); font-weight: 800; font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; transition: 0.15s; }
    .rr-btn-reset:hover { background: #f0ebe0; }
    .rr-btn-apply { background: var(--ink); border-color: var(--ink); color: #fff; }
    .rr-btn-apply:hover { background: #201a10; }
    .rr-table-footer { display: flex; align-items: center; justify-content: space-between; padding: 16px 22px; border-top: 1px solid var(--border); background: var(--bg2); gap: 12px; flex-wrap: wrap; border-bottom-left-radius: 20px; border-bottom-right-radius: 20px;}
    .rr-page-size { display: flex; align-items: center; gap: 9px; font-size: 13px; font-weight: 600; color: var(--ink-mid); }
    .rr-page-size select { height: 34px; padding: 0 10px; border: 1.5px solid var(--border); border-radius: 9px; background: var(--paper); font-size: 13px; color: var(--ink); outline: none; }
    .rr-pagination { display: flex; align-items: center; gap: 8px; }
    .rr-page-btn { height: 34px; padding: 0 14px; border-radius: 9px; border: 1.5px solid var(--border); background: var(--paper); color: var(--ink-mid); font-weight: 800; font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; cursor: pointer; transition: 0.15s; }
    .rr-page-btn:hover { background: var(--gold-lt); border-color: #d4a854; color: var(--gold); }
    .rr-page-btn.disabled { pointer-events: none; opacity: .5; background: #f3eee6; }
    .rr-page-current { width: 34px; height: 34px; border-radius: 9px; background: var(--ink); color: #fff; font-weight: 900; font-size: 13px; display: inline-flex; align-items: center; justify-content: center; }

    /* Bảng dữ liệu: Đã chia 6 cột */
    .rr-table-card { background: var(--paper); border: 1px solid var(--border); border-radius: 20px; overflow: hidden; box-shadow: 0 2px 16px rgba(44,36,22,.06); }
    .sr-grid { display: grid; grid-template-columns: 70px 2fr 1.2fr 1.2fr 1.2fr 100px; gap: 12px; align-items: center; }
    .rr-table-header { background: var(--bg2); border-bottom: 1.5px solid var(--border); padding: 14px 18px; font-size: 10.5px; font-weight: 900; letter-spacing: .14em; text-transform: uppercase; color: var(--ink-soft); }
    .rr-table-row { padding: 16px 18px; border-bottom: 1px solid var(--border); transition: background .15s; background: var(--paper); }
    .rr-table-row:hover { background: #f0ebe0; }
    .rr-table-row:last-child { border-bottom: none; }

    /* Căn giữa cột thứ 3 trở đi */
    .rr-table-header > div:nth-child(n+3), .rr-table-row > div:nth-child(n+3) { display: flex; justify-content: center; align-items: center; text-align: center; }

    .rr-main-title { font-size: 14px; font-weight: 800; color: var(--ink); margin-bottom: 4px; line-height: 1.2; }

    /* Nhãn Pills */
    .rr-pill { display: inline-flex; align-items: center; justify-content: center; padding: 5px 12px; border-radius: 10px; font-weight: 900; font-size: 11px; white-space: nowrap; }
    .rr-category-pill { background: rgba(99, 102, 241, 0.1); color: #6366f1; min-width: 90px; }
    .rr-price-pill { background: #f3ecdf; color: #8d6d3b; min-width: 90px; }
    .rr-status-pill { min-width: 100px; height: 28px; }
    .rr-status-pill.status-active { background: var(--sage-lt); color: var(--sage); }
    .rr-status-pill.status-inactive { background: var(--gray-status-bg); color: var(--gray-status); }

    /* Nút Actions */
    .rr-actions { display: flex; gap: 8px; justify-content: center; }
    .rr-action-btn { width: 40px; height: 38px; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; transition: all .18s ease; border: 1.5px solid var(--border); background: var(--paper); color: var(--ink-soft); cursor: pointer; }
    .rr-action-btn:hover { transform: translateY(-1px); box-shadow: 0 10px 22px rgba(44,36,22,.10); background: var(--gold-lt); border-color: #d4a854; color: var(--gold); }
</style>

<!-- HEADER -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="dashboard-title" style="font-size: 1.8rem; font-weight: 800; color: #1e293b;">Service Performance Dashboard</h1>
        <p class="dashboard-date" style="font-size: 0.75rem; font-weight: 700; color: #94a3b8;">Monitor high-demand services and overall operational revenue.</p>
    </div>
    <!-- Nút Create Service -->
    <button class="btn-new-reservation" data-bs-toggle="modal" data-bs-target="#serviceModal" onclick="openCreateModal()" style="background: #0f172a; color: white; border: none; padding: 10px 20px; border-radius: 12px; font-weight: 700;">
        <i class="bi bi-plus-lg"></i> Create Service
    </button>
</div>

<!-- KPI CARDS -->
<div class="stats-grid mb-4" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
    <div class="stat-card" style="background: white; padding: 20px; border-radius: 30px; display: flex; align-items: center; gap: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
        <div class="stat-icon-wrapper bg-blue-soft" style="width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; background: #eff6ff; color: #3b82f6;"><i class="bi bi-gear-fill"></i></div>
        <div>
            <span class="stat-label" style="font-size: 0.6rem; font-weight: 800; color: #94a3b8; display: block; margin-bottom: 4px;">TOTAL SERVICES</span>
            <div class="stat-value" style="font-size: 1.6rem; font-weight: 800; color: #1e293b;">${kpis.totalServices != null ? kpis.totalServices : 0}</div>
        </div>
    </div>
    <div class="stat-card" style="background: white; padding: 20px; border-radius: 30px; display: flex; align-items: center; gap: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
        <div class="stat-icon-wrapper bg-green-soft" style="width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; background: #f0fdf4; color: #22c55e;"><i class="bi bi-activity"></i></div>
        <div>
            <span class="stat-label" style="font-size: 0.6rem; font-weight: 800; color: #94a3b8; display: block; margin-bottom: 4px;">ACTIVE SERVICES</span>
            <div class="stat-value" style="font-size: 1.6rem; font-weight: 800; color: #1e293b;">${kpis.activeServices != null ? kpis.activeServices : 0}</div>
        </div>
    </div>
    <div class="stat-card" style="background: white; padding: 20px; border-radius: 30px; display: flex; align-items: center; gap: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
        <div class="stat-icon-wrapper bg-orange-soft" style="width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; background: #fff7ed; color: #f97316;"><i class="bi bi-graph-up-arrow"></i></div>
        <div>
            <span class="stat-label" style="font-size: 0.6rem; font-weight: 800; color: #94a3b8; display: block; margin-bottom: 4px;">TOTAL ORDERS</span>
            <div class="stat-value" style="font-size: 1.6rem; font-weight: 800; color: #1e293b;">${kpis.totalOrders != null ? kpis.totalOrders : 0}</div>
        </div>
    </div>
    <div class="stat-card" style="background: white; padding: 20px; border-radius: 30px; display: flex; align-items: center; gap: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
        <div class="stat-icon-wrapper bg-indigo-soft" style="width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; background: #eef2ff; color: #6366f1;"><i class="bi bi-currency-dollar"></i></div>
        <div>
            <span class="stat-label" style="font-size: 0.6rem; font-weight: 800; color: #94a3b8; display: block; margin-bottom: 4px;">TOTAL REVENUE</span>
            <div class="stat-value" style="font-size: 1.6rem; font-weight: 800; color: #1e293b;">
                <!-- Đã chuyển sang VND (đ) -->
                <fmt:formatNumber value="${kpis.totalRevenue != null ? kpis.totalRevenue : 0}" type="number" pattern="#,##0"/> đ
            </div>
        </div>
    </div>
</div>

<!-- KHUNG LỌC (FILTER BAR) -->
<form class="rr-filter-card mt-4" action="${pageContext.request.contextPath}/manager/services" method="get">
    <div class="rr-filter-grid">
        <div class="rr-field">
            <label>Search</label>
            <div class="rr-search-wrap">
                <i class="bi bi-search"></i>
                <input class="rr-input" type="text" name="keyword" placeholder="Search service name or category..." value="${keyword}">
            </div>
        </div>
        <div class="rr-field">
            <label>Category</label>
            <select name="serviceType" class="rr-select">
                <option value="">All Categories</option>
                <option value="3" ${serviceType == '3' ? 'selected' : ''}>Transport</option>
                <option value="1" ${serviceType == '1' ? 'selected' : ''}>Food</option>
                <option value="2" ${serviceType == '2' ? 'selected' : ''}>Laundry</option>
                <option value="0" ${serviceType == '0' ? 'selected' : ''}>Other</option>
            </select>
        </div>
        <div class="rr-field">
            <label>Status</label>
            <select name="status" class="rr-select">
                <option value="">All Status</option>
                <option value="1" ${status == '1' ? 'selected' : ''}>Active</option>
                <option value="0" ${status == '0' ? 'selected' : ''}>Inactive</option>
            </select>
        </div>
    </div>
    <div class="rr-filter-actions">
        <a class="rr-btn-reset" href="${pageContext.request.contextPath}/manager/services">Reset</a>
        <button type="submit" class="rr-btn-apply">Apply Filter</button>
    </div>
</form>

<!-- BẢNG DANH SÁCH -->
<div class="rr-table-card mt-4">
    <!-- HEADER BẢNG -->
    <div class="rr-table-header sr-grid">
        <div>ID</div>
        <div>Service Details</div>
        <div>Category</div>
        <div>Price</div>
        <div>Status</div>
        <div>Actions</div>
    </div>

    <!-- DANH SÁCH DỊCH VỤ -->
    <c:forEach var="s" items="${services}">
        <div class="rr-table-row sr-grid">
            <!-- Cột ID -->
            <div style="font-weight: 900; color: var(--ink-soft); font-size: 0.9rem;">#${s.serviceId}</div>

            <!-- Tên Dịch Vụ (Đã bỏ Service ID bên dưới) -->
            <div>
                <div class="rr-main-title">${s.name}</div>
            </div>

            <!-- Phân Loại -->
            <div>
                <span class="rr-pill rr-category-pill">${s.categoryName}</span>
            </div>

            <!-- Giá (Đã chuyển sang đ) -->
            <div>
                <span class="rr-pill rr-price-pill">
                    <fmt:formatNumber value="${s.unitPrice}" type="number" pattern="#,##0"/> đ
                </span>
            </div>

            <!-- Trạng Thái -->
            <div>
                <span class="rr-pill rr-status-pill ${s.status == 1 ? 'status-active' : 'status-inactive'}">
                    ${s.statusText}
                </span>
            </div>

            <!-- Hành Động -->
            <div class="rr-actions">
                <button type="button" class="rr-action-btn" 
                        onclick="openEditModal(${s.serviceId}, '${s.name}', ${s.unitPrice}, ${s.serviceType}, ${s.status})" 
                        data-bs-toggle="modal" data-bs-target="#serviceModal" title="Edit">
                    <i class="bi bi-pencil-square"></i>
                </button>
            </div>
        </div>
    </c:forEach>

    <!-- NẾU KHÔNG CÓ DỮ LIỆU -->
    <c:if test="${empty services}">
        <div class="p-5 text-center text-muted" style="font-weight: 600;">No services found matching your criteria.</div>
    </c:if>

    <!-- PAGINATION -->
    <div class="rr-table-footer">
        <form action="${pageContext.request.contextPath}/manager/services" method="get" class="rr-page-size">
            <span>Show</span>
            <input type="hidden" name="keyword" value="${keyword}">
            <input type="hidden" name="serviceType" value="${serviceType}">
            <input type="hidden" name="status" value="${status}">
            <input type="hidden" name="page" value="1">
            <select name="pageSize" onchange="this.form.submit()">
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
            </select>
            <span>entries per page</span>
        </form>

        <div class="rr-pagination">
            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a class="rr-page-btn" href="${pageContext.request.contextPath}/manager/services?page=${currentPage - 1}&pageSize=${pageSize}&keyword=${keyword}&serviceType=${serviceType}&status=${status}">← Prev</a>
                </c:when>
                <c:otherwise>
                    <span class="rr-page-btn disabled">← Prev</span>
                </c:otherwise>
            </c:choose>

            <span class="rr-page-current">${currentPage}</span>

            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a class="rr-page-btn" href="${pageContext.request.contextPath}/manager/services?page=${currentPage + 1}&pageSize=${pageSize}&keyword=${keyword}&serviceType=${serviceType}&status=${status}">Next →</a>
                </c:when>
                <c:otherwise>
                    <span class="rr-page-btn disabled">Next →</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- MODAL CREATE/EDIT -->
<div class="modal fade" id="serviceModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px;">
            <form id="serviceForm" action="${pageContext.request.contextPath}/manager/services" method="post">
                <input type="hidden" name="action" id="modalAction" value="create">
                <input type="hidden" name="serviceId" id="modalServiceId">
                
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title" id="modalTitle" style="font-weight: 900; color: #1e293b;">CREATE NEW SERVICE</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- Tên dịch vụ -->
                    <div class="mb-3">
                        <label class="form-label" style="font-size: 0.7rem; font-weight: 800; color: #94a3b8; text-transform: uppercase;">Service Name</label>
                        <input type="text" class="form-control rounded-3" name="name" id="modalName" placeholder="e.g. Express Laundry" required>
                    </div>
                    <!-- Đơn giá & Phân loại (đã đổi $ thành đ) -->
                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label" style="font-size: 0.7rem; font-weight: 800; color: #94a3b8; text-transform: uppercase;">Unit Price (đ)</label>
                            <input type="number" step="1000" min="0" class="form-control rounded-3" name="unitPrice" id="modalPrice" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label" style="font-size: 0.7rem; font-weight: 800; color: #94a3b8; text-transform: uppercase;">Category</label>
                            <select class="form-select rounded-3" name="serviceType" id="modalCategory">
                                <option value="3">Transport</option>
                                <option value="1">Food</option>
                                <option value="2">Laundry</option>
                                <option value="0">Other</option>
                            </select>
                        </div>
                    </div>
                    <!-- Trạng thái -->
                    <div class="mb-3">
                        <label class="form-label" style="font-size: 0.7rem; font-weight: 800; color: #94a3b8; text-transform: uppercase;">Availability Status</label>
                        <select class="form-select rounded-3" name="status" id="modalStatus">
                            <option value="1">Active</option>
                            <option value="0">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 d-flex justify-content-between">
                    <button type="button" class="btn btn-light rounded-3 w-50 fw-bold border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-3 w-50 fw-bold" style="background: #2563eb; border: none;">SAVE SERVICE</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('modalTitle').innerText = 'CREATE NEW SERVICE';
        document.getElementById('modalAction').value = 'create';
        document.getElementById('serviceForm').reset();
    }

    function openEditModal(id, name, price, type, status) {
        document.getElementById('modalTitle').innerText = 'EDIT SERVICE';
        document.getElementById('modalAction').value = 'update';
        document.getElementById('modalServiceId').value = id;
        document.getElementById('modalName').value = name;
        document.getElementById('modalPrice').value = price;
        document.getElementById('modalCategory').value = type;
        document.getElementById('modalStatus').value = status;
    }
</script>