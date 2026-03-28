<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="cb-page">
    <h2 class="cb-title">Past Stays</h2>
    <p class="cb-sub">Your stay history</p>

    <c:choose>
        <c:when test="${empty pastStays}">
            <div class="empty">
                <div class="icon">&#127970;</div>
                <h3>No past stays</h3>
                <p>You haven't completed any stays yet.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="cb-list">
                <c:forEach var="b" items="${pastStays}">

                    <div class="cb-card"
                         data-rooms="${b.roomQuantityText}"
                         data-booking-id="${b.bookingId}"
                         data-status-text="${b.statusText}"
                         data-status-ui="${b.statusUiType}"
                         data-room="${b.roomTypeName}"
                         data-room-meta="${b.roomMeta}"
                         data-checkin="<fmt:formatDate value='${b.checkInDate}' pattern='dd/MM/yyyy'/>"
                         data-checkout="<fmt:formatDate value='${b.checkOutDate}' pattern='dd/MM/yyyy'/>"
                         data-occupancy="Up to ${b.maxAdult} Adults, ${b.maxChildren} Children"
                         data-total="${b.totalAmount}"
                         data-amenities="${b.amenitiesText}">

                        <!-- LEFT -->
                        <div class="cb-media">

                            <div class="cb-status cb-status--${b.statusUiType}">
                                ${b.statusText}
                            </div>

                            <c:choose>
                                <c:when test="${empty b.imageUrls}">
                                    <img class="cb-slide is-active"
                                         src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1400&q=60"/>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="img" items="${b.imageUrls}" varStatus="i">
                                        <img class="cb-slide ${i.first ? 'is-active' : ''}"
                                             src="${pageContext.request.contextPath}${img}"
                                             onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1400&q=60';"/>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>

                        </div>

                        <!-- RIGHT -->
                        <div class="cb-body">

                            <div class="cb-dates">
                                CHECK-IN:
                                <fmt:formatDate value="${b.checkInDate}" pattern="dd/MM/yyyy"/>
                                -
                                <fmt:formatDate value="${b.checkOutDate}" pattern="dd/MM/yyyy"/>
                            </div>

                            <h3 class="cb-room">${b.roomTypeName}</h3>
                            <div class="cb-meta">${b.roomMeta}</div>

                            <div class="cb-divider"></div>

                            <div class="cb-kpi">
                                <div class="cb-item">
                                    <div class="k">OCCUPANCY</div>
                                    <div class="v">
                                        Up to ${b.maxAdult} Adults, ${b.maxChildren} Children
                                    </div>
                                </div>

                                <div class="cb-item">
                                    <div class="k">TOTAL</div>
                                    <div class="v">
                                        <fmt:formatNumber value="${b.totalAmount}"
                                                          type="number"
                                                          minFractionDigits="2"/>
                                    </div>
                                </div>

                                <div class="cb-item">
                                    <div class="k">BOOKING ID</div>
                                    <div class="v">#${b.bookingId}</div>
                                </div>

                                <div class="cb-item">
                                    <div class="k">ROOMS</div>
                                    <div class="v">${b.roomQuantityText}</div>
                                </div>
                            </div>

                            <div class="cb-actions">
                                <button type="button"
                                        class="cb-btn cb-btn-primary js-view-detail">
                                    View Details
                                </button>

                                <form action="${pageContext.request.contextPath}/booking"
                                      method="get">
                                    <input type="hidden"
                                           name="roomTypeId"
                                           value="${b.roomTypeId}" />
                                    <input type="hidden"
                                           name="roomQty"
                                           value="${b.quantity}" />

                                    <button type="submit"
                                            class="cb-btn">
                                        Book Again
                                    </button>
                                </form>
                            </div>

                        </div>

                    </div>

                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty pastStays}">
        <div class="cb-bottombar">

            <form method="get"
                  action="${pageContext.request.contextPath}/customer/bookings/past"
                  class="cb-size-form">
                <input type="hidden" name="pastPage" value="1"/>

                <label class="cb-size-label">Show</label>

                <select name="pageSize"
                        class="cb-size-select"
                        onchange="this.form.submit()">

                    <option value="2" ${pageSize == 2 ? 'selected' : ''}>2</option>
                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>

                </select>

                <span class="cb-size-label">per page</span>
            </form>

            <c:if test="${pastTotalPages > 1}">
                <div class="cb-pagination">

                    <a class="cb-page-link ${pastCurrentPage == 1 ? 'is-disabled' : ''}"
                       href="${pageContext.request.contextPath}/customer/bookings/past?pastPage=${pastCurrentPage - 1}&pageSize=${pageSize}">
                        Previous
                    </a>

                    <c:forEach var="token" items="${pastPageTokens}">
                        <c:choose>
                            <c:when test="${token == '...'}">
                                <span class="cb-page-link is-disabled">...</span>
                            </c:when>
                            <c:otherwise>
                                <a class="cb-page-link ${token == pastCurrentPage ? 'is-active' : ''}"
                                   href="${pageContext.request.contextPath}/customer/bookings/past?pastPage=${token}&pageSize=${pageSize}">
                                    ${token}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <a class="cb-page-link ${pastCurrentPage == pastTotalPages ? 'is-disabled' : ''}"
                       href="${pageContext.request.contextPath}/customer/bookings/past?pastPage=${pastCurrentPage + 1}&pageSize=${pageSize}">
                        Next
                    </a>

                </div>
            </c:if>

        </div>
    </c:if>
</div>

<!-- Modal (same as current) -->
<div class="cbm-overlay" id="cbmOverlay">
    <div class="cbm-modal" role="dialog">

        <div class="cbm-gallery" id="cbmGallery">
            <button type="button" class="cb-nav cb-prev" id="cbmPrev">&#8249;</button>
            <button type="button" class="cb-nav cb-next" id="cbmNext">&#8250;</button>
        </div>

        <div class="cbm-panel">

            <button type="button" class="cbm-x" id="cbmClose">&#10005;</button>

            <div class="cbm-statusWrap">
                <span class="cbm-statusPill" id="cbmStatusPill">&mdash;</span>
            </div>

            <div class="cbm-head">
                <div>
                    <h2 class="cbm-room" id="cbmRoom">&mdash;</h2>
                    <div class="cbm-meta" id="cbmMeta">&mdash;</div>
                </div>
            </div>

            <div class="cbm-line"></div>

            <div class="cbm-grid">
                <div class="cbm-box">
                    <div class="cbm-k">BOOKING ID</div>
                    <div class="cbm-v" id="cbmId">&mdash;</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">OCCUPANCY</div>
                    <div class="cbm-v" id="cbmOcc">&mdash;</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">CHECK-IN</div>
                    <div class="cbm-v" id="cbmCheckin">&mdash;</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">CHECK-OUT</div>
                    <div class="cbm-v" id="cbmCheckout">&mdash;</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">ROOMS</div>
                    <div class="cbm-v" id="cbmRooms">&mdash;</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">TOTAL</div>
                    <div class="cbm-v" id="cbmTotal">&mdash;</div>
                </div>
            </div>

            <div class="cbm-amenities">
                <div class="cbm-amenTitle">AMENITIES</div>
                <div class="cbm-chips" id="cbmAmenities"></div>
            </div>

        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const overlay = document.getElementById('cbmOverlay');
        const closeBtn = document.getElementById('cbmClose');
        const gallery = document.getElementById('cbmGallery');
        const gPrev = document.getElementById('cbmPrev');
        const gNext = document.getElementById('cbmNext');

        let gIdx = 0;
        let gImgs = [];

        function renderGallery() {
            gallery.querySelectorAll("img").forEach(x => x.remove());

            gImgs.forEach((src, i) => {
                const img = document.createElement("img");
                img.src = src;
                if (i === gIdx)
                    img.classList.add("is-active");
                gallery.appendChild(img);
            });

            const multi = gImgs.length > 1;
            gPrev.style.display = multi ? "flex" : "none";
            gNext.style.display = multi ? "flex" : "none";
        }

        function openDetail(card) {

            document.getElementById("cbmRoom").textContent = card.dataset.room;
            document.getElementById("cbmMeta").textContent = card.dataset.roomMeta;
            document.getElementById("cbmId").textContent = "#" + card.dataset.bookingId;
            document.getElementById("cbmCheckin").textContent = card.dataset.checkin;
            document.getElementById("cbmCheckout").textContent = card.dataset.checkout;
            document.getElementById("cbmOcc").textContent = card.dataset.occupancy;
            document.getElementById("cbmRooms").textContent = card.dataset.rooms || "\u2014";
            const total = Number(card.dataset.total);
            document.getElementById("cbmTotal").textContent =
                    new Intl.NumberFormat('vi-VN', {minimumFractionDigits: 2}).format(total);

            const pill = document.getElementById("cbmStatusPill");
            pill.textContent = card.dataset.statusText;
            pill.className = "cbm-statusPill cbm-statusPill--" + card.dataset.statusUi;

            const amenWrap = document.getElementById("cbmAmenities");
            amenWrap.innerHTML = "";
            (card.dataset.amenities || "").split(",").forEach(a => {
                if (a.trim()) {
                    const chip = document.createElement("span");
                    chip.className = "cbm-chip";
                    chip.textContent = a.trim();
                    amenWrap.appendChild(chip);
                }
            });

            gImgs = Array.from(card.querySelectorAll(".cb-slide"))
                    .map(img => img.getAttribute("src"));

            gIdx = 0;
            renderGallery();

            overlay.classList.add("show");
            document.body.style.overflow = "hidden";
        }

        function closeDetail() {
            overlay.classList.remove("show");
            document.body.style.overflow = "";
        }

        document.querySelectorAll(".js-view-detail").forEach(btn => {
            btn.addEventListener("click", e => {
                const card = e.target.closest(".cb-card");
                openDetail(card);
            });
        });

        gPrev.addEventListener("click", () => {
            gIdx = (gIdx - 1 + gImgs.length) % gImgs.length;
            renderGallery();
        });

        gNext.addEventListener("click", () => {
            gIdx = (gIdx + 1) % gImgs.length;
            renderGallery();
        });

        closeBtn.addEventListener("click", closeDetail);
        overlay.addEventListener("click", e => {
            if (e.target === overlay)
                closeDetail();
        });

    });
</script>


