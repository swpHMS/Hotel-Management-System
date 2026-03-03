<%-- 
    Document   : template_list
    Created on : Feb 20, 2026
    Author     : DieuBHHE191686
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>HMS Admin | Email Templates</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

        <style>
            *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

            :root {
                --bg:        #f5f0e8;
                --bg2:       #ede7da;
                --paper:     #faf7f2;
                --border:    #e0d8cc;
                --border2:   #cfc6b8;
                --ink:       #2c2416;
                --ink-mid:   #5a4e3c;
                --ink-soft:  #9c8e7a;
                --gold:      #b5832a;
                --gold-lt:   #f0ddb8;
                --gold-bg:   rgba(181,131,42,.09);
                --sage:      #5a7a5c;
                --sage-lt:   #d4e6d4;
                --sidebar-w: 280px;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--bg);
                color: var(--ink);
            }

            .hms-sidebar, aside.hms-sidebar, aside {
                position: fixed !important;
                top: 0; left: 0;
                width: var(--sidebar-w) !important;
                height: 100vh !important;
                overflow-y: auto !important;
                z-index: 9999;
            }

            .wrap {
                margin-left: var(--sidebar-w);
                padding: 40px 44px 64px;
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
            .page-title {
                font-family: 'Fraunces', serif;
                font-size: 38px;
                font-weight: 800;
                color: var(--ink);
                line-height: 1;
                letter-spacing: -1px;
            }
            .page-sub {
                margin-top: 7px;
                font-size: 13px;
                color: var(--ink-soft);
            }

            /* ── TABS ── */
            .tabs {
                display: flex;
                gap: 4px;
                background: var(--paper);
                border: 1px solid var(--border);
                padding: 5px;
                border-radius: 14px;
                width: fit-content;
                box-shadow: 0 2px 10px rgba(44,36,22,.05);
                flex-shrink: 0;
            }
            .tab {
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
            .tab:hover { background: var(--bg2); color: var(--ink); }
            .tab.active {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 14px rgba(44,36,22,.22);
            }

            /* ── MAIN CARD ── */
            .card {
                background: var(--paper);
                border: 1px solid var(--border);
                border-radius: 22px;
                box-shadow: 0 4px 24px rgba(44,36,22,.07);
                overflow: hidden;
                animation: slideUp .4s .08s ease both;
            }
            @keyframes slideUp {
                from { opacity:0; transform:translateY(16px); }
                to   { opacity:1; transform:translateY(0); }
            }

            /* ── LAYOUT (same 2-column grid) ── */
            .layout {
                display: grid;
                grid-template-columns: 280px 1fr;
                min-height: 650px;
            }

            /* ── LEFT ── */
            .left {
                background: var(--bg2);
                border-right: 1px solid var(--border);
                padding: 24px 16px;
                display: flex;
                flex-direction: column;
                gap: 4px;
            }
            .left h4 {
                font-size: 10.5px;
                font-weight: 800;
                letter-spacing: .18em;
                text-transform: uppercase;
                color: var(--ink-soft);
                padding: 0 12px 10px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 8px;
            }
            .item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 13px 14px;
                border-radius: 13px;
                text-decoration: none;
                color: var(--ink-mid);
                font-weight: 600;
                font-size: 13.5px;
                transition: all .18s ease;
            }
            .item:hover {
                background: var(--paper);
                color: var(--ink);
                transform: translateX(2px);
            }
            .item .arrow { opacity: .5; transition: transform .18s; }
            .item:hover .arrow { transform: translateX(3px); opacity: .8; }
            .item.active {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 16px rgba(44,36,22,.2);
            }
            .item.active .arrow { color: var(--gold); opacity: 1; }

            /* ── RIGHT ── */
            .right {
                padding: 32px 36px;
                display: flex;
                flex-direction: column;
            }

            .template-title {
                font-family: 'Fraunces', serif;
                font-size: 26px;
                font-weight: 700;
                color: var(--ink);
                margin-bottom: 6px;
            }
            .template-meta {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 4px 12px;
                background: var(--gold-bg);
                color: var(--gold);
                border: 1px solid var(--gold-lt);
                border-radius: 100px;
                font-size: 11px;
                font-weight: 800;
                letter-spacing: .08em;
                margin-bottom: 20px;
            }
            .meta-dot { width: 6px; height: 6px; background: var(--gold); border-radius: 50%; }

            .divider { height: 1px; background: var(--border); margin-bottom: 22px; }

            /* ── EDITOR ── */
            .editor {
                flex: 1;
                border: 1.5px solid var(--border);
                border-radius: 16px;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                transition: border-color .2s, box-shadow .2s;
            }
            .editor:focus-within {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            }

            /* Subject + Status row */
            .row {
                display: grid;
                grid-template-columns: 1fr 200px;
                gap: 14px;
                align-items: end;
                padding: 18px 18px 16px;
                background: var(--bg2);
                border-bottom: 1px solid var(--border);
            }
            .field label {
                display: block;
                font-size: 10px;
                font-weight: 800;
                letter-spacing: .18em;
                text-transform: uppercase;
                color: var(--ink-soft);
                margin-bottom: 7px;
            }
            .field input[type="text"] {
                width: 100%;
                height: 44px;
                padding: 0 14px;
                border: 1.5px solid var(--border);
                border-radius: 11px;
                background: var(--paper);
                font-family: 'DM Sans', sans-serif;
                font-size: 14px;
                color: var(--ink);
                outline: none;
                transition: border-color .18s, box-shadow .18s;
            }
            .field input[type="text"]:focus {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(181,131,42,.12);
            }

            /* Toggle */
            .toggle {
                height: 44px;
                padding: 0 14px;
                border: 1.5px solid var(--border);
                border-radius: 11px;
                background: var(--paper);
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                transition: all .18s;
            }
            .toggle label {
                font-size: 13.5px !important;
                font-weight: 700 !important;
                color: var(--ink-mid) !important;
                letter-spacing: 0 !important;
                text-transform: none !important;
                margin: 0 !important;
                cursor: pointer;
            }
            .toggle.is-active {
                border-color: var(--sage);
                background: var(--sage-lt);
            }
            .toggle.is-active label { color: var(--sage) !important; }
            .toggle input[type="checkbox"] {
                width: 16px; height: 16px;
                accent-color: var(--sage);
                cursor: pointer;
                flex-shrink: 0;
            }

            /* Content body */
            .editor-body {
                flex: 1;
                padding: 16px 18px 18px;
                background: var(--paper);
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .editor-body label {
                font-size: 10px;
                font-weight: 800;
                letter-spacing: .18em;
                text-transform: uppercase;
                color: var(--ink-soft);
                display: flex;
                align-items: center;
                gap: 7px;
            }
            .editor-body label::before {
                content: '';
                display: inline-block;
                width: 7px; height: 7px;
                background: var(--gold);
                border-radius: 50%;
            }
            textarea {
                flex: 1;
                width: 100%;
                min-height: 340px;
                padding: 14px 16px;
                border: 1.5px solid var(--border);
                border-radius: 11px;
                background: var(--bg);
                font-family: 'DM Sans', sans-serif;
                font-size: 14px;
                line-height: 1.7;
                color: var(--ink);
                outline: none;
                resize: vertical;
                transition: border-color .18s, box-shadow .18s, background .18s;
            }
            textarea:focus {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(181,131,42,.12);
                background: var(--paper);
            }
            textarea::placeholder { color: var(--ink-soft); }

            /* ── FOOTER ── */
            .footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                padding: 18px 22px;
                border-top: 1px solid var(--border);
                background: var(--bg2);
            }
            .btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 11px 22px;
                border-radius: 12px;
                font-family: 'DM Sans', sans-serif;
                font-weight: 700;
                font-size: 13.5px;
                cursor: pointer;
                border: 0;
                transition: all .18s ease;
            }
            .btn.ghost {
                background: transparent;
                color: var(--ink-mid);
                border: 1.5px solid var(--border);
            }
            .btn.ghost:hover { background: var(--bg); border-color: var(--border2); color: var(--ink); }
            .btn.primary {
                background: var(--ink);
                color: #fff;
                box-shadow: 0 4px 16px rgba(44,36,22,.2);
            }
            .btn.primary:hover {
                opacity: .88;
                transform: translateY(-1px);
                box-shadow: 0 8px 24px rgba(44,36,22,.28);
            }

            /* ── TOAST ── */
            #toast {
                position: fixed;
                bottom: 32px; right: 32px;
                background: var(--ink);
                color: #fff;
                padding: 13px 20px;
                border-radius: 13px;
                font-size: 13px;
                font-weight: 600;
                box-shadow: 0 8px 28px rgba(44,36,22,.25);
                transform: translateY(16px);
                opacity: 0;
                pointer-events: none;
                transition: all .3s cubic-bezier(.22,.68,0,1.2);
                display: flex;
                align-items: center;
                gap: 9px;
                z-index: 99999;
            }
            #toast.show { opacity: 1; transform: translateY(0); }
            #toast .t-icon { color: var(--gold); }

            @media (max-width: 980px) { .wrap { margin-left: 0; } }
        </style>
    </head>

    <body>
        <jsp:include page="/view/admin_layout/sidebar.jsp"/>

        <div class="wrap">

            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <div class="page-eyebrow">⚙ System Configuration</div>
                    <h1 class="page-title">Email Templates</h1>
                </div>

                <!-- Tabs -->
                <div class="tabs">
                <a class="tab" href="${pageContext.request.contextPath}/admin/policies">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                    Terms &amp; Policies
                </a>
                <a class="tab active" href="${pageContext.request.contextPath}/admin/templates">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                    Email Templates
                </a>
                </div>
            </div>

            <!-- Main Card -->
            <div class="card">
                <div class="layout">

                    <!-- LEFT: template list -->
                    <div class="left">
                        <h4>Templates</h4>
                        <c:forEach var="t" items="${templates}">
                            <a class="item ${t.templateId == selectedId ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/templates?id=${t.templateId}">
                                <span class="item-name">${t.code}</span>
                                <span class="arrow">›</span>
                            </a>
                        </c:forEach>
                    </div>

                    <!-- RIGHT: editor -->
                    <div class="right">
                        <div class="template-title">${selectedTemplate.code}</div>
                        <div class="template-meta">
                            <span class="meta-dot"></span>
                            Template ID: ${selectedTemplate.templateId}
                        </div>

                        <div class="divider"></div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/templates"
                              style="flex:1;display:flex;flex-direction:column;">
                            <input type="hidden" name="templateId" value="${selectedTemplate.templateId}"/>

                            <div class="editor">

                                <div class="row">
                                    <div class="field">
                                        <label>Subject</label>
                                        <input type="text" name="subject"
                                               value="${fn:escapeXml(selectedTemplate.subject)}"
                                               placeholder="Email subject line…"/>
                                    </div>
                                    <div class="field">
                                        <label>Status</label>
                                        <div class="toggle">
                                            <input type="checkbox" id="isActive" name="isActive"
                                                   ${selectedTemplate.active ? 'checked' : ''}/>
                                            <label for="isActive">Active</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="editor-body">
                                    <label>Content</label>
                                    <textarea name="content"
                                              placeholder="Write your email template content here…"><c:out value="${selectedTemplate.content}"/></textarea>
                                </div>

                            </div>

                            <div class="footer">
                                <button type="button" class="btn ghost"
                                        onclick="window.location='${pageContext.request.contextPath}/admin/templates?id=${selectedTemplate.templateId}'">
                                    Discard
                                </button>
                                <button type="submit" class="btn primary" onclick="showToast()">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/>
                                        <polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>
                                    </svg>
                                    Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>

        <div id="toast">
            <span class="t-icon">✦</span>
            Template saved successfully
        </div>

        <script>
            // Format template code labels: BOOKING_CONFIRM -> Booking Confirm
            document.addEventListener('DOMContentLoaded', function() {
                document.querySelectorAll('.item .item-name').forEach(function(el) {
                    el.textContent = el.textContent.trim()
                        .toLowerCase()
                        .replace(/_/g, ' ')
                        .replace(/(^|\s)\S/g, function(c){ return c.toUpperCase(); });
                });
            });

            // Toggle active class on checkbox change (replaces :has() for JSP compat)
            document.addEventListener('DOMContentLoaded', function() {
                const cb = document.getElementById('isActive');
                const toggle = cb ? cb.closest('.toggle') : null;
                if (cb && toggle) {
                    function syncToggle() {
                        toggle.classList.toggle('is-active', cb.checked);
                    }
                    cb.addEventListener('change', syncToggle);
                    syncToggle();
                }
            });

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
