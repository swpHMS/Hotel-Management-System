<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

    <style>
        :root {
            --cream:       #f5f0e8;
            --cream-dark:  #ede7d9;
            --cream-deep:  #e4dccf;
            --white:       #fdfaf5;
            --ink:         #1c1712;
            --ink-mid:     #4a3f35;
            --ink-light:   #8c7d6e;
            --ink-faint:   #c4b8a8;
            --gold:        #b5862a;
            --gold-hover:  #9a7024;
            --gold-pale:   #f0e0b8;
            --gold-bg:     #faf4e6;
            --green-bg:    #1a2f1e;
            --green-text:  #6fcf7e;
            --red-bg:      #2f1a1a;
            --red-text:    #f87171;
            --shadow:      rgba(28, 23, 18, 0.07);
            --font: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: var(--cream);
            color: var(--ink);
            font-family: var(--font);
        }

        .hms-page {
            padding: 28px 56px 48px;
        }

        /* ── Back link ── */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 12px;
            font-weight: 500;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-light);
            text-decoration: none;
            margin-bottom: 20px;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--gold); }

        /* ── Page top ── */
        .page-eyebrow {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 6px;
        }
        .hms-title {
            font-size: 30px;
            font-weight: 700;
            color: var(--ink);
            letter-spacing: -0.01em;
            margin-bottom: 20px;
        }

        /* ── Divider ── */
        .divider {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 28px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--ink-faint), transparent);
        }
        .divider__gem {
            width: 7px; height: 7px;
            border: 1.5px solid var(--gold);
            transform: rotate(45deg);
        }

        /* ── Section card ── */
        .section-card {
            background: var(--white);
            border: 1px solid var(--cream-deep);
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px var(--shadow);
        }

        .section-card__head {
            padding: 20px 28px;
            border-bottom: 1px solid var(--cream-dark);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-icon {
            width: 36px; height: 36px;
            border-radius: 8px;
            background: var(--gold-bg);
            border: 1px solid var(--gold-pale);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            color: var(--gold);
            font-size: 16px;
        }

        .section-title {
            font-size: 14px;
            font-weight: 700;
            color: var(--ink);
            margin-bottom: 2px;
        }

        .section-desc {
            font-size: 12px;
            color: var(--ink-light);
        }

        .section-card__body {
            padding: 24px 28px;
        }

        /* ── Field ── */
        .field {
            max-width: 440px;
        }

        .field-label {
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-light);
            margin-bottom: 8px;
        }

        .field-control {
            width: 100%;
            font-family: var(--font);
            font-size: 14px;
            font-weight: 500;
            color: var(--ink);
            background: var(--white);
            border: 1.5px solid var(--cream-deep);
            border-radius: 8px;
            padding: 11px 16px;
            outline: none;
            appearance: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .field-control:hover:not(:focus) {
            border-color: var(--ink-faint);
        }

        .field-control:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(181,134,42,0.14);
            background: var(--white);
        }

        select.field-control {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%238c7d6e' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            padding-right: 38px;
            cursor: pointer;
        }

        .field-hint {
            margin-top: 10px;
            padding: 10px 14px;
            background: var(--gold-bg);
            border: 1px solid var(--gold-pale);
            border-radius: 8px;
            font-size: 12px;
            color: var(--ink-mid);
            line-height: 1.6;
        }

        /* ── Status badge preview ── */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin-top: 12px;
        }
        .status-badge::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
            background: currentColor;
            flex-shrink: 0;
        }
        .status-badge.active   { background: var(--green-bg); color: var(--green-text); }
        .status-badge.inactive { background: var(--red-bg);   color: var(--red-text);   }

        /* ── Actions ── */
        .actions-bar {
            background: var(--white);
            border: 1px solid var(--cream-deep);
            border-radius: 12px;
            padding: 18px 28px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            box-shadow: 0 2px 8px var(--shadow);
        }

        .btn {
            padding: 10px 24px;
            border-radius: 8px;
            font-family: var(--font);
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.03em;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            transition: all 0.2s;
            white-space: nowrap;
        }

        .btn-ghost {
            border: 1.5px solid var(--cream-deep);
            background: transparent;
            color: var(--ink-mid);
        }
        .btn-ghost:hover {
            border-color: var(--ink-faint);
            background: var(--cream-dark);
        }

        .btn-primary {
            border: 1.5px solid var(--gold);
            background: var(--gold);
            color: #fff;
        }
        .btn-primary:hover {
            background: var(--gold-hover);
            border-color: var(--gold-hover);
        }

        /* ── Responsive ── */
        @media (max-width: 860px) {
            .hms-page { padding: 24px 16px 40px; }
            .section-card__head, .section-card__body { padding: 18px 20px; }
            .field { max-width: 100%; }
            .actions-bar { flex-direction: column; padding: 16px 20px; }
            .btn { width: 100%; justify-content: center; }
        }
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/view/admin_layout/sidebar.jsp" %>
    <div class="hms-main">
        <main class="hms-page">

            <a class="back-link" href="${pageContext.request.contextPath}/admin/staff/detail?id=${user.userId}">
                ← Staff Detail
            </a>

            <div class="page-eyebrow">Staff Management</div>
            <h1 class="hms-title">Edit Account</h1>

            <div class="divider"><div class="divider__gem"></div></div>

            <form method="post" action="${pageContext.request.contextPath}/admin/staff/edit">
                <input type="hidden" name="id" value="${user.userId}"/>

                <!-- Role -->
                <div class="section-card">
                    <div class="section-card__head">
                        <div class="section-icon">👤</div>
                        <div>
                            <div class="section-title">Role</div>
                            <div class="section-desc">Set the staff member's system role and permissions</div>
                        </div>
                    </div>
                    <div class="section-card__body">
                        <div class="field">
                            <div class="field-label">Role Selection</div>
                            <select name="roleId" class="field-control">
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.roleId}" ${r.roleId == user.roleId ? 'selected' : ''}>
                                        ${r.roleName}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="field-hint">
                                Changing the role will immediately update the user's permissions and access across the system.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Status -->
                <div class="section-card">
                    <div class="section-card__head">
                        <div class="section-icon">🔘</div>
                        <div>
                            <div class="section-title">Account Status</div>
                            <div class="section-desc">Enable or disable this account's access to HMS</div>
                        </div>
                    </div>
                    <div class="section-card__body">
                        <div class="field">
                            <div class="field-label">Status</div>
                            <select name="status" id="statusSelect" class="field-control">
                                <option value="1" ${user.status == 1 ? 'selected' : ''}>Active</option>
                                <option value="0" ${user.status == 0 ? 'selected' : ''}>Inactive</option>
                            </select>
                            <div class="field-hint">
                                Inactive accounts are immediately blocked from logging in and accessing any HMS resources.
                            </div>
                            <div id="statusBadge" class="status-badge ${user.status == 1 ? 'active' : 'inactive'}">
                                ${user.status == 1 ? 'Active Account' : 'Inactive Account'}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="actions-bar">
                    <a class="btn btn-ghost"
                       href="${pageContext.request.contextPath}/admin/staff/detail?id=${user.userId}">
                        Cancel
                    </a>
                    <button class="btn btn-primary" type="submit">
                        Save Changes
                    </button>
                </div>

            </form>

        </main>
        <%@ include file="/view/admin_layout/footer.jsp" %>
    </div>
</div>

<script>
    const sel = document.getElementById('statusSelect');
    const badge = document.getElementById('statusBadge');
    if (sel && badge) {
        sel.addEventListener('change', function () {
            const active = this.value === '1';
            badge.className = 'status-badge ' + (active ? 'active' : 'inactive');
            badge.textContent = active ? 'Active Account' : 'Inactive Account';
        });
    }
</script>
</body>
</html>
