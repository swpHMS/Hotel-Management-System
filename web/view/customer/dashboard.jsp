<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Customer Dashboard</title>

        <style>
            body{
                margin:0;
                font-family: Arial, sans-serif;
                background:#f6f6f6;
            }

            /* ===== Topbar: gradient giống header (dùng variables từ header.css) ===== */
            .topbar{
                background: linear-gradient(90deg, var(--bg1), var(--bg2));
                color: var(--text);
                padding:22px 36px;
                display:flex;
                align-items:center;
                gap:18px;
                border-bottom:1px solid var(--line);
            }

            /* Avatar đồng bộ màu với avatar header */
            .dash-avatar{
                width:78px;
                height:78px;
                border-radius:50%;
                background: var(--gold);
                color:#1b1406;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:900;
                font-size:28px;
                border:4px solid rgba(216,177,91,.55);
                box-shadow: 0 10px 24px rgba(0,0,0,.18);
                flex:0 0 auto;
                user-select:none;
            }

            .welcome h1{
                margin:0;
                font-size:34px;
                letter-spacing:.2px;
                color: var(--text);
            }

            .sub{
                margin-top:8px;
                opacity:.9;
                font-size:14px;
                display:flex;
                gap:18px;
                flex-wrap:wrap;
                color: var(--muted);
            }
            .sub span{
                display:flex;
                align-items:center;
                gap:8px;
            }

            .container{
                display:flex;
                gap:24px;
                padding:28px 36px;
            }

            .sidebar{
                width:320px;
                background:#fff;
                border-radius:10px;
                box-shadow:0 2px 10px rgba(0,0,0,.05);
                overflow:hidden;
                display:flex;
                flex-direction:column;
            }

            /* Sidebar menu */
            .menu{
                padding:14px;
            }

            .menu a{
                display:flex;
                align-items:center;
                gap:12px;
                padding:12px 14px;
                margin:8px 0;
                border-radius:12px;
                text-decoration:none;
                color:#0f172a;
                font-weight:650;
                background:#fff;
                border:1px solid #eef2f7;
                transition:all .18s ease;
                position:relative;
            }
            .menu a .mi{
                width:36px;
                height:36px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f1f5f9;
                color:#0a1b2a;
                font-size:18px;
                flex:0 0 auto;
            }
            .menu a .text{
                display:flex;
                flex-direction:column;
                line-height:1.15;
            }
            .menu a .title{
                font-size:14px;
            }
            .menu a .desc{
                font-size:12px;
                color:#64748b;
                margin-top:3px;
                font-weight:500;
            }

            .menu a:hover{
                background:#f8fafc;
                transform:translateX(2px);
                border-color:#e2e8f0;
            }
            .menu a:hover .mi{
                background:#e9eef6;
            }

            .menu a.active{
                background:#f0ece3;
                border-color:#ead7b3;
                color:#8a5a08;
            }
            .menu a.active .mi{
                background:#fff3db;
                color:#9a6a10;
                box-shadow:0 6px 18px rgba(154,106,16,.12);
            }
            .menu a.active::before{
                content:"";
                position:absolute;
                left:-2px;
                top:10px;
                bottom:10px;
                width:4px;
                border-radius:10px;
                background: rgba(216,177,91,.75);
            }

            /* disabled option */
            .menu a.disabled{
                opacity:.65;
                cursor:not-allowed;
                pointer-events:none;
                background:#fafafa;
                border-color:#f0f0f0;
                transform:none !important;
            }
            .menu a.disabled .mi{
                background:#f3f4f6;
                color:#64748b;
            }
            .menu a.disabled .desc{
                font-style:italic;
            }

            .back{
                margin-top:auto;
                padding:18px;
                background:#fff;
                border-top:1px solid #eee;
            }
            .back a{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:10px;
                background:#0a1b2a;
                color:#fff;
                padding:12px 14px;
                border-radius:8px;
                text-decoration:none;
                font-weight:800;
            }

            .content{
                flex:1;
                background:#fff;
                border-radius:10px;
                box-shadow:0 2px 10px rgba(0,0,0,.05);
                min-height:420px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#666;
                padding:22px;
            }

            .empty{
                text-align:center;
            }
            .empty .icon{
                width:56px;
                height:56px;
                margin:0 auto 10px;
                border-radius:50%;
                background:#f0f0f0;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:900;
            }
            .empty h3{
                margin:10px 0 6px;
                color:#111;
            }
            .empty p{
                margin:0;
                color:#888;
                font-style:italic;
            }

            @media (max-width: 900px){
                .container{
                    flex-direction:column;
                    padding:18px;
                }
                .sidebar{
                    width:100%;
                }
                .topbar{
                    padding:18px;
                }
                .welcome h1{
                    font-size:26px;
                }
                .dash-avatar{
                    width:64px;
                    height:64px;
                    font-size:22px;
                }
            }
        </style>
    </head>

    <body>
        <!-- Include header trong body (đúng chuẩn HTML) -->
        <jsp:include page="/view/common/header.jsp" />

        <!-- Topbar theo khách hàng -->
        <div class="topbar">
            <div class="dash-avatar">
                <c:out value="${initials}" default="U"/>
            </div>

            <div class="welcome">
                <h1>Welcome, <c:out value="${profile.fullName}" default="User"/></h1>

                <div class="sub">
                    <span>✉ <c:out value="${profile.email}" default=""/></span>
                    <span>📍 <c:out value="${profile.residenceAddress}" default=""/></span>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="sidebar">
                <div class="menu">
                    <a data-tab="current" href="${pageContext.request.contextPath}/customer/dashboard?tab=current">
                        <span class="mi">📅</span>
                        <span class="text">
                            <span class="title">Current Bookings</span>
                            <span class="desc">Your upcoming stays</span>
                        </span>
                    </a>

                    <a data-tab="past" href="${pageContext.request.contextPath}/customer/dashboard?tab=past">
                        <span class="mi">🏨</span>
                        <span class="text">
                            <span class="title">Past Stays</span>
                            <span class="desc">Stay history</span>
                        </span>
                    </a>

                    <a data-tab="profile" href="${pageContext.request.contextPath}/customer/profile">
                        <span class="mi">👤</span>
                        <span class="text">
                            <span class="title">Profile</span>
                            <span class="desc">View your information</span>
                        </span>
                    </a>
                </div>


                <div class="back">
                    <a href="${pageContext.request.contextPath}/">← Back to Home</a>
                </div>
            </div>

            <div class="content">
                <div class="empty">
                    <div class="icon">□</div>
                    <h3>No records found</h3>
                    <p>Go to Profile to view your information.</p>
                </div>
            </div>
        </div>
    </body>
    
</html>
