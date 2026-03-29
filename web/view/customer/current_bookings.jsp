<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="cb-page">
    <h2 class="cb-title">Current Bookings</h2>
    <p class="cb-sub">Your upcoming stays</p>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert-success">
            ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert-error">
            ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty currentBookings}">
            <div class="empty">
                <div class="icon">&#128197;</div>
                <h3>No current bookings</h3>
                <p>You don't have any upcoming stays.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="cb-list">
                <c:forEach var="b" items="${currentBookings}">
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
                         data-total="${b.displayTotalAmount}"
                         data-amenities="${b.amenitiesText}">

                        <!-- LEFT -->
                        <div class="cb-media">
                            <div class="cb-status cb-status--${b.statusUiType}">${b.statusText}</div>

                            <c:choose>
                                <c:when test="${empty b.imageUrls}">
                                    <img class="cb-slide is-active"
                                         src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1400&q=60"
                                         alt="room image"/>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="img" items="${b.imageUrls}" varStatus="i">
                                        <img class="cb-slide ${i.first ? 'is-active' : ''}"
                                             src="${pageContext.request.contextPath}${img}"
                                             alt="room image"
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
                                    <div class="v">Up to ${b.maxAdult} Adults, ${b.maxChildren} Children</div>
                                </div>

                                <div class="cb-item">
                                    <div class="k">TOTAL</div>
                                    <div class="v">
                                        <c:choose>
                                            <c:when test="${b.displayTotalAmount != null && b.displayTotalAmount > 0}">
                                                <fmt:formatNumber value="${b.displayTotalAmount}" type="number" minFractionDigits="2"/>
                                            </c:when>
                                            <c:otherwise>TBD</c:otherwise>
                                        </c:choose>
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
                                <button type="button" class="cb-btn cb-btn-primary js-view-detail">
                                    View Details
                                </button>

                                <c:if test="${b.canCancel}">
                                    <form action="${pageContext.request.contextPath}/customer/bookings/current"
                                          method="post"
                                          class="js-cancel-form">

                                        <input type="hidden" name="bookingId" value="${b.bookingId}" />
                                        <input type="hidden" name="page" value="${currentPage}" />
                                        <input type="hidden" name="pageSize" value="${pageSize}" />

                                        <button type="button"
                                                class="cb-btn cb-btn-cancel js-open-cancel"
                                                data-booking-id="${b.bookingId}">
                                            Cancel
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty currentBookings}">
        <div class="cb-bottombar">

            <form method="get"
                  action="${pageContext.request.contextPath}/customer/bookings/current"
                  class="cb-size-form">
                <input type="hidden" name="currentPage" value="1"/>

                <label for="pageSize" class="cb-size-label">Show</label>
                <select id="pageSize"
                        name="pageSize"
                        class="cb-size-select"
                        onchange="this.form.submit()">
                    <option value="2" ${pageSize == 2 ? 'selected' : ''}>2</option>
                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                </select>
                <span class="cb-size-label">per page</span>
            </form>

            <c:if test="${totalPages > 1}">
                <div class="cb-pagination">
                    <a class="cb-page-link ${currentPage == 1 ? 'is-disabled' : ''}"
                       href="${pageContext.request.contextPath}/customer/bookings/current?currentPage=${currentPage - 1}&pageSize=${pageSize}">
                        Previous
                    </a>

                    <c:forEach var="token" items="${currentPageTokens}">
                        <c:choose>
                            <c:when test="${token == '...'}">
                                <span class="cb-page-link is-disabled">...</span>
                            </c:when>
                            <c:otherwise>
                                <a class="cb-page-link ${token == currentPage ? 'is-active' : ''}"
                                   href="${pageContext.request.contextPath}/customer/bookings/current?currentPage=${token}&pageSize=${pageSize}">
                                    ${token}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <a class="cb-page-link ${currentPage == totalPages ? 'is-disabled' : ''}"
                       href="${pageContext.request.contextPath}/customer/bookings/current?currentPage=${currentPage + 1}&pageSize=${pageSize}">
                        Next
                    </a>
                </div>
            </c:if>

        </div>
    </c:if>
</div>

<!-- Modal -->
<div class="cbm-overlay" id="cbmOverlay">
    <div class="cbm-modal" role="dialog" aria-modal="true">

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
                <div class="cbm-titleWrap">
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
                <div class="cbm-chips" id="cbmAmenities">
                    <span class="cbm-chip">&mdash;</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cancel Confirm Modal -->
<div class="cbm-overlay" id="cancelOverlay">
    <div class="cbm-modal" style="width:min(520px, calc(100vw - 40px)); height:auto; display:block; background:#fff;">
        <div class="cbm-panel" style="padding:24px;">
            <button type="button" class="cbm-x" id="cancelClose">&#10005;</button>

            <h3 style="margin:0 0 10px; font-size:24px; font-weight:800; color:#0f172a;">
                Cancel booking?
            </h3>

            <p style="margin:0 0 18px; color:#64748b; line-height:1.6;">
                Are you sure you want to cancel booking
                <strong id="cancelBookingLabel">#&mdash;</strong>?
            </p>

            <div style="display:flex; gap:12px; justify-content:flex-end;">
                <button type="button" class="cb-btn" id="cancelNoBtn">Keep booking</button>
                <button type="button" class="cb-btn cb-btn-cancel" id="cancelYesBtn">Yes, cancel</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const cancelOverlay = document.getElementById('cancelOverlay');
        const cancelClose = document.getElementById('cancelClose');
        const cancelNoBtn = document.getElementById('cancelNoBtn');
        const cancelYesBtn = document.getElementById('cancelYesBtn');
        const cancelBookingLabel = document.getElementById('cancelBookingLabel');

        let pendingCancelForm = null;

        function openCancelModal(form, bookingId) {
            pendingCancelForm = form;
            cancelBookingLabel.textContent = '#' + (bookingId || '\u2014');
            cancelOverlay.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeCancelModal() {
            cancelOverlay.classList.remove('show');
            document.body.style.overflow = '';
            pendingCancelForm = null;
        }

        document.querySelectorAll('.js-open-cancel').forEach(btn => {
            btn.addEventListener('click', function () {
                const form = this.closest('.js-cancel-form');
                const bookingId = this.dataset.bookingId;
                openCancelModal(form, bookingId);
            });
        });

        cancelClose.addEventListener('click', closeCancelModal);
        cancelNoBtn.addEventListener('click', closeCancelModal);

        cancelOverlay.addEventListener('click', function (e) {
            if (e.target === cancelOverlay) {
                closeCancelModal();
            }
        });

        cancelYesBtn.addEventListener('click', function () {
            if (pendingCancelForm) {
                pendingCancelForm.submit();
            }
        });
        const overlay = document.getElementById('cbmOverlay');
        const closeBtn = document.getElementById('cbmClose');
        const gallery = document.getElementById('cbmGallery');
        const gPrev = document.getElementById('cbmPrev');
        const gNext = document.getElementById('cbmNext');

        let gIdx = 0;
        let gImgs = [];

        function setStatusPill(text, ui) {
            const pill = document.getElementById('cbmStatusPill');
            pill.textContent = text || '\u2014';
            pill.className = 'cbm-statusPill cbm-statusPill--' + (ui || 'completed');
        }

        function setAmenities(raw) {
            const wrap = document.getElementById('cbmAmenities');
            wrap.innerHTML = '';

            if (!raw || !raw.trim()) {
                wrap.innerHTML = '<span class="cbm-chip">&mdash;</span>';
                return;
            }

            raw.split(',').map(s => s.trim()).filter(Boolean).forEach(t => {
                const chip = document.createElement('span');
                chip.className = 'cbm-chip';
                chip.textContent = t;
                wrap.appendChild(chip);
            });
        }

        function renderModalGallery() {

            const imgs = gallery.querySelectorAll('img');

            // If the gallery is empty, create the slides once.
            if (imgs.length === 0) {
                gImgs.forEach((src, i) => {
                    const img = document.createElement('img');
                    img.src = src;
                    if (i === 0)
                        img.classList.add('is-active');
                    img.onerror = function () {
                        this.src = 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1400&q=60';
                    };
                    gallery.appendChild(img);
                });
            }

            // Then just toggle the active class.
            gallery.querySelectorAll('img').forEach((img, i) => {
                img.classList.toggle('is-active', i === gIdx);
            });

            const multi = gImgs.length > 1;
            gPrev.style.display = multi ? 'flex' : 'none';
            gNext.style.display = multi ? 'flex' : 'none';
        }

        function openDetail(card) {
            gallery.querySelectorAll('img').forEach(x => x.remove());
            document.getElementById('cbmRooms').textContent = card.dataset.rooms || '\u2014';
            document.getElementById('cbmRoom').textContent = card.dataset.room || '\u2014';
            document.getElementById('cbmMeta').textContent = card.dataset.roomMeta || '\u2014';
            document.getElementById('cbmId').textContent = '#' + (card.dataset.bookingId || '\u2014');
            document.getElementById('cbmCheckin').textContent = card.dataset.checkin || '\u2014';
            document.getElementById('cbmCheckout').textContent = card.dataset.checkout || '\u2014';
            document.getElementById('cbmOcc').textContent = card.dataset.occupancy || '\u2014';

            const totalNum = Number(card.dataset.total);
            document.getElementById('cbmTotal').textContent =
                    (!isNaN(totalNum) && totalNum > 0)
                    ? new Intl.NumberFormat('vi-VN', {minimumFractionDigits: 2}).format(totalNum)
                    : 'TBD';

            setStatusPill(card.dataset.statusText, card.dataset.statusUi);
            setAmenities(card.dataset.amenities);

            // Reuse the image sources already rendered in the card.
            gImgs = Array.from(card.querySelectorAll('.cb-slide'))
                    .map(img => img.getAttribute('src'));

            gIdx = 0;
            renderModalGallery();

            overlay.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeDetail() {
            overlay.classList.remove('show');
            document.body.style.overflow = '';
        }

        document.querySelectorAll('.js-view-detail').forEach(btn => {
            btn.addEventListener('click', e => {
                const card = e.target.closest('.cb-card');
                openDetail(card);
            });
        });

        gPrev.addEventListener('click', () => {
            gIdx = (gIdx - 1 + gImgs.length) % gImgs.length;
            renderModalGallery();
        });

        gNext.addEventListener('click', () => {
            gIdx = (gIdx + 1) % gImgs.length;
            renderModalGallery();
        });

        closeBtn.addEventListener('click', closeDetail);
        overlay.addEventListener('click', e => {
            if (e.target === overlay)
                closeDetail();
        });

    });
</script>


