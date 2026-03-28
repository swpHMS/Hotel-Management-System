<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile | Regal Quintet HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Fraunces:wght@600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff/dashboard-styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff/room.css">

    <style>
        :root {
            --regal-cream: #f5f0e8;
            --regal-dark: #2c2416;
            --regal-gold: #b5832a;
            --regal-green: #5a7a5c;
            --card-bg: #faf7f2;
        }

        body {
            background-color: var(--regal-cream);
            font-family: 'DM Sans', sans-serif;
            color: var(--regal-dark);
        }

        .main-content {
            margin-left: 260px;
            width: calc(100% - 260px);
            min-height: 100vh;
            padding: 40px;
        }

        .card-custom {
            border-radius: 24px;
            border: 1px solid #e0d8cc;
            background: var(--card-bg);
            box-shadow: 0 10px 30px rgba(44,36,22,0.05);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #ede7da 0%, #faf7f2 100%);
            padding: 40px;
            border-bottom: 1px solid #e0d8cc;
        }

        .avatar-circle {
            width: 110px;
            height: 110px;
            background: var(--regal-dark);
            color: white;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            font-family: 'Fraunces', serif;
            text-transform: uppercase;
        }

        .info-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: #9c8e7a;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .info-value {
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--regal-dark);
        }

        .form-control {
            border-radius: 12px;
            border: 1.5px solid #e0d8cc;
            padding: 12px 15px;
            background-color: white;
            font-weight: 500;
        }

        .is-invalid {
            border-color: #dc3545 !important;
            background-color: #fff8f8 !important;
        }

        .invalid-feedback {
            color: #dc3545;
            font-size: 0.75rem;
            margin-top: 5px;
            display: none;
        }

        .is-invalid ~ .invalid-feedback {
            display: block;
        }

        .btn-edit {
            background-color: var(--regal-gold);
            color: white;
            border-radius: 12px;
            padding: 10px 25px;
            font-weight: bold;
            border: none;
            transition: 0.3s;
        }

        .btn-edit:hover {
            background-color: #966b20;
            transform: translateY(-2px);
        }

        .btn-save {
            background-color: var(--regal-green);
            color: white;
            border-radius: 100px;
            padding: 12px 35px;
            font-weight: bold;
            border: none;
            box-shadow: 0 4px 12px rgba(90,122,92,0.2);
            transition: 0.3s;
        }

        .edit-mode {
            display: none !important;
        }

        .edit-mode.active {
            display: block !important;
        }

        .view-mode.hidden {
            display: none !important;
        }

        .section-title {
            font-family: 'Fraunces', serif;
            font-size: 1.4rem;
            margin-bottom: 20px;
        }

        .password-card {
            margin-top: 28px;
            padding: 30px;
            border-top: 1px solid #e0d8cc;
            background: #fffdf9;
        }

        .password-note {
            margin-top: 10px;
            background: #f7fafc;
            border: 1px solid #eef2f7;
            border-radius: 12px;
            padding: 14px 16px;
            color: #64748b;
        }

        .password-note-title {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .8px;
            text-transform: uppercase;
            color: #94a3b8;
            margin: 0 0 10px;
        }

        .password-note ul {
            margin: 0;
            padding-left: 18px;
            font-size: 13px;
            line-height: 1.65;
        }
    </style>
</head>
<body>

<c:choose>
    <c:when test="${sessionScope.userAccount.roleId == 1}">
        <jsp:include page="../admin_layout/sidebar.jsp" />
    </c:when>
    <c:when test="${sessionScope.userAccount.roleId == 2}">
        <jsp:include page="../manager/sidebar.jsp" />
    </c:when>
    <c:when test="${sessionScope.userAccount.roleId == 3}">
        <jsp:include page="../receptionist/sidebar.jsp" />
    </c:when>
    <c:when test="${sessionScope.userAccount.roleId == 4}">
        <jsp:include page="sidebar_staff/sidebar_staff.jsp" />
    </c:when>
</c:choose>

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 style="font-family: 'Fraunces', serif; font-weight: 600; margin:0;">Staff Profile</h2>
            <button type="button" class="btn btn-edit" id="toggleEditBtn" onclick="toggleEdit()">
                <i class="bi bi-pencil-square me-2"></i> Edit Information
            </button>
        </div>

        <div class="card card-custom shadow-sm">
            <div class="profile-header d-flex align-items-center">
                <div class="avatar-circle me-4">
                    <c:set var="names" value="${fn:split(staff.fullName,' ')}"/>
                    <c:set var="first" value="${names[0]}"/>
                    <c:set var="last" value="${names[fn:length(names)-1]}"/>
                    ${fn:substring(first,0,1)}${fn:substring(last,0,1)}
                </div>
                <div>
                    <span class="badge-role mb-2 d-inline-block">${staff.roleName != null ? staff.roleName : 'RECEPTIONIST'}</span>
                    <h3 class="fw-bold mb-1" style="font-family: 'Fraunces', serif;">${staff.fullName}</h3>
                    <p class="text-muted m-0 small">
                        <i class="bi bi-upc-scan me-2"></i>Employee ID: #STF-${staff.staffId}
                    </p>
                </div>
            </div>

            <form action="staff-profile" method="POST" id="profileForm" class="p-4 p-md-5">
                <input type="hidden" name="staffId" value="${staff.staffId}">
                <input type="hidden" name="action" value="updateProfile">

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Full Name</div>
                            <div class="view-mode info-value">${staff.fullName}</div>
                            <div class="edit-mode">
                                <input type="text" name="fullName" id="fullNameInput" class="form-control"
                                       value="${staff.fullName}" oninput="checkName(this)">
                                <div class="invalid-feedback">Please enter a name containing only letters and spaces.</div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Email System</div>
                            <div class="info-value" style="color: #9c8e7a;">${staff.email}</div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Mobile Number</div>
                            <div class="view-mode info-value">${staff.phone}</div>
                            <div class="edit-mode">
                                <input type="text" name="phone" id="phoneInput" class="form-control"
                                       value="${staff.phone}" maxlength="10" oninput="checkPhone(this)">
                                <div class="invalid-feedback">Phone numbers must have 10 digits and begin with the number 0.</div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Gender</div>
                            <div class="view-mode info-value">
                                <c:choose>
                                    <c:when test="${staff.gender == 1}">Male</c:when>
                                    <c:when test="${staff.gender == 2}">Female</c:when>
                                    <c:otherwise>Other</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="edit-mode">
                                <select name="gender" class="form-select form-control">
                                    <option value="1" ${staff.gender == 1 ? 'selected' : ''}>Male</option>
                                    <option value="2" ${staff.gender == 2 ? 'selected' : ''}>Female</option>
                                    <option value="3" ${staff.gender == 3 ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Citizen ID Number</div>
                            <div class="view-mode info-value">${staff.identityNumber}</div>
                            <div class="edit-mode">
                                <input type="text" name="identityNumber" id="identityNumberInput" class="form-control"
                                       value="${staff.identityNumber}" maxlength="12" oninput="checkIdentityNumber(this)">
                                <div class="invalid-feedback">Citizen ID must contain exactly 12 digits.</div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <div class="mb-3">
                            <div class="info-label">Residence Address</div>
                            <div class="view-mode info-value">${staff.residenceAddress}</div>
                            <div class="edit-mode">
                                <textarea name="residenceAddress" class="form-control" rows="2">${staff.residenceAddress}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 edit-mode text-center border-top mt-5 pt-4">
                        <button type="button" class="btn btn-link text-muted text-decoration-none me-4 fw-bold" onclick="toggleEdit()">Discard Changes</button>
                        <button type="submit" class="btn btn-save shadow-sm">
                            <i class="bi bi-check-lg me-2"></i> Save Changes
                        </button>
                    </div>
                </div>
            </form>

            <div class="password-card">
                <h3 class="section-title">Change Password</h3>

                <form action="staff-profile" method="POST" id="passwordForm">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <div class="info-label">Current Password</div>
                                <input type="password" name="currentPassword" id="currentPassword" class="form-control" required>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="mb-3">
                                <div class="info-label">New Password</div>
                                <input type="password" name="newPassword" id="newPassword" class="form-control" required>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="mb-3">
                                <div class="info-label">Confirm New Password</div>
                                <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required>
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="password-note">
                                <div class="password-note-title">Password Requirements</div>
                                <ul>
                                    <li>Minimum 8 characters long</li>
                                    <li>Include at least one number</li>
                                    <li>Include at least one uppercase letter</li>
                                    <li>Must not contain spaces</li>
                                    <li>Must be different from your current password</li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-12 text-center mt-2">
                            <button type="submit" class="btn btn-save shadow-sm">
                                <i class="bi bi-shield-lock me-2"></i> Change Password
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function toggleEdit() {
        const views = document.querySelectorAll('.view-mode');
        const edits = document.querySelectorAll('.edit-mode');
        const btn = document.getElementById('toggleEditBtn');
        const isEditing = edits.length > 0 && edits[0].classList.contains('active');

        if (isEditing) {
            views.forEach(el => el.classList.remove('hidden'));
            edits.forEach(el => el.classList.remove('active'));
            btn.innerHTML = '<i class="bi bi-pencil-square me-2"></i> Edit Information';
            btn.classList.remove('btn-secondary');
            btn.classList.add('btn-edit');
        } else {
            views.forEach(el => el.classList.add('hidden'));
            edits.forEach(el => el.classList.add('active'));
            btn.innerHTML = '<i class="bi bi-x-lg me-2"></i> Cancel';
            btn.classList.remove('btn-edit');
            btn.classList.add('btn-secondary');
        }
    }

    function checkName(input) {
        const regex = /^[\p{L}\s]+$/u;
        const val = input.value;
        if (val.trim() === "" || regex.test(val)) {
            input.classList.remove('is-invalid');
        } else {
            input.classList.add('is-invalid');
        }
    }

    function checkPhone(input) {
        const regex = /^0\d{9}$/;
        const val = input.value;
        if (val.trim() === "" || regex.test(val)) {
            input.classList.remove('is-invalid');
        } else {
            input.classList.add('is-invalid');
        }
    }

    function checkIdentityNumber(input) {
        const regex = /^\d{12}$/;
        const val = input.value;
        if (val.trim() === "" || regex.test(val)) {
            input.classList.remove('is-invalid');
        } else {
            input.classList.add('is-invalid');
        }
    }

    document.getElementById('profileForm').onsubmit = function(e) {
        const nameInput = document.getElementById('fullNameInput');
        const phoneInput = document.getElementById('phoneInput');
        const identityInput = document.getElementById('identityNumberInput');

        checkName(nameInput);
        checkPhone(phoneInput);
        checkIdentityNumber(identityInput);

        if (nameInput.classList.contains('is-invalid')
                || phoneInput.classList.contains('is-invalid')
                || identityInput.classList.contains('is-invalid')) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Check Information',
                text: 'Please enter the correct format for Name, Phone Number, and Citizen ID.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }
        return true;
    };

    document.getElementById('passwordForm').onsubmit = function(e) {
        const currentPassword = document.getElementById('currentPassword').value.trim();
        const newPassword = document.getElementById('newPassword').value.trim();
        const confirmPassword = document.getElementById('confirmPassword').value.trim();

        if (!currentPassword || !newPassword || !confirmPassword) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Missing Information',
                text: 'Please fill in all password fields.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        if (newPassword.length < 8) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password',
                text: 'New password must be at least 8 characters long.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        if (/\s/.test(newPassword)) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password',
                text: 'New password must not contain spaces.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        if (!/[A-Z]/.test(newPassword)) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password',
                text: 'New password must include at least one uppercase letter.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        if (!/\d/.test(newPassword)) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password',
                text: 'New password must include at least one number.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        if (currentPassword === newPassword) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password',
                text: 'New password must be different from your current password.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        if (newPassword !== confirmPassword) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Password Mismatch',
                text: 'Confirm password does not match the new password.',
                confirmButtonColor: '#b5832a'
            });
            return false;
        }

        return true;
    };
</script>

<c:if test="${not empty sessionScope.flash_success}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: '${sessionScope.flash_success}',
            timer: 2200,
            showConfirmButton: false
        });
    </script>
    <c:remove var="flash_success" scope="session" />
</c:if>

<c:if test="${not empty sessionScope.flash_error}">
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: '${sessionScope.flash_error}',
            confirmButtonColor: '#b5832a'
        });
    </script>
    <c:remove var="flash_error" scope="session" />
</c:if>

</body>
</html>