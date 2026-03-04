<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Customer Information</title>

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
                    <a class="btn btn-light border"
                       href="${pageContext.request.contextPath}/receptionist/booking/create?checkIn=${fn:escapeXml(param.checkIn)}&checkOut=${fn:escapeXml(param.checkOut)}&rooms=${fn:escapeXml(param.rooms)}&adults=${fn:escapeXml(param.adults)}&children=${fn:escapeXml(param.children)}&roomTypeId=${fn:escapeXml(param.roomTypeId)}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <div>
                        <div class="fw-bold fs-4">CUSTOMER INFORMATION</div>
                        <div class="text-secondary">Step 2/2 – Fill guest details and confirm.</div>
                    </div>
                </div>
                <c:if test="${not empty errors}">
                    <div class="alert alert-danger">
                        <ul class="mb-0">
                            <c:forEach var="e" items="${errors}">
                                <li>${fn:escapeXml(e)}</li>
                                </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <c:if test="${not empty warn}">
                    <div class="alert alert-warning">${fn:escapeXml(warn)}</div>
                </c:if>

                <!-- ✅ ONE FORM wraps BOTH columns -->
                <form method="post" action="${pageContext.request.contextPath}/receptionist/booking/customer">

                    <!-- carry stay data to POST -->
                    <input type="hidden" name="checkIn"  value="${fn:escapeXml(not empty checkIn ? checkIn : param.checkIn)}">
                    <input type="hidden" name="checkOut" value="${fn:escapeXml(not empty checkOut ? checkOut : param.checkOut)}">
                    <input type="hidden" name="rooms"    value="${fn:escapeXml(not empty rooms ? rooms : param.rooms)}">
                    <input type="hidden" name="adults"   value="${fn:escapeXml(not empty adults ? adults : param.adults)}">
                    <input type="hidden" name="children" value="${fn:escapeXml(not empty children ? children : param.children)}">
                    <input type="hidden" name="roomTypeId" value="${fn:escapeXml(not empty roomTypeId ? roomTypeId : param.roomTypeId)}">

                    <div class="cb-wrap cb-wrap-step2">
                        <!-- LEFT: CUSTOMER INFO (NO inner form) -->
                        <div class="card-soft p-4">
                            <div class="section-title mb-3">
                                <i class="bi bi-person me-2 text-primary"></i>CUSTOMER INFORMATION
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Full Name *</label>
                                    <input class="form-control" name="fullName" required
                                           value="${fn:escapeXml(not empty fullName ? fullName : param.fullName)}">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Phone *</label>
                                    <input class="form-control" name="phone" required
                                           value="${fn:escapeXml(not empty phone ? phone : param.phone)}">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Email</label>
                                    <input class="form-control" name="email"
                                           value="${fn:escapeXml(not empty email ? email : param.email)}">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Identity / Passport</label>
                                    <input class="form-control" name="identity"
                                           value="${fn:escapeXml(not empty identity ? identity : param.identity)}">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">Address *</label>
                                    <input class="form-control" name="address" required
                                           value="${fn:escapeXml(not empty address ? address : param.address)}">
                                </div>
                            </div>
                        </div>

                        <!-- RIGHT: SUMMARY + SUBMIT BUTTON -->
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

                            <hr style="border-color:rgba(148,163,184,.18);" class="my-3">

                            <div class="d-flex justify-content-between align-items-end">
                                <div class="sum-k">Total Estimated</div>
                                <div class="sum-total"><fmt:formatNumber value="${total}" type="number"/> đ</div>
                            </div>

                            <div class="hint mt-2">
                                After confirm, status will be <b>PENDING_DEPOSIT</b>.
                            </div>

                            <!-- ✅ Submit button in black box -->
                            <button class="btn btn-primary btn-confirm mt-3" type="submit">
                                CONFIRM RESERVATION <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                        </div>

                    </div>
                </form>

            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>