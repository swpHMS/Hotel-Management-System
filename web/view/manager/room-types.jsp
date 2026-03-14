<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manager/room-types.css"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<div class="rt-page">
    <div class="rt-header">
        <div>
            <h1>Room Types</h1>
            <p>Manage different types of rooms in the hotel</p>
        </div>
        <a class="rt-btn-create" href="${pageContext.request.contextPath}/manager/room-types?mode=create">
            <i class="bi bi-plus-lg"></i> Create Room Type
        </a>
    </div>

    <c:if test="${not empty param.success}">
        <div class="rt-alert success">Action completed: ${param.success}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="rt-alert error">${param.error}</div>
    </c:if>
    <c:if test="${not empty errors}">
        <div class="rt-alert error">
            <ul>
                <c:forEach var="err" items="${errors}"><li>${err}</li></c:forEach>
            </ul>
        </div>
    </c:if>

    <div class="rt-toolbar-card">
        <form method="get" action="${pageContext.request.contextPath}/manager/room-types" class="rt-search-form">
            <div class="rt-search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" name="q" placeholder="Search room types..." value="${q}"/>
            </div>
            <button type="submit">Search</button>
        </form>
        <div class="rt-total">
            <span>Total Types</span>
            <strong>${roomTypes.size()}</strong>
        </div>
    </div>

    <div class="rt-cards">
        <c:forEach var="item" items="${roomTypes}">
            <article class="rt-card">
                <div class="rt-card-top">
                    <a class="rt-edit-link" href="${pageContext.request.contextPath}/manager/room-types?editId=${item.roomTypeId}">
                        <i class="bi bi-pencil"></i>
                    </a>
                </div>

                <img class="rt-thumb" src="${pageContext.request.contextPath}/${item.imageUrl}" alt="${item.name}"/>

                <div class="rt-card-body">
                    <div class="rt-row between">
                        <h3>${item.name}</h3>
                        <div class="rt-price">
                            <c:choose>
                                <c:when test="${item.currentPrice != null}">
                                    <fmt:formatNumber value="${item.currentPrice}" type="number" groupingUsed="true"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                            <small>PER NIGHT</small>
                        </div>
                    </div>
                    <div class="rt-meta">
                        <span class="rt-meta-chip">
                            <strong>Bed</strong>
                            <span>${item.bedType}</span>
                        </span>
                        <span class="rt-meta-chip">
                            <strong>View</strong>
                            <span>${item.viewType}</span>
                        </span>
                        <span class="rt-meta-chip">
                            <strong>Size</strong>
                            <span>${item.roomSize} sqm</span>
                        </span>
                    </div>
                    <div class="rt-capacity">
                        <span>Up to <strong>${item.maxAdult}</strong> adults, <strong>${item.maxChildren}</strong> children</span>
                    </div>
                    <div class="rt-amenities">
                        <c:forEach var="aName" items="${item.amenityNames}">
                            <span>${aName}</span>
                        </c:forEach>
                    </div>
                </div>
            </article>
        </c:forEach>
    </div>

    <c:if test="${mode == 'create' || mode == 'edit'}">
        <div class="rt-form-card">
            <h2>${mode == 'create' ? 'Create Room Type' : 'Update Room Type'}</h2>
            <p>${mode == 'create' ? 'Define a new room type for your hotel.' : 'Adjust room type details.'}</p>

            <c:set var="editing" value="${editingRoomType}"/>

            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manager/room-types">
                <input type="hidden" name="action" value="${mode == 'create' ? 'create' : 'update'}"/>
                <c:if test="${mode == 'edit'}">
                    <input type="hidden" name="roomTypeId" value="${editing != null ? editing.roomTypeId : editingId}"/>
                </c:if>

                <div class="rt-form-grid cols-2">
                    <label>Room Type Name *
                        <input type="text" name="name" required
                               value="${formValue != null ? formValue.name : (editing != null ? editing.name : '')}"/>
                    </label>
                    <label>Room Size (sqm) *
                        <input type="number" min="1" name="roomSize" required
                               value="${formValue != null ? formValue.roomSize : (editing != null ? editing.roomSize : '')}"/>
                    </label>
                    <label>Bed Type *
                        <input type="text" name="bedType" placeholder="King Bed / Queen Bed" required
                               value="${formValue != null ? formValue.bedType : (editing != null ? editing.bedType : '')}"/>
                    </label>
                    <label>View Type *
                        <input type="text" name="viewType" placeholder="Ocean View / City View" required
                               value="${formValue != null ? formValue.viewType : (editing != null ? editing.viewType : '')}"/>
                    </label>
                    <label>Description
                        <textarea name="description" rows="3" placeholder="Describe this room type...">${formValue != null ? formValue.description : (editing != null ? editing.descriptionPlain : '')}</textarea>
                    </label>
                    <label>Thumbnail Image (JPG/PNG/WEBP)
                        <input type="file" name="thumbnailImage" accept=".jpg,.jpeg,.png,.webp"/>
                    </label>
                </div>

                <div class="rt-form-grid cols-4">
                    <label>Max Adults *
                        <input type="number" min="1" name="maxAdult" required
                               value="${formValue != null ? formValue.maxAdult : (editing != null ? editing.maxAdult : 2)}"/>
                    </label>
                    <label>Max Children *
                        <input type="number" min="0" name="maxChildren" required
                               value="${formValue != null ? formValue.maxChildren : (editing != null ? editing.maxChildren : 0)}"/>
                    </label>
                    <label>Base Price
                        <input type="number" min="0" step="0.01" name="price"
                               value="${formValue != null ? formValue.price : (editing != null ? editing.currentPrice : '')}"/>
                    </label>
                </div>

                <input type="hidden" name="status"
                       value="${formValue != null ? formValue.status : (editing != null ? editing.status : 1)}"/>

                <div class="rt-form-grid cols-2">
                    <label>Valid From
                        <input type="date" name="validFrom"
                               value="${formValue != null ? formValue.validFrom : (editing != null ? editing.validFrom : '')}"/>
                    </label>
                    <label>Valid To
                        <input type="date" name="validTo"
                               value="${formValue != null ? formValue.validTo : (editing != null ? editing.validTo : '')}"/>
                    </label>
                </div>

                <div class="rt-amenity-box">
                    <h3>Amenities</h3>
                    <div class="rt-amenity-grid">
                        <c:forEach var="a" items="${amenities}">
                            <label class="rt-amenity-item">
                                <c:set var="checked" value="false"/>
                                <c:if test="${formValue != null && formValue.amenityIds.contains(a.amenityId)}">
                                    <c:set var="checked" value="true"/>
                                </c:if>
                                <c:if test="${formValue == null && mode == 'edit' && editing != null && editing.amenityIds.contains(a.amenityId)}">
                                    <c:set var="checked" value="true"/>
                                </c:if>
                                <input type="checkbox" name="amenityIds" value="${a.amenityId}" ${checked ? 'checked' : ''}/>
                                <span>${a.name}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div class="rt-form-actions">
                    <a href="${pageContext.request.contextPath}/manager/room-types" class="rt-btn-cancel">Cancel</a>
                    <button type="submit" class="rt-btn-save">${mode == 'create' ? 'Create Room Type' : 'Save Changes'}</button>
                </div>
            </form>
        </div>
    </c:if>
</div>
