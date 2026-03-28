<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="ep">
    <div class="ep-head">
        <div class="ep-left">
            <div class="ep-avatar">${initials != null ? initials : 'U'}</div>
            <div class="ep-meta">
                <div class="ep-title">Edit Profile</div>
                <div class="ep-sub">
                    Update your personal information. Fields marked * are required.
                </div>
            </div>
        </div>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty flash_error}">
        <div class="ep-alert ep-alert--error">
            <span class="ep-alertIcon">⚠</span>
            <span>${flash_error}</span>
        </div>
    </c:if>

    <c:if test="${not empty flash_success}">
        <div class="ep-alert ep-alert--success">
            <span class="ep-alertIcon">✓</span>
            <span>${flash_success}</span>
        </div>
    </c:if>

    <form class="ep-card" method="post"
          action="${pageContext.request.contextPath}/customer/profile/edit">

        <div class="ep-cardHead">Personal Information</div>

        <div class="ep-body">
            <div class="ep-grid">

                <!-- Full Name -->
                <div class="ep-field">
                    <label class="ep-label" for="fullName">Full Name *</label>
                    <input class="ep-input" id="fullName" name="fullName" type="text"
                           value="${not empty form_fullName ? form_fullName : profile.fullName}"
                           placeholder="Your full name" required>
                </div>

                <!-- Email (read-only) -->
                <div class="ep-field">
                    <label class="ep-label" for="email">Email</label>
                    <input class="ep-input" id="email" name="email" type="email"
                           value="${profile.email}" readonly>
                </div>

                <!-- Phone -->
                <div class="ep-field">
                    <label class="ep-label" for="phone">Phone Number</label>
                    <input class="ep-input" id="phone" name="phone" type="text"
                           value="${not empty form_phone ? form_phone : profile.phone}"
                           placeholder="e.g. 0987654321"
                           inputmode="numeric"
                           required>
                    <div class="ep-help">Vietnam format: exactly 10 digits, starting with 0.</div>
                </div>

                <div class="ep-field">
                    <label class="ep-label" for="identityNumber">Identity Number</label>
                    <input class="ep-input" id="identityNumber" name="identityNumber" type="text"
                           value="${not empty form_identity ? form_identity : profile.identityNumber}"
                           placeholder="12 digits">
                    <div class="ep-help">If provided, identity number must contain exactly 12 digits.</div>
                </div>

                <!-- Gender -->
                <c:set var="g" value="${not empty form_gender ? form_gender : profile.gender}" />
                <c:set var="gStr" value="${g != null ? g.toString() : ''}" />

                <div class="ep-field">
                    <label class="ep-label" for="gender">Gender</label>
                    <select class="ep-input" id="gender" name="gender">
                        <option value="" ${empty gStr ? 'selected' : ''}>— Select —</option>
                        <option value="1" ${gStr eq '1' ? 'selected' : ''}>Male</option>
                        <option value="2" ${gStr eq '2' ? 'selected' : ''}>Female</option>
                        <option value="3" ${gStr eq '3' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <!-- DOB -->
                <c:choose>
                    <c:when test="${not empty form_dob}">
                        <c:set var="dobVal" value="${form_dob}" />
                    </c:when>
                    <c:otherwise>
                        <fmt:formatDate value="${profile.dateOfBirth}" pattern="yyyy-MM-dd" var="dobVal"/>
                    </c:otherwise>
                </c:choose>

                <div class="ep-field">
                    <label class="ep-label" for="dateOfBirth">Date of Birth</label>
                    <input class="ep-input" id="dateOfBirth" name="dateOfBirth" type="date"
                           value="${dobVal}">
                </div>

                <!-- Address -->
                <div class="ep-field ep-span2">
                    <label class="ep-label" for="residenceAddress">Residence Address</label>
                    <textarea class="ep-input ep-textarea"
                              id="residenceAddress"
                              name="residenceAddress"
                              rows="3"
                              placeholder="Your address">${not empty form_address ? form_address : profile.residenceAddress}</textarea>
                </div>

            </div>

            <div class="ep-actions">
                <a class="ep-btn ep-btn--ghost"
                   href="${pageContext.request.contextPath}/customer/profile">
                    Cancel
                </a>

                <button class="ep-btn ep-btn--primary" type="submit">
                    Save changes
                </button>
            </div>
        </div>
    </form>
</div>
