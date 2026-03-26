<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Regal Quintet Hotel | Find Room</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking/booking.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/header_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/footer_home.css">
    </head>

    <body class="booking-page" data-ctx="${pageContext.request.contextPath}">
        <c:set var="defaultImg" value="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1600&q=80&auto=format&fit=crop"/>

        <!-- =============================
             ✅ DEFAULTS / PARAMS (NEW)
        ============================== -->
        <c:set var="qVal" value="${empty param.q ? '' : param.q}" />
        <c:set var="ci" value="${empty param.checkIn ? checkIn : param.checkIn}" />
        <c:set var="co" value="${empty param.checkOut ? checkOut : param.checkOut}" />
        <c:set var="ad" value="${empty param.adults ? (empty adults ? 2 : adults) : param.adults}" />
        <c:set var="ch" value="${empty param.children ? (empty children ? 0 : children) : param.children}" />
        <c:set var="rq" value="${empty param.roomQty ? (empty roomQty ? 1 : roomQty) : param.roomQty}" />

        <c:set var="forceBookingHeader" value="true" scope="request"/>
        <jsp:include page="/view/home/header.jsp"/>

        <!-- TOP SEARCH BAR -->
        <section class="bk-top">
            <div class="container">

                <!-- ✅ change method to GET for consistent URL params -->
                <form class="bk-search bk-search--5" action="${pageContext.request.contextPath}/booking" method="get">

                    <!-- Room type keyword -->
                    <div class="bk-field bk-keyword">
                        <label>Room type</label>
                        <input
                            type="text"
                            name="q"
                            placeholder="Room type name..."
                            value="${fn:escapeXml(qVal)}">
                    </div>

                    <!-- Check-in -->
                    <div class="bk-field">
                        <label>Check-in</label>
                        <!-- ✅ ADDED id -->
                        <input type="date" name="checkIn" id="checkIn" value="${ci}">
                    </div>

                    <!-- Check-out -->
                    <div class="bk-field">
                        <label>Check-out</label>
                        <!-- ✅ ADDED id -->
                        <input type="date" name="checkOut" id="checkOut" value="${co}">
                    </div>

                    <!-- Guests -->
                    <div class="bk-field bk-guest">
                        <label>Guests</label>

                        <!-- hidden inputs -->
                        <input type="hidden" name="adults" id="bkAdults" value="${ad}">
                        <input type="hidden" name="children" id="bkChildren" value="${ch}">

                        <button type="button" class="bk-guest-btn" id="bkGuestBtn">
                            <span id="bkGuestText">${ad} Adults, ${ch} Children</span>
                            <span class="bk-guest-caret">▾</span>
                        </button>

                        <div class="bk-guest-dd" id="bkGuestDd">
                            <div class="bk-guest-row">
                                <span>Adults</span>
                                <div class="bk-guest-step">
                                    <button type="button" class="gminus" data-target="adults">−</button>
                                    <input type="number" min="1" max="30" id="bkAdultsView" value="${ad}">
                                    <button type="button" class="gplus" data-target="adults">+</button>
                                </div>
                            </div>

                            <div class="bk-guest-row">
                                <span>Children</span>
                                <div class="bk-guest-step">
                                    <button type="button" class="gminus" data-target="children">−</button>
                                    <input type="number" min="0" max="15" id="bkChildrenView" value="${ch}">
                                    <button type="button" class="gplus" data-target="children">+</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Rooms -->
                    <div class="bk-field">
                        <label>Rooms</label>
                        <input
                            type="number"
                            id="topRoomQty"
                            name="roomQty"
                            min="1"
                            max="${empty maxAvailableQty ? 20 : maxAvailableQty}"
                            value="${rq}">
                    </div>

                    <button class="bk-btn" type="submit">FIND ROOM</button>
                </form>

            </div>
        </section>
        <c:if test="${not empty dateError}">
            <div style="margin:12px auto; padding:12px 14px; border-radius:12px; background:#fff7e6; border:1px solid #f3d19c; color:#9a6700; font-weight:700; max-width:1200px;">
                ${dateError}
            </div>
        </c:if>
        <!-- capacity error (giữ nguyên) -->
        <c:if test="${param.err == 'capacity'}">
            <div style="margin:12px 0; padding:12px 14px; border-radius:12px; background:#fff1f2; border:1px solid #ffe4e6; color:#991b1b; font-weight:700;">
                Guests exceed the selected room capacity.
                Max allowed: ${param.maxA} adults, ${param.maxC} children (based on number of rooms).
            </div>
        </c:if>

        <!-- guest-room mismatch -->
        <c:if test="${param.err == 'guest_room_mismatch'}">
            <div style="margin:12px 0; padding:12px 14px; border-radius:12px; background:#fff1f2; border:1px solid #ffe4e6; color:#991b1b; font-weight:700;">
                Number of guests cannot be less than number of rooms.
            </div>
        </c:if>

        <!-- ✅ no inventory -->
        <c:if test="${param.err == 'no_inventory'}">
            <div style="margin:12px 0; padding:12px 14px; border-radius:12px; background:#fff1f2; border:1px solid #ffe4e6; color:#991b1b; font-weight:700;">
                The number of rooms you selected exceeds the available rooms for the chosen date range.
                Please reduce the number of rooms or choose another date.
            </div>
        </c:if>

        <!-- RESULTS -->
        <section class="bk-wrap">
            <div class="container">

                <div class="bk-head">
                    <h2>
                        <c:out value="${fn:length(roomTypes)}"/> ROOM (room type)
                    </h2>

                    <div class="bk-sort">
                        <label>SORT:</label>
                        <select id="sortSelect" name="sort" onchange="applySort()">
                            <option value="default"   ${param.sort == 'default' || empty param.sort ? 'selected' : ''}>DEFAULT</option>
                            <option value="priceAsc"  ${param.sort == 'priceAsc' ? 'selected' : ''}>LOWEST PRICE</option>
                            <option value="priceDesc" ${param.sort == 'priceDesc' ? 'selected' : ''}>HIGHEST PRICE</option>
                        </select>
                    </div>
                </div>

                <div class="bk-list" id="bkList">
                    <c:forEach var="rt" items="${roomTypes}">

                        <c:set var="rawImg" value="${empty rt.thumbnailUrl ? '' : rt.thumbnailUrl}" />

                        <c:choose>
                            <c:when test="${empty rawImg}">
                                <c:set var="img" value="${defaultImg}" />
                            </c:when>
                            <c:when test="${fn:startsWith(rawImg, 'http://') or fn:startsWith(rawImg, 'https://')}">
                                <c:set var="img" value="${rawImg}" />
                            </c:when>
                            <c:when test="${fn:startsWith(rawImg, '/')}">
                                <c:set var="img" value="${pageContext.request.contextPath}${rawImg}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="img" value="${pageContext.request.contextPath}/${rawImg}" />
                            </c:otherwise>
                        </c:choose>

                        <div class="bk-card"
                             id="rt-${rt.roomTypeId}"
                             data-price="${rt.priceToday == null ? 999999999 : rt.priceToday}">

                            <div class="bk-img bk-gallery" data-idx="0">

                                <c:choose>
                                    <c:when test="${not empty rt.images}">
                                        <c:forEach var="im" items="${rt.images}" varStatus="st">
                                            <c:set var="raw" value="${empty im.imageUrl ? '' : im.imageUrl}" />
                                            <c:choose>
                                                <c:when test="${empty raw}">
                                                    <c:set var="src" value="${defaultImg}" />
                                                </c:when>
                                                <c:when test="${fn:startsWith(raw, 'http://') or fn:startsWith(raw, 'https://')}">
                                                    <c:set var="src" value="${raw}" />
                                                </c:when>
                                                <c:when test="${fn:startsWith(raw, '/')}">
                                                    <c:set var="src" value="${pageContext.request.contextPath}${raw}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="src" value="${pageContext.request.contextPath}/${raw}" />
                                                </c:otherwise>
                                            </c:choose>

                                            <img class="bk-slide ${st.index == 0 ? 'is-active' : ''}"
                                                 src="${src}"
                                                 alt="${rt.name}"
                                                 onerror="this.onerror=null;this.src='${defaultImg}';">
                                        </c:forEach>

                                        <button type="button" class="bk-nav bk-prev" aria-label="Previous">‹</button>
                                        <button type="button" class="bk-nav bk-next" aria-label="Next">›</button>

                                        <div class="bk-dots">
                                            <c:forEach var="im" items="${rt.images}" varStatus="st">
                                                <span class="bk-dot ${st.index == 0 ? 'is-active' : ''}"></span>
                                            </c:forEach>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <img class="bk-slide is-active"
                                             src="${defaultImg}"
                                             alt="${rt.name}">
                                    </c:otherwise>
                                </c:choose>

                                <div class="bk-tag">NIGHTLY</div>
                            </div>

                            <div class="bk-info">
                                <h3 class="bk-title">${rt.name}</h3>

                                <div class="bk-meta">
                                    <span>👤 MAX: ${rt.maxAdult} adults</span>
                                    <span>🧒 Children: ${rt.maxChildren}</span>
                                </div>

                                <c:set var="desc"
                                       value="${empty rt.description
                                                ? 'Phòng cao cấp, thiết kế sang trọng theo phong cách Regal Quintet.'
                                                : rt.description}" />

                                <div class="bk-desc">
                                    <c:out value="${fn:replace(desc, '•', ' | ')}" />
                                </div>

                                <!-- ✅ available qty note -->
                                <c:if test="${not empty rt.availableQty}">
                                    <div style="margin-top:8px; color:#7c8aa5; font-size:13px; font-weight:600;">
                                        Available: ${rt.availableQty} room(s)
                                    </div>
                                </c:if>

                                <div class="bk-actions">
                                    <a class="bk-link js-open-detail"
                                       href="#"
                                       data-roomtypeid="${rt.roomTypeId}"
                                       data-title="${fn:escapeXml(rt.name)}"
                                       data-maxadult="${rt.maxAdult}"
                                       data-maxchildren="${rt.maxChildren}"
                                       data-price="${rt.priceToday}"
                                       data-amenities="${fn:escapeXml(rt.amenityPipe)}">
                                        Detail →
                                    </a>

                                    <div class="bk-cta">
                                        <div class="bk-qty">
                                            <button type="button" class="qty-btn minus">−</button>
                                            <input
                                                type="text"
                                                class="qty-input"
                                                value="${not empty rt.availableQty and rq > rt.availableQty ? rt.availableQty : rq}"
                                                min="1"
                                                max="${not empty rt.availableQty ? rt.availableQty : 20}"
                                                data-min="1"
                                                data-max="${not empty rt.availableQty ? rt.availableQty : 20}"
                                                readonly>
                                            <button type="button" class="qty-btn plus">+</button>
                                        </div>

                                        <a class="bk-book js-book-now"
                                           href="#"
                                           data-roomtype="${rt.roomTypeId}"
                                           data-maxadult="${rt.maxAdult}"
                                           data-maxchildren="${rt.maxChildren}">
                                            BOOK NOW
                                        </a>
                                    </div>

                                    <div class="bk-room-error" style="display:none;"></div>
                                </div>

                            </div>

                            <div class="bk-price">
                                <div class="bk-price-label">PRICE/NIGHT</div>
                                <div class="bk-price-value">
                                    <c:choose>
                                        <c:when test="${rt.priceToday != null}">
                                            <fmt:formatNumber value="${rt.priceToday}" maxFractionDigits="0"/> đ
                                        </c:when>
                                        <c:otherwise>Liên hệ</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </div>

            </div>
        </section>

        <!-- ROOM DETAIL MODAL -->
        <div class="rm-modal" id="rmModal" aria-hidden="true">
            <div class="rm-backdrop" id="rmBackdrop"></div>

            <div class="rm-panel" role="dialog" aria-modal="true">
                <button class="rm-close" id="rmClose" type="button">×</button>

                <div class="rm-left">
                    <div class="rm-gallery">
                        <button class="rm-nav rm-prev" type="button">‹</button>
                        <img class="rm-img" id="rmImg" alt="Room image">
                        <button class="rm-nav rm-next" type="button">›</button>
                        <div class="rm-badge" id="rmBadge">GALLERY</div>
                    </div>
                </div>

                <div class="rm-right">
                    <div class="rm-kicker">ROOM EXPLORATION</div>
                    <h2 class="rm-title" id="rmTitle">Room</h2>
                    <div class="rm-sub" id="rmSub">—</div>

                    <div class="rm-divider"></div>

                    <div class="rm-grid">
                        <div class="rm-item">
                            <div class="rm-label">ROOM SIZE</div>
                            <div class="rm-value" id="rmSize">—</div>
                        </div>
                        <div class="rm-item">
                            <div class="rm-label">OCCUPANCY</div>
                            <div class="rm-value" id="rmOcc">—</div>
                        </div>
                        <div class="rm-item">
                            <div class="rm-label">BED</div>
                            <div class="rm-value" id="rmBed">—</div>
                        </div>
                        <div class="rm-item">
                            <div class="rm-label">VIEW</div>
                            <div class="rm-value" id="rmView">—</div>
                        </div>
                        <div class="rm-item rm-wide">
                            <div class="rm-label">NIGHTLY</div>
                            <div class="rm-value" id="rmPrice">—</div>
                        </div>
                    </div>

                    <div class="rm-divider"></div>
                    <div class="rm-amenities" id="rmAmenities"></div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets/js/booking/booking.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/home_js/booking_date.js"></script>

        <jsp:include page="/view/home/footer.jsp"/>
    </body>
</html>