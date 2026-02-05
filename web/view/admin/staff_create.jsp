<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>HMS Admin - Create Staff Account</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/enhanced-form.css"/>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    </head>

    <body>
        <div class="app-shell">
            <%@ include file="/view/admin_layout/sidebar.jsp" %>

            <div class="hms-main">


                <main class="hms-page">
                    <div class="hms-page__top">
                        <div class="page-header-content">

                            <h1 class="hms-title">
                                <i class="fas fa-user-plus title-icon"></i>
                                Create Staff Account
                            </h1>
                            <p class="hms-subtitle">Create a new staff user and staff profile in the system.</p>
                        </div>

                        <a class="btn btn-light btn-with-icon" href="${pageContext.request.contextPath}/admin/staff">
                            <i class="fas fa-arrow-left"></i>
                            Back to Staff List
                        </a>
                    </div>

                    <!-- Global messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <c:if test="${not empty errors.common}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${errors.common}</span>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span>${success}</span>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/admin/staff/create" class="hms-panel enhanced-form">

                        <!-- Account Information Section -->
                        <div class="form-section">
                            <div class="section-header">
                                <div class="section-icon">
                                    <i class="fas fa-key"></i>
                                </div>
                                <div>
                                    <h2 class="hms-h2">Account Information</h2>
                                    <p class="section-description">Login credentials and role assignment</p>
                                </div>
                            </div>

                            <div class="hms-form-grid">
                                <div class="field">
                                    <label>
                                        <i class="fas fa-envelope field-icon"></i>
                                        Email *
                                    </label>
                                    <input type="email" name="email" required value="${email}"
                                           placeholder="staff@example.com"
                                           class="${not empty errors.email ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.email}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.email}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>
                                        <i class="fas fa-user-tag field-icon"></i>
                                        Role *
                                    </label>
                                    <select name="roleId" required class="${not empty errors.roleId ? 'is-invalid' : ''}">
                                        <option value="">-- Select Role --</option>
                                        <c:forEach var="r" items="${roles}">
                                            <option value="${r.roleId}" ${roleId == r.roleId.toString() ? 'selected' : ''}>
                                                ${r.roleName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not empty errors.roleId}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.roleId}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>
                                        <i class="fas fa-lock field-icon"></i>
                                        Password *
                                    </label>
                                    <div class="password-wrapper">
                                        <input type="password" name="password" id="password" required minlength="6"
                                               placeholder="••••••••"
                                               class="${not empty errors.password ? 'is-invalid' : ''}">
                                        <button type="button" class="toggle-password" onclick="togglePassword('password')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="field-hint">
                                        <i class="fas fa-info-circle"></i>
                                        Minimum 6 characters
                                    </div>
                                    <c:if test="${not empty errors.password}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.password}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>
                                        <i class="fas fa-lock field-icon"></i>
                                        Confirm Password *
                                    </label>
                                    <div class="password-wrapper">
                                        <input type="password" name="confirmPassword" id="confirmPassword" required minlength="6"
                                               placeholder="••••••••"
                                               class="${not empty errors.confirmPassword ? 'is-invalid' : ''}">
                                        <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <c:if test="${not empty errors.confirmPassword}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.confirmPassword}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field status-field">
                                    <label>
                                        <i class="fas fa-check-circle field-icon"></i>
                                        Status
                                    </label>
                                    <div class="status-badge status-active">
                                        <i class="fas fa-circle"></i>
                                        ACTIVE
                                    </div>
                                    <div class="field-hint">
                                        <i class="fas fa-info-circle"></i>
                                        New staff accounts are created as ACTIVE
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="hms-hr"/>

                        <!-- Staff Profile Section -->
                        <!-- Staff Profile Section (FIX layout đồng bộ) -->
                        <div class="form-section">
                            <div class="section-header">
                                <div class="section-icon">
                                    <i class="fas fa-id-card"></i>
                                </div>
                                <div>
                                    <h2 class="hms-h2">Staff Profile</h2>
                                    <p class="section-description">Personal details and identity information</p>
                                </div>
                            </div>

                            <div class="hms-form-grid">
                                <div class="field">
                                    <label>Full Name *</label>
                                    <input type="text" name="fullName" required
                                           value="${fullName}"
                                           class="${not empty errors.fullName ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.fullName}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.fullName}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>Phone *</label>
                                    <input type="text" name="phone" required
                                           value="${phone}"
                                           class="${not empty errors.phone ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.phone}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.phone}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>Gender *</label>
                                    <select name="gender" required class="${not empty errors.gender ? 'is-invalid' : ''}">
                                        <option value="1" ${empty param.gender || param.gender == '1' ? 'selected' : ''}>Male</option>
                                        <option value="2" ${param.gender == '2' ? 'selected' : ''}>Female</option>
                                        <option value="3" ${param.gender == '3' ? 'selected' : ''}>Other</option>
                                    </select>
                                    <c:if test="${not empty errors.gender}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.gender}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>Date of Birth *</label>
                                    <input type="date" name="dob" required
                                           value="${dob}"
                                           class="${not empty errors.dob ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.dob}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.dob}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>Identity Number *</label>
                                    <input type="text" name="identityNumber" required
                                           value="${identityNumber}"
                                           class="${not empty errors.identityNumber ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.identityNumber}">
                                        <div class="field-error">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ${errors.identityNumber}
                                        </div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>Residence Address</label>
                                    <input type="text" name="address" value="${address}">
                                </div>
                            </div>
                        </div>

                        <div class="hms-actions">
                            <a class="btn btn-light btn-with-icon" href="${pageContext.request.contextPath}/admin/staff">
                                <i class="fas fa-times"></i>
                                Cancel
                            </a>
                            <button class="btn btn-primary btn-with-icon" type="submit">
                                <i class="fas fa-save"></i>
                                Create Staff Account
                            </button>
                        </div>
                    </form>
                </main>

                <%@ include file="/view/admin_layout/footer.jsp" %>
            </div>
        </div>

        <script>
            function togglePassword(inputId) {
                const input = document.getElementById(inputId);
                const button = input.nextElementSibling;
                const icon = button.querySelector('i');

                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            }
        </script>
    </body>
</html>
```__
