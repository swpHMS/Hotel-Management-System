<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create Booking</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist/create-booking.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

        <style>
            .qty-box{
                display:flex;
                align-items:center;
                border:1px solid #ddd;
                border-radius:8px;
                overflow:hidden;
                width:140px;
            }

            .qty-box button{
                width:40px;
                height:40px;
                border:none;
                background:#f5f5f5;
                font-size:20px;
                cursor:pointer;
            }

            .qty-box button:hover{
                background:#eaeaea;
            }

            .qty-box input{
                width:60px;
                text-align:center;
                border:none;
                outline:none;
            }
        </style>

    </head>

    <body>
        <div class="d-flex">
            <% request.setAttribute("active", "create_booking"); %>
            <jsp:include page="sidebar.jsp"/>

            <main class="hms-main">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <a class="btn btn-light border" href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <div>
                        <div class="fw-bold fs-4">CREATE BOOKING</div>
                    </div>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert alert-danger">
                        <ul class="mb-0">
                            <c:forEach var="e" items="${errors}">
                                <li>${e}</li>
                                </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <div class="cb-wrap">

                    <!-- LEFT COLUMN -->
                    <div class="d-flex flex-column gap-3">

                        <!-- (1) STAY DETAILS - GET (Update availability) -->
                        <form method="get"
                              action="${pageContext.request.contextPath}/receptionist/booking/create"
                              class="card-soft p-4">

                            <div class="section-title mb-3">
                                <i class="bi bi-calendar2-week me-2 text-primary"></i>STAY DETAILS
                            </div>

                            <!-- giữ lại customer info khi bấm Update availability -->
                            <input type="hidden" name="fullName" value="${fn:escapeXml(param.fullName)}">
                            <input type="hidden" name="phone" value="${fn:escapeXml(param.phone)}">
                            <input type="hidden" name="email" value="${fn:escapeXml(param.email)}">
                            <input type="hidden" name="identity" value="${fn:escapeXml(param.identity)}">
                            <input type="hidden" name="address" value="${fn:escapeXml(param.address)}">

                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label">Check-in date</label>
                                    <input type="date" class="form-control" name="checkIn" id="checkInDate"
                                           value="<fmt:formatDate value='${checkIn}' pattern='yyyy-MM-dd'/>"
                                           min="${minCheckInDate}">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Check-out date</label>
                                    <input type="date" class="form-control" name="checkOut" id="checkOutDate"
                                           value="<fmt:formatDate value='${checkOut}' pattern='yyyy-MM-dd'/>">
                                </div>


                                <!-- Room Type (dropdown) -->
                                <div class="col-md-4">
                                    <label class="form-label">Room type</label>
                                    <select class="form-select" name="roomTypeId" id="roomTypeSelect">
                                        <c:forEach var="c" items="${cards}">
                                            <option value="${c.roomTypeId}" ${c.roomTypeId == roomTypeId ? 'selected' : ''}>
                                                ${c.roomTypeName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="row g-3">

                                    <div class="col-md-4">
                                        <label for="rooms" class="form-label fw-semibold">Number of rooms</label>
                                        <input type="number" class="form-control" id="rooms" name="rooms" min="1" max="50" step="1" value="${rooms != null ? rooms : 1}" required>
                                    </div>

                                    <div class="col-md-4">
                                        <label for="adults" class="form-label fw-semibold">Adults</label>
                                        <input type="number" class="form-control" id="adults" name="adults" min="1" max="10" step="1" value="${adults != null ? adults : 1}" required>
                                    </div>

                                    <div class="col-md-4">
                                        <label for="children" class="form-label fw-semibold">Children</label>
                                        <input type="number" class="form-control" id="children" name="children" min="0" max="10" step="1" value="${children != null ? children : 0}" required>
                                    </div>

                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-3">
                                <button class="btn btn-primary px-4 fw-bold" type="submit">
                                    <i class="bi bi-arrow-repeat me-1"></i> Update availability
                                </button>
                            </div>
                        </form>

                        <!-- (2) SELECT ROOM TYPE -->
                        <div class="card-soft p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="section-title">SELECT ROOM TYPE</div>
                                <div class="hint">Availability updated based on dates</div>
                            </div>

                            <div class="rt-grid">
                                <c:forEach var="c" items="${cards}">
                                    <a class="rt-card ${c.roomTypeId == roomTypeId ? 'active' : ''}"
                                       data-room-id="${c.roomTypeId}"
                                       href="${pageContext.request.contextPath}/receptionist/booking/create?checkIn=<fmt:formatDate value='${checkIn}' pattern='yyyy-MM-dd'/>&checkOut=<fmt:formatDate value='${checkOut}' pattern='yyyy-MM-dd'/>&rooms=${rooms}&adults=${adults}&children=${children}&roomTypeId=${c.roomTypeId}&fullName=${fn:escapeXml(param.fullName)}&phone=${fn:escapeXml(param.phone)}&email=${fn:escapeXml(param.email)}&identity=${fn:escapeXml(param.identity)}&address=${fn:escapeXml(param.address)}">
                                        <!--
                                        <c:choose>
                                            <c:when test="${c.uiStatus=='ok'}">
                                                <div class="rt-badge b-ok">AVAILABLE</div>
                                            </c:when>
                                            <c:when test="${c.uiStatus=='limited'}">
                                                <div class="rt-badge b-limited">LIMITED</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rt-badge b-soldout">SOLD OUT</div>
                                            </c:otherwise>
                                        </c:choose>
                                        -->
                                        <div class="rt-name">${c.roomTypeName}</div>
                                        <div class="rt-price mt-2">
                                            <fmt:formatNumber value="${c.ratePerNight}" type="number"/> đ
                                        </div>
                                        <div class="text-secondary small mt-2">
                                            Available: <b>${c.availableRooms}</b> rooms
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>



                    </div>

                    <!-- RIGHT SUMMARY + POST CONFIRM -->
                    <div class="summary">
                        <div class="section-title mb-2">Reservation Summary</div>

                        <div class="sum-row">
                            <div class="sum-k">Duration</div>
                            <div class="sum-v">${nights} night</div>
                        </div>

                        <div class="sum-row">
                            <div class="sum-k">Quantity</div>
                            <div class="sum-v">${rooms} room</div>
                        </div>

                        <div class="sum-row">
                            <div class="sum-k">Room Type</div>
                            <div class="sum-v">${roomTypeName}</div>
                        </div>

                        <div class="sum-row">
                            <div class="sum-k">Rate</div>
                            <div class="sum-v"><fmt:formatNumber value="${rate}" type="number"/> đ / night</div>
                        </div>

                        <div class="mt-3 p-2 rounded-3"
                             style="border:1px solid rgba(251,191,36,.35);background:rgba(251,191,36,.08);">
                            <div class="small fw-bold" style="color:#fbbf24;">
                                <i class="bi bi-exclamation-triangle me-1"></i>Room availability status
                            </div>
                            <div class="small" style="color:#e2e8f0;">
                                Available rooms for selected type: <b>${availableRooms}</b>
                            </div>
                        </div>

                        <hr style="border-color:rgba(148,163,184,.18);" class="my-3">

                        <div class="d-flex justify-content-between align-items-end">
                            <div class="sum-k">Total Estimated</div>
                            <div class="sum-total"><fmt:formatNumber value="${total}" type="number"/> đ</div>
                        </div>

                        <!-- POST confirm: gửi đủ data -->
                        <form method="post" action="${pageContext.request.contextPath}/receptionist/booking/create" class="mt-3">
                            <input type="hidden" name="checkIn"
                                   value="<fmt:formatDate value='${checkIn}' pattern='yyyy-MM-dd'/>">                           
                            <input type="hidden" name="checkOut"
                                   value="<fmt:formatDate value='${checkOut}' pattern='yyyy-MM-dd'/>">
                            <input type="hidden" name="rooms" value="${rooms}">
                            <input type="hidden" name="adults" value="${adults}">
                            <input type="hidden" name="children" value="${children}">
                            <input type="hidden" name="roomTypeId" value="${roomTypeId}">

                            <button class="btn btn-primary btn-confirm mt-3" type="submit">
                                NEXT: CUSTOMER INFO <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                        </form>


                        <!-- <div class="hint mt-2">
                            Status will be set to <b>PENDING_DEPOSIT</b>; deposit required.
                        </div>
                        -->
                    </div>

                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- ✅ Sync dropdown RoomType ↔ cards -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const dropdown = document.getElementById("roomTypeSelect");
                const cards = document.querySelectorAll(".rt-card");

                if (!dropdown || !cards.length)
                    return;

                function setActiveCard(roomTypeId) {
                    cards.forEach(card => {
                        const isMatch = card.dataset.roomId === String(roomTypeId);
                        card.classList.toggle("active", isMatch);
                    });
                }

                // 1) Dropdown change -> active card
                dropdown.addEventListener("change", function () {
                    setActiveCard(this.value);
                    // (tuỳ chọn) scroll nhẹ xuống card đang chọn
                    const target = document.querySelector('.rt-card[data-room-id="' + this.value + '"]');
                    if (target)
                        target.scrollIntoView({behavior: "smooth", block: "center"});
                });

                // 2) Click card -> dropdown selected (bonus)
                cards.forEach(card => {
                    card.addEventListener("click", function () {
                        const id = this.dataset.roomId;
                        dropdown.value = id;
                        setActiveCard(id);
                    });
                });

                // init (khi load trang)
                setActiveCard(dropdown.value);
            });
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const checkInInput = document.getElementById("checkInDate");
                const checkOutInput = document.getElementById("checkOutDate");

                if (!checkInInput || !checkOutInput)
                    return;

                const minCheckInDate = "${minCheckInDate}";

                // luôn chặn chọn ngày check-in trong quá khứ
                checkInInput.min = minCheckInDate;

                function formatDate(date) {
                    return date.toISOString().split("T")[0];
                }

                function updateCheckOutMin() {
                    if (!checkInInput.value)
                        return;

                    const checkInDate = new Date(checkInInput.value);
                    checkInDate.setDate(checkInDate.getDate() + 1);

                    const minCheckOut = formatDate(checkInDate);
                    checkOutInput.min = minCheckOut;

                    if (!checkOutInput.value || checkOutInput.value < minCheckOut) {
                        checkOutInput.value = minCheckOut;
                    }
                }

                // chạy ngay khi load trang
                updateCheckOutMin();

                // khi đổi check-in
                checkInInput.addEventListener("change", function () {
                    if (checkInInput.value < minCheckInDate) {
                        alert("Ngày check-in không hợp lệ theo quy định khách sạn!");
                        checkInInput.value = minCheckInDate;
                    }

                    updateCheckOutMin();
                });

                // khi đổi check-out
                checkOutInput.addEventListener("change", function () {
                    if (checkOutInput.value <= checkInInput.value) {
                        alert("Ngày Check-out phải lớn hơn ngày Check-in!");
                        updateCheckOutMin();
                    }
                });

                // chặn submit nếu user cố nhập sai
                document.querySelectorAll("form").forEach(form => {
                    form.addEventListener("submit", function (e) {
                        if (checkInInput.value < minCheckInDate) {
                            e.preventDefault();
                            alert("Không được chọn ngày Check-in trong quá khứ!");
                            checkInInput.focus();
                            return;
                        }

                        if (checkOutInput.value <= checkInInput.value) {
                            e.preventDefault();
                            alert("Ngày Check-out phải lớn hơn ngày Check-in!");
                            checkOutInput.focus();
                        }
                    });
                });
            });
        </script>

        <script>

            function changeQty(id, delta) {

                const input = document.getElementById(id)

                let value = parseInt(input.value) || 0

                const min = parseInt(input.min)
                const max = parseInt(input.max)

                value += delta

                if (value < min)
                    value = min
                if (value > max)
                    value = max

                input.value = value
            }

        </script>

    </body>
</html>