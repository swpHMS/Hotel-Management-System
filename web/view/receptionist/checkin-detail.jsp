<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Check-in Detail | HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f2f5; font-family: 'Inter', sans-serif; }
        .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .btn-finalize { background-color: #76c893; color: white; font-weight: bold; border-radius: 12px; transition: 0.3s; }
        .btn-finalize:hover { background-color: #52b788; transform: translateY(-2px); }
        .room-indicator { width: 45px; height: 45px; font-size: 0.9rem; }
        .main-content { 
        margin-left: 260px; /* Điều chỉnh con số này khớp với độ rộng Sidebar của bạn */
        transition: 0.3s;
    }

    .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
    <%@include file="sidebar.jsp" %>
    <div class="main-content">
<div class="container py-5">
    <div class="d-flex align-items-center mb-4">
        <a href="dashboard" class="btn btn-light rounded-circle me-3 shadow-sm"><i class="bi bi-arrow-left"></i></a>
        <h2 class="fw-bold m-0">Check-in: #${booking.bookingId}</h2>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card card-custom p-4 shadow-sm">
                <h6 class="text-muted fw-bold mb-4 small text-uppercase" style="letter-spacing: 1px;">Booking Summary</h6>
                <div class="mb-3">
                    <label class="text-muted small d-block">Guest</label>
                    <span class="fw-bold">${booking.guestName}</span>
                </div>
                <div class="mb-3">
                    <label class="text-muted small d-block">Dates</label>
                    <span class="fw-bold">${booking.checkInDate} — ${booking.checkOutDate}</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Total Amount</span>
                    <span class="fw-bold text-dark">
                        <fmt:formatNumber value="${booking.totalAmount}" type="number" pattern="###,###"/>₫
                    </span>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <h6 class="text-muted fw-bold mb-3 text-uppercase small" style="letter-spacing: 1px;">Room Assignments</h6>
            
            <form action="finalize-checkin" method="POST">
                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                
                <%-- Kiểm tra nếu danh sách assignments bị trống --%>
                <c:if test="${empty assignments}">
                    <div class="alert alert-warning card-custom p-4 text-center">
                        <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                        Không tìm thấy thông tin phòng cho đơn đặt này. Vui lòng kiểm tra lại Database.
                    </div>
                </c:if>

                <c:forEach items="${assignments}" var="asm" varStatus="loop">
                    <div class="card card-custom p-4 mb-3 border-0 shadow-sm">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center">
                                <div class="bg-light rounded-circle me-3 d-flex align-items-center justify-content-center fw-bold text-muted room-indicator">
                                    ${loop.count}
                                </div>
                                
                                <div>
                                    <h5 class="fw-bold m-0" style="font-size: 1.1rem;">${asm.roomTypeName}</h5>
                                    <p class="text-muted small m-0 mb-2">Standard Occupancy: ${asm.numPersons} Adults</p>
                                    
                                    <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" 
                                            style="font-size: 0.75rem; color: #3a86ff;"
                                            onclick="addOccupantRow(${asm.assignmentId})">
                                        <i class="bi bi-plus-lg"></i> Add Occupant
                                    </button>
                                    
                                    <div id="occupant-list-${asm.assignmentId}" class="mt-2"></div>
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <div class="mb-3">
                                    <a href="#" class="text-primary small fw-bold text-decoration-none me-3" style="font-size: 0.8rem;">
                                        Upgrade <i class="bi bi-check-square-fill" style="color: #4cc9f0;"></i>
                                    </a>
                                    <span id="room_display_${asm.assignmentId}" class="text-danger small italic" style="font-size: 0.85rem;">Not assigned</span>
                                </div>
                                
                                <button type="button" class="btn btn-dark btn-sm rounded-pill px-4 py-2 fw-bold" 
                                        style="font-size: 0.85rem;"
                                        onclick="openRoomPicker(${asm.assignmentId}, ${asm.roomTypeId})">
                                    Assign Room
                                </button>
                                
                                <input type="hidden" name="roomAssign_${asm.assignmentId}" id="room_input_${asm.assignmentId}" required>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${not empty assignments}">
                    <button type="submit" class="btn w-100 py-3 mt-3 fw-bold shadow-sm btn-finalize">
                        <i class="bi bi-shield-check me-2"></i> Finalize Check-in
                    </button>
                </c:if>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="roomPickerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content card-custom">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold px-3 pt-3">Chọn phòng trống</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="list-group list-group-flush" id="room-list-content"></div>
            </div>
        </div>
    </div>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Chuyển đổi list Java sang mảng JS
    const availableRooms = [
        <c:forEach items="${availableRooms}" var="r" varStatus="st">
            { id: ${r.roomId}, no: "${r.roomNo}", floor: ${r.floor} }${!st.last ? ',' : ''}
        </c:forEach>
    ];

    function addOccupantRow(id) {
        const container = document.getElementById('occupant-list-' + id);
        if (!container) return;
        const row = document.createElement('div');
        row.className = 'd-flex gap-2 mb-2 animate__animated animate__fadeIn';
        row.innerHTML = `
            <input type="text" name="occName_` + id + `" class="form-control form-control-sm" placeholder="Full Name" required style="font-size: 0.8rem;">
            <input type="text" name="occId_` + id + `" class="form-control form-control-sm" placeholder="ID Number" required style="font-size: 0.8rem;">
            <button type="button" class="btn btn-sm btn-outline-danger border-0" onclick="this.parentElement.remove()"><i class="bi bi-trash"></i></button>
        `;
        container.appendChild(row);
    }

    function openRoomPicker(assignId, typeId) {
        const content = document.getElementById('room-list-content');
        content.innerHTML = ""; 
        if (availableRooms.length === 0) {
            content.innerHTML = "<p class='text-center text-muted'>Không có phòng trống!</p>";
        } else {
            availableRooms.forEach(room => {
                const btn = document.createElement('button');
                btn.type = "button";
                btn.className = "list-group-item list-group-item-action border-0 rounded-3 mb-2 py-3 fw-bold";
                btn.innerHTML = `<i class="bi bi-door-closed me-2"></i> Phòng ` + room.no + ` (Tầng ` + room.floor + `)`;
                btn.onclick = function() {
                    document.getElementById('room_input_' + assignId).value = room.id;
                    const display = document.getElementById('room_display_' + assignId);
                    display.innerText = "Phòng " + room.no;
                    display.className = "text-success small fw-bold";
                    bootstrap.Modal.getInstance(document.getElementById('roomPickerModal')).hide();
                };
                content.appendChild(btn);
            });
        }
        new bootstrap.Modal(document.getElementById('roomPickerModal')).show();
    }
</script>
</body>
</html>