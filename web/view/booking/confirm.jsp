<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Booking Confirm</title>

        <link rel="stylesheet" href="${ctx}/assets/css/booking/confirm.css">
    </head>

    <body class="confirm-page" data-ctx="${ctx}" data-holdms="${holdMs}">
        <c:set var="forceBookingHeader" value="true" scope="request"/>

        <div class="cf-topbar">
            <div class="container cf-topbar-inner">
                <div class="cf-brand">
                    <a href="${ctx}/home" class="cf-brand" style="text-decoration: none; color: inherit; display: flex; align-items: center;">
                        <div class="rq-logo">
                            <span class="rq-diamond d1">◆</span>
                            <span class="rq-diamond d2">◆</span>
                            <span class="rq-diamond d3">◆</span>
                        </div>
                        <span class="cf-name">Regal Quintet Hotel</span>
                    </a>
                </div>

                <div class="cf-steps">
                    <span class="cf-step is-active"><span class="dot">1</span> Billing Information <span class="bar"></span></span>
                    <span class="cf-step"><span class="dot">2</span> Payment <span class="bar"></span></span>
                    <span class="cf-step"><span class="dot">3</span> Confirmation</span>
                </div>

                <%-- ==== Account display (giữ như file trên) ==== --%>
                <c:set var="acc" value="${sessionScope.user}" />
                <c:if test="${empty acc}">
                    <c:set var="acc" value="${sessionScope.userProfile}" />
                </c:if>
                <c:if test="${empty acc}">
                    <c:set var="acc" value="${sessionScope.profile}" />
                </c:if>
                <c:if test="${empty acc}">
                    <c:set var="acc" value="${sessionScope.account}" />
                </c:if>
                <c:if test="${empty acc}">
                    <c:set var="acc" value="${sessionScope.currentUser}" />
                </c:if>

                <c:set var="displayName" value="${acc.fullName}" />
                <c:if test="${empty displayName}">
                    <c:set var="displayName" value="${acc.name}" />
                </c:if>
                <c:if test="${empty displayName}">
                    <c:set var="displayName" value="Guest" />
                </c:if>

                <div class="cf-account">
                    <span class="cf-avatar">
                        ${fn:toUpperCase(fn:substring(displayName, 0, 1))}
                    </span>
                    <span class="cf-email">${displayName}</span>
                </div>
            </div>
        </div>

        <div class="container cf-wrap">
            <div class="cf-hold">
                We are holding this price for you...
                <span class="clock" aria-hidden="true"></span>
                <b id="cfTimer">15:00</b>
            </div>

            <div class="cf-grid">
                <!-- LEFT -->
                <div>
                    <div class="cf-card cf-card--right">
                        <div class="cf-hd">Booking Summary</div>
                        <div class="cf-bd">
                            <div class="cf-row">
                                <div class="cf-lb">Room Type</div>
                                <div class="cf-val">${rt.name}</div>
                            </div>

                            <div class="cf-row">
                                <div class="cf-lb">Check-in / Check-out</div>
                                <div class="cf-val">
                                    ${checkIn} - ${checkOut}
                                    <div class="cf-sub">(${nights} nights)</div>
                                </div>
                            </div>

                            <div class="cf-row">
                                <div class="cf-lb">Guests</div>
                                <div class="cf-val">
                                    ${adults} adults<c:if test="${children > 0}">, ${children} children</c:if>
                                    </div>
                                </div>

                                <div class="cf-row">
                                    <div class="cf-lb">Rooms</div>
                                    <div class="cf-val">${roomQty} rooms</div>
                            </div>

                            <div class="cf-row">
                                <div class="cf-lb">Price per Night</div>
                                <div class="cf-val">
                                    <c:choose>
                                        <c:when test="${pricePerNight != 0}">
                                            <fmt:formatNumber value="${pricePerNight}" maxFractionDigits="0" groupingUsed="true"/> ₫
                                        </c:when>
                                        <c:otherwise>Contact</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="cf-total">
                                <div class="cf-total-title">TOTAL</div>
                                <div class="cf-total-amt">
                                    <fmt:formatNumber value="${total}" maxFractionDigits="0" groupingUsed="true"/> ₫
                                </div>
                            </div>

                            <div class="cf-deposit">
                                <div class="cf-deposit-left">
                                    DEPOSIT (50%)<br/>
                                    <span>Non-refundable Deposit</span>
                                </div>
                                <div class="cf-deposit-right">
                                    <fmt:formatNumber value="${deposit}" maxFractionDigits="0" groupingUsed="true"/> ₫
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="cf-gap"></div>

                    <div class="cf-card cf-terms">
                        <div class="cf-hd">Deposit Agreement & Booking Terms</div>
                        <div class="cf-bd">
                            <div class="cf-alert">
                                <div class="cf-alert-title">${paymentPolicy.name}</div>
                                <div class="cf-alert-text">
                                    <c:forEach var="line" items="${fn:split(formattedPaymentPolicy, '||')}">
                                        <div class="cf-policy-item">${line}</div>
                                    </c:forEach>
                                </div>
                            </div>

                            <%-- ✅ GHÉP LOGIC FILE DƯỚI:
                                 - action chuyển sang /booking/pay
                                 - thêm holdId hidden (fallback holdId từ request attribute hoặc param)
                            --%>
                            <form method="post" action="${ctx}/booking/pay" id="cfForm">

                                <c:set var="hid" value="${holdId}" />
                                <c:if test="${empty hid}">
                                    <c:set var="hid" value="${param.holdId}" />
                                </c:if>

                                <input type="hidden" name="holdId" value="${hid}"/>
                                <input type="hidden" name="paymentMethod" value="vnpay"/>

                                <input type="hidden" name="roomTypeId" value="${rt.roomTypeId}">
                                <input type="hidden" name="checkIn" value="${checkIn}">
                                <input type="hidden" name="checkOut" value="${checkOut}">
                                <input type="hidden" name="roomQty" value="${roomQty}">
                                <input type="hidden" name="adults" value="${adults}">
                                <input type="hidden" name="children" value="${children}">
                                <input type="hidden" name="customerEmail" value="${customerEmail}"/>
                                <input type="hidden" name="deposit" value="${deposit}"/>
                                <input type="hidden" name="total" value="${total}"/>

                                <div class="cf-check">
                                    <input type="checkbox" id="cfAgree" name="agree" value="1" required/>
                                    <label for="cfAgree">
                                        I agree to the Deposit Agreement & Booking Terms (Non-refundable policy applied)
                                    </label>
                                </div>

                                <button type="submit" class="cf-btn" id="cfContinue">
                                    Agree and Continue to Payment →
                                </button>
                            </form>

                        </div>
                    </div>
                </div>

                <!-- RIGHT -->
                <!-- RIGHT -->
                <div class="cf-rightCol">
                    <div class="cf-card">
                        <div class="cf-miniTop">
                            <div>
                                <div class="cf-miniLabel">CHECK-IN</div>
                                <div class="cf-miniDate">${checkIn}</div>
                            </div>
                            <div class="cf-miniRight">
                                <div class="cf-miniLabel">CHECK-OUT</div>
                                <div class="cf-miniDate">${checkOut}</div>
                            </div>
                        </div>

                        <div class="cf-miniItem">
                            <div class="cf-thumb">
                                <c:set var="rawImg" value="${empty rt.imageUrl ? '' : rt.imageUrl}" />
                                <c:choose>
                                    <c:when test="${empty rawImg}">
                                        <img src="https://dummyimage.com/200x200/e2e8f0/0f172a&text=ROOM" alt="room"/>
                                    </c:when>
                                    <c:when test="${fn:startsWith(rawImg, 'http://') or fn:startsWith(rawImg, 'https://')}">
                                        <img src="${rawImg}" alt="room"/>
                                    </c:when>
                                    <c:when test="${fn:startsWith(rawImg, '/')}">
                                        <img src="${ctx}${rawImg}" alt="room"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${ctx}/${rawImg}" alt="room"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="cf-miniInfo">
                                <div class="cf-miniTitle">${roomQty}x ${rt.name}</div>
                                <div class="cf-miniSub">${nights} nights • ${adults} adults</div>
                            </div>
                        </div>

                        <div class="cf-miniSum">
                            <div class="cf-line">
                                <span>TOTAL</span>
                                <span><fmt:formatNumber value="${total}" maxFractionDigits="0" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="cf-line">
                                <b>DEPOSIT (50%)</b>
                                <b><fmt:formatNumber value="${deposit}" maxFractionDigits="0" groupingUsed="true"/> ₫</b>
                            </div>
                        </div>
                    </div>

                    <a href="${ctx}/booking?roomTypeId=${rt.roomTypeId}&checkIn=${checkIn}&checkOut=${checkOut}&roomQty=${roomQty}&adults=${adults}&children=${children}"
                       class="cf-back-link"
                       style="display:flex;align-items:center;justify-content:center;width:100%;min-height:58px;margin-top:16px;padding:0 20px;border-radius:20px;border:1.5px solid #0f2343;background:#fff;color:#0f2343;text-decoration:none;font-size:16px;font-weight:800;box-sizing:border-box;">
                        ← Back to Booking
                    </a>
                </div>
            </div>
        </div>

        <script src="${ctx}/assets/js/booking/confirm.js"></script>
    </body>
</html>