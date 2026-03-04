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
                        <div class="text-secondary">Create a future reservation for guest.</div>
                    </div>
                </div>

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
                                    <input type="date" class="form-control" name="checkIn"
                                           value="<fmt:formatDate value='${checkIn}' pattern='yyyy-MM-dd'/>">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Check-out date</label>
                                    <input type="date" class="form-control" name="checkOut"
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

                                <div class="col-md-4">
                                    <label class="form-label">Number of rooms</label>
                                    <select class="form-select" name="rooms">
                                        <c:forEach var="i" begin="1" end="5">
                                            <option value="${i}" ${i==rooms?'selected':''}>${i} Room</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Adults</label>
                                    <select class="form-select" name="adults">
                                        <c:forEach var="i" begin="1" end="6">
                                            <option value="${i}" ${i==adults?'selected':''}>${i} Adult</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Children</label>
                                    <select class="form-select" name="children">
                                        <c:forEach var="i" begin="0" end="6">
                                            <option value="${i}" ${i==children?'selected':''}>${i} Child</option>
                                        </c:forEach>
                                    </select>
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
                                       href="${pageContext.request.contextPath}/receptionist/booking/create
                                       ?checkIn=<fmt:formatDate value='${checkIn}' pattern='yyyy-MM-dd'/>
                                       &checkOut=<fmt:formatDate value='${checkOut}' pattern='yyyy-MM-dd'/>
                                       &rooms=${rooms}&adults=${adults}&children=${children}
                                       &roomTypeId=${c.roomTypeId}
                                       &fullName=${fn:escapeXml(param.fullName)}
                                       &phone=${fn:escapeXml(param.phone)}
                                       &email=${fn:escapeXml(param.email)}
                                       &identity=${fn:escapeXml(param.identity)}
                                       &address=${fn:escapeXml(param.address)}">
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
                            <input type="hidden" name="action" value="holdAndNext">
                            <input type="hidden" name="checkIn" value="<fmt:formatDate value='${checkIn}' pattern='yyyy-MM-dd'/>">
                            <input type="hidden" name="checkOut" value="<fmt:formatDate value='${checkOut}' pattern='yyyy-MM-dd'/>">
                            <input type="hidden" name="rooms" value="${rooms}">
                            <input type="hidden" name="adults" value="${adults}">
                            <input type="hidden" name="children" value="${children}">
                            <input type="hidden" name="roomTypeId" value="${roomTypeId}">

                            <button class="btn btn-primary btn-confirm mt-3" type="submit">
                                NEXT: CUSTOMER INFO <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                        </form>

                        <div class="hint mt-2">
                            Status will be set to <b>PENDING_DEPOSIT</b>; deposit required.
                        </div>
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

    </body>
</html>