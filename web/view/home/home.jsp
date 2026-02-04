<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>Hotel Management System | Home</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/header_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/body_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/footer_home.css">
    </head>

    <body>
        <c:set var="defaultImg" value="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1600&q=80&auto=format&fit=crop"/>

        <jsp:include page="header.jsp"/>

        <section class="hero">
            <div class="container hero-content">
                <div class="hero-eyebrow">WELCOME TO EXCELLENCE</div>
                <h1 class="hero-title">Majestic Comfort</h1>
                <div class="hero-subtitle">Redefined</div>
                <p class="hero-desc">Discover premium room types managed seamlessly by your Hotel Management System.</p>
            </div>

            <div class="container booking-wrap">
                <form class="booking" action="#" method="get">
                    <div class="field">
                        <label>Check-in</label>
                        <div class="control">
                            <input type="date" id="checkIn"  name="checkIn"
                                   value="${defaultCheckIn}"
                                   min="<%= java.time.LocalDate.now() %>">
                        </div>
                    </div>

                    <div class="field">
                        <label>Check-out</label>
                        <div class="control">
                            <input type="date" id="checkOut" name="checkOut"
                                   value="${defaultCheckOut}"
                                   min="<%= java.time.LocalDate.now() %>">
                        </div>
                    </div>

                    <!-- ✅ GUESTS -->
                    <div class="field guest-field" id="guestField">
                        <label>Guests</label>

                        <div class="control guest-trigger" id="guestTrigger" role="button" tabindex="0"
                             aria-haspopup="dialog" aria-expanded="false">
                            <span class="guest-value" id="guestValue">2 Adults, 0 Children</span>
                            <span class="chev" aria-hidden="true"></span>
                        </div>

                        <input type="hidden" name="adults" id="adultsHidden" value="2">
                        <input type="hidden" name="children" id="childrenHidden" value="0">

                        <div class="guest-panel" id="guestPanel" role="dialog" aria-label="Select guests">
                            <div class="guest-row">
                                <div class="guest-stepper">
                                    <span class="mini-label">Adults</span>
                                    <div class="stepper">
                                        <button type="button" class="step-btn" data-step="adults" data-dir="-1"
                                                aria-label="Decrease adults">−</button>

                                        <!-- ✅ span -> input -->
                                        <input
                                            type="number"
                                            class="step-input"
                                            id="adultsValue"
                                            value="2"
                                            min="1"
                                            max="30"
                                            inputmode="numeric"
                                            aria-label="Adults"
                                            />

                                        <button type="button" class="step-btn" data-step="adults" data-dir="1"
                                                aria-label="Increase adults">+</button>
                                    </div>
                                </div>

                                <div class="guest-stepper">
                                    <span class="mini-label">Children</span>
                                    <div class="stepper">
                                        <button type="button" class="step-btn" data-step="children" data-dir="-1"
                                                aria-label="Decrease children">−</button>

                                        <!-- ✅ span -> input -->
                                        <input
                                            type="number"
                                            class="step-input"
                                            id="childrenValue"
                                            value="0"
                                            min="0"
                                            max="15"
                                            inputmode="numeric"
                                            aria-label="Children"
                                            />

                                        <button type="button" class="step-btn" data-step="children" data-dir="1"
                                                aria-label="Increase children">+</button>
                                    </div>
                                </div>
                            </div>

                            <div class="guest-actions">
                                <button type="button" class="guest-btn apply" id="guestApply">Apply</button>
                            </div>
                        </div>
                    </div>
                    <div class="field field-rooms">
                        <label>Rooms</label>

                        <div class="control">
                            <input
                                type="number"
                                name="roomQty"
                                id="roomQty"
                                min="1"
                                max="${empty maxRooms ? 5 : maxRooms}"
                                value="${empty roomQty ? 1 : roomQty}"
                                class="rooms-input"
                                />
                        </div>

                        <c:if test="${not empty roomQtyError}">
                            <div class="field-error">${roomQtyError}</div>
                        </c:if>
                    </div>






                    <button class="btn btn-navy btn-find" type="submit">FIND ROOMS</button>
                </form>
            </div>
        </section>

        <!-- WHY -->
        <section class="section why-section" id="why">
            <div class="container">
                <h2 class="why-title">Why choose our hotel?</h2>
                <p class="why-quote">“We provide more than just a place to sleep. We provide an experience.”</p>
                <div class="why-divider"></div>

                <div class="why-grid">
                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M12 2v4"/><path d="M12 18v4"/>
                            <path d="M4.93 4.93l2.83 2.83"/><path d="M16.24 16.24l2.83 2.83"/>
                            <path d="M2 12h4"/><path d="M18 12h4"/>
                            <path d="M4.93 19.07l2.83-2.83"/><path d="M16.24 7.76l2.83-2.83"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Easy Online Booking</h3>
                        <p class="why-item-desc">Secure your room in just a few clicks with our streamlined checkout.</p>
                    </div>

                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M12 2l7 4v6c0 5-3 9-7 10C8 21 5 17 5 12V6l7-4z"/>
                            <path d="M9 12l2 2 4-4"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Secure Payment</h3>
                        <p class="why-item-desc">Your data is protected with industry-standard encryption protocols.</p>
                    </div>

                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M3 12V8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v4"/>
                            <path d="M2 18h20"/><path d="M4 18v-3"/><path d="M20 18v-3"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Comfortable Rooms</h3>
                        <p class="why-item-desc">Premium linens, quiet environments, and world-class amenities.</p>
                    </div>

                    <div class="why-item">
                        <div class="why-iconbox" aria-hidden="true">
                            <svg class="why-icon" viewBox="0 0 24 24">
                            <path d="M4 20h16"/>
                            <path d="M12 4c3 0 5 2 5 5v3H7V9c0-3 2-5 5-5z"/>
                            <path d="M7 12v3a5 5 0 0 0 10 0v-3"/>
                            </svg>
                        </div>
                        <h3 class="why-item-title">Friendly Service</h3>
                        <p class="why-item-desc">Our 24/7 concierge is dedicated to making your stay perfect.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ROOMS -->
        <section class="section suites-section" id="rooms">
            <div class="container">
                <div class="suites-eyebrow">SANCTUARY OF PEACE</div>
                <h2 class="suites-title">Our Signature Suites</h2>
                <p class="suites-sub">“Experience the convergence of heritage and modern luxury in our meticulously curated spaces.”</p>
                <div class="suites-divider"></div>

                <div class="suites-grid">
                    <c:forEach var="rt" items="${roomTypes}" varStatus="st">
                        <c:if test="${st.index < 8}">

                            <c:set var="rawImg" value="${empty rt.imageUrl ? '' : rt.imageUrl}" />
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

                            <c:set var="desc" value="${empty rt.description ? '' : rt.description}" />
                            <c:set var="parts" value="${fn:split(desc, '•')}" />
                            <c:set var="bedText"  value="${fn:length(parts) > 0 ? fn:trim(parts[0]) : ''}" />
                            <c:set var="viewText" value="${fn:length(parts) > 1 ? fn:trim(parts[1]) : ''}" />
                            <c:set var="sizeText" value="${fn:length(parts) > 2 ? fn:trim(parts[2]) : ''}" />

                            <div class="suites-card">
                                <div class="suites-media">
                                    <img src="${img}" alt="<c:out value='${rt.name}'/>"
                                         onerror="this.onerror=null;this.src='${defaultImg}';">

                                    <div class="suites-price">
                                        NIGHTLY
                                        <b>
                                            <c:choose>
                                                <c:when test="${rt.priceToday != null}">
                                                    <fmt:formatNumber value="${rt.priceToday}" maxFractionDigits="0"/>
                                                </c:when>
                                                <c:otherwise>CONTACT</c:otherwise>
                                            </c:choose>
                                        </b>
                                    </div>
                                </div>

                                <div class="room-details">
                                    <div class="room-eyebrow">Room photos and details</div>
                                    <h3 class="room-title"><c:out value="${rt.name}"/></h3>

                                    <ul class="suites-meta" style="margin-top:14px;">
                                        <li>
                                            <span class="suites-ico" aria-hidden="true">
                                                <svg viewBox="0 0 24 24">
                                                <path d="M3 12V8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v4"/>
                                                <path d="M2 18h20"/><path d="M4 18v-3"/><path d="M20 18v-3"/>
                                                </svg>
                                            </span>
                                            <span><c:out value="${not empty bedText ? bedText : 'Bed info'}"/></span>
                                        </li>

                                        <li>
                                            <span class="suites-ico" aria-hidden="true">
                                                <svg viewBox="0 0 24 24">
                                                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/>
                                                <path d="M12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/>
                                                </svg>
                                            </span>
                                            <span><c:out value="${not empty viewText ? viewText : 'View'}"/></span>
                                        </li>

                                        <li>
                                            <span class="suites-ico" aria-hidden="true">
                                                <svg viewBox="0 0 24 24">
                                                <path d="M8 3H3v5"/><path d="M16 3h5v5"/>
                                                <path d="M8 21H3v-5"/><path d="M16 21h5v-5"/>
                                                <path d="M3 8l6-6"/><path d="M21 8l-6-6"/>
                                                <path d="M3 16l6 6"/><path d="M21 16l-6 6"/>
                                                </svg>
                                            </span>
                                            <span><c:out value="${not empty sizeText ? sizeText : 'N/A'}"/></span>
                                        </li>
                                    </ul>

                                    <div class="suites-actions" style="padding:0 18px 18px; margin-top:14px;">
                                        <a class="suites-btn suites-btn-detail js-room-detail"
                                           href="javascript:void(0)"
                                           data-id="${rt.roomTypeId}"
                                           data-name="${fn:escapeXml(rt.name)}"
                                           data-img="${img}"
                                           data-price="${rt.priceToday}"
                                           data-bed="${fn:escapeXml(bedText)}"
                                           data-view="${fn:escapeXml(viewText)}"
                                           data-size="${fn:escapeXml(sizeText)}"
                                           data-adult="${rt.maxAdult}"
                                           data-child="${rt.maxChildren}"
                                           data-desc="${fn:escapeXml(rt.description)}"
                                           data-amenities="${fn:escapeXml(rt.amenityPipe)}">
                                            DETAILS
                                        </a>


                                        <a class="suites-btn suites-btn-book"
                                           href="${pageContext.request.contextPath}/booking?roomTypeId=${rt.roomTypeId}">
                                            BOOK
                                        </a>
                                    </div>

                                </div>
                            </div>

                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </section>

        <jsp:include page="footer.jsp"/>
        <div class="room-modal" id="roomModal" aria-hidden="true">
            <div class="room-modal__backdrop" data-close="1"></div>

            <div class="room-modal__panel">
                <button class="room-modal__close" type="button" data-close="1">×</button>

                <div class="room-modal__grid">
                    <div class="room-modal__media">
                        <img id="rmImg" src="" alt="">
                    </div>

                    <div class="room-modal__content">
                        <div class="room-modal__eyebrow">ROOM EXPLORATION</div>
                        <h3 class="room-modal__title" id="roomModalTitle"></h3>

                        <p class="room-modal__desc" id="rmDesc"></p>

                        <div class="room-modal__facts">
                            <div><b>ROOM SIZE</b><div id="rmSize"></div></div>
                            <div><b>OCCUPANCY</b><div id="rmOcc"></div></div>
                            <div><b>BED</b><div id="rmBed"></div></div>
                            <div><b>VIEW</b><div id="rmView"></div></div>
                            <div><b>NIGHTLY</b><div id="rmPrice"></div></div>
                        </div>

                        <div class="room-modal__amenities" id="rmAmenities"></div>

                        <div class="room-modal__actions">
                            <a id="rmCheckBtn" class="room-modal__btn room-modal__btn-primary" href="#">CHECK AVAILABILITY</a>
                            <a id="rmDetailPageBtn" class="room-modal__btn room-modal__btn-outline" href="#">BOOKING</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets/js/home_js/header_scroll.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/home_js/room_modal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/home_js/booking_date.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/home_js/guest_panel.js"></script>

    </body>
</html>
