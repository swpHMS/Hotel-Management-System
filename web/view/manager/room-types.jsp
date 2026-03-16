<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="fallbackRoomImage" value="${pageContext.request.contextPath}/assets/images/room_types/standard_doubleee.jpg"/>

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
        <div class="rt-alert success" id="rtSuccessAlert">
            <c:choose>
                <c:when test="${param.success == 'created'}">Room type created successfully.</c:when>
                <c:when test="${param.success == 'updated'}">Room type updated successfully.</c:when>
                <c:when test="${param.success == 'imageDeleted'}">Image deleted successfully.</c:when>
                <c:when test="${param.success == 'imageDeleteFailed'}">Could not delete image.</c:when>
                <c:otherwise>Action completed successfully.</c:otherwise>
            </c:choose>
        </div>
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
        <form method="get" action="${pageContext.request.contextPath}/manager/room-types" class="rt-search-form" id="rtSearchForm">
            <div class="rt-search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" name="q" placeholder="Search room types..." value="${q}" id="rtSearchInput" autocomplete="off"/>
            </div>
            <input type="hidden" name="page" value="1" id="rtSearchPage"/>
            <input type="hidden" name="pageSize" value="${pageSize}" id="rtSearchPageSize"/>
        </form>
        <div class="rt-total">
            <span>Total Types</span>
            <strong>${totalItems}</strong>
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

                <img class="rt-thumb"
                     src="${pageContext.request.contextPath}/${item.imageUrl}"
                     alt="${item.name}"
                     onerror="this.onerror=null;this.src='${fallbackRoomImage}';"/>

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

    <div class="rt-pagination-bar">
        <div class="rt-page-size">
            <span>Show</span>
            <form method="get" action="${pageContext.request.contextPath}/manager/room-types" id="rtPageSizeForm">
                <input type="hidden" name="q" value="${q}"/>
                <input type="hidden" name="page" value="1"/>
                <select name="pageSize" id="rtPageSizeSelect">
                    <c:forEach var="size" items="${pageSizeOptions}">
                        <option value="${size}" ${pageSize == size ? 'selected' : ''}>${size}</option>
                    </c:forEach>
                </select>
            </form>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="rt-pagination">
                <a class="rt-page-btn ${currentPage == 1 ? 'disabled' : ''}"
                   href="${currentPage == 1 ? '#' : pageContext.request.contextPath}/manager/room-types?q=${q}&pageSize=${pageSize}&page=${currentPage - 1}">Prev</a>

                <c:forEach var="token" items="${pageTokens}">
                    <c:choose>
                        <c:when test="${token == '...'}">
                            <span class="rt-page-ellipsis">...</span>
                        </c:when>
                        <c:otherwise>
                            <a class="rt-page-number ${currentPage == token ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/manager/room-types?q=${q}&pageSize=${pageSize}&page=${token}">${token}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <a class="rt-page-btn ${currentPage == totalPages ? 'disabled' : ''}"
                   href="${currentPage == totalPages ? '#' : pageContext.request.contextPath}/manager/room-types?q=${q}&pageSize=${pageSize}&page=${currentPage + 1}">Next</a>
            </div>
        </c:if>
    </div>

    <c:if test="${mode == 'create' || mode == 'edit'}">
        <c:set var="editing" value="${editingRoomType}"/>
        <div class="rt-modal-backdrop">
            <div class="rt-modal-shell">
                <div class="rt-form-card">
                    <div class="rt-modal-head">
                        <div>
                            <h2>${mode == 'create' ? 'Create Room Type' : 'Update Room Type'}</h2>
                            <p>${mode == 'create' ? 'Create a new room type with thumbnail and gallery images.' : 'Update room type details, thumbnail and gallery images.'}</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/manager/room-types" class="rt-modal-close">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </div>

                    <c:if test="${not empty errors}">
                        <div class="rt-alert error rt-modal-alert">
                            <ul>
                                <c:forEach var="err" items="${errors}"><li>${err}</li></c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    <div class="rt-alert error rt-modal-alert" id="rtClientImageError" style="display:none;"></div>

                    <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manager/room-types">
                        <input type="hidden" name="action" value="${mode == 'create' ? 'create' : 'update'}"/>
                        <c:if test="${mode == 'edit'}">
                            <input type="hidden" name="roomTypeId" value="${editing != null ? editing.roomTypeId : editingId}"/>
                        </c:if>
                        <input type="hidden" name="status"
                               value="${formValue != null ? formValue.status : (editing != null ? editing.status : 1)}"/>
                        <c:if test="${not empty preservedThumbnailUrl}">
                            <input type="hidden" name="existingThumbnailUrl" value="${preservedThumbnailUrl}"/>
                        </c:if>
                        <c:forEach var="preservedGalleryUrl" items="${preservedGalleryUrls}">
                            <input type="hidden" name="existingGalleryUrls" value="${preservedGalleryUrl}"/>
                        </c:forEach>
                        <div id="rtDeletedGalleryInputs">
                            <c:forEach var="deletedImageId" items="${deletedGalleryImageIds}">
                                <input type="hidden" name="deletedGalleryImageIds" value="${deletedImageId}"/>
                            </c:forEach>
                        </div>

                        <div class="rt-form-section">
                            <h3>Images</h3>
                            <div class="rt-image-layout">
                                <div class="rt-thumb-panel">
                                    <span class="rt-section-label">Thumbnail *</span>
                                    <label class="rt-thumb-drop">
                                        <input id="rtThumbnailInput" type="file" name="thumbnailImage" accept=".jpg,.jpeg,.png"/>
                                        <span id="rtThumbnailPreview">
                                            <c:choose>
                                                <c:when test="${not empty preservedThumbnailUrl}">
                                                    <img src="${pageContext.request.contextPath}/${preservedThumbnailUrl}"
                                                         alt="Thumbnail"
                                                         onerror="this.onerror=null;this.src='${fallbackRoomImage}';"/>
                                                </c:when>
                                                <c:when test="${mode == 'edit' && editing != null && editing.thumbnailImage != null}">
                                                    <img src="${pageContext.request.contextPath}/${editing.thumbnailImage.imageUrl}"
                                                         alt="Thumbnail"
                                                         onerror="this.onerror=null;this.src='${fallbackRoomImage}';"/>
                                                </c:when>
                                                <c:when test="${mode == 'edit' && editing != null && not empty editing.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}/${editing.imageUrl}"
                                                         alt="Thumbnail"
                                                         onerror="this.onerror=null;this.src='${fallbackRoomImage}';"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="rt-thumb-placeholder">
                                                        <i class="bi bi-image"></i>
                                                        <strong>Upload thumbnail</strong>
                                                        <small>Click here to choose a new thumbnail image</small>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </label>
                                    <small class="rt-help-text">Click the thumbnail area to replace it with a new image. Supported formats: JPG, JPEG, PNG. Files larger than 300 KB will be resized automatically.</small>
                                </div>

                                <div class="rt-gallery-panel">
                                    <div class="rt-gallery-top">
                                        <span class="rt-section-label">Gallery Images</span>
                                        <label class="rt-gallery-upload">
                                            <i class="bi bi-cloud-arrow-up"></i>
                                            <span>Add Images</span>
                                            <input id="rtGalleryInput" type="file" name="galleryImages" accept=".jpg,.jpeg,.png" multiple/>
                                        </label>
                                    </div>

                                    <div class="rt-gallery-grid" id="rtGalleryPreview">
                                        <c:forEach var="preservedGalleryUrl" items="${preservedGalleryUrls}">
                                            <div class="rt-gallery-item rt-gallery-item-preview">
                                                <img src="${pageContext.request.contextPath}/${preservedGalleryUrl}"
                                                     alt="Gallery preview"
                                                     onerror="this.onerror=null;this.src='${fallbackRoomImage}';"/>
                                                <span class="rt-preview-badge">New</span>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${mode == 'edit' && editing != null && not empty editing.galleryImages}">
                                            <c:forEach var="image" items="${editing.galleryImages}">
                                                <c:set var="deletedClass" value="" />
                                                <c:if test="${deletedGalleryImageIds != null && deletedGalleryImageIds.contains(image.imageId)}">
                                                    <c:set var="deletedClass" value=" is-hidden" />
                                                </c:if>
                                                <div class="rt-gallery-item${deletedClass}" data-existing-gallery-item="true" data-image-id="${image.imageId}">
                                                    <img src="${pageContext.request.contextPath}/${image.imageUrl}"
                                                         alt="Room image"
                                                         onerror="this.onerror=null;this.src='${fallbackRoomImage}';"/>
                                                    <button class="rt-delete-image"
                                                            type="button"
                                                            data-delete-gallery
                                                            data-image-id="${image.imageId}"
                                                            title="Remove image">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                    <div class="rt-gallery-empty ${(not empty preservedGalleryUrls) || (mode == 'edit' && editing != null && not empty editing.galleryImages) ? 'is-hidden' : ''}"
                                         id="rtGalleryEmpty"
                                         data-create-message="Upload one or more non-thumbnail images for this room type. Supported formats: JPG, JPEG, PNG. Files larger than 300 KB will be resized automatically."
                                         data-edit-message="No gallery images will remain after saving. You can add new JPG, JPEG, or PNG images before clicking Save Changes.">
                                        ${mode == 'edit' ? 'No gallery images will remain after saving. You can add new JPG, JPEG, or PNG images before clicking Save Changes.' : 'Upload one or more non-thumbnail images for this room type. Supported formats: JPG, JPEG, PNG. Files larger than 300 KB will be resized automatically.'}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="rt-panel">
                            <div class="rt-panel-head">
                                <h3>Basic Information</h3>
                                <p>Set the core details for this room type.</p>
                            </div>
                            <div class="rt-form-grid cols-4">
                                <label>Room Type Name *
                                    <input type="text" name="name" required
                                           value="${formValue != null ? formValue.name : (editing != null ? editing.name : '')}"/>
                                </label>
                                <label>Bed Type *
                                    <input type="text" name="bedType" placeholder="Ex: King Bed / Queen Bed" required
                                           value="${formValue != null ? formValue.bedType : (editing != null ? editing.bedType : '')}"/>
                                </label>
                                <label>View Type *
                                    <input type="text" name="viewType" placeholder="Ex: Ocean View / City View" required
                                           value="${formValue != null ? formValue.viewType : (editing != null ? editing.viewType : '')}"/>
                                </label>
                                <label>Room Size (sqm) *
                                    <input type="number" min="1" name="roomSize" required
                                           value="${formValue != null ? formValue.roomSize : (editing != null ? editing.roomSize : '')}"/>
                                </label>
                            </div>
                        </div>

                        <div class="rt-panel">
                            <div class="rt-panel-head">
                                <h3>Capacity And Pricing</h3>
                                <p>Set occupancy and price. The date range will be managed automatically by the system.</p>
                            </div>
                            <div class="rt-form-grid cols-2">
                                <label>Max Adults *
                                    <input type="number" min="1" name="maxAdult" required
                                           value="${formValue != null ? formValue.maxAdult : (editing != null ? editing.maxAdult : 2)}"/>
                                </label>
                                <label>Max Children *
                                    <input type="number" min="0" name="maxChildren" required
                                           value="${formValue != null ? formValue.maxChildren : (editing != null ? editing.maxChildren : 0)}"/>
                                </label>
                            </div>

                            <div class="rt-form-grid cols-2">
                                <label>Base Price *
                                    <input type="number" min="0" step="0.01" name="price" required
                                           value="${formValue != null ? formValue.price : (editing != null ? editing.currentPrice : '')}"/>
                                </label>
                                <div class="rt-static-note">
                                    <strong>Automatic Price Period</strong>
                                    <span>${mode == 'create' ? 'The first price starts from tomorrow. When you change the price later, the previous price period will be closed automatically.' : 'When you change the price, the new price starts today and the previous price period will be closed automatically.'}</span>
                                </div>
                            </div>
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
            </div>
        </div>
    </c:if>
</div>

<script>
(() => {
    const successAlert = document.getElementById('rtSuccessAlert');
    const searchForm = document.getElementById('rtSearchForm');
    const searchInput = document.getElementById('rtSearchInput');
    const searchPage = document.getElementById('rtSearchPage');
    const pageSizeSelect = document.getElementById('rtPageSizeSelect');
    const pageSizeForm = document.getElementById('rtPageSizeForm');
    const thumbnailInput = document.getElementById('rtThumbnailInput');
    const thumbnailPreview = document.getElementById('rtThumbnailPreview');
    const galleryInput = document.getElementById('rtGalleryInput');
    const galleryPreview = document.getElementById('rtGalleryPreview');
    const galleryEmpty = document.getElementById('rtGalleryEmpty');
    const clientImageError = document.getElementById('rtClientImageError');
    const deletedGalleryInputs = document.getElementById('rtDeletedGalleryInputs');
    const allowedImageExtensions = ['jpg', 'jpeg', 'png'];
    let searchTimer;

    if (successAlert) {
        window.setTimeout(() => {
            successAlert.style.display = 'none';
        }, 3000);
    }

    if (searchForm && searchInput) {
        if (document.activeElement !== searchInput) {
            searchInput.focus();
            const valueLength = searchInput.value.length;
            searchInput.setSelectionRange(valueLength, valueLength);
        }

        searchInput.addEventListener('input', () => {
            window.clearTimeout(searchTimer);
            searchTimer = window.setTimeout(() => {
                if (searchPage) {
                    searchPage.value = '1';
                }
                searchForm.submit();
            }, 350);
        });
    }

    if (pageSizeSelect && pageSizeForm) {
        pageSizeSelect.addEventListener('change', () => {
            pageSizeForm.submit();
        });
    }

    if (thumbnailInput && thumbnailPreview) {
        thumbnailInput.addEventListener('change', (event) => {
            const file = event.target.files && event.target.files[0];
            if (!file) return;
            if (!isAllowedImage(file)) {
                showClientImageError('Thumbnail only supports JPG, JPEG, or PNG files.');
                event.target.value = '';
                return;
            }
            clearClientImageError();

            const url = URL.createObjectURL(file);
            thumbnailPreview.innerHTML = '';
            const image = document.createElement('img');
            image.src = url;
            image.alt = 'Thumbnail preview';
            thumbnailPreview.appendChild(image);
        });
    }

    if (galleryInput && galleryPreview) {
        galleryInput.addEventListener('change', (event) => {
            const files = Array.from(event.target.files || []);
            if (!files.length) return;
            const invalidFile = files.find((file) => !isAllowedImage(file));
            if (invalidFile) {
                showClientImageError('Gallery images only support JPG, JPEG, or PNG files.');
                event.target.value = '';
                return;
            }
            clearClientImageError();

            files.forEach((file) => {
                const url = URL.createObjectURL(file);
                const item = document.createElement('div');
                item.className = 'rt-gallery-item rt-gallery-item-preview';
                const image = document.createElement('img');
                image.src = url;
                image.alt = 'Gallery preview';

                const badge = document.createElement('span');
                badge.className = 'rt-preview-badge';
                badge.textContent = 'New';

                item.appendChild(image);
                item.appendChild(badge);
                galleryPreview.appendChild(item);
            });

            if (galleryEmpty) {
                galleryEmpty.classList.add('is-hidden');
            }
        });
    }

    document.querySelectorAll('[data-delete-gallery]').forEach((button) => {
        button.addEventListener('click', () => {
            const imageId = button.dataset.imageId;
            const item = button.closest('.rt-gallery-item');
            if (!imageId || !item || !deletedGalleryInputs) {
                return;
            }

            if (!deletedGalleryInputs.querySelector(`input[value="${imageId}"]`)) {
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'deletedGalleryImageIds';
                hiddenInput.value = imageId;
                deletedGalleryInputs.appendChild(hiddenInput);
            }

            item.remove();
            toggleGalleryEmptyState();
        });
    });

    toggleGalleryEmptyState();

    function isAllowedImage(file) {
        const name = (file && file.name ? file.name : '').toLowerCase();
        const extension = name.includes('.') ? name.split('.').pop() : '';
        return allowedImageExtensions.includes(extension);
    }

    function showClientImageError(message) {
        if (!clientImageError) {
            return;
        }
        clientImageError.textContent = message;
        clientImageError.style.display = 'block';
    }

    function clearClientImageError() {
        if (!clientImageError) {
            return;
        }
        clientImageError.textContent = '';
        clientImageError.style.display = 'none';
    }

    function toggleGalleryEmptyState() {
        if (!galleryEmpty || !galleryPreview) {
            return;
        }
        const visibleItems = galleryPreview.querySelectorAll('.rt-gallery-item');
        const hasVisibleItems = visibleItems.length > 0;
        galleryEmpty.classList.toggle('is-hidden', hasVisibleItems);
        if (!hasVisibleItems) {
            const hasPendingDeletes = deletedGalleryInputs && deletedGalleryInputs.querySelector('input[name="deletedGalleryImageIds"]');
            galleryEmpty.textContent = hasPendingDeletes
                ? galleryEmpty.dataset.editMessage
                : galleryEmpty.dataset.createMessage;
        }
    }
})();
</script>
