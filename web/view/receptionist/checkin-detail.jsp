<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Check-in Detail | LuxStay HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f5f0e8; font-family: 'DM Sans', sans-serif; color: #2c2416; }
        .card-custom { border-radius: 20px; border: 1px solid #e0d8cc; background: #faf7f2; box-shadow: 0 4px 12px rgba(44,36,22,0.05); }
        .btn-finalize { background-color: #5a7a5c; color: white; font-weight: bold; border-radius: 12px; transition: 0.3s; border: none; }
        .btn-finalize:hover { background-color: #4a664c; transform: translateY(-2px); color: white; }
        .btn-finalize:disabled { background-color: #9c8e7a; opacity: 0.6; transform: none; }
        .room-indicator { width: 45px; height: 45px; font-size: 0.9rem; background: #ede7da; color: #b5832a; }
        .main-content { margin-left: 260px; width: calc(100% - 260px); min-height: 100vh; padding: 30px; }
        .text-upgrade { cursor: pointer; transition: 0.2s; color: #b5832a !important; }

        .occupant-item {
            position: relative;
            padding-bottom: 22px !important;
            margin-bottom: 5px !important;
            display: flex;
            gap: 10px;
            align-items: flex-start;
        }

        .input-wrapper { position: relative; flex: 1; }
        .invalid-feedback {
            position: absolute;
            left: 5px;
            bottom: -18px;
            font-size: 0.65rem !important;
            margin: 0 !important;
            white-space: nowrap;
            display: none;
            color: #c0614a;
        }
        .is-invalid ~ .invalid-feedback { display: block; }
        .form-control-sm { border-radius: 8px; border: 1.5px solid #e0d8cc; }
        .form-control-sm:focus { border-color: #b5832a; box-shadow: 0 0 0 3px rgba(181,131,42,0.1); }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex align-items-center mb-4">
                <a href="dashboard" class="btn btn-light rounded-circle me-3 shadow-sm"><i class="bi bi-arrow-left"></i></a>
                <h2 class="fw-bold m-0" style="font-family: 'Fraunces', serif;">Confirm Arrival</h2>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card card-custom p-4 shadow-sm">
                        <h6 class="text-muted fw-bold mb-4 small text-uppercase" style="letter-spacing: 1px;">Booking Summary</h6>
                        <div class="mb-3">
                            <label class="text-muted small d-block">Main Guest</label>
                            <span class="fw-bold fs-5">${booking.guestName}</span>
                        </div>
                        <div class="mb-3">
                            <label class="text-muted small d-block">Stay Period</label>
                            <span class="fw-bold text-muted">${booking.checkInDate} — ${booking.checkOutDate}</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Original Total</span>
                            <span class="fw-bold" id="total-display">
                                <fmt:formatNumber value="${booking.totalAmount}" pattern="###,###"/>₫
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Deposit Paid</span>
                            <span class="fw-bold text-success">
                                - <fmt:formatNumber value="${booking.deposit != null ? booking.deposit : 0}" pattern="###,###"/>₫
                            </span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fw-bold small">Balance Due</span>
                            <span class="fw-bold text-danger fs-4" id="balance-display">
                                <fmt:formatNumber value="${booking.totalAmount - (booking.deposit != null ? booking.deposit : 0)}" pattern="###,###"/>₫
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <h6 class="text-muted fw-bold mb-3 text-uppercase small">Room Selection & Guest Details</h6>
                    <form action="finalize-checkin" method="POST" id="checkinForm">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">

                        <c:forEach items="${assignments}" var="asm" varStatus="loop">
                            <div class="card card-custom p-4 mb-3 shadow-sm">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex align-items-start w-75">
                                        <div class="rounded-circle me-3 d-flex align-items-center justify-content-center fw-bold room-indicator">
                                            ${loop.count}
                                        </div>
                                        <div class="w-100">
                                            <h5 class="fw-bold m-0">${asm.roomTypeName}</h5>
                                            <p class="text-muted small mb-2">Capacity: ${asm.numPersons} Guests</p>

                                            <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold mb-2 text-success"
                                                    onclick="addOccupantRow(${loop.index}, ${asm.numPersons})">
                                                <i class="bi bi-person-plus-fill"></i> Add Guest Info
                                            </button>

                                            <div id="occupant-list-${loop.index}"></div>
                                        </div>
                                    </div>

                                    <div class="text-end">
                                        <div class="mb-3">
                                            <a onclick="showAllRooms(${loop.index}, ${asm.roomTypeId})" class="text-upgrade small fw-bold text-decoration-none me-3">
                                                Upgrade <i class="bi bi-arrow-up-circle"></i>
                                            </a>
                                            <span id="room_display_${loop.index}" class="text-danger small italic">Not selected</span>
                                        </div>

                                        <button type="button"
                                                class="btn btn-outline-dark btn-sm rounded-pill px-4 py-2 fw-bold"
                                                onclick="openRoomPicker(${loop.index}, ${asm.roomTypeId})">
                                            Select Room
                                        </button>

                                        <input type="hidden" name="roomAssign_${loop.index}" id="room_input_${loop.index}" required>
                                        <input type="hidden" name="upgradeFee_${loop.index}" id="upgrade_fee_${loop.index}" value="0">
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <button type="submit" class="btn w-100 py-3 mt-3 fw-bold shadow-sm btn-finalize" id="submitBtn" disabled>
                            <i class="bi bi-check-circle-fill me-2"></i> Finalize Check-in
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="roomPickerModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content card-custom" style="background: white;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold px-3 pt-3">Available Rooms</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="list-group list-group-flush" id="room-list-content"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const availableRooms = [];
        <c:forEach items="${availableRooms}" var="r">
        availableRooms.push({
            roomId: parseInt("${r.roomId}"),
            roomNo: "${r.roomNo}",
            roomTypeId: parseInt("${r.roomTypeId}"),
            roomTypeName: "${r.roomTypeName}",
            price: parseFloat("${r.price != null ? r.price : 0}")
        });
        </c:forEach>

        console.log("JS nhận được từ JSP:", availableRooms);

        const initialTotal = ${booking.totalAmount};
        const depositAmount = ${booking.deposit != null ? booking.deposit : 0};
        const originalPricePerRoom = ${booking.totalAmount / (assignments.size() > 0 ? assignments.size() : 1)};
        let selectedRoomIds = {};

        function openRoomPicker(idx, typeId) {
            const targetTypeId = Number(typeId);
            const busyIds = Object.values(selectedRoomIds).filter(id => id !== null);

            const filtered = availableRooms.filter(r =>
                Number(r.roomTypeId) === targetTypeId && !busyIds.includes(r.roomId)
            );

            renderRoomButtons(filtered, idx, false, targetTypeId);
            new bootstrap.Modal(document.getElementById('roomPickerModal')).show();
        }

        function showAllRooms(idx, bookedTypeId) {
            const busyIds = Object.values(selectedRoomIds).filter(id => id !== null);

            const filtered = availableRooms.filter(r =>
                !busyIds.includes(r.roomId) &&
                Number(r.roomTypeId) !== Number(bookedTypeId)
            );

            renderRoomButtons(filtered, idx, true, bookedTypeId);
            new bootstrap.Modal(document.getElementById('roomPickerModal')).show();
        }

        function renderRoomButtons(rooms, idx, isUpgrade, bookedTypeId) {
            const content = document.getElementById('room-list-content');
            content.innerHTML = rooms.length
                ? ""
                : "<p class='text-center py-3 text-muted'>Không còn phòng trống phù hợp.</p>";

            rooms.forEach(r => {
                const diff = r.price - originalPricePerRoom;
                const isSameType = Number(r.roomTypeId) === Number(bookedTypeId);

                const btn = document.createElement('button');
                btn.className = "list-group-item list-group-item-action border-0 rounded-3 mb-2 py-3 d-flex justify-content-between align-items-center";

                let tag = `<span class="badge bg-success">Standard</span>`;

                if (isUpgrade) {
                    if (isSameType) {
                        tag = `<span class="badge bg-secondary">Same Type</span>`;
                    } else if (diff > 0) {
                        tag = `<span class="badge bg-warning text-dark">+ \${diff.toLocaleString()}₫</span>`;
                    } else {
                        tag = `<span class="badge bg-info text-dark">Upgrade</span>`;
                    }
                }

                btn.innerHTML = `<span><i class="bi bi-door-closed-fill me-2"></i> Room \${r.roomNo} (\${r.roomTypeName})</span> \${tag}`;

                btn.onclick = () => {
    selectedRoomIds[idx] = r.roomId;
    document.getElementById('room_input_' + idx).value = r.roomId;

    const display = document.getElementById('room_display_' + idx);

    if (isUpgrade && !isSameType) {
        if (diff > 0) {
            const choice = confirm(`UPGRADE FEE: \${diff.toLocaleString()}₫\n- OK: Tính phí khách hàng\n- Cancel: Miễn phí`);
            document.getElementById('upgrade_fee_' + idx).value = choice ? diff : 0;

            if (choice) {
                display.innerText = `Room: \${r.roomNo} (\${r.roomTypeName}) • Upgrade (+\${diff.toLocaleString()}₫)`;
                display.className = "text-warning small fw-bold";
            } else {
                display.innerText = `Room: \${r.roomNo} (\${r.roomTypeName}) • Free Upgrade`;
                display.className = "text-primary small fw-bold";
            }
        } else {
            document.getElementById('upgrade_fee_' + idx).value = 0;
            display.innerText = `Room: \${r.roomNo} (\${r.roomTypeName}) • Upgrade`;
            display.className = "text-primary small fw-bold";
        }
    } else {
        document.getElementById('upgrade_fee_' + idx).value = 0;
        display.innerText = `Room: \${r.roomNo} (\${r.roomTypeName})`;
        display.className = "text-success small fw-bold";
    }

    updateTotalDisplay();
    bootstrap.Modal.getInstance(document.getElementById('roomPickerModal')).hide();
    checkReadyToFinalize();
};

                content.appendChild(btn);
            });
        }

        function addOccupantRow(idx, maxOcc) {
            const container = document.getElementById('occupant-list-' + idx);
            if (container.querySelectorAll('.occupant-item').length >= maxOcc) {
                alert("Room capacity reached (" + maxOcc + " guests max)");
                return;
            }

            const row = document.createElement('div');
            row.className = 'occupant-item';
            row.innerHTML = `
                <div class="input-wrapper">
                    <input type="text" name="occName_\${idx}" class="form-control form-control-sm" placeholder="Full Name" oninput="validate(this, 'name')" required>
                    <div class="invalid-feedback">Letters only.</div>
                </div>
                <div class="input-wrapper">
                    <input type="text" name="occId_\${idx}" class="form-control form-control-sm" placeholder="ID Number (12 digits)" maxlength="12" oninput="validate(this, 'id')" required>
                    <div class="invalid-feedback">12 digits required.</div>
                </div>
                <button type="button" class="btn btn-sm text-danger border-0" onclick="this.parentElement.remove(); checkReadyToFinalize(); reValidateIDs();">
                    <i class="bi bi-x-circle-fill"></i>
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
                input.nextElementSibling.innerText = isDup ? "Duplicate ID found!" : "Must be 12 digits.";
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
                const v = i.value.trim();
                if (v === "") return;

                const isDup = vals.filter(x => x === v).length > 1;
                const ok = /^\d{12}$/.test(v) && !isDup;
                i.classList.toggle('is-valid', ok);
                i.classList.toggle('is-invalid', !ok);
            });
        }

        function updateTotalDisplay() {
            let totalExtra = 0;
            document.querySelectorAll('input[id^="upgrade_fee_"]').forEach(input => {
                totalExtra += parseFloat(input.value) || 0;
            });

            const newTotal = initialTotal + totalExtra;
            const newBalance = newTotal - depositAmount;

            document.getElementById('total-display').innerText = newTotal.toLocaleString('vi-VN') + "₫";
            document.getElementById('balance-display').innerText = newBalance.toLocaleString('vi-VN') + "₫";
        }

        function checkReadyToFinalize() {
            const assigned = Array.from(document.querySelectorAll('input[name^="roomAssign_"]')).every(i => i.value !== "");
            const guestInputs = document.querySelectorAll('.occupant-item input');
            const guestsOk = guestInputs.length > 0 && Array.from(guestInputs).every(i => i.classList.contains('is-valid'));

            const btn = document.getElementById('submitBtn');
            btn.disabled = !(assigned && guestsOk);
        }
    </script>
</body>
</html>