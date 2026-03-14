<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/assets/css/manager/room-types.css"%>

<div class="rt-page">
    <!-- Header -->
    <div class="rt-header">
        <div>
            <div class="rt-title">Room Types</div>
            <p class="rt-subtitle">Manage your hotel’s room types efficiently</p>
        </div>

        <a href="${pageContext.request.contextPath}/manager/room-types?action=create" class="rt-create-btn">
            <i class="bi bi-plus-lg"></i>
            <span>Create Room Type</span>
        </a>
    </div>

    <!-- Toolbar -->
    <div class="rt-toolbar">
        <div class="rt-toolbar-left">
            <form method="get" action="${pageContext.request.contextPath}/manager/room-types" class="rt-search">
                <i class="bi bi-search"></i>
                <input type="text" name="q" value="${param.q}" placeholder="Search room types..." />
            </form>
        </div>
        <div class="rt-toolbar-right">
            <div class="rt-metric">
                <span class="rt-metric-label">TOTAL TYPES</span>
                <span class="rt-metric-value">${totalTypes}</span>
            </div>
        </div>
    </div>

    <!-- Room Types Grid -->
    <c:choose>
        <c:when test="${not empty roomTypes}">
            <div class="rt-grid">
                <c:forEach var="rt" items="${roomTypes}">
                    <div class="rt-card">
                        <div class="rt-image-wrap">
                            <c:set var="displayImage" value="${not empty rt.thumbnailUrl ? rt.thumbnailUrl : rt.imageUrl}" />

<c:choose>
    <c:when test="${not empty displayImage}">
        <img src="${pageContext.request.contextPath}${displayImage}" alt="${rt.name}" class="rt-image">
    </c:when>
    <c:otherwise>
        <img src="https://placehold.co/800x500?text=Room+Type" alt="${rt.name}" class="rt-image">
    </c:otherwise>
</c:choose>
                            <div class="rt-actions">
                                <a href="${pageContext.request.contextPath}/manager/room-types?action=edit&id=${rt.roomTypeId}"
                                   class="rt-action-btn" title="Edit">
                                    <i class="bi bi-pencil"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/manager/room-types?action=delete&id=${rt.roomTypeId}"
                                   class="rt-action-btn" title="Delete"
                                   onclick="return confirm('Are you sure you want to delete this room type?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </div>
                        </div>

                        <div class="rt-body">
                            <div class="rt-topline">
                                <h3 class="rt-name">${rt.name}</h3>

                                <div class="rt-price">
                                    <span class="rt-price-value">
                                        <c:choose>
                                            <c:when test="${rt.price != null}">
                                                $<fmt:formatNumber value="${rt.price}" pattern="#,##0"/>
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="rt-price-label">Per Night</span>
                                </div>
                            </div>

                            <div class="rt-meta">
                                <span><i class="bi bi-bed"></i> ${rt.maxAdult} Adults</span>
                                <span><i class="bi bi-child"></i> ${rt.maxChildren} Children</span>
                            </div>

                            <hr class="rt-divider"/>

                            <div class="rt-capacity">
                                <div class="rt-cap-item">
                                    <div class="rt-cap-icon"><i class="bi bi-people"></i></div>
                                    <div>
                                        <span class="rt-cap-label">Adults</span>
                                        <span class="rt-cap-value">${rt.maxAdult}</span>
                                    </div>
                                </div>

                                <div class="rt-cap-item">
                                    <div class="rt-cap-icon"><i class="bi bi-emoji-smile"></i></div>
                                    <div>
                                        <span class="rt-cap-label">Children</span>
                                        <span class="rt-cap-value">${rt.maxChildren}</span>
                                    </div>
                                </div>
                            </div>

                            <hr class="rt-divider"/>

                            <div class="rt-section-title">Amenities</div>
<div class="rt-amenities">
    <c:choose>
        <c:when test="${not empty rt.amenityNames}">
            <c:forEach var="amenity" items="${rt.amenityNames}" begin="0" end="5">
                <div class="rt-amenity" title="${amenity}">
                    <i class="bi bi-star-fill"></i>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-muted small">No amenities</div>
        </c:otherwise>
    </c:choose>
</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="rt-empty">
                <h5 class="mb-2">No room types found</h5>
                <div>No room types available.</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>