<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Change Password</title>
        <style>
            :root{
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
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
                background:var(--bg);
                color:var(--text);

                display: flex;
                align-items: center;        /* căn giữa theo chiều dọc */
                justify-content: center;    /* căn giữa theo chiều ngang */
                min-height: 100vh;
            }


            /* page layout */
            .page{
                max-width: 1100px;
                margin: 0 auto;
                padding: 26px 18px 40px;
            }
            .title{
                font-size: 22px;
                font-weight: 650; /* không đậm quá */
                margin: 0 0 18px;
                letter-spacing: -.2px;
            }

            /* card wrapper */
            .card{
                background:var(--card);
                border:1px solid var(--line);
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                padding: 22px;
                max-width: 820px;
            }

            .field{
                margin-bottom: 14px;
            }
            .label{
                display:block;
                font-size: 13px;
                font-weight: 600;  /* vừa như ảnh */
                color: #1f2937;
                margin: 0 0 8px;
            }
            .input{
                width: 100%;
                border:1px solid #dbe3ee;
                background:#fff;
                border-radius: 10px;
                padding: 12px 12px;
                font-size: 14px;
                outline:none;
                transition: box-shadow .12s ease, border-color .12s ease;
            }
            .input:focus{
                border-color:#bcd0ff;
                box-shadow: 0 0 0 4px rgba(37,99,235,.10);
            }

            .row2{
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px;
            }

            /* requirements box */
            .req{
                margin-top: 10px;
                background: #f7fafc;
                border:1px solid #eef2f7;
                border-radius: 12px;
                padding: 14px 16px;
                color: var(--muted);
            }
            .reqTitle{
                font-size: 11px;
                font-weight: 700;
                letter-spacing: .8px;
                text-transform: uppercase;
                color:#94a3b8;
                margin: 0 0 10px;
            }
            .req ul{
                margin: 0;
                padding-left: 18px;
                font-size: 13px;
                line-height: 1.65;
            }

            /* alerts */
            .alert{
                border-radius: 10px;
                padding: 10px 12px;
                margin-bottom: 12px;
                font-size: 14px;
                border: 1px solid transparent;
            }
            .alert.err{
                background:#fff1f2;
                border-color:#fecdd3;
                color:#b42318;
                font-weight: 500;
            }
            .alert.ok{
                background:#ecfdf3;
                border-color:#c7f6d6;
                color:#027a48;
                font-weight: 500;
            }

            /* divider + buttons */
            .divider{
                height:1px;
                background: #eef2f7;
                margin: 18px 0 16px;
            }
            .actions{
                display:flex;
                gap: 12px;
                justify-content:flex-start;
                align-items:center;
            }
            .btn{
                appearance:none;
                border:1px solid #d7e0ee;
                background:#fff;
                color:#0f172a;
                padding: 11px 18px;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 600; /* không quá đậm */
                cursor:pointer;
                text-decoration:none;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                min-width: 140px;
                transition: transform .05s ease, filter .12s ease, background .12s ease;
            }
            .btn:active{
                transform: translateY(1px);
            }
            .btn.primary{
                background: var(--primary);
                border-color: var(--primary);
                color:#fff;
            }
            .btn.primary:hover{
                background: var(--primary2);
            }
            .btn:hover{
                filter: brightness(.99);
            }

            /* responsive */
            @media (max-width: 860px){
                .card{
                    max-width: 100%;
                }
            }
            @media (max-width: 640px){
                .row2{
                    grid-template-columns: 1fr;
                }
                .btn{
                    min-width: 0;
                    width: 100%;
                }
                .actions{
                    flex-direction:column;
                    align-items:stretch;
                }
            }
        </style>
    </head>

    <body>
        <div class="page">
            <div class="title">Change Password</div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert err"><c:out value="${error}"/></div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert ok"><c:out value="${success}"/></div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/customer/change-password">
                    <!-- Current password -->
                    <div class="field">
                        <label class="label" for="currentPassword">Current Password</label>
                        <input class="input" id="currentPassword" type="password" name="currentPassword" required />
                    </div>

                    <!-- New + confirm -->
                    <div class="row2">
                        <div class="field">
                            <label class="label" for="newPassword">New Password</label>
                            <input class="input" id="newPassword" type="password" name="newPassword" required />
                        </div>

                        <div class="field">
                            <label class="label" for="confirmPassword">Confirm New Password</label>
                            <input class="input" id="confirmPassword" type="password" name="confirmPassword" required />
                        </div>
                    </div>

                    <!-- requirements -->
                    <div class="req">
                        <div class="reqTitle">Password Requirements</div>
                        <ul>
                            <li>Minimum 8 characters long</li>
                            <li>Include at least one number</li>
                            <li>Include at least one uppercase letter</li>
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
    </body>
</html>
