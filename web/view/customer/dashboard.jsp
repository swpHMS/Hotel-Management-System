<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Customer Dashboard</title>
        <style>
            body{
                margin:0;
                font-family:Arial,sans-serif;
                background:#f6f6f6;
            }
            .topbar{
                background:#0a1b2a;
                color:#fff;
                padding:22px 36px;
                display:flex;
                align-items:center;
                gap:18px;
            }
            .avatar{
                width:78px;
                height:78px;
                border-radius:50%;
                background:#5b4bff;
                color:#fff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:800;
                font-size:28px;
                border:4px solid #d7b36a;
                flex:0 0 auto;
            }
            .welcome h1{
                margin:0;
                font-size:34px;
            }
            .sub{
                margin-top:8px;
                opacity:.85;
                font-size:14px;
                display:flex;
                gap:18px;
                flex-wrap:wrap;
            }
            .container{
                display:flex;
                gap:24px;
                padding:28px 36px;
            }
            .sidebar{
                width:320px;
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 10px rgba(0,0,0,.05);
                overflow:hidden;
                display:flex;
                flex-direction:column;
            }
            .menu{
                padding:18px 0;
            }
            .menu a{
                display:flex;
                gap:12px;
                align-items:center;
                padding:14px 18px;
                text-decoration:none;
                color:#333;
                font-weight:600;
            }
            .menu a:hover{
                background:#f3f3f3;
            }
            .menu a.active{
                background:#f0ece3;
                color:#9a6a10;
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
                gap:10px;
                background:#0a1b2a;
                color:#fff;
                padding:12px 14px;
                border-radius:6px;
                text-decoration:none;
                font-weight:700;
                justify-content:center;
            }
            .content{
                flex:1;
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 10px rgba(0,0,0,.05);
                min-height:420px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#666;
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
                font-weight:800;
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
            /* ===== Sidebar menu đẹp hơn (có disabled) ===== */
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
                background:#d7b36a;
            }

            /* disabled option (chưa làm feature) */
            .menu a.disabled{
                opacity:.65;
                cursor:not-allowed;
                pointer-events:none;         /* không cho click */
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

        </style>
    </head>

    <body>
        <div class="topbar">
            <div class="avatar">${initials}</div>

            <div class="welcome">
                <h1>Welcome, <c:out value="${profile.fullName}" default="User"/></h1>
                <div class="sub">
                    <span>✉ <c:out value="${profile.email}" default=""/></span>
                    <span>📍 <c:out value="${profile.residenceAddress}" default=""/></span>
                </div>
            </div>

            <!-- ✅ Bỏ Gold member / Points / Stayed -->
        </div>

        <div class="container">
            <div class="sidebar">
                <div class="menu">
                    <a class="disabled" href="javascript:void(0)">
                        <span class="mi">📅</span>
                        <span class="text">
                            <span class="title">Current Bookings</span>
                            <span class="desc">Coming soon</span>
                        </span>
                    </a>

                    <a class="disabled" href="javascript:void(0)">
                        <span class="mi">🏨</span>
                        <span class="text">
                            <span class="title">Past Stays</span>
                            <span class="desc">Coming soon</span>
                        </span>
                    </a>

                    <a class="active" href="${pageContext.request.contextPath}/customer/profile">
                        <span class="mi">👤</span>
                        <span class="text">
                            <span class="title">Profile</span>
                            <span class="desc">View your information</span>
                        </span>
                    </a>
                </div>


                <!-- ✅ Back to home ở cuối sidebar -->
                <div class="back">
                    <!-- home co duong dan gi thi de o duoi sau phan /   -->
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
