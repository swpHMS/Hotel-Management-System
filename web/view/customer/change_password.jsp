<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ===== Change Password scoped (cp-*) ===== */
    .cp{
        --bg:#f5f7fb;
        --card:#ffffff;
        --text:#0f172a;
        --muted:#64748b;
        --line:#e5eaf2;
        --shadow:0 8px 24px rgba(15,23,42,.06);
        --radius:16px;
        --primary:#2563eb;
        --primary2:#1d4ed8;
        --danger:#dc2626;
        --soft:#f1f5f9;
    }
    .cp, .cp *{
        box-sizing:border-box;
    }

    .cp .page{
        max-width:1100px;
        margin:0 auto;
        padding:0;
    }
    /* đổi title để không đụng sidebar .title */
    .cp .cp-title{
        font-size:22px;
        font-weight:650;
        margin:0 0 18px;
        letter-spacing:-.2px;
        color: var(--text);
    }

    .cp .card{
        background:var(--card);
        border:1px solid var(--line);
        border-radius:var(--radius);
        box-shadow:var(--shadow);
        padding:22px;
        max-width:820px;
    }

    .cp .field{
        margin-bottom:14px;
    }

    .cp .label{
        display:block;
        font-size:13px;
        font-weight:600;
        color:#1f2937;
        margin:0 0 8px;
    }

    .cp .input{
        width:100%;
        border:1px solid #dbe3ee;
        background:#fff;
        border-radius:10px;
        padding:12px 12px;
        font-size:14px;
        outline:none;
        transition: box-shadow .12s ease, border-color .12s ease;
    }
    .cp .input:focus{
        border-color:#bcd0ff;
        box-shadow:0 0 0 4px rgba(37,99,235,.10);
    }

    .cp .row2{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:14px;
    }

    .cp .pw-wrap{
        position:relative;
        display:flex;
        align-items:center;
    }
    .cp .pw-wrap .input{
        padding-right:46px;
    }

    .cp .pw-toggle{
        position:absolute;
        right:10px;
        top:50%;
        transform:translateY(-50%);
        width:34px;
        height:34px;
        border:0;
        background:transparent;
        cursor:pointer;
        padding:0;
        display:grid;
        place-items:center;
        border-radius:10px;

        opacity:0;
        pointer-events:none;
        transition: opacity .15s ease;
    }
    .cp .pw-wrap:focus-within .pw-toggle,
    .cp .pw-wrap:hover .pw-toggle{
        opacity:1;
        pointer-events:auto;
    }

    .cp .pw-toggle:hover{
        background: rgba(15,23,42,.06);
    }
    .cp .pw-toggle:focus{
        outline:none;
        box-shadow:0 0 0 4px rgba(37,99,235,.10);
    }
    .cp .pw-toggle svg{
        width:18px;
        height:18px;
        color:#94a3b8;
        transition: color .15s ease;
    }
    .cp .pw-toggle:hover svg{
        color:#475569;
    }
    .cp .pw-toggle.is-on svg{
        color: var(--primary);
    }
    .cp .pw-toggle.is-on .icon-eyeoff{
        display:none;
    }
    .cp .pw-toggle:not(.is-on) .icon-eye{
        display:none;
    }

    .cp .req{
        margin-top:10px;
        background:#f7fafc;
        border:1px solid #eef2f7;
        border-radius:12px;
        padding:14px 16px;
        color:var(--muted);
    }
    .cp .reqTitle{
        font-size:11px;
        font-weight:700;
        letter-spacing:.8px;
        text-transform:uppercase;
        color:#94a3b8;
        margin:0 0 10px;
    }
    .cp .req ul{
        margin:0;
        padding-left:18px;
        font-size:13px;
        line-height:1.65;
    }

    .cp .alert{
        border-radius:10px;
        padding:10px 12px;
        margin-bottom:12px;
        font-size:14px;
        border:1px solid transparent;
    }
    .cp .alert.err{
        background:#fff1f2;
        border-color:#fecdd3;
        color:#b42318;
        font-weight:500;
    }
    .cp .alert.ok{
        background:#ecfdf3;
        border-color:#c7f6d6;
        color:#027a48;
        font-weight:500;
    }

    .cp .divider{
        height:1px;
        background:#eef2f7;
        margin:18px 0 16px;
    }

    .cp .actions{
        display:flex;
        gap:12px;
        justify-content:flex-start;
        align-items:center;
    }

    .cp .btn{
        appearance:none;
        border:1px solid #d7e0ee;
        background:#fff;
        color:#0f172a;
        padding:11px 18px;
        border-radius:10px;
        font-size:14px;
        font-weight:600;
        cursor:pointer;
        text-decoration:none;
        display:inline-flex;
        align-items:center;
        justify-content:center;
        min-width:140px;
        transition: transform .05s ease, filter .12s ease, background .12s ease;
    }
    .cp .btn:active{
        transform: translateY(1px);
    }

    .cp .btn.primary{
        background:var(--primary);
        border-color:var(--primary);
        color:#fff;
    }
    .cp .btn.primary:hover{
        background:var(--primary2);
    }
    .cp .btn:hover{
        filter: brightness(.99);
    }

    @media (max-width: 860px){
        .cp .card{
            max-width:100%;
        }
    }
    @media (max-width: 640px){
        .cp .row2{
            grid-template-columns:1fr;
        }
        .cp .btn{
            min-width:0;
            width:100%;
        }
        .cp .actions{
            flex-direction:column;
            align-items:stretch;
        }
    }
</style>

<div class="cp">
    <div class="page">
        <div class="cp-title">Change Password</div>

        <div class="card">
            <c:if test="${not empty flash_success}">
                <c:set var="justChanged" value="1"/>
                <div class="alert ok">
                    <c:out value="${flash_success}"/>
                </div>
            </c:if>

            <c:if test="${not empty flash_error}">
                <div class="alert err">
                    <c:out value="${flash_error}"/>
                </div>
            </c:if>


            <form method="post" action="${pageContext.request.contextPath}/customer/change-password">
                <div class="field">
                    <label class="label" for="currentPassword">Current Password</label>
                    <div class="pw-wrap">
                        <input class="input" id="currentPassword" type="password" name="currentPassword"
                               autocomplete="current-password" required />

                        <button type="button" class="pw-toggle" aria-label="Show password" data-target="currentPassword">
                            <svg class="icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"
                                  fill="none" stroke="currentColor" stroke-width="1.6"/>
                            <circle cx="12" cy="12" r="3"
                                    fill="none" stroke="currentColor" stroke-width="1.6"/>
                            </svg>
                            <svg class="icon-eyeoff" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M17.94 17.94C16.23 19.24 14.21 20 12 20
                                  5 20 1 12 1 12a21.77 21.77 0 0 1 5.06-5.94"
                                  fill="none" stroke="currentColor" stroke-width="1.6"
                                  stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M9.88 9.88a3 3 0 0 0 4.24 4.24"
                                  fill="none" stroke="currentColor" stroke-width="1.6"
                                  stroke-linecap="round" stroke-linejoin="round"/>
                            <line x1="1" y1="1" x2="23" y2="23"
                                  stroke="currentColor" stroke-width="1.6"
                                  stroke-linecap="round"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="row2">
                    <div class="field">
                        <label class="label" for="newPassword">New Password</label>
                        <div class="pw-wrap">
                            <input class="input" id="newPassword" type="password" name="newPassword"
                                   autocomplete="new-password" required />

                            <button type="button" class="pw-toggle" aria-label="Show password" data-target="newPassword">
                                <svg class="icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"
                                      fill="none" stroke="currentColor" stroke-width="1.6"/>
                                <circle cx="12" cy="12" r="3"
                                        fill="none" stroke="currentColor" stroke-width="1.6"/>
                                </svg>
                                <svg class="icon-eyeoff" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M17.94 17.94C16.23 19.24 14.21 20 12 20
                                      5 20 1 12 1 12a21.77 21.77 0 0 1 5.06-5.94"
                                      fill="none" stroke="currentColor" stroke-width="1.6"
                                      stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M9.88 9.88a3 3 0 0 0 4.24 4.24"
                                      fill="none" stroke="currentColor" stroke-width="1.6"
                                      stroke-linecap="round" stroke-linejoin="round"/>
                                <line x1="1" y1="1" x2="23" y2="23"
                                      stroke="currentColor" stroke-width="1.6"
                                      stroke-linecap="round"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label" for="confirmPassword">Confirm New Password</label>
                        <div class="pw-wrap">
                            <input class="input" id="confirmPassword" type="password" name="confirmPassword"
                                   autocomplete="new-password" required />

                            <button type="button" class="pw-toggle" aria-label="Show password" data-target="confirmPassword">
                                <svg class="icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"
                                      fill="none" stroke="currentColor" stroke-width="1.6"/>
                                <circle cx="12" cy="12" r="3"
                                        fill="none" stroke="currentColor" stroke-width="1.6"/>
                                </svg>
                                <svg class="icon-eyeoff" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M17.94 17.94C16.23 19.24 14.21 20 12 20
                                      5 20 1 12 1 12a21.77 21.77 0 0 1 5.06-5.94"
                                      fill="none" stroke="currentColor" stroke-width="1.6"
                                      stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M9.88 9.88a3 3 0 0 0 4.24 4.24"
                                      fill="none" stroke="currentColor" stroke-width="1.6"
                                      stroke-linecap="round" stroke-linejoin="round"/>
                                <line x1="1" y1="1" x2="23" y2="23"
                                      stroke="currentColor" stroke-width="1.6"
                                      stroke-linecap="round"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="req">
                    <div class="reqTitle">Password Requirements</div>
                    <ul>
                        <li>Minimum 8 characters long</li>
                        <li>Include at least one number</li>
                        <li>Include at least one uppercase letter</li>
                        <li>Must not contain spaces</li>
                        <li>Must be different from your current password</li>
                    </ul>
                </div>

                <div class="divider"></div>

                <div class="actions">
                    <a class="btn" href="${pageContext.request.contextPath}/customer/dashboard?tab=viewProfile">Cancel</a>
                    <button class="btn primary" type="submit">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${justChanged == 1}">
        <script>
            setTimeout(() => {
                window.location.href =
                        "${pageContext.request.contextPath}/customer/dashboard?tab=viewProfile";
            }, 2000);
        </script>
    </c:if>

    <script>
        (function () {
            function hideField(btn) {
                const id = btn.getAttribute('data-target');
                const input = document.getElementById(id);
                if (!input)
                    return;

                input.type = 'password';
                btn.classList.remove('is-on');
                btn.setAttribute('aria-label', 'Show password');
            }

            function showField(btn) {
                const id = btn.getAttribute('data-target');
                const input = document.getElementById(id);
                if (!input)
                    return;

                input.type = 'text';
                btn.classList.add('is-on');
                btn.setAttribute('aria-label', 'Hide password');
            }

            document.querySelectorAll('.cp .pw-toggle').forEach(btn => {
                btn.addEventListener('click', () => {
                    const id = btn.getAttribute('data-target');
                    const input = document.getElementById(id);
                    if (!input)
                        return;

                    const willShow = (input.type === 'password');

                    document.querySelectorAll('.cp .pw-toggle').forEach(otherBtn => {
                        if (otherBtn !== btn)
                            hideField(otherBtn);
                    });

                    if (willShow)
                        showField(btn);
                    else
                        hideField(btn);
                });
            });
        })();
    </script>
</div>
