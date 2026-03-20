<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>HMS Admin | Customer Detail</title>
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

            /* Buttons */
            .top-actions { display: flex; gap: 10px; flex-shrink: 0; }

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

            .btn-solid {
                border: 1.5px solid var(--ink);
                background: var(--ink);
                color: var(--white);
            }
            .btn-solid:hover {
                background: var(--gold);
                border-color: var(--gold);
            }

            .btn[disabled], .btn:disabled {
                opacity: 0.45;
                cursor: not-allowed;
                pointer-events: none;
            }

            /* Divider */
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

            /* Card */
            .detail-card {
                background: var(--white);
                border-radius: 4px;
                border: 1px solid var(--cream-deeper);
                box-shadow:
                    0 1px 3px var(--shadow-warm),
                    0 16px 40px -12px var(--shadow-warm);
                overflow: hidden;
                margin-bottom: 0;
            }

            /* Card header */
            .card-header {
                background: var(--ink);
                padding: 28px 48px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 16px;
            }

            .card-header__name {
                font-size: 26px;
                font-weight: 700;
                color: var(--cream);
                letter-spacing: -0.01em;
            }

            .card-header__meta {
                font-size: 12px;
                letter-spacing: 0.12em;
                text-transform: uppercase;
                color: var(--gold-light);
                margin-top: 5px;
                font-weight: 400;
            }

            /* Grid */
            .detail-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
            }

            .detail-col {
                padding: 40px 44px;
                border-right: 1px solid var(--cream-dark);
            }
            .detail-col:last-child { border-right: none; }

            /* Section label */
            .section-label {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 28px;
            }
            .section-label__line {
                width: 18px;
                height: 1px;
                background: var(--gold);
                flex-shrink: 0;
            }
            .section-label__text {
                font-size: 10px;
                font-weight: 700;
                letter-spacing: 0.2em;
                text-transform: uppercase;
                color: var(--gold);
            }

            /* Detail items */
            .detail-item {
                margin-bottom: 24px;
                padding: 12px 14px;
                margin-left: -14px;
                margin-right: -14px;
                border-radius: 4px;
                transition: background 0.15s;
            }
            .detail-item:hover { background: var(--cream); }
            .detail-item:last-child { margin-bottom: 0; }

            .detail-k {
                font-size: 11px;
                font-weight: 600;
                letter-spacing: 0.1em;
                text-transform: uppercase;
                color: var(--ink-faint);
                margin-bottom: 6px;
            }

            .detail-v {
                font-size: 15px;
                font-weight: 500;
                color: var(--ink);
                line-height: 1.5;
            }

            .detail-v.email {
                font-size: 14px;
                font-weight: 400;
                color: var(--gold);
                text-decoration: none;
            }
            .detail-v.email:hover { text-decoration: underline; }

            /* Pills */
            .pill {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 6px 14px;
                border-radius: 3px;
                font-family: var(--font);
                font-size: 11px;
                font-weight: 700;
                letter-spacing: 0.1em;
                text-transform: uppercase;
            }
            .pill::before {
                content: '';
                width: 6px;
                height: 6px;
                border-radius: 50%;
                flex-shrink: 0;
            }
            .pill.active   { background: #1a2f1e; color: #6fcf7e; }
            .pill.active::before { background: #6fcf7e; }
            .pill.inactive { background: #2f1a1a; color: #f87171; }
            .pill.inactive::before { background: #f87171; }
            .pill.gray     { background: var(--cream-dark); color: var(--ink-light); }
            .pill.gray::before { background: var(--ink-faint); }

            /* ID badge */
            .id-badge {
                display: inline-block;
                font-size: 13px;
                font-weight: 600;
                letter-spacing: 0.06em;
                color: var(--ink-mid);
                background: var(--cream);
                border: 1px solid var(--cream-deeper);
                padding: 4px 12px;
                border-radius: 3px;
            }

            /* Card footer */
            .card-footer {
                background: var(--cream);
                border-top: 1px solid var(--cream-dark);
                padding: 16px 48px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .card-footer__note { font-size: 11px; color: var(--ink-faint); letter-spacing: 0.06em; }
            .card-footer__dot  { width: 4px; height: 4px; background: var(--gold); border-radius: 50%; }

            /* Error state */
            .error-message {
                background: var(--white);
                border: 1px solid var(--cream-deeper);
                border-radius: 4px;
                padding: 28px 32px;
                color: var(--ink-light);
                font-size: 15px;
                font-weight: 500;
                box-shadow: 0 1px 3px var(--shadow-warm);
            }

            /* Responsive */
            @media (max-width: 860px) {
                .hms-page { padding: 32px 20px 48px; }
                .detail-grid { grid-template-columns: 1fr; }
                .detail-col { border-right: none; border-bottom: 1px solid var(--cream-dark); padding: 32px 24px; }
                .detail-col:last-child { border-bottom: none; }
                .hms-title { font-size: 26px; }
                .card-header { padding: 22px 24px; flex-direction: column; align-items: flex-start; }
                .card-footer { padding: 14px 24px; }
                .hms-page__top { flex-direction: column; align-items: stretch; }
                .top-actions { width: 100%; }
                .btn { width: 100%; justify-content: center; }
            }
        </style>
    </head>

    <body class="admin-shell">
        <div class="app-shell">
            <%@ include file="/view/admin_layout/sidebar.jsp" %>

            <div class="hms-main">
                <main class="hms-page">

                    <a class="back-link" href="${pageContext.request.contextPath}/admin/customers">← Customer List</a>

                    <div class="hms-page__top">
                        <div>
                            <div class="page-eyebrow">Customer Management</div>
                            <h1 class="hms-title">Customer Detail</h1>
                        </div>
                        <div class="top-actions">
                            <c:choose>
                                <c:when test="${c != null && c.userId != null}">
                                    <a class="btn btn-solid"
                                       href="${pageContext.request.contextPath}/admin/customer-status?id=${c.customerId}">
                                        Change Account Status
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-solid" disabled>Change Account Status</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="ornamental-divider">
                        <div class="ornamental-divider__gem"></div>
                    </div>

                    <c:if test="${c == null}">
                        <div class="error-message">Customer not found or has been removed.</div>
                    </c:if>

                    <c:if test="${c != null}">
                        <div class="detail-card">

                            <div class="card-header">
                                <div>
                                    <div class="card-header__name">${c.fullName}</div>
                                    <div class="card-header__meta">Customer &ensp;·&ensp; ID #${c.customerId}</div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${c.accountStatus == 'ACTIVE'}">
                                            <span class="pill active">Active</span>
                                        </c:when>
                                        <c:when test="${c.accountStatus == 'INACTIVE'}">
                                            <span class="pill inactive">Inactive</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill gray">No Account</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-grid">

                                <!-- Basic Information -->
                                <div class="detail-col">
                                    <div class="section-label">
                                        <div class="section-label__line"></div>
                                        <div class="section-label__text">Basic Information</div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Full Name</div>
                                        <div class="detail-v">${c.fullName}</div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Gender</div>
                                        <div class="detail-v">
                                            <c:choose>
                                                <c:when test="${c.gender == 1}">Male</c:when>
                                                <c:when test="${c.gender == 2}">Female</c:when>
                                                <c:when test="${c.gender == 3}">Other</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Date of Birth</div>
                                        <div class="detail-v">
                                            <c:choose>
                                                <c:when test="${c.dateOfBirth != null}">
                                                    <fmt:formatDate value="${c.dateOfBirth}" pattern="dd MMM yyyy"/>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Residence Address</div>
                                        <div class="detail-v">${c.residenceAddress != null ? c.residenceAddress : '—'}</div>
                                    </div>
                                </div>

                                <!-- Contact Information -->
                                <div class="detail-col">
                                    <div class="section-label">
                                        <div class="section-label__line"></div>
                                        <div class="section-label__text">Contact Information</div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Phone Number</div>
                                        <div class="detail-v">${c.phone != null ? c.phone : '—'}</div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Email Address</div>
                                        <div class="detail-v">
                                            <c:choose>
                                                <c:when test="${not empty c.email}">
                                                    <a class="detail-v email" href="mailto:${c.email}">${c.email}</a>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <!-- Account Details -->
                                <div class="detail-col">
                                    <div class="section-label">
                                        <div class="section-label__line"></div>
                                        <div class="section-label__text">Account Details</div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Account Status</div>
                                        <div class="detail-v">
                                            <c:choose>
                                                <c:when test="${c.accountStatus == 'ACTIVE'}">
                                                    <span class="pill active">Active</span>
                                                </c:when>
                                                <c:when test="${c.accountStatus == 'INACTIVE'}">
                                                    <span class="pill inactive">Inactive</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="pill gray">No Account</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">Customer ID</div>
                                        <div class="detail-v"><span class="id-badge">#${c.customerId}</span></div>
                                    </div>

                                    <div class="detail-item">
                                        <div class="detail-k">User ID</div>
                                        <div class="detail-v">
                                            <c:choose>
                                                <c:when test="${c.userId != null}">
                                                    <span class="id-badge">#${c.userId}</span>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                            </div><!-- /detail-grid -->

                            <div class="card-footer">
                                <span class="card-footer__note">HMS Hotel Management System</span>
                                <div class="card-footer__dot"></div>
                                <span class="card-footer__note">Customer Record</span>
                            </div>

                        </div><!-- /detail-card -->
                    </c:if>

                </main>

                <%@ include file="/view/admin_layout/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
