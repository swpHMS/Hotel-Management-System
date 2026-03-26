<%-- 
    Document   : policy_list
    Created on : Feb 18, 2026
    Author     : DieuBHHE191686
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>HMS Admin | Terms & Policies</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,600;0,9..144,800;1,9..144,400&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            :root {
                --ink:       #2c2416;
                --ink-mid:   #5a4e3c;
                --ink-soft:  #9c8e7a;
                --cream:     #f5f0e8;
                --bg2:       #ede7da;
                --paper:     #faf7f2;
                --gold:      #b5832a;
                --gold-lt:   #f0ddb8;
                --gold-bg:   rgba(181,131,42,.09);
                --border:    #e0d8cc;
                --border2:   #cfc6b8;
                --sidebar-w: 280px;
                --radius:    20px;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--cream);
                color: var(--ink);
                overflow-x: hidden;
            }

            /* ── SIDEBAR OVERRIDE ── */
            .hms-sidebar, aside.hms-sidebar, aside {
                position: fixed !important;
                top: 0;
                left: 0;
                width: var(--sidebar-w) !important;
                height: 100vh !important;
                overflow-y: auto !important;
                z-index: 9999;
            }

            /* ── MAIN WRAP ── */
            .wrap {
                margin-left: var(--sidebar-w);
                padding: 40px 44px;
                min-height: 100vh;
            }

            /* ── PAGE HEADER ── */
            .page-header {
                display: flex;
                align-items: flex-end;
                justify-content: space-between;
                margin-bottom: 28px;
                animation: fadeDown .4s ease both;
            }
            @keyframes fadeDown {
                from {
                    opacity:0;
                    transform:translateY(-10px);
                }
                to   {
                    opacity:1;
                    transform:translateY(0);
                }
            }
            .eyebrow {
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
            .eyebrow::before {
                content: '';
                display: block;
                width: 22px;
                height: 1.5px;
                background: var(--gold);
            }
            .page-title {
                font-family: 'Fraunces', serif;
                font-size: 38px;
                font-weight: 800;
                color: var(--ink);
                line-height: 1;
                letter-spacing: -1px;
            }

            /* ── TAB NAV ── */
            .tab-nav {
                display: flex;
                gap: 4px;
                background: var(--paper);
                border: 1px solid var(--border);
                padding: 5px;
                border-radius: 14px;
                box-shadow: 0 2px 10px rgba(44,36,22,.05);
            }
            .tab-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 700;
                font-size: 13.5px;
                color: var(--ink-mid);
                transition: all .18s ease;
            }
            .tab-link:hover {
                background: var(--bg2);
                color: var(--ink);
            }
            .tab-link.is-active {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 14px rgba(44,36,22,.22);
            }
            .tab-link .tab-icon {
                width: 15px;
                height: 15px;
                opacity: .75;
            }

            /* ── CARD ── */
            .card {
                background: var(--paper);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                box-shadow: 0 4px 24px rgba(44,36,22,.07);
                overflow: hidden;
                animation: slideUp .4s ease both;
            }
            @keyframes slideUp {
                from {
                    opacity:0;
                    transform:translateY(16px);
                }
                to   {
                    opacity:1;
                    transform:translateY(0);
                }
            }

            .layout {
                display: grid;
                grid-template-columns: 270px 1fr;
                min-height: 680px;
            }

            /* ── LEFT PANEL ── */
            .left-panel {
                background: var(--bg2);
                border-right: 1px solid var(--border);
                padding: 20px 14px 24px;
                display: flex;
                flex-direction: column;
                gap: 0;
            }

            .panel-label-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 4px 14px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 14px;
            }

            .panel-label {
                font-size: 10px;
                font-weight: 800;
                letter-spacing: .2em;
                text-transform: uppercase;
                color: var(--ink-soft);
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .panel-label::before {
                content: '';
                display: block;
                width: 14px;
                height: 1.5px;
                background: var(--ink-soft);
                border-radius: 2px;
            }

            .add-policy-btn {
                width: 30px;
                height: 30px;
                border: 0;
                border-radius: 50%;
                background: var(--ink);
                color: #fff;
                font-size: 19px;
                font-weight: 300;
                line-height: 1;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background .18s ease, transform .28s ease;
                flex-shrink: 0;
            }
            .add-policy-btn:hover {
                background: var(--gold);
                color: var(--ink);
                transform: scale(1.08) rotate(90deg);
            }

            /* ── ADD / RENAME FORMS ── */
            .add-policy-form,
            .rename-policy-form {
                background: var(--paper);
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 10px;
                margin: 0 2px 10px;
            }

            .policy-input {
                width: 100%;
                border: 1px solid var(--border2);
                border-radius: 10px;
                padding: 10px 12px;
                font-size: 13px;
                outline: none;
                background: #fff;
                color: var(--ink);
                font-family: 'DM Sans', sans-serif;
            }
            .policy-input:focus {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            }

            .policy-form-actions {
                margin-top: 8px;
                display: flex;
                gap: 8px;
            }

            .mini-btn {
                border: 0;
                border-radius: 9px;
                padding: 7px 10px;
                font-size: 12px;
                font-weight: 700;
                cursor: pointer;
                font-family: 'DM Sans', sans-serif;
            }
            .mini-btn-save {
                background: var(--ink);
                color: #fff;
            }
            .mini-btn-save:hover {
                opacity: .9;
            }
            .mini-btn-cancel {
                background: var(--bg2);
                color: var(--ink-mid);
            }
            .mini-btn-cancel:hover {
                background: var(--border);
            }

            /* ── POLICY LIST ── */
            .policy-list {
                display: flex;
                flex-direction: column;
                gap: 3px;
            }

            .policy-row {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 4px 4px 4px 2px;
                border-radius: 14px;
            }

            .policy-link {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 11px 13px;
                border-radius: 12px;
                text-decoration: none;
                color: var(--ink-mid);
                font-weight: 600;
                font-size: 13px;
                transition: background .18s ease, color .16s ease, transform .16s ease;
            }
            .policy-link:hover {
                background: var(--paper);
                color: var(--ink);
                transform: translateX(2px);
            }
            .policy-row.active .policy-link {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 18px rgba(44,36,22,.18);
            }

            .nav-name {
                flex: 1;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 140px;
            }

            /* Arrow indicator */
            .nav-arrow {
                font-size: 15px;
                opacity: 0;
                transition: opacity .16s ease, transform .16s ease;
                flex-shrink: 0;
            }
            .policy-link:hover .nav-arrow {
                opacity: .5;
                transform: translateX(2px);
            }
            .policy-row.active .policy-link .nav-arrow {
                opacity: .65;
                color: var(--gold-lt);
            }

            /* Action buttons — hidden until row hover */
            .policy-actions {
                display: flex;
                align-items: center;
                gap: 4px;
                opacity: 0;
                transition: opacity .18s ease;
                flex-shrink: 0;
            }
            .policy-row:hover .policy-actions {
                opacity: 1;
            }

            .icon-btn {
                width: 28px;
                height: 28px;
                border: 1px solid var(--border);
                background: var(--paper);
                color: var(--ink-soft);
                border-radius: 9px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background .16s ease, color .16s ease, border-color .16s ease;
                flex-shrink: 0;
            }
            .icon-btn:hover {
                background: var(--bg2);
                color: var(--ink);
            }
            .icon-btn.danger:hover {
                background: #fbe9e9;
                color: #b42318;
                border-color: #f2b8b5;
            }

            /* ── RIGHT PANEL ── */
            .right-panel {
                padding: 32px 36px;
                display: flex;
                flex-direction: column;
            }

            .section-header {
                display: flex;
                align-items: flex-start;
                justify-content: space-between;
                margin-bottom: 6px;
            }
            .section-title {
                font-family: 'Fraunces', serif;
                font-size: 26px;
                font-weight: 700;
                color: var(--ink);
                line-height: 1.2;
            }
            .section-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 5px 12px;
                background: var(--gold-bg);
                color: var(--gold);
                border: 1px solid var(--gold-lt);
                border-radius: 100px;
                font-size: 11px;
                font-weight: 800;
                letter-spacing: .08em;
                margin-top: 4px;
            }
            .badge-dot {
                width: 6px;
                height: 6px;
                background: var(--gold);
                border-radius: 50%;
            }

            .divider {
                height: 1px;
                background: var(--border);
                margin: 20px 0;
            }

            /* ── EDITOR ── */
            .editor-shell {
                flex: 1;
                display: flex;
                flex-direction: column;
                border: 1.5px solid var(--border);
                border-radius: 16px;
                overflow: hidden;
                transition: border-color .2s, box-shadow .2s;
            }
            .editor-shell:focus-within {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            }
            .editor-toolbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 16px;
                background: var(--bg2);
                border-bottom: 1px solid var(--border);
            }
            .editor-label {
                font-size: 10px;
                font-weight: 800;
                letter-spacing: .2em;
                text-transform: uppercase;
                color: var(--ink-soft);
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .editor-label::before {
                content: '';
                display: inline-block;
                width: 8px;
                height: 8px;
                background: var(--gold);
                border-radius: 50%;
            }
            .char-count {
                font-size: 11px;
                color: var(--ink-soft);
                font-weight: 500;
            }
            textarea {
                flex: 1;
                width: 100%;
                min-height: 460px;
                padding: 20px 22px;
                border: 0;
                outline: none;
                resize: vertical;
                font-family: 'DM Sans', sans-serif;
                font-size: 14px;
                line-height: 1.75;
                color: var(--ink);
                background: var(--paper);
            }
            textarea::placeholder {
                color: var(--ink-soft);
            }

            /* ── FOOTER ACTIONS ── */
            .actions {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding-top: 20px;
            }
            .last-edited {
                font-size: 12px;
                color: var(--ink-soft);
                font-weight: 500;
            }
            .btn-group {
                display: flex;
                gap: 10px;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 12px 22px;
                border-radius: 12px;
                font-family: 'DM Sans', sans-serif;
                font-weight: 700;
                font-size: 13.5px;
                cursor: pointer;
                border: 0;
                transition: all .18s ease;
            }
            .btn-ghost {
                background: transparent;
                color: var(--ink-mid);
                border: 1.5px solid var(--border);
            }
            .btn-ghost:hover {
                background: var(--bg2);
                border-color: var(--border2);
                color: var(--ink);
            }
            .btn-primary {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 16px rgba(44,36,22,.2);
            }
            .btn-primary:hover {
                opacity: .88;
                transform: translateY(-1px);
                box-shadow: 0 8px 24px rgba(44,36,22,.28);
            }
            .btn-primary:active {
                transform: translateY(0);
            }

            /* ── TOAST ── */
            #toast {
                position: fixed;
                bottom: 32px;
                right: 32px;
                background: var(--ink);
                color: #fff;
                padding: 14px 22px;
                border-radius: 14px;
                font-size: 13px;
                font-weight: 600;
                box-shadow: 0 8px 30px rgba(44,36,22,.25);
                transform: translateY(20px);
                opacity: 0;
                pointer-events: none;
                transition: all .3s cubic-bezier(.22,.68,0,1.2);
                display: flex;
                align-items: center;
                gap: 10px;
                z-index: 99999;
            }
            #toast.show {
                opacity: 1;
                transform: translateY(0);
            }
            #toast .toast-icon {
                color: var(--gold);
                font-size: 16px;
            }
        </style>
    </head>

    <body>

        <jsp:include page="/view/admin_layout/sidebar.jsp"/>

        <div class="wrap">

            <!-- Page Header -->
            <div class="page-header">
                <div class="page-header-left">
                    <div class="eyebrow">System Configuration</div>
                    <h1 class="page-title">Terms and Policies</h1>
                </div>

                <!-- Tab Nav -->
                <nav class="tab-nav">
                    <a class="tab-link is-active"
                       href="${pageContext.request.contextPath}/admin/policies?key=${activeKey}">
                        <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                        Terms and Policies
                    </a>
                    <a class="tab-link"
                       href="${pageContext.request.contextPath}/admin/templates">
                        <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                        Email Templates
                    </a>
                </nav>
            </div>

            <!-- Main Card -->
            <div class="card">
                <div class="layout">

                    <!-- LEFT: Policy Nav -->
                    <div class="left-panel">

                        <div class="panel-label-row">
                            <span class="panel-label">Policy Sections</span>
                            <button type="button" class="add-policy-btn" onclick="toggleAddPolicyForm()" title="Add Policy Section">+</button>
                        </div>

                        <div id="addPolicyForm" class="add-policy-form" style="display:none;">
                            <form method="post" action="${pageContext.request.contextPath}/admin/policies">
                                <input type="hidden" name="action" value="addPolicy"/>
                                <input type="text"
                                       name="newPolicyName"
                                       class="policy-input"
                                       placeholder="New section name…"
                                       required />

                                <textarea name="content"
                                          class="policy-textarea"
                                          placeholder="Enter policy content..."
                                          required></textarea>

                                <div class="policy-form-actions">
                                    <button type="submit" class="mini-btn mini-btn-save">Add</button>
                                    <button type="button"
                                            class="mini-btn mini-btn-cancel"
                                            onclick="toggleAddPolicyForm(false)">
                                        Cancel
                                    </button>
                                </div>
                            </form>
                        </div>

                        <div class="policy-list">
                            <c:choose>
                                <c:when test="${not empty policies}">
                                    <c:forEach var="p" items="${policies}">

                                        <div class="policy-row ${p.name eq activeKey ? 'active' : ''}">
                                            <a class="policy-link"
                                               href="${pageContext.request.contextPath}/admin/policies?key=${p.name}">
                                                <span class="nav-name"><c:out value="${p.name}"/></span>
                                                <span class="nav-arrow">›</span>
                                            </a>

                                            <div class="policy-actions">
                                                <button type="button"
                                                        class="icon-btn"
                                                        title="Rename"
                                                        onclick="toggleRenameForm('${p.policyId}')">
                                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                    <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/>
                                                    <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                                    </svg>
                                                </button>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/policies"
                                                      style="display:inline;"
                                                      onsubmit="return confirm('Are you sure you want to delete this policy section?');">
                                                    <input type="hidden" name="action" value="deletePolicy"/>
                                                    <input type="hidden" name="policyId" value="${p.policyId}"/>
                                                    <button type="submit" class="icon-btn danger" title="Delete">
                                                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                        <polyline points="3 6 5 6 21 6"/>
                                                        <path d="M19 6l-1 14H6L5 6"/>
                                                        <path d="M10 11v6M14 11v6M9 6V4h6v2"/>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>

                                        <div id="renameForm-${p.policyId}" class="rename-policy-form" style="display:none;">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/policies">
                                                <input type="hidden" name="action" value="renamePolicy"/>
                                                <input type="hidden" name="policyId" value="${p.policyId}"/>
                                                <input type="text"
                                                       name="renameValue"
                                                       class="policy-input"
                                                       value="${p.name}"
                                                       required />
                                                <div class="policy-form-actions">
                                                    <button type="submit" class="mini-btn mini-btn-save">Save</button>
                                                    <button type="button" class="mini-btn mini-btn-cancel"
                                                            onclick="toggleRenameForm('${p.policyId}', false)">Cancel</button>
                                                </div>
                                            </form>
                                        </div>

                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <div style="padding: 12px 4px; color: var(--ink-soft); font-size: 13px;">
                                        No policy sections found.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div><!-- /LEFT -->

                    <!-- RIGHT: Editor -->
                    <div class="right-panel">

                        <c:choose>
                            <c:when test="${selectedPolicy != null}">

                                <div class="section-header">
                                    <h2 class="section-title">
                                        <c:out value="${selectedPolicy.name}"/>
                                    </h2>
                                </div>

                                <div class="section-badge">
                                    <span class="badge-dot"></span>
                                    KEY: <c:out value="${activeKey}"/>
                                </div>

                                <div class="divider"></div>

                                <form method="post" action="${pageContext.request.contextPath}/admin/policies"
                                      style="flex:1;display:flex;flex-direction:column;gap:0;">
                                    <input type="hidden" name="key" value="${activeKey}"/>
                                    <input type="hidden" name="policyId" value="${selectedPolicy.policyId}"/>

                                    <div class="editor-shell">
                                        <div class="editor-toolbar">
                                            <span class="editor-label">Document Editor</span>
                                            <span class="char-count" id="charCount">0 characters</span>
                                        </div>
                                        <textarea name="content" id="editor"
                                                  placeholder="Start writing your policy content here…"><c:out value="${selectedPolicy.content}"/></textarea>
                                    </div>

                                    <div class="actions">
                                        <span class="last-edited">Policy ID: ${selectedPolicy.policyId}</span>
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-ghost"
                                                    onclick="window.location = '${pageContext.request.contextPath}/admin/policies?key=${activeKey}'">
                                                Discard
                                            </button>
                                            <button type="submit" class="btn btn-primary">
                                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/>
                                                <polyline points="17 21 17 13 7 13 7 21"/>
                                                <polyline points="7 3 7 8 15 8"/>
                                                </svg>
                                                Save Changes
                                            </button>
                                        </div>
                                    </div>
                                </form>

                            </c:when>

                            <c:otherwise>
                                <div style="padding: 24px 8px; color: var(--ink-soft); font-size: 14px;">
                                    No policy content available in database.
                                </div>
                            </c:otherwise>
                        </c:choose>

                    </div><!-- /RIGHT -->

                </div>
            </div>
        </div>

        <!-- Toast Notification -->
        <div id="toast">
            <span class="toast-icon">✦</span>
            Changes saved successfully
        </div>

        <script>
            const editor = document.getElementById('editor');
            const charCount = document.getElementById('charCount');

            function updateCount() {
                if (!editor || !charCount)
                    return;
                const n = editor.value.length;
                charCount.textContent = n.toLocaleString() + ' character' + (n !== 1 ? 's' : '');
            }

            if (editor) {
                editor.addEventListener('input', updateCount);
                updateCount();
            }

            function showToast() {
                const t = document.getElementById('toast');
                if (!t)
                    return;
                t.classList.add('show');
                setTimeout(() => t.classList.remove('show'), 2800);
            }

            function toggleAddPolicyForm(force) {
                const box = document.getElementById('addPolicyForm');
                if (!box)
                    return;
                if (force === false) {
                    box.style.display = 'none';
                    return;
                }
                box.style.display = (box.style.display === 'none' || box.style.display === '') ? 'block' : 'none';
            }

            function toggleRenameForm(policyId, force) {
                const el = document.getElementById('renameForm-' + policyId);
                if (!el)
                    return;
                if (force === false) {
                    el.style.display = 'none';
                    return;
                }
                el.style.display = (el.style.display === 'none' || el.style.display === '') ? 'block' : 'none';
            }

            function toggleAddPolicyForm(force) {
                const box = document.getElementById('addPolicyForm');
                if (!box)
                    return;

                if (force === false) {
                    box.style.display = 'none';

                    // clear input
                    box.querySelector('input').value = '';
                    box.querySelector('textarea').value = '';
                    return;
                }

                box.style.display = (box.style.display === 'none' || box.style.display === '')
                        ? 'block'
                        : 'none';
            }

            document.addEventListener('keydown', e => {
                if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                    const form = document.querySelector('form');
                    if (!form)
                        return;
                    e.preventDefault();
                    form.submit();
                }
            });

            <c:if test="${param.saved == '1'}">
            window.addEventListener('load', function () {
                showToast();
            });
            </c:if>
        </script>

    </body>
</html>
