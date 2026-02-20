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
            *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

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
                top: 0; left: 0;
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
                from { opacity:0; transform:translateY(-10px); }
                to   { opacity:1; transform:translateY(0); }
            }
            .page-header-left {}
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
                width: 22px; height: 1.5px;
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
            .tab-link:hover { background: var(--bg2); color: var(--ink); }
            .tab-link.is-active {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 14px rgba(44,36,22,.22);
            }
            .tab-link .tab-icon {
                width: 15px; height: 15px;
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
                from { opacity:0; transform:translateY(16px); }
                to   { opacity:1; transform:translateY(0); }
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
                padding: 24px 16px;
                display: flex;
                flex-direction: column;
                gap: 4px;
            }
            .panel-label {
                font-size: 10.5px;
                font-weight: 800;
                letter-spacing: .18em;
                text-transform: uppercase;
                color: var(--ink-soft);
                padding: 0 12px 10px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 8px;
            }
            .nav-item {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 13px 14px;
                border-radius: 13px;
                text-decoration: none;
                color: var(--ink-mid);
                font-weight: 600;
                font-size: 13.5px;
                transition: all .18s ease;
            }
            .nav-item:hover {
                background: var(--paper);
                color: var(--ink);
                transform: translateX(2px);
            }
            .nav-item.active {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 16px rgba(44,36,22,.2);
            }
            .nav-item.active .nav-arrow { color: var(--gold); opacity: 1; }
            .nav-name { position: relative; z-index: 1; }
            .nav-arrow {
                font-size: 16px;
                opacity: .5;
                transition: transform .18s;
            }
            .nav-item:hover .nav-arrow { transform: translateX(3px); opacity: .8; }

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
                width: 6px; height: 6px;
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
                width: 8px; height: 8px;
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
            textarea::placeholder { color: var(--ink-soft); }

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
            .btn-group { display: flex; gap: 10px; }

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
            .btn-ghost:hover { background: var(--bg2); border-color: var(--border2); color: var(--ink); }
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
            .btn-primary:active { transform: translateY(0); }

            /* ── TOAST ── */
            #toast {
                position: fixed;
                bottom: 32px; right: 32px;
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
            #toast.show { opacity: 1; transform: translateY(0); }
            #toast .toast-icon { color: var(--gold); font-size: 16px; }
        </style>
    </head>

    <body>

        <jsp:include page="/view/admin_layout/sidebar.jsp"/>

        <div class="wrap">

            <!-- Page Header -->
            <div class="page-header">
                <div class="page-header-left">
                    <div class="eyebrow"> System Configuration</div>
                    <h1 class="page-title">Terms Policies</h1>
                </div>

                <!-- Tab Nav -->
                <nav class="tab-nav">
                    <a class="tab-link is-active"
                       href="${pageContext.request.contextPath}/admin/policies?key=${activeKey}">
                        <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                        Terms  Policies
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
                        <div class="panel-label">Policy Sections</div>

                        <c:forEach var="entry" items="${sidebarMap}">
                            <a class="nav-item ${entry.key == activeKey ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/policies?key=${entry.key}">
                                <span class="nav-name">${entry.value}</span>
                                <span class="nav-arrow">›</span>
                            </a>
                        </c:forEach>
                    </div>

                    <!-- RIGHT: Editor -->
                    <div class="right-panel">

                        <div class="section-header">
                            <h2 class="section-title"><c:out value="${sidebarMap[activeKey]}"/></h2>
                        </div>
                        <div class="section-badge">
                            <span class="badge-dot"></span>
                            KEY: ${activeKey}
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
                                    <button type="submit" class="btn btn-primary" onclick="showToast()">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/>
                                            <polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>
                                        </svg>
                                        Save Changes
                                    </button>
                                </div>
                            </div>
                        </form>

                    </div>
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
                const n = editor.value.length;
                charCount.textContent = n.toLocaleString() + ' character' + (n !== 1 ? 's' : '');
            }
            editor.addEventListener('input', updateCount);
            updateCount();

            function showToast() {
                const t = document.getElementById('toast');
                t.classList.add('show');
                setTimeout(() => t.classList.remove('show'), 2800);
            }

            document.addEventListener('keydown', e => {
                if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                    e.preventDefault();
                    document.querySelector('form').submit();
                    showToast();
                }
            });
        </script>

    </body>
</html>
