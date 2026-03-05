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
        .main-content { margin-left: 260px; width: calc(100% - 260px); min-height: 100vh; transition: 0.3s; padding: 20px; }
        .text-upgrade { cursor: pointer; transition: 0.2s; }
        .text-upgrade:hover { opacity: 0.8; }
        
        /* --- GIẢI PHÁP CHỐNG NHẢY FORM VÀ THU HẸP KHOẢNG CÁCH --- */
        .occupant-item { 
            position: relative;
            padding-bottom: 22px !important; /* Dành chỗ cố định cho thông báo lỗi */
            margin-bottom: 5px !important; 
            display: flex;
            gap: 10px;
            align-items: flex-start;
        }
        
        .input-wrapper {
            position: relative; 
            flex: 1;
        }

        /* Khóa chết vị trí thông báo lỗi để không đẩy form */
        .invalid-feedback { 
            position: absolute;
            left: 5px;
            bottom: -18px; /* Nằm ngay dưới input */
            font-size: 0.65rem !important;
            margin: 0 !important;
            white-space: nowrap;
            display: none;
            color: #dc3545;
        }

        .is-invalid ~ .invalid-feedback {
            display: block;
        }
        
        .form-control-sm { height: 32px; }
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
                            <span class="text-muted small">Total Amount</span>
                            <span class="fw-bold text-dark" id="total-display">
                                <fmt:formatNumber value="${booking.totalAmount}" type="number" pattern="###,###"/>₫
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Deposit Paid</span>
                            <span class="fw-bold text-success">
                                - <fmt:formatNumber value="${booking.deposit != null ? booking.deposit : 0}" type="number" pattern="###,###"/>₫
                            </span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <span class="fw-bold small">Balance Due</span>
                            <span class="fw-bold text-danger fs-5" id="balance-display">
                                <fmt:formatNumber value="${booking.totalAmount - (booking.deposit != null ? booking.deposit : 0)}" type="number" pattern="###,###"/>₫
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <h6 class="text-muted fw-bold mb-3 text-uppercase small">Room Assignments</h6>
                    <form action="finalize-checkin" method="POST" id="checkinForm">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <c:forEach items="${assignments}" var="asm" varStatus="loop">
                            <div class="card card-custom p-4 mb-3 border-0 shadow-sm">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex align-items-start w-75">
                                        <div class="bg-light rounded-circle me-3 d-flex align-items-center justify-content-center fw-bold text-muted room-indicator">
                                            ${loop.count}
                                        </div>
                                        <div class="w-100">
                                            <h5 class="fw-bold m-0" style="font-size: 1.1rem;">${asm.roomTypeName}</h5>
                                            <p class="text-muted small mb-2">Max: ${asm.numPersons} Guests</p>
                                            
                                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold mb-2" 
                                                    onclick="addOccupantRow(${asm.assignmentId}, ${asm.numPersons})">
                                                <i class="bi bi-plus-lg"></i> Add Occupant
                                            </button>
                                            
                                            <div id="occupant-list-${asm.assignmentId}"></div>
                                        </div>
                                    </div>
                                    
                                    <div class="text-end">
                                        <div class="mb-3">
                                            <a onclick="showAllRooms(${asm.assignmentId})" class="text-primary small fw-bold text-decoration-none me-3 text-upgrade">
                                                Upgrade <i class="bi bi-arrow-up-circle-fill"></i>
                                            </a>
                                            <span id="room_display_${asm.assignmentId}" class="text-danger small italic">Not assigned</span>
                                        </div>
                                        <button type="button" class="btn btn-dark btn-sm rounded-pill px-4 py-2 fw-bold" onclick="openRoomPicker(${asm.assignmentId}, ${asm.roomTypeId})">
                                            Assign Room
                                        </button>
                                        <input type="hidden" name="roomAssign_${asm.assignmentId}" id="room_input_${asm.assignmentId}" required>
                                        <input type="hidden" name="upgradeFee_${asm.assignmentId}" id="upgrade_fee_${asm.assignmentId}" value="0">
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <button type="submit" class="btn w-100 py-3 mt-3 fw-bold shadow-sm btn-finalize" id="submitBtn" disabled>
                            <i class="bi bi-shield-check me-2"></i> Finalize Check-in
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="roomPickerModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content card-custom">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold px-3 pt-3">Chọn phòng trống</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4"><div class="list-group list-group-flush" id="room-list-content"></div></div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const availableRooms = [<c:forEach items="${availableRooms}" var="r" varStatus="st">{id:${r.roomId},no:"${r.roomNo}",floor:${r.floor},typeId:${r.roomTypeId},typeName:"${r.roomTypeName}",price:${r.price!=null?r.price:0}}${!st.last?',':''}</c:forEach>];
        
        // DỮ LIỆU TÀI CHÍNH BAN ĐẦU
        const initialTotal = ${booking.totalAmount};
        const depositAmount = ${booking.deposit != null ? booking.deposit : 0};
        const originalPricePerRoom = ${booking.totalAmount / (assignments.size() > 0 ? assignments.size() : 1)};

        function addOccupantRow(id, maxOcc) {
            const container = document.getElementById('occupant-list-' + id);
            if (container.querySelectorAll('.occupant-item').length >= maxOcc) {
                alert("Phòng này tối đa " + maxOcc + " người!"); return;
            }
            const row = document.createElement('div');
            row.className = 'occupant-item';
            row.innerHTML = `
                <div class="input-wrapper">
                    <input type="text" name="occName_`+id+`" class="form-control form-control-sm" placeholder="Họ Tên" oninput="validate(this, 'name')" required>
                    <div class="invalid-feedback">Tên chỉ chứa chữ cái.</div>
                </div>
                <div class="input-wrapper">
                    <input type="text" name="occId_`+id+`" class="form-control form-control-sm" placeholder="ID (12 số)" maxlength="12" oninput="validate(this, 'id')" required>
                    <div class="invalid-feedback">ID 12 số, không trùng.</div>
                </div>
                <button type="button" class="btn btn-sm btn-outline-danger border-0" onclick="this.parentElement.remove(); checkReadyToFinalize(); reValidateIDs();">
                    <i class="bi bi-trash"></i>
                </button>`;
            container.appendChild(row);
            checkReadyToFinalize();
        }

        function validate(input, type) {
            const val = input.value.trim();
            if (val === "") { 
                input.classList.remove('is-invalid', 'is-valid'); 
                checkReadyToFinalize(); 
                return; 
            }
            let ok = false;
            if (type === 'name') {
                ok = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹý\s]+$/.test(val);
            } else {
                const isFormat = /^\d{12}$/.test(val);
                const allIds = Array.from(document.querySelectorAll('input[name^="occId_"]')).map(i => i.value.trim());
                const isDup = allIds.filter(v => v === val && v !== "").length > 1;
                ok = isFormat && !isDup;
                input.nextElementSibling.innerText = isDup ? "ID đã trùng!" : "ID phải đủ 12 số.";
            }
            input.classList.toggle('is-valid', ok);
            input.classList.toggle('is-invalid', !ok);
            if (type === 'id') reValidateIDs();
            checkReadyToFinalize();
        }

        function reValidateIDs() {
            const inputs = document.querySelectorAll('input[name^="occId_"]');
            const vals = Array.from(inputs).map(i => i.value.trim());
            inputs.forEach(i => {
                const v = i.value.trim(); if (v === "") return;
                const isDup = vals.filter(x => x === v).length > 1;
                const ok = /^\d{12}$/.test(v) && !isDup;
                i.classList.toggle('is-valid', ok); i.classList.toggle('is-invalid', !ok);
                if (isDup) i.nextElementSibling.innerText = "ID đã trùng!";
            });
        }

        function openRoomPicker(assignId, typeId) { renderRoomButtons(availableRooms.filter(r => r.typeId === Number(typeId)), assignId, false); new bootstrap.Modal(document.getElementById('roomPickerModal')).show(); }
        function showAllRooms(assignId) { renderRoomButtons(availableRooms, assignId, true); new bootstrap.Modal(document.getElementById('roomPickerModal')).show(); }

        function renderRoomButtons(rooms, assignId, isUp) {
            const content = document.getElementById('room-list-content');
            content.innerHTML = rooms.length ? "" : "<p class='text-center py-3 text-muted'>Hết phòng trống.</p>";
            rooms.forEach(r => {
                const diff = r.price - originalPricePerRoom;
                const btn = document.createElement('button');
                btn.className = "list-group-item list-group-item-action border-0 rounded-3 mb-2 py-3 d-flex justify-content-between align-items-center";
                let tag = (isUp && diff > 0) ? `<span class="badge bg-warning text-dark">+ \${diff.toLocaleString()}₫</span>` : `<span class="badge bg-success">Standard</span>`;
                btn.innerHTML = `<span><i class="bi bi-door-closed-fill me-2"></i> Phòng \${r.no} (\${r.typeName})</span> \${tag}`;
                
                btn.onclick = () => {
                    document.getElementById('room_input_' + assignId).value = r.id;
                    document.getElementById('room_display_' + assignId).innerText = "Đã chọn: " + r.no;
                    document.getElementById('room_display_' + assignId).className = "text-success small fw-bold";
                    
                    if (isUp && diff > 0) {
    // Sử dụng dấu huyền ` (phím dưới nút ESC) thay vì dấu nháy kép "
    const choice = confirm(`UPGRADE FEE: \${diff.toLocaleString()}₫
- OK: Guest requested (CHARGE APPLIES)
- CANCEL: Hotel's fault (FREE OF CHARGE)`);
    
    document.getElementById('upgrade_fee_' + assignId).value = choice ? diff : 0;
}
                    
                    updateTotalDisplay();
                    bootstrap.Modal.getInstance(document.getElementById('roomPickerModal')).hide();
                    checkReadyToFinalize();
                };
                content.appendChild(btn);
            });
        }

        function updateTotalDisplay() {
            let totalExtra = 0;
            document.querySelectorAll('input[id^="upgrade_fee_"]').forEach(input => {
                totalExtra += parseFloat(input.value) || 0;
            });
            const newTotal = initialTotal + totalExtra;
            const newBalance = newTotal - depositAmount;

            const totalDisplay = document.getElementById('total-display');
            const balanceDisplay = document.getElementById('balance-display');
            
            if (totalDisplay) totalDisplay.innerText = newTotal.toLocaleString('vi-VN') + "₫";
            if (balanceDisplay) balanceDisplay.innerText = newBalance.toLocaleString('vi-VN') + "₫";
        }

        function checkReadyToFinalize() {
            const assigned = Array.from(document.querySelectorAll('input[name^="roomAssign_"]')).every(i => i.value !== "");
            const inputs = document.querySelectorAll('.occupant-item input');
            const ok = inputs.length > 0 && Array.from(inputs).every(i => i.classList.contains('is-valid'));
            const btn = document.getElementById('submitBtn');
            btn.disabled = !(assigned && ok); 
            btn.style.opacity = btn.disabled ? "0.5" : "1";
        }
    </script>
</body>
</html>