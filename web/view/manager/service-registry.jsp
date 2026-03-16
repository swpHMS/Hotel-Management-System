<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
/* Style Filter và Phân trang (Lấy từ Room Registry) */
.rr-filter-card { background: #fff; border: 1px solid #e0d8cc; border-radius: 20px; padding: 20px 22px; margin-bottom: 18px; box-shadow: 0 2px 12px rgba(44,36,22,.05); }
.rr-filter-grid { display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 16px; align-items: end; }
.rr-field label { display: block; font-size: 10.5px; font-weight: 800; letter-spacing: .16em; text-transform: uppercase; color: #9c8e7a; margin-bottom: 8px; }
.rr-search-wrap { position: relative; }
.rr-search-wrap i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9c8e7a; font-size: 14px; pointer-events: none; }
.rr-input, .rr-select { width: 100%; height: 46px; padding: 0 14px; border: 1.5px solid #e0d8cc; border-radius: 12px; background: #f5f0e8; font-size: 14px; color: #2c2416; outline: none; box-shadow: none; appearance: none; }
.rr-input { padding-left: 40px; }
.rr-input:focus, .rr-select:focus { border-color: #b5832a; box-shadow: 0 0 0 3px rgba(181,131,42,.12); background: #faf7f2; }
.rr-filter-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 14px; }
.rr-btn-reset, .rr-btn-apply { height: 42px; padding: 0 18px; border-radius: 12px; border: 1.5px solid #e0d8cc; background: #faf7f2; color: #5a4e3c; font-weight: 800; font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; transition: 0.15s; }
.rr-btn-reset:hover { background: #f0ebe0; }
.rr-btn-apply { background: #2c2416; border-color: #2c2416; color: #fff; }
.rr-btn-apply:hover { background: #201a10; color: #fff;}
.rr-table-footer { display: flex; align-items: center; justify-content: space-between; padding: 16px 22px; border-top: 1px solid #e0d8cc; background: #ede7da; gap: 12px; flex-wrap: wrap; border-bottom-left-radius: 20px; border-bottom-right-radius: 20px;}
.rr-page-size { display: flex; align-items: center; gap: 9px; font-size: 13px; font-weight: 600; color: #5a4e3c; }
.rr-page-size select { height: 34px; padding: 0 10px; border: 1.5px solid #e0d8cc; border-radius: 9px; background: #faf7f2; font-size: 13px; color: #2c2416; outline: none; }
.rr-pagination { display: flex; align-items: center; gap: 8px; }
.rr-page-btn { height: 34px; padding: 0 14px; border-radius: 9px; border: 1.5px solid #e0d8cc; background: #faf7f2; color: #5a4e3c; font-weight: 800; font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; cursor: pointer; transition: 0.15s; }
.rr-page-btn:hover { background: #f0ddb8; border-color: #d4a854; color: #b5832a; }
.rr-page-btn.disabled { pointer-events: none; opacity: .5; background: #f3eee6; }
.rr-page-current { width: 34px; height: 34px; border-radius: 9px; background: #2c2416; color: #fff; font-weight: 900; font-size: 13px; display: inline-flex; align-items: center; justify-content: center; }
 /* --- STYLE BẢNG CHUẨN ROOM REGISTRY --- */
    :root {
        --bg2: #ede7da; --paper: #faf7f2; --border: #e0d8cc;
        --ink: #2c2416; --ink-mid: #5a4e3c; --ink-soft: #9c8e7a;
        --gold: #b5832a; --gold-lt: #f0ddb8; --gold-bg: rgba(181,131,42,.09);
        --sage: #5a7a5c; --sage-lt: #d4e6d4;
        --gray-status: #7a6f61; --gray-status-bg: #ece7df;
    }

    .rr-table-card { background: var(--paper); border: 1px solid var(--border); border-radius: 20px; overflow: hidden; box-shadow: 0 2px 16px rgba(44,36,22,.06); }
    .sr-grid { display: grid; grid-template-columns: 2fr 1.2fr 1.2fr 1.2fr 100px; gap: 12px; align-items: center; }
    
    .rr-table-header { background: var(--bg2); border-bottom: 1.5px solid var(--border); padding: 14px 18px; font-size: 10.5px; font-weight: 900; letter-spacing: .14em; text-transform: uppercase; color: var(--ink-soft); }
    .rr-table-row { padding: 16px 18px; border-bottom: 1px solid var(--border); transition: background .15s; background: var(--paper); }
    .rr-table-row:hover { background: #f0ebe0; }
    .rr-table-row:last-child { border-bottom: none; }

    .rr-main-title { font-size: 14px; font-weight: 800; color: var(--ink); margin-bottom: 4px; line-height: 1.2; }
    .rr-sub-title { font-size: 10px; letter-spacing: .14em; text-transform: uppercase; color: var(--ink-soft); font-weight: 800; line-height: 1.2; }

    /* Căn giữa nội dung các cột 2,3,4,5 */
    .rr-table-header > div:not(:first-child), .rr-table-row > div:not(:first-child) { display: flex; justify-content: center; align-items: center; }

    /* Các Nhãn Màu (Pills) */
    .rr-pill { display: inline-flex; align-items: center; justify-content: center; padding: 5px 12px; border-radius: 10px; font-weight: 900; font-size: 11px; white-space: nowrap; }
    .rr-category-pill { background: rgba(99, 102, 241, 0.1); color: #6366f1; min-width: 90px; } /* Màu xanh tím */
    .rr-price-pill { background: #f3ecdf; color: #8d6d3b; min-width: 90px; } /* Màu vàng nâu */
    
    .rr-status-pill { min-width: 100px; height: 28px; }
    .rr-status-pill.status-active { background: var(--sage-lt); color: var(--sage); } /* Màu xanh lá nhạt */
    .rr-status-pill.status-inactive { background: var(--gray-status-bg); color: var(--gray-status); } /* Màu xám */

    /* Nút Actions */
    .rr-actions { display: flex; gap: 8px; }
    .rr-action-btn { width: 40px; height: 38px; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; transition: all .18s ease; border: 1.5px solid var(--border); background: var(--paper); color: var(--ink-soft); cursor: pointer; }
    .rr-action-btn:hover { transform: translateY(-1px); box-shadow: 0 10px 22px rgba(44,36,22,.10); background: var(--gold-lt); border-color: #d4a854; color: var(--gold); }

</style>

<!-- HEADER -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="dashboard-title">Service Performance Dashboard</h1>
        <p class="dashboard-date">Monitor high-demand services and overall operational revenue.</p>
    </div>
    <!-- Nút Create Service đã được đưa lên thay thế vị trí Last 30 Days -->
    <button class="btn-new-reservation" data-bs-toggle="modal" data-bs-target="#serviceModal" onclick="openCreateModal()">
        <i class="bi bi-plus-lg"></i> Create Service
    </button>
</div>

<!-- KPI CARDS (Theo Mockup Ảnh 1) -->
<div class="stats-grid mb-4">
    <div class="stat-card">
        <div class="stat-icon-wrapper bg-blue-soft"><i class="bi bi-gear-fill"></i></div>
        <div>
            <span class="stat-label">TOTAL SERVICES</span>
            <div class="stat-value">${kpis.totalServices != null ? kpis.totalServices : 0}</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon-wrapper bg-green-soft"><i class="bi bi-activity"></i></div>
        <div>
            <span class="stat-label">ACTIVE SERVICES</span>
            <div class="stat-value">${kpis.activeServices != null ? kpis.activeServices : 0}</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon-wrapper bg-orange-soft"><i class="bi bi-graph-up-arrow"></i></div>
        <div>
            <span class="stat-label">TOTAL ORDERS</span>
            <div class="stat-value">${kpis.totalOrders != null ? kpis.totalOrders : 0}</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon-wrapper bg-indigo-soft"><i class="bi bi-currency-dollar"></i></div>
        <div>
            <span class="stat-label">TOTAL REVENUE</span>
            <div class="stat-value">
                $<fmt:formatNumber value="${kpis.totalRevenue != null ? kpis.totalRevenue : 0}" type="number" pattern="#,##0.00"/>
            </div>
        </div>
    </div>
</div>

<!-- SERVICE LIST (Theo Mockup Ảnh 2) -->

    <!-- FILTER BAR -->
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
        <input type="hidden" name="page" value="1">
        <div class="rr-filter-actions">
            <a class="rr-btn-reset" href="${pageContext.request.contextPath}/manager/services">Reset</a>
            <button type="submit" class="rr-btn-apply">Apply Filter</button>
        </div>
    </form>

<div class="rr-table-card">
        <!-- HEADER BẢNG -->
        <div class="rr-table-header sr-grid">
            <div>Service Details</div>
            <div>Category</div>
            <div>Price</div>
            <div>Status</div>
            <div>Actions</div>
        </div>

        <!-- DANH SÁCH DỊCH VỤ -->
        <c:forEach var="s" items="${services}">
            <div class="rr-table-row sr-grid">
                <!-- Tên Dịch Vụ -->
                <div>
                    <div class="rr-main-title">${s.name}</div>
                    <div class="rr-sub-title">Service ID: ${s.serviceId}</div>
                </div>

                <!-- Phân Loại -->
                <div>
                    <span class="rr-pill rr-category-pill">${s.categoryName}</span>
                </div>

                <!-- Giá -->
                <div>
                    <span class="rr-pill rr-price-pill">
                        $<fmt:formatNumber value="${s.unitPrice}" type="number" pattern="#,##0.00"/>
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
    <!-- PAGINATION (Dưới cùng của bảng) -->
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
    </div> <!-- Đóng thẻ booking-table-container -->


<!-- MODAL CREATE/EDIT (Theo Mockup Ảnh 3 & 4) -->
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
                    <!-- Service Name -->
                    <div class="mb-3">
                        <label class="form-label" style="font-size: 0.7rem; font-weight: 800; color: #94a3b8; text-transform: uppercase;">Service Name</label>
                        <input type="text" class="form-control rounded-3" name="name" id="modalName" placeholder="e.g. Express Laundry" required>
                    </div>
                    <!-- Unit Price & Category -->
                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label" style="font-size: 0.7rem; font-weight: 800; color: #94a3b8; text-transform: uppercase;">Unit Price ($)</label>
                            <input type="number" step="0.01" min="0" class="form-control rounded-3" name="unitPrice" id="modalPrice" required>
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
                    <!-- Availability Status -->
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

<!-- SCRIPTS ĐIỀU KHIỂN MODAL -->
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