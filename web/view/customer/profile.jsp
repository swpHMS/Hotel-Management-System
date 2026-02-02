<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>My Profile</title>

        <style>
            :root{
                --bg:#f5f7fb;
                --card:#ffffff;
                --text:#111827;
                --muted:#6b7280;
                --muted2:#9ca3af;
                --line:#e9eef5;
                --shadow: 0 2px 14px rgba(16,24,40,.06);
                --radius:16px;
                --primary:#2563eb;
                --danger:#dc2626;
                --success-bg:#ecfdf3;
                --success-text:#027a48;
            }
            *{
                box-sizing:border-box
            }

            body{
                margin:0;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
                background:var(--bg);
                color:var(--text);
            }

            .wrap{
                max-width: 1100px;
                margin: 0 auto;
                padding: 20px 18px 24px;
            }

            h1{
                margin: 0 0 16px;
                font-size: 28px;
                font-weight: 700;
                letter-spacing: -.2px;
            }

            .grid{
                display:grid;
                grid-template-columns: 340px 1fr;
                gap: 20px;
                align-items:start;
            }

            .card{
                background:var(--card);
                border:1px solid var(--line);
                border-radius: var(--radius);
                box-shadow: var(--shadow);
            }

            /* LEFT */
            .leftTop{
                padding: 18px;
                text-align:center;
            }

            .avatarWrap{
                position:relative;
                display:inline-block;
                margin: 4px 0 10px;
            }

            .avatar{
                width:100px;
                height:100px;
                border-radius:50%;
                background:#eef2ff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size: 34px;
                font-weight: 600;
                color:#1f2937;
            }

            .dot{
                position:absolute;
                right:8px;
                bottom:8px;
                width:12px;
                height:12px;
                border-radius:50%;
                background:#22c55e;
                border:3px solid #fff;
            }

            .name{
                margin: 6px 0 2px;
                font-size: 18px;
                font-weight: 700;
            }

            .email{
                margin:0;
                font-size: 13px;
                color: var(--muted);
            }

            .roleBadge{
                display:inline-block;
                margin-top: 10px;
                padding: 6px 14px;
                border-radius: 999px;
                background:#eef2ff;
                color: var(--primary);
                font-size: 12px;
                font-weight: 700;
                letter-spacing: .4px;
                text-transform: uppercase;
            }

            .spacer{
                height:12px;
            }

            /* ACTIONS */
            .actions{
                padding: 16px 18px;
            }

            .actionsTitle{
                margin: 0 0 8px;
                font-size: 15px;
                font-weight: 700;
            }

            .actionItem{
                display:flex;
                align-items:center;
                gap: 10px;
                padding: 10px 8px;
                border-radius: 10px;
                text-decoration:none;
                color: var(--text);
                font-size: 14px;
            }

            .actionItem:hover{
                background:#f7f9fd;
            }

            .icon{
                width:26px;
                height:26px;
                display:flex;
                align-items:center;
                justify-content:center;
                color: var(--muted);
            }

            .logout{
                color: var(--danger);
            }
            .logout .icon{
                color: var(--danger);
            }

            /* RIGHT */
            .sectionHead{
                padding: 14px 16px;
                border-bottom:1px solid var(--line);
                font-size: 15px;
                font-weight: 700;
            }

            .sectionBody{
                padding: 16px;
            }

            .infoGrid{
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px 24px;
            }

            .label{
                font-size: 11px;
                color: var(--muted2);
                letter-spacing: .8px;
                text-transform: uppercase;
                font-weight: 600;
                margin-bottom: 4px;
            }

            .value{
                font-size: 14px;
                font-weight: 600;
                line-height: 1.35;
                word-break: break-word;
            }

            .statusPill{
                display:inline-block;
                padding: 4px 10px;
                border-radius: 8px;
                background: var(--success-bg);
                color: var(--success-text);
                font-weight: 700;
                font-size: 12px;
            }

            /* BACK */
            .backWrap{
               
                text-align:center;
            }

            .backBtn{
                display:inline-flex;
                align-items:center;
                gap: 8px;
                padding: 10px 18px;
                border-radius: 10px;
                background:#f1f5f9;
                color:#1f2937;
                text-decoration:none;
                font-size:14px;
                font-weight:600;
            }

            .backBtn:hover{
                background:#e5e7eb;
            }

            /* responsive */
            @media (max-width: 980px){
                .grid{
                    grid-template-columns: 1fr;
                }
                .infoGrid{
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <div class="wrap">
            <h1>My Profile</h1>

            <div class="grid">
                <!-- LEFT -->
                <div>
                    <div class="card leftTop">
                        <div class="avatarWrap">
                            <div class="avatar">${initials}</div>
                            <span class="dot"></span>
                        </div>

                        <div class="name"><c:out value="${profile.fullName}" default="User"/></div>
                        <p class="email"><c:out value="${profile.email}" default=""/></p>

                        <div class="roleBadge">
                            <c:out value="${profile.roleName}" default="CUSTOMER"/>
                        </div>
                    </div>

                    <div class="spacer"></div>

                    <div class="card actions">
                        <div class="actionsTitle">Actions</div>

                        <a class="actionItem" href="${pageContext.request.contextPath}/customer/profile/edit">
                            <span class="icon">✎</span>
                            <span>Edit Profile</span>
                        </a>


                        <a class="actionItem" href="${pageContext.request.contextPath}/customer/change-password">
                            <span class="icon">🔒</span>
                            <span>Change Password</span>
                        </a>

                        <a class="actionItem logout" href="${pageContext.request.contextPath}/logout">
                            <span class="icon">⎋</span>
                            <span>Logout</span>
                        </a>
                    </div>
                </div>

                <!-- RIGHT -->
                <div>
                    <div class="card">
                        <div class="sectionHead">Personal Information</div>
                        <div class="sectionBody">
                            <div class="infoGrid">
                                <div>
                                    <div class="label">Full Name</div>
                                    <div class="value"><c:out value="${profile.fullName}" default="—"/></div>
                                </div>

                                <div>
                                    <div class="label">Email Address</div>
                                    <div class="value"><c:out value="${profile.email}" default="—"/></div>
                                </div>

                                <div>
                                    <div class="label">Phone Number</div>
                                    <div class="value"><c:out value="${profile.phone}" default="—"/></div>
                                </div>

                                <div>
                                    <div class="label">Identity Number</div>
                                    <div class="value"><c:out value="${profile.identityNumber}" default="—"/></div>
                                </div>

                                <div>
                                    <div class="label">Gender</div>
                                    <div class="value">
                                        <c:choose>
                                            <c:when test="${profile.gender == 1}">Male</c:when>
                                            <c:when test="${profile.gender == 2}">Female</c:when>
                                            <c:when test="${profile.gender == 3}">Other</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div>
                                    <div class="label">Date of Birth</div>
                                    <div class="value"><c:out value="${profile.dateOfBirth}" default="—"/></div>
                                </div>

                                <div>
                                    <div class="label">Account Status</div>
                                    <div class="value">
                                        <c:choose>
                                            <c:when test="${profile.userStatus == 1}">
                                                <span class="statusPill">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="statusPill" style="background:#fff1f2;color:#b42318;">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="spacer"></div>

                    <div class="card">
                        <div class="sectionHead">Address Details</div>
                        <div class="sectionBody">
                            <div class="label">Street Address</div>
                            <div class="value"><c:out value="${profile.residenceAddress}" default="—"/></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- BACK -->
            <div class="backWrap">
                <a class="backBtn" href="${pageContext.request.contextPath}/customer/dashboard">
                    ← Back to Dashboard
                </a>
            </div>
        </div>
    </body>
</html>
