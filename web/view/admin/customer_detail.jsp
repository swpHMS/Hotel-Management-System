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
            :root{
                --bg:#f5f7fb;
                --card:#fff;
                --text:#0f172a;
                --muted:#667085;
                --line:#e6eaf2;
                --primary:#4f46e5;
                --primary2:#4338ca;
                --shadow:0 14px 40px rgba(15,23,42,.08);
                --radius:18px;
            }

            body{
                background:var(--bg);
            }

            .page-head{
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                gap:16px;
                margin: 6px 0 18px;
            }

            .head-actions{
                display:flex;
                gap:12px;
            }

            .btnx{
                height:44px;
                padding:0 18px;
                border-radius:12px;
                font-weight:900;
                border:1px solid transparent;
                display:inline-flex;
                align-items:center;
                text-decoration:none;
                cursor:pointer;
                font-size:14px;
            }
            .btnx-outline{
                background:#fff;
                border-color:#dbe2f0;
                color:#344054;
            }
            .btnx-outline:hover{
                background:#f8fafc
            }
            .btnx-primary{
                background:var(--primary);
                color:#fff;
                box-shadow: 0 10px 22px rgba(79,70,229,.18);
            }
            .btnx-primary:hover{
                background:var(--primary2)
            }
            .btnx:disabled, .btnx.disabled{
                opacity:.5;
                cursor:not-allowed
            }

            .detail-card{
                background:var(--card);
                border:1px solid var(--line);
                border-radius:var(--radius);
                box-shadow:var(--shadow);
                overflow:hidden;
            }

            .hero{
                display:flex;
                align-items:center;
                gap:22px;
                padding:26px;
            }

            .avatar{
                width:110px;
                height:110px;
                border-radius:18px;
                background:var(--primary);
                color:#fff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:42px;
                font-weight:900;
                letter-spacing:1px;
                box-shadow: 0 14px 30px rgba(79,70,229,.22);
                flex:0 0 auto;
            }

            .hero h2{
                margin:0;
                font-size:40px;
                letter-spacing:-0.6px;
            }

            .hero-sub{
                margin-top:8px;
                display:flex;
                gap:12px;
                align-items:center;
                color:var(--muted);
                font-size:14px;
            }
            .dot{
                width:5px;
                height:5px;
                border-radius:999px;
                background:#cbd5e1;
                display:inline-block
            }

            .divider{
                height:1px;
                background:var(--line)
            }

            .grid3{
                display:grid;
                grid-template-columns: 1fr 1fr 1fr;
                padding: 22px 26px 26px;
            }
            .col{
                padding: 0 18px;
            }
            .col:not(:first-child){
                border-left:1px solid #eef2f7;
            }

            .section-title{
                font-size:12px;
                letter-spacing:.2em;
                font-weight:900;
                color:#98a2b3;
                text-transform:uppercase;
                padding-bottom:12px;
                border-bottom:1px solid #eef2f7;
                margin: 6px 0 18px;
            }

            .kv{
                display:grid;
                gap:18px;
            }
            .k{
                font-size:12px;
                letter-spacing:.1em;
                font-weight:900;
                color:#98a2b3;
                text-transform:uppercase;
                margin-bottom:6px;
            }
            .v{
                font-size:14px;
                font-weight:900;
                color:#111827;
                line-height:1.4;
                word-break:break-word;
            }

            .badge{
                display:inline-flex;
                align-items:center;
                padding:7px 12px;
                border-radius:999px;
                font-weight:900;
                font-size:12px;
                line-height:1;
            }
            .badge-green{
                background:#e9fbef;
                color:#137a3a
            }
            .badge-red{
                background:#ffe9e9;
                color:#a11a1a
            }
            .badge-gray{
                background:#f2f4f7;
                color:#344054
            }

            .link{
                color:#2563eb;
                font-weight:900;
                text-decoration:none
            }
            .link:hover{
                text-decoration:underline
            }

            @media (max-width: 1000px){
                .grid3{
                    grid-template-columns:1fr;
                    gap:18px;
                }
                .col{
                    padding:0;
                    border-left:none !important;
                }
                .hero{
                    flex-direction:column;
                    align-items:flex-start;
                }
                .hero h2{
                    font-size:30px;
                }
                .avatar{
                    width:96px;
                    height:96px;
                    font-size:38px;
                }
                .head-actions{
                    flex-direction:column;
                    align-items:stretch;
                }
                .btnx{
                    justify-content:center
                }
            }
        </style>
    </head>

    <body class="admin-shell">
        <div class="app-shell">
            <%@ include file="/view/layout/sidebar.jsp" %>


            <main class="hms-main">

                <div class="admin-content">

                    <div class="breadcrumb">Admin &gt; Customer Management &gt; <b>Customer Detail</b></div>

                    <div class="page-head">
                        <h1 class="page-title" style="margin:0;">Customer Detail</h1>

                        <div class="head-actions">
                            <a class="btnx btnx-outline" href="${pageContext.request.contextPath}/admin/customers">
                                Back to List
                            </a>

                            <c:choose>
                                <c:when test="${c != null && c.userId != null}">
                                    <a class="btnx btnx-primary"
                                       href="${pageContext.request.contextPath}/admin/customer-status?id=${c.customerId}">
                                        Change Account Status
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btnx btnx-primary" disabled>Change Account Status</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <c:if test="${c == null}">
                        <div class="detail-card" style="padding:20px;">
                            <div style="color:var(--muted); font-weight:800;">Customer not found.</div>
                        </div>
                    </c:if>

                    <c:if test="${c != null}">
                        <%-- initials: lấy 2 ký tự đầu của full_name (fallback 1 ký tự) --%>
                        <c:set var="nm" value="${c.fullName}" />
                        <c:set var="i1" value="${nm != null && fn:length(nm) >= 1 ? fn:toUpperCase(fn:substring(nm,0,1)) : 'C'}" />
                        <c:set var="i2" value="${nm != null && fn:length(nm) >= 2 ? fn:toUpperCase(fn:substring(nm,1,2)) : ''}" />
                        <c:set var="initials" value="${i1}${i2}" />

                        <div class="detail-card">
                            <div class="hero">
                                <div class="avatar">${initials}</div>

                                <div style="flex:1;">
                                    <h2>${c.fullName}</h2>

                                    <div class="hero-sub">
                                        <span>${c.residenceAddress != null ? c.residenceAddress : '—'}</span>
                                        <span class="dot"></span>

                                        <span>
                                            <c:choose>
                                                <c:when test="${c.accountStatus == 'ACTIVE'}">Active Account</c:when>
                                                <c:when test="${c.accountStatus == 'INACTIVE'}">Inactive Account</c:when>
                                                <c:otherwise>No Account</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="divider"></div>

                            <div class="grid3">
                                <!-- BASIC INFO -->
                                <div class="col">
                                    <div class="section-title">Basic Info</div>
                                    <div class="kv">
                                        <div>
                                            <div class="k">Full Name</div>
                                            <div class="v">${c.fullName}</div>
                                        </div>

                                        <div>
                                            <div class="k">Gender</div>
                                            <div class="v">
                                                <c:choose>
                                                    <c:when test="${c.gender == 1}">Male</c:when>
                                                    <c:when test="${c.gender == 2}">Female</c:when>
                                                    <c:when test="${c.gender == 3}">Other</c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div>
                                            <div class="k">Date of Birth</div>
                                            <div class="v">
                                                <c:choose>
                                                    <c:when test="${c.dateOfBirth != null}">
                                                        <fmt:formatDate value="${c.dateOfBirth}" pattern="yyyy-MM-dd"/>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div>
                                            <div class="k">Residence Address</div>
                                            <div class="v">${c.residenceAddress != null ? c.residenceAddress : '—'}</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- IDENTITY & CONTACT -->
                                <div class="col">
                                    <div class="section-title">Identity & Contact</div>
                                    <div class="kv">
                                        <div>
                                            <div class="k">Identity Number</div>
                                            <div class="v">${c.identityNumber != null ? c.identityNumber : '—'}</div>
                                        </div>

                                        <div>
                                            <div class="k">Phone</div>
                                            <div class="v">${c.phone != null ? c.phone : '—'}</div>
                                        </div>

                                        <div>
                                            <div class="k">Email Address</div>
                                            <div class="v">
                                                <c:choose>
                                                    <c:when test="${not empty c.email}">
                                                        <a class="link" href="mailto:${c.email}">${c.email}</a>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- ACCOUNT INFO -->
                                <div class="col">
                                    <div class="section-title">Account Info</div>
                                    <div class="kv">
                                        <div>
                                            <div class="k">Account Status</div>
                                            <div class="v">
                                                <c:choose>
                                                    <c:when test="${c.accountStatus == 'ACTIVE'}">
                                                        <span class="badge badge-green">Active</span>
                                                    </c:when>
                                                    <c:when test="${c.accountStatus == 'INACTIVE'}">
                                                        <span class="badge badge-red">Inactive</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-gray">No Account</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div>
                                            <div class="k">Customer ID</div>
                                            <div class="v">${c.customerId}</div>
                                        </div>

                                        <div>
                                            <div class="k">User ID</div>
                                            <div class="v">${c.userId != null ? c.userId : '—'}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </c:if>

                </div>
            </main>
        </div>
    </body>
</html>
