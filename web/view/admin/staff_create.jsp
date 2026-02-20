<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>HMS Admin - Create Staff Account</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:         #f5f0e8;
            --bg2:        #ede7da;
            --paper:      #faf7f2;
            --border:     #e0d8cc;
            --border2:    #cfc6b8;
            --ink:        #2c2416;
            --ink-mid:    #5a4e3c;
            --ink-soft:   #9c8e7a;
            --gold:       #b5832a;
            --gold-lt:    #f0ddb8;
            --gold-bg:    rgba(181,131,42,.09);
            --sage:       #5a7a5c;
            --sage-lt:    #d4e6d4;
            --terra:      #c0614a;
            --terra-lt:   #f5d8d2;
            --sidebar-w:  280px;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--ink);
        }

        /* Sidebar */
        .hms-sidebar, aside.hms-sidebar, aside {
            position: fixed !important;
            top: 0; left: 0;
            width: var(--sidebar-w) !important;
            height: 100vh !important;
            overflow-y: auto !important;
            z-index: 9999;
        }
        .app-shell { display: flex; }
        .hms-main  { flex: 1; margin-left: var(--sidebar-w); }

        .hms-page {
            padding: 40px 44px 64px;
        }

        /* ── PAGE TOP ── */
        .hms-page__top {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 32px;
            animation: fadeDown .4s ease both;
        }
        @keyframes fadeDown {
            from { opacity:0; transform:translateY(-10px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .page-eyebrow {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .2em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 7px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .page-eyebrow::before {
            content: '';
            display: block;
            width: 22px; height: 1.5px;
            background: var(--gold);
        }
        .hms-title {
            font-family: 'Fraunces', serif !important;
            font-size: 40px !important;
            font-weight: 800 !important;
            color: var(--ink) !important;
            letter-spacing: -1px !important;
            line-height: 1 !important;
            margin: 0 !important;
        }

        /* Back button */
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 12px;
            background: var(--paper);
            border: 1.5px solid var(--border);
            color: var(--ink-mid);
            font-weight: 600;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
            transition: all .18s ease;
        }
        .btn-back:hover { background: var(--bg2); border-color: var(--border2); color: var(--ink); }

        /* ── ALERTS ── */
        .alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 18px;
            border-radius: 14px;
            font-size: 13.5px;
            font-weight: 600;
            margin-bottom: 20px;
            animation: slideUp .3s ease both;
        }
        @keyframes slideUp {
            from { opacity:0; transform:translateY(10px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .alert-danger  { background: var(--terra-lt); border: 1px solid rgba(192,97,74,.25); color: var(--terra); }
        .alert-success { background: var(--sage-lt);  border: 1px solid rgba(90,122,92,.25);  color: var(--sage); }

        /* ── FORM CARD ── */
        .form-card {
            background: var(--paper);
            border: 1px solid var(--border);
            border-radius: 22px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(44,36,22,.07);
            animation: slideUp .4s .05s ease both;
        }

        /* ── SECTION ── */
        .form-section {
            padding: 30px 32px;
        }
        .form-section + .form-section {
            border-top: 1px solid var(--border);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 24px;
        }
        .section-icon {
            width: 40px; height: 40px;
            border-radius: 12px;
            background: var(--gold-bg);
            border: 1px solid var(--gold-lt);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gold);
            font-size: 15px;
            flex-shrink: 0;
        }
        .section-title {
            font-family: 'Fraunces', serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--ink);
        }
        .section-sub {
            font-size: 12px;
            color: var(--ink-soft);
            margin-top: 2px;
        }

        /* ── FORM GRID ── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .field-full { grid-column: 1 / -1; }

        .field { display: flex; flex-direction: column; }
        .field label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .14em;
            text-transform: uppercase;
            color: var(--ink-soft);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .field label .field-icon { color: var(--gold); font-size: 11px; }

        .field input,
        .field select {
            height: 46px;
            padding: 0 14px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            background: var(--bg);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            color: var(--ink);
            outline: none;
            transition: border-color .18s, box-shadow .18s, background .18s;
            appearance: none;
        }
        .field input:focus,
        .field select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            background: var(--paper);
        }
        .field input::placeholder { color: var(--ink-soft); }
        .field input.is-invalid,
        .field select.is-invalid {
            border-color: var(--terra);
            background: #fdf5f3;
        }
        .field input.is-invalid:focus,
        .field select.is-invalid:focus {
            box-shadow: 0 0 0 3px rgba(192,97,74,.12);
        }

        /* Password wrapper */
        .password-wrapper {
            position: relative;
        }
        .password-wrapper input { padding-right: 46px; width: 100%; }
        .toggle-password {
            position: absolute;
            right: 1px; top: 1px;
            height: calc(100% - 2px);
            width: 42px;
            border: none;
            background: transparent;
            color: var(--ink-soft);
            cursor: pointer;
            border-radius: 0 11px 11px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color .18s;
        }
        .toggle-password:hover { color: var(--gold); }

        /* Hints & errors */
        .field-hint {
            margin-top: 6px;
            font-size: 11.5px;
            color: var(--ink-soft);
            display: flex;
            align-items: flex-start;
            gap: 5px;
        }
        .field-hint i { margin-top: 1px; flex-shrink: 0; }
        .field-error {
            margin-top: 6px;
            font-size: 11.5px;
            font-weight: 600;
            color: var(--terra);
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Status badge */
        .status-active {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 10px 16px;
            background: var(--sage-lt);
            border: 1px solid rgba(90,122,92,.2);
            border-radius: 12px;
            color: var(--sage);
            font-size: 13px;
            font-weight: 700;
            letter-spacing: .08em;
            width: fit-content;
            margin-top: 2px;
        }
        .status-active i { font-size: 8px; }

        /* ── FORM ACTIONS ── */
        .form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            padding: 22px 32px;
            background: var(--bg2);
            border-top: 1px solid var(--border);
        }
        .btn-cancel {
            padding: 12px 22px;
            border-radius: 12px;
            background: transparent;
            border: 1.5px solid var(--border);
            color: var(--ink-mid);
            font-weight: 700;
            font-size: 13.5px;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all .18s;
        }
        .btn-cancel:hover { background: var(--bg); border-color: var(--border2); color: var(--ink); }
        .btn-submit {
            padding: 12px 26px;
            border-radius: 12px;
            background: var(--ink);
            color: #fff;
            font-weight: 700;
            font-size: 13.5px;
            font-family: 'DM Sans', sans-serif;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 16px rgba(44,36,22,.2);
            transition: transform .18s ease, box-shadow .18s ease, opacity .18s;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(44,36,22,.28);
        }

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .field-full { grid-column: 1; }
            .hms-page { padding: 24px 20px 48px; }
        }
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/view/admin_layout/sidebar.jsp" %>

    <div class="hms-main">
        <main class="hms-page">

            <!-- Page Top -->
            <div class="hms-page__top">
                <div>
                    <div class="page-eyebrow">Human Resources</div>
                    <h1 class="hms-title">Create Staff Account</h1>
                </div>
                <a class="btn-back" href="${pageContext.request.contextPath}/admin/staff">
                    <i class="fas fa-arrow-left" style="font-size:12px;"></i>
                    Back to Staff List
                </a>
            </div>

            <!-- Alerts -->
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

            <!-- Form -->
            <form method="post" action="${pageContext.request.contextPath}/admin/staff/create">
                <div class="form-card">

                    <!-- Section 1: Account Information -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon"><i class="fas fa-key"></i></div>
                            <div>
                                <div class="section-title">Account Information</div>
                                <div class="section-sub">Login credentials and access role</div>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label>
                                    <i class="fas fa-envelope field-icon"></i>
                                    Email *
                                </label>
                                <input type="email" name="email" required value="${email}"
                                       placeholder="staff@example.com"
                                       class="${not empty errors.email ? 'is-invalid' : ''}">
                                <c:if test="${not empty errors.email}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.email}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>
                                    <i class="fas fa-user-tag field-icon"></i>
                                    Role *
                                </label>
                                <select name="roleId" required class="${not empty errors.roleId ? 'is-invalid' : ''}">
                                    <option value="">— Select Role —</option>
                                    <c:forEach var="r" items="${roles}">
                                        <option value="${r.roleId}" ${roleId == r.roleId.toString() ? 'selected' : ''}>
                                            ${r.roleName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty errors.roleId}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.roleId}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>
                                    <i class="fas fa-lock field-icon"></i>
                                    Password *
                                </label>
                                <div class="password-wrapper">
                                    <input type="password" name="password" id="password" required
                                           minlength="8"
                                           pattern="^(?=.*[A-Z])(?=.*\d)\S{8,}$"
                                           placeholder="••••••••"
                                           class="${not empty errors.password ? 'is-invalid' : ''}">
                                    <button type="button" class="toggle-password" onclick="togglePassword('password')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="field-hint">
                                    <i class="fas fa-info-circle"></i>
                                    Min 8 chars, 1 uppercase, 1 number, no spaces
                                </div>
                                <c:if test="${not empty errors.password}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.password}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>
                                    <i class="fas fa-lock field-icon"></i>
                                    Confirm Password *
                                </label>
                                <div class="password-wrapper">
                                    <input type="password" name="confirmPassword" id="confirmPassword" required
                                           placeholder="••••••••"
                                           class="${not empty errors.confirmPassword ? 'is-invalid' : ''}">
                                    <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty errors.confirmPassword}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.confirmPassword}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>
                                    <i class="fas fa-check-circle field-icon"></i>
                                    Account Status
                                </label>
                                <div class="status-active">
                                    <i class="fas fa-circle"></i>
                                    Active
                                </div>
                                <div class="field-hint">
                                    <i class="fas fa-info-circle"></i>
                                    New accounts are created as Active by default
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Section 2: Staff Profile -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon"><i class="fas fa-id-card"></i></div>
                            <div>
                                <div class="section-title">Staff Profile</div>
                                <div class="section-sub">Personal information and contact details</div>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label>Full Name *</label>
                                <input type="text" name="fullName" required value="${fullName}"
                                       placeholder="Enter full name"
                                       class="${not empty errors.fullName ? 'is-invalid' : ''}">
                                <c:if test="${not empty errors.fullName}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.fullName}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>Phone *</label>
                                <input type="text" name="phone" required value="${phone}"
                                       placeholder="e.g. 0912 345 678"
                                       class="${not empty errors.phone ? 'is-invalid' : ''}">
                                <c:if test="${not empty errors.phone}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.phone}</div>
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
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.gender}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>Date of Birth *</label>
                                <input type="date" name="dob" required value="${dob}"
                                       class="${not empty errors.dob ? 'is-invalid' : ''}">
                                <c:if test="${not empty errors.dob}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.dob}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>Identity Number *</label>
                                <input type="text" name="identityNumber" required value="${identityNumber}"
                                       placeholder="National ID / Passport"
                                       class="${not empty errors.identityNumber ? 'is-invalid' : ''}">
                                <c:if test="${not empty errors.identityNumber}">
                                    <div class="field-error"><i class="fas fa-exclamation-triangle"></i> ${errors.identityNumber}</div>
                                </c:if>
                            </div>

                            <div class="field">
                                <label>Residence Address</label>
                                <input type="text" name="address" value="${address}"
                                       placeholder="Street, district, city…">
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="form-actions">
                        <a class="btn-cancel" href="${pageContext.request.contextPath}/admin/staff">
                            Cancel
                        </a>
                        <button class="btn-submit" type="submit">
                            <i class="fas fa-user-plus" style="font-size:13px;"></i>
                            Create Staff Account
                        </button>
                    </div>

                </div>
            </form>

        </main>
        <%@ include file="/view/admin_layout/footer.jsp" %>
    </div>
</div>

<script>
    function togglePassword(inputId) {
        const input = document.getElementById(inputId);
        const btn   = input.nextElementSibling;
        const icon  = btn.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }
</script>
</body>
</html>
