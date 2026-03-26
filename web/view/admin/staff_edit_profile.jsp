<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>HMS Admin | Edit Profile</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

        <style>
            :root {
                --cream:        #f5f0e8;
                --cream-dark:   #ede7d9;
                --cream-deeper: #e4dccf;
                --ink:          #1c1712;
                --ink-mid:      #4a3f35;
                --ink-light:    #8c7d6e;
                --ink-faint:    #c4b8a8;
                --gold:         #b5862a;
                --gold-light:   #d4a84b;
                --gold-pale:    #f0e0b8;
                --white:        #fdfaf5;
                --red:          #b91c1c;
                --red-pale:     #fef2f2;
                --red-border:   #fca5a5;
                --shadow-warm:  rgba(28, 23, 18, 0.08);
                --font: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
            }

            *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

            body {
                background-color: var(--cream);
                color: var(--ink);
                font-family: var(--font);
            }

            .hms-page {
                padding: 28px 56px 48px;
            }

            /* Back link */
            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 12px;
                font-weight: 500;
                letter-spacing: 0.12em;
                text-transform: uppercase;
                color: var(--ink-light);
                text-decoration: none;
                margin-bottom: 20px;
                transition: color 0.2s;
            }
            .back-link:hover { color: var(--gold); }

            /* Page top */
            .hms-page__top {
                display: flex;
                align-items: flex-end;
                justify-content: space-between;
                margin-bottom: 20px;
                gap: 16px;
                flex-wrap: wrap;
            }

            .page-eyebrow {
                font-size: 11px;
                font-weight: 600;
                letter-spacing: 0.2em;
                text-transform: uppercase;
                color: var(--gold);
                margin-bottom: 6px;
            }

            .hms-title {
                font-size: 32px;
                font-weight: 700;
                line-height: 1.1;
                color: var(--ink);
                letter-spacing: -0.01em;
            }

            /* Ornamental divider */
            .ornamental-divider {
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 24px;
            }
            .ornamental-divider::before,
            .ornamental-divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: linear-gradient(90deg, transparent, var(--ink-faint), transparent);
            }
            .ornamental-divider__gem {
                width: 7px;
                height: 7px;
                border: 1.5px solid var(--gold);
                transform: rotate(45deg);
                flex-shrink: 0;
            }

            /* Section card */
            .form-card {
                background: var(--white);
                border: 1px solid var(--cream-deeper);
                border-radius: 4px;
                box-shadow: 0 1px 3px var(--shadow-warm), 0 8px 24px -8px var(--shadow-warm);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .form-card__header {
                padding: 24px 40px;
                border-bottom: 1px solid var(--cream-dark);
                background: var(--cream);
                display: flex;
                align-items: center;
                gap: 14px;
            }

            .form-card__header-line {
                width: 18px;
                height: 1px;
                background: var(--gold);
                flex-shrink: 0;
            }

            .form-card__header-text {
                flex: 1;
            }

            .form-card__title {
                font-size: 13px;
                font-weight: 700;
                letter-spacing: 0.16em;
                text-transform: uppercase;
                color: var(--gold);
                margin-bottom: 3px;
            }

            .form-card__desc {
                font-size: 13px;
                color: var(--ink-light);
                font-weight: 400;
            }

            .form-card__body {
                padding: 32px 40px;
            }

            /* Grid */
            .grid-2 {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px 32px;
            }

            /* Field */
            .field { display: flex; flex-direction: column; }

            .label {
                font-size: 11px;
                font-weight: 700;
                letter-spacing: 0.14em;
                text-transform: uppercase;
                color: var(--ink-faint);
                margin-bottom: 8px;
            }

            .control {
                width: 100%;
                font-family: var(--font);
                font-size: 14px;
                font-weight: 500;
                color: var(--ink);
                background: var(--cream);
                border: 1.5px solid var(--cream-deeper);
                border-radius: 4px;
                padding: 10px 14px;
                outline: none;
                transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
                appearance: none;
            }

            .control:focus {
                border-color: var(--gold);
                background: var(--white);
                box-shadow: 0 0 0 3px rgba(181, 134, 42, 0.12);
            }

            .control:hover:not(:focus):not(.readonly) {
                border-color: var(--ink-faint);
            }

            .control.readonly,
            .control[readonly] {
                background: var(--cream-dark);
                border-color: var(--cream-deeper);
                color: var(--ink-light);
                cursor: not-allowed;
            }

            .control.is-invalid {
                border-color: var(--red) !important;
                box-shadow: 0 0 0 3px rgba(185, 28, 28, 0.1) !important;
            }

            select.control {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%238c7d6e' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 14px center;
                padding-right: 36px;
            }

            .hint {
                font-size: 12px;
                color: var(--ink-light);
                margin-top: 6px;
                font-style: italic;
            }

            .field-error {
                font-size: 12px;
                font-weight: 600;
                color: var(--red);
                margin-top: 6px;
            }

            /* Actions bar */
            .actions-bar {
                background: var(--white);
                border: 1px solid var(--cream-deeper);
                border-radius: 4px;
                padding: 20px 40px;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 12px;
                box-shadow: 0 1px 3px var(--shadow-warm);
            }

            .btn {
                padding: 10px 24px;
                border-radius: 4px;
                font-family: var(--font);
                font-size: 13px;
                font-weight: 600;
                letter-spacing: 0.04em;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                cursor: pointer;
                transition: background 0.2s, color 0.2s, border-color 0.2s;
                white-space: nowrap;
            }

            .btn-outline {
                border: 1.5px solid var(--ink-faint);
                background: transparent;
                color: var(--ink-mid);
            }
            .btn-outline:hover {
                border-color: var(--gold);
                color: var(--gold);
                background: var(--gold-pale);
            }

            .btn-solid {
                border: 1.5px solid var(--ink);
                background: var(--ink);
                color: var(--white);
            }
            .btn-solid:hover {
                background: var(--gold);
                border-color: var(--gold);
            }

            /* Responsive */
            @media (max-width: 860px) {
                .hms-page { padding: 32px 20px 48px; }
                .grid-2 { grid-template-columns: 1fr; }
                .form-card__header { padding: 20px 24px; }
                .form-card__body  { padding: 24px; }
                .actions-bar { padding: 16px 24px; flex-direction: column; align-items: stretch; }
                .btn { width: 100%; justify-content: center; }
                .hms-title { font-size: 26px; }
            }
        </style>
    </head>

    <body>
        <div class="app-shell">
            <%@ include file="/view/admin_layout/sidebar.jsp" %>
            <div class="hms-main">
                <main class="hms-page">

                    <a class="back-link" href="${pageContext.request.contextPath}/admin/staff/detail?id=${staff.userId}">← Staff Detail</a>

                    <div class="hms-page__top">
                        <div>
                            <div class="page-eyebrow">Staff Management</div>
                            <h1 class="hms-title">Edit Profile</h1>
                        </div>
                    </div>

                    <div class="ornamental-divider">
                        <div class="ornamental-divider__gem"></div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/admin/staff/edit-profile">
                        <input type="hidden" name="userId" value="${staff.userId}"/>

                        <!-- 1. Basic Information -->
                        <div class="form-card">
                            <div class="form-card__header">
                                <div class="form-card__header-line"></div>
                                <div class="form-card__header-text">
                                    <div class="form-card__title">Basic Information</div>
                                    <div class="form-card__desc">Essential personal details for identifying the staff member.</div>
                                </div>
                            </div>
                            <div class="form-card__body">
                                <div class="grid-2">

                                    <div class="field">
                                        <div class="label">Full Name</div>
                                        <input name="fullName" value="${staff.fullName}"
                                               class="control ${errors.fullName != null ? 'is-invalid' : ''}" required/>
                                        <c:if test="${errors.fullName != null}">
                                            <div class="field-error">${errors.fullName}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <div class="label">Gender</div>
                                        <select name="gender" class="control ${errors.gender != null ? 'is-invalid' : ''}">
                                            <option value="1" ${staff.gender == 1 ? 'selected' : ''}>Male</option>
                                            <option value="2" ${staff.gender == 2 ? 'selected' : ''}>Female</option>
                                            <option value="3" ${staff.gender == 3 ? 'selected' : ''}>Other</option>
                                        </select>
                                        <c:if test="${errors.gender != null}">
                                            <div class="field-error">${errors.gender}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <div class="label">Date of Birth</div>
                                        <input type="date" name="dateOfBirth"
                                               value="<fmt:formatDate value='${staff.dateOfBirth}' pattern='yyyy-MM-dd'/>"
                                               class="control ${errors.dateOfBirth != null ? 'is-invalid' : ''}"/>
                                        <c:if test="${errors.dateOfBirth != null}">
                                            <div class="field-error">${errors.dateOfBirth}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <div class="label">Residence Address</div>
                                        <input name="residenceAddress" value="${staff.residenceAddress}" class="control"/>
                                        <c:if test="${errors.residenceAddress != null}">
                                            <div class="field-error">${errors.residenceAddress}</div>
                                        </c:if>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <!-- 2. Identity & Contact -->
                        <div class="form-card">
                            <div class="form-card__header">
                                <div class="form-card__header-line"></div>
                                <div class="form-card__header-text">
                                    <div class="form-card__title">Identity &amp; Contact</div>
                                    <div class="form-card__desc">Contact information and system verification identifiers.</div>
                                </div>
                            </div>
                            <div class="form-card__body">
                                <div class="grid-2">

                                    <div class="field">
                                        <div class="label">Phone Number</div>
                                        <input name="phone" value="${staff.phone}"
                                               class="control ${errors.phone != null ? 'is-invalid' : ''}"/>
                                        <c:if test="${errors.phone != null}">
                                            <div class="field-error">${errors.phone}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <div class="label">Email Address</div>
                                        <input type="email" name="email" value="${staff.email}"
                                               class="control ${errors.email != null ? 'is-invalid' : ''}" required/>
                                        <c:if test="${errors.email != null}">
                                            <div class="field-error">${errors.email}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <div class="label">Identity Number</div>
                                        <input name="identityNumber" value="${staff.identityNumber}"
                                               class="control ${errors.identityNumber != null ? 'is-invalid' : ''}"/>
                                        <c:if test="${errors.identityNumber != null}">
                                            <div class="field-error">${errors.identityNumber}</div>
                                        </c:if>
                                        <div class="hint">Example: 012345678901 (CCCD/CMND).</div>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="actions-bar">
                            <a class="btn btn-outline"
                               href="${pageContext.request.contextPath}/admin/staff/detail?id=${staff.userId}">Cancel</a>
                            <button class="btn btn-solid" type="submit">Save Changes</button>
                        </div>

                    </form>

                </main>

                <%@ include file="/view/admin_layout/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
