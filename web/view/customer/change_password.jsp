<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="cp">
    <div class="page">
        <div class="cp-title">Change Password</div>

        <div class="card">
            <!-- alerts -->
            <c:if test="${not empty flash_success}">
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
                    <a class="btn" href="${pageContext.request.contextPath}/customer/profile">Cancel</a>
                    <button class="btn primary" type="submit">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

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


