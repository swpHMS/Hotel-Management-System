<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* =========================
       CURRENT BOOKINGS (cb-*)
       FINAL - compact, dashboard-aligned
       ========================= */

    .cb-page{
        width:100%;
        max-width:1100px;
        margin:0 auto;
    }

    .cb-title{
        margin:0;
        font-size:26px;
        font-weight:700;
        letter-spacing:-.2px;
        color:#0f172a;
    }
    .cb-sub{
        margin:6px 0 14px;
        font-size:13px;
        color:#94a3b8;
        font-weight:500;
    }

    .cb-list{
        display:flex;
        flex-direction:column;
        gap:14px;
    }

    .cb-card{
        background:#fff;
        border:1px solid #e9eef5;
        border-radius:14px;
        box-shadow:0 6px 18px rgba(15,23,42,.06);
        overflow:hidden;
        display:grid;
        grid-template-columns: 300px 1fr;
        min-height:180px;
    }

    /* LEFT */
    .cb-media{
        position:relative;
        background:#f1f5f9;
        overflow:hidden;
        border-top-left-radius:14px;
        border-bottom-left-radius:14px;
    }

    .cb-slide{
        width:100%;
        height:100%;
        min-height:180px;
        object-fit:cover;
        display:none;
        transform:scale(1);
        transition:transform .35s ease;
    }
    .cb-slide.is-active{
        display:block;
    }
    .cb-media:hover .cb-slide.is-active{
        transform:scale(1.04);
    }

    .cb-status{
        position:absolute;
        top:12px;
        left:12px;
        padding:6px 10px;
        border-radius:999px;
        font-size:10px;
        font-weight:800;
        letter-spacing:.06em;
        text-transform:uppercase;
        user-select:none;
        box-shadow:0 10px 22px rgba(0,0,0,.14);
        border:1px solid rgba(15,23,42,.10);
        backdrop-filter: blur(6px);
    }
    .cb-status--confirmed{
        background:rgba(236,253,243,.92);
        color:#027a48;
    }
    .cb-status--pending{
        background:rgba(255,243,219,.92);
        color:#8a5a08;
    }
    .cb-status--cancelled{
        background:rgba(255,241,242,.92);
        color:#b42318;
    }
    .cb-status--completed{
        background:rgba(241,245,249,.92);
        color:#475569;
    }

    .cb-nav{
        position:absolute;
        top:50%;
        transform:translateY(-50%);
        width:34px;
        height:34px;
        border-radius:999px;
        border:1px solid rgba(255,255,255,.55);
        background:rgba(2,6,23,.40);
        color:#fff;
        display:flex;
        align-items:center;
        justify-content:center;
        cursor:pointer;
        user-select:none;
        transition:all .15s ease;
    }
    .cb-nav:hover{
        background:rgba(2,6,23,.60);
    }
    .cb-prev{
        left:10px;
    }
    .cb-next{
        right:10px;
    }
    .cb-nav[disabled]{
        opacity:.35;
        cursor:not-allowed;
    }

    /* RIGHT (center text vertically) */
    .cb-body{
        padding:14px 16px;
        display:flex;
        flex-direction:column;
        justify-content:center;  /* ✅ căn giữa theo chiều dọc */
        gap:10px;
    }

    .cb-dates{
        font-size:11px;
        font-weight:700;
        letter-spacing:.12em;
        text-transform:uppercase;
        color:#b08a3c;
        line-height:1.35;
        margin:0;
    }

    .cb-room{
        margin:0;
        font-size:30px;
        font-weight:800;
        letter-spacing:-.4px;
        color:#0f172a;
        line-height:1.15;
    }

    .cb-meta{
        margin:0;
        font-size:14px;
        color:#64748b;
        font-weight:500;
        line-height:1.45;
    }

    .cb-divider{
        height:1px;
        background:#e9eef5;
    }

    .cb-kpi{
        display:grid;
        grid-template-columns: 1fr 1fr;
        gap:12px 18px;
    }

    .cb-item .k{
        font-size:12px;
        color:#94a3b8;
        font-weight:800;
        letter-spacing:.14em;
        text-transform:uppercase;
        margin-bottom:6px;
    }
    .cb-item .v{
        font-size:16px;
        color:#0f172a;
        font-weight:700;
        line-height:1.25;
        word-break:break-word;
    }

    .cb-actions{
        display:flex;
        gap:12px;
        margin-top:6px;
    }

    /* ✅ buttons: no rounded */
    .cb-btn{
        appearance:none;
        border-radius:0;              /* ✅ bỏ bo góc */
        padding:12px 18px;
        font-weight:800;
        letter-spacing:.10em;
        text-transform:uppercase;
        font-size:12px;
        cursor:pointer;
        min-width:210px;
        border:1px solid #e5eaf2;
        background:#fff;
        color:#475569;
        transition:filter .12s ease, background .12s ease, border-color .12s ease;
    }

    .cb-btn-primary{
        background:#0a1b2a;
        color:#fff;
        border-color:#0a1b2a;
    }
    .cb-btn-primary:hover{
        filter:brightness(1.05);
    }

    .cb-btn-cancel{
        background:#fff;
        color:#b42318;
        border-color: rgba(180,35,24,.28);
    }
    .cb-btn-cancel:hover{
        background:#fff1f2;
        border-color: rgba(180,35,24,.40);
    }

    /* ===== Modal (cbm-*) - smaller ===== */
    .cbm-overlay{
        position:fixed;
        inset:0;
        background:rgba(2,6,23,.55);
        backdrop-filter: blur(6px);
        display:none;
        z-index:9999;
    }
    .cbm-overlay.show{
        display:block;
    }

    .cbm-modal{
        position:absolute;
        left:50%;
        top:50%;
        transform:translate(-50%,-50%);
        width:min(980px, calc(100vw - 60px));   /* ✅ nhỏ lại */
        height:min(560px, calc(100vh - 60px));  /* ✅ nhỏ lại */
        border-radius:18px;
        overflow:hidden;
        box-shadow:0 30px 70px rgba(0,0,0,.45);
        display:grid;
        grid-template-columns: 1.1fr .9fr;
        background:#0b1c2b;
    }

    .cbm-gallery{
        position:relative;
    }
    .cbm-gallery img{
        width:100%;
        height:100%;
        object-fit:cover;
        display:none;
    }
    .cbm-gallery img.is-active{
        display:block;
    }

    .cbm-panel{
        background:#fff;
        padding:18px 18px 16px;
        overflow:auto;
        position:relative;
    }

    .cbm-x{
        position:absolute;
        right:12px;
        top:12px;
        width:42px;
        height:42px;
        border-radius:0; /* ✅ đồng bộ yêu cầu bỏ bo góc */
        background:#fff;
        border:1px solid rgba(15,23,42,.12);
        cursor:pointer;
        font-size:18px;
        font-weight:900;
        z-index:2;
    }

    .cbm-head{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:12px;
        margin-bottom:10px;
    }

    .cbm-room{
        margin:0;
        font-size:30px;
        font-weight:800;
        letter-spacing:-.5px;
        color:#0f172a;
        line-height:1.12;
    }

    .cbm-meta{
        margin:8px 0 0;
        color:#64748b;
        font-size:14px;
        line-height:1.55;
        font-weight:500;
    }

    .cbm-statusPill{
        display:inline-flex;
        align-items:center;
        padding:7px 10px;
        border-radius:999px;
        font-size:11px;
        font-weight:800;
        letter-spacing:.08em;
        text-transform:uppercase;
        border:1px solid rgba(15,23,42,.10);
        background:#f1f5f9;
        color:#475569;
        white-space:nowrap;
        flex:0 0 auto;
    }
    .cbm-statusPill--confirmed{
        background:#ecfdf3;
        color:#027a48;
        border-color:rgba(2,122,72,.16);
    }
    .cbm-statusPill--pending{
        background:#fff3db;
        color:#8a5a08;
        border-color:rgba(138,90,8,.18);
    }
    .cbm-statusPill--cancelled{
        background:#fff1f2;
        color:#b42318;
        border-color:rgba(180,35,24,.18);
    }
    .cbm-statusPill--completed{
        background:#f1f5f9;
        color:#475569;
        border-color:rgba(71,85,105,.16);
    }

    .cbm-line{
        height:1px;
        background:#e9eef5;
        margin:12px 0;
    }

    .cbm-grid{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:10px 12px;
    }
    .cbm-box{
        border:1px solid #eef2f7;
        background:#f8fafc;
        border-radius:12px;
        padding:10px 10px;
        min-width:0;
    }
    .cbm-k{
        color:#94a3b8;
        font-weight:800;
        letter-spacing:.14em;
        text-transform:uppercase;
        font-size:10px;
        margin-bottom:6px;
    }
    /* ✅ value NOT bold */
    .cbm-v{
        color:#0f172a;
        font-weight:500;       /* ✅ bỏ đậm */
        font-size:14px;
        line-height:1.25;
        word-break:break-word;
    }

    .cbm-amenities{
        margin-top:12px;
    }
    .cbm-amenTitle{
        font-size:10px;
        color:#94a3b8;
        font-weight:800;
        letter-spacing:.14em;
        text-transform:uppercase;
        margin-bottom:8px;
    }
    .cbm-chips{
        display:flex;
        flex-wrap:wrap;
        gap:8px;
    }
    .cbm-chip{
        display:inline-flex;
        align-items:center;
        padding:7px 10px;
        border-radius:999px;
        background:#fff;
        border:1px solid #eef2f7;
        font-size:12px;
        font-weight:500;   /* ✅ bỏ đậm */
        color:#334155;
    }

    @media (max-width: 980px){
        .cb-card{
            grid-template-columns:1fr;
        }
        .cb-slide{
            min-height:220px;
        }
        .cb-actions{
            justify-content:stretch;
        }
        .cb-btn{
            flex:1;
            min-width:0;
        }
        .cbm-modal{
            grid-template-columns:1fr;
            height:min(680px, calc(100vh - 60px));
        }

    }
    .cb-status--no-show{
        background:rgba(254,243,199,.92);
        color:#92400e;
    }
    .cbm-statusPill--no-show{
        background:#fef3c7;
        color:#92400e;
        border-color:rgba(146,64,14,.18);
    }
    .cb-status--inhouse{
        background:rgba(219,234,254,.92);
        color:#1d4ed8;
    }
    .alert-error{
        background:#fff1f2;
        color:#b42318;
        padding:12px 16px;
        border:1px solid rgba(180,35,24,.25);
        margin-bottom:16px;
    }
    .cbm-statusWrap{
        margin-bottom:12px;
    }
</style>

<div class="cb-page">
    <h2 class="cb-title">Current Bookings</h2>
    <p class="cb-sub">Your upcoming stays</p>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert-error">
            ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:choose>
        <c:when test="${empty currentBookings}">
            <div class="empty">
                <div class="icon">📅</div>
                <h3>No current bookings</h3>
                <p>You don't have any upcoming stays.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="cb-list">
                <c:forEach var="b" items="${currentBookings}">
                    <div class="cb-card"
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
                                            <c:when test="${b.totalAmount != null && b.totalAmount > 0}">
                                                <fmt:formatNumber value="${b.totalAmount}" type="number" minFractionDigits="2"/>
                                            </c:when>
                                            <c:otherwise>TBD</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="cb-item">
                                    <div class="k">BOOKING ID</div>
                                    <div class="v">#${b.bookingId}</div>
                                </div>
                            </div>

                            <div class="cb-actions">
                                <button type="button" class="cb-btn cb-btn-primary js-view-detail">
                                    View Details
                                </button>

                                <c:if test="${b.canCancel}">
                                    <form action="${pageContext.request.contextPath}/current_bookings"
                                          method="post"
                                          class="js-cancel-form">

                                        <input type="hidden"
                                               name="bookingId"
                                               value="${b.bookingId}" />

                                        <button type="submit"
                                                class="cb-btn cb-btn-cancel">
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
</div>

<!-- Modal -->
<div class="cbm-overlay" id="cbmOverlay">
    <div class="cbm-modal" role="dialog" aria-modal="true">

        <div class="cbm-gallery" id="cbmGallery">
            <button type="button" class="cb-nav cb-prev" id="cbmPrev">‹</button>
            <button type="button" class="cb-nav cb-next" id="cbmNext">›</button>
        </div>

        <div class="cbm-panel">

            <button type="button" class="cbm-x" id="cbmClose">✕</button>

            <!-- ✅ STATUS RIÊNG -->
            <div class="cbm-statusWrap">
                <span class="cbm-statusPill" id="cbmStatusPill">—</span>
            </div>

            <div class="cbm-head">
                <div class="cbm-titleWrap">
                    <h2 class="cbm-room" id="cbmRoom">—</h2>
                    <div class="cbm-meta" id="cbmMeta">—</div>
                </div>
            </div>

            <div class="cbm-line"></div>

            <div class="cbm-grid">
                <div class="cbm-box">
                    <div class="cbm-k">BOOKING ID</div>
                    <div class="cbm-v" id="cbmId">—</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">OCCUPANCY</div>
                    <div class="cbm-v" id="cbmOcc">—</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">CHECK-IN</div>
                    <div class="cbm-v" id="cbmCheckin">—</div>
                </div>
                <div class="cbm-box">
                    <div class="cbm-k">CHECK-OUT</div>
                    <div class="cbm-v" id="cbmCheckout">—</div>
                </div>
                <div class="cbm-box" style="grid-column:1/-1;">
                    <div class="cbm-k">TOTAL</div>
                    <div class="cbm-v" id="cbmTotal">—</div>
                </div>
            </div>

            <div class="cbm-amenities">
                <div class="cbm-amenTitle">AMENITIES</div>
                <div class="cbm-chips" id="cbmAmenities">
                    <span class="cbm-chip">—</span>
                </div>
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

        function setStatusPill(text, ui) {
            const pill = document.getElementById('cbmStatusPill');
            pill.textContent = text || '—';
            pill.className = 'cbm-statusPill cbm-statusPill--' + (ui || 'completed');
        }

        function setAmenities(raw) {
            const wrap = document.getElementById('cbmAmenities');
            wrap.innerHTML = '';

            if (!raw || !raw.trim()) {
                wrap.innerHTML = '<span class="cbm-chip">—</span>';
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

            // Nếu chưa có ảnh thì tạo lần đầu
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

            // Chỉ toggle class
            gallery.querySelectorAll('img').forEach((img, i) => {
                img.classList.toggle('is-active', i === gIdx);
            });

            const multi = gImgs.length > 1;
            gPrev.style.display = multi ? 'flex' : 'none';
            gNext.style.display = multi ? 'flex' : 'none';
        }

        function openDetail(card) {
            gallery.querySelectorAll('img').forEach(x => x.remove());

            document.getElementById('cbmRoom').textContent = card.dataset.room || '—';
            document.getElementById('cbmMeta').textContent = card.dataset.roomMeta || '—';
            document.getElementById('cbmId').textContent = '#' + (card.dataset.bookingId || '—');
            document.getElementById('cbmCheckin').textContent = card.dataset.checkin || '—';
            document.getElementById('cbmCheckout').textContent = card.dataset.checkout || '—';
            document.getElementById('cbmOcc').textContent = card.dataset.occupancy || '—';

            const totalNum = Number(card.dataset.total);
            document.getElementById('cbmTotal').textContent =
                    (!isNaN(totalNum) && totalNum > 0)
                    ? new Intl.NumberFormat('vi-VN', {minimumFractionDigits: 2}).format(totalNum)
                    : 'TBD';

            setStatusPill(card.dataset.statusText, card.dataset.statusUi);
            setAmenities(card.dataset.amenities);

            // ✅ LẤY ẢNH TRỰC TIẾP TỪ CARD
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

