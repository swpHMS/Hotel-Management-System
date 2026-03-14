<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Property Information</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root{
    --bg: #f5f1ea;
    --card: #fcfbf8;
    --navy: #0b2341;
    --navy-2: #102b4c;
    --gold: #c9a24f;
    --muted: #8d9bb2;
    --line: #e7e2d8;
    --shadow: 0 10px 30px rgba(11,35,65,.08);
    --radius-xl: 34px;
    --radius-lg: 26px;
    --radius-md: 18px;
}

*{
    box-sizing: border-box;
}

body{
    margin: 0;
    font-family: "Segoe UI", Arial, sans-serif;
    background: var(--bg);
    color: var(--navy);
}

.page{
    min-height: 100vh;
    background: var(--bg);
}

.main{
    margin-left: 260px;
    min-height: 100vh;
    padding: 0;
}

.topbar{
    height: 84px;
    background: rgba(255,255,255,0.55);
    backdrop-filter: blur(8px);
    border-bottom: 1px solid rgba(11,35,65,.08);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 30px;
}

.topbar-left{
    display: flex;
    align-items: center;
    gap: 18px;
}

.back-btn{
    width: 42px;
    height: 42px;
    border-radius: 12px;
    border: 1px solid rgba(11,35,65,.12);
    background: #fff;
    color: var(--navy);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    text-decoration: none;
}

.hotel-name{
    font-family: Georgia, "Times New Roman", serif;
    font-size: 23px;
    font-weight: 700;
    color: var(--navy);
}

.topbar-right{
    display: flex;
    align-items: center;
    gap: 18px;
}

.market-box{
    text-align: center;
    line-height: 1.2;
}

.market-label{
    font-size: 11px;
    color: #95a3b9;
    font-weight: 800;
    letter-spacing: 1.2px;
    text-transform: uppercase;
}

.market-status{
    font-size: 13px;
    font-weight: 700;
    color: #2eaf6d;
}

.market-status::before{
    content: "●";
    font-size: 9px;
    margin-right: 6px;
    vertical-align: middle;
}

.manager-box{
    display: flex;
    align-items: center;
    gap: 12px;
}

.manager-meta{
    text-align: right;
}

.manager-name{
    font-weight: 700;
    font-size: 14px;
    color: var(--navy);
}

.manager-role{
    font-size: 10px;
    color: var(--gold);
    font-weight: 900;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.manager-avatar{
    width: 50px;
    height: 50px;
    border-radius: 16px;
    background: var(--navy);
    color: var(--gold);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    font-size: 18px;
    box-shadow: var(--shadow);
}

.content{
    padding: 34px 36px 48px;
}

.hero{
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 18px;
    margin-bottom: 22px;
}

.hero-title{
    font-family: Georgia, "Times New Roman", serif;
    font-size: 28px;
    font-weight: 800;
    letter-spacing: 1.6px;
    text-transform: uppercase;
    color: var(--navy);
    margin: 0 0 6px;
}

.hero-subtitle{
    margin: 0;
    color: #6e7d93;
    font-size: 13px;
    font-style: italic;
    font-weight: 600;
}

.hero-action{
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
    background: var(--gold);
    color: #fff;
    padding: 14px 22px;
    min-width: 210px;
    justify-content: center;
    border-radius: 16px;
    font-weight: 800;
    font-size: 14px;
    box-shadow: 0 12px 22px rgba(201,162,79,.22);
    white-space: nowrap;
}

.divider{
    height: 1px;
    background: var(--line);
    margin-bottom: 28px;
}

.grid-top{
    display: grid;
    grid-template-columns: 1.35fr .85fr;
    gap: 28px;
    margin-bottom: 26px;
}

.section-card{
    background: var(--card);
    border: 1px solid rgba(11,35,65,.06);
    border-radius: 30px;
    padding: 24px 26px;
    box-shadow: var(--shadow);
}

.section-head{
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 20px;
}

.icon-box{
    width: 60px;
    height: 60px;
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    flex-shrink: 0;
}

.icon-gold{
    background: rgba(201,162,79,.12);
    color: var(--gold);
}

.icon-blue{
    background: rgba(11,35,65,.08);
    color: var(--navy);
}

.icon-green{
    background: rgba(23,174,112,.12);
    color: #159a64;
}

.eyebrow{
    color: #97a5bc;
    font-size: 11px;
    font-weight: 900;
    letter-spacing: 2.4px;
    text-transform: uppercase;
    margin-bottom: 4px;
}

.section-title{
    font-size: 18px;
    font-weight: 900;
    color: var(--navy);
    margin: 0;
}

.big-name{
    font-family: Georgia, "Times New Roman", serif;
    font-size: 24px;
    font-weight: 800;
    margin: 4px 0 14px;
    color: var(--navy);
}

.description-box{
    position: relative;
    border-radius: 22px;
    padding: 6px 4px 0 2px;
}

.description-text{
    font-family: Georgia, "Times New Roman", serif;
    font-size: 20px;
    line-height: 1.55;
    font-style: italic;
    font-weight: 600;
    color: #5f6b80;
    margin: 0;
}

.contact-card-dark{
    background: linear-gradient(180deg, #071c39 0%, #081c37 100%);
    color: #fff;
    border: none;
}

.contact-card-dark .section-title,
.contact-card-dark .eyebrow{
    color: #fff;
}

.contact-list{
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin-top: 14px;
}

.contact-item{
    display: grid;
    grid-template-columns: 56px 1fr;
    gap: 16px;
    align-items: start;
}

.contact-icon{
    width: 52px;
    height: 52px;
    border-radius: 16px;
    background: rgba(255,255,255,.08);
    color: var(--gold);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
}

.contact-label{
    font-size: 11px;
    letter-spacing: 1.4px;
    text-transform: uppercase;
    color: #92a0b6;
    font-weight: 900;
    margin-bottom: 5px;
}

.contact-value{
    color: #fff;
    font-size: 16px;
    font-weight: 800;
    line-height: 1.45;
    word-break: break-word;
}

.bottom-card{
    background: var(--card);
    border: 1px solid rgba(11,35,65,.06);
    border-radius: 32px;
    padding: 24px 26px 26px;
    box-shadow: var(--shadow);
}

.bottom-head{
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 20px;
}

.bottom-separator{
    height: 1px;
    background: #ece6dc;
    margin-bottom: 20px;
}

.protocol-grid{
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 22px;
    align-items: stretch;
}

.protocol-left{
    background: #f7f8fb;
    border-radius: 26px;
    min-height: 220px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 24px 18px;
    border: 1px solid rgba(11,35,65,.05);
}

.clock-circle{
    width: 66px;
    height: 66px;
    border-radius: 999px;
    border: 4px solid var(--navy);
    position: relative;
    margin-bottom: 20px;
}

.clock-circle::before{
    content: "";
    position: absolute;
    width: 4px;
    height: 20px;
    background: var(--navy);
    left: 50%;
    top: 14px;
    transform: translateX(-50%);
    border-radius: 5px;
}

.clock-circle::after{
    content: "";
    position: absolute;
    width: 16px;
    height: 4px;
    background: var(--navy);
    left: 50%;
    top: 31px;
    transform: translateX(-2px) rotate(35deg);
    transform-origin: left center;
    border-radius: 5px;
}

.protocol-mini{
    color: #98a6bc;
    font-size: 11px;
    font-weight: 900;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 8px;
}

.protocol-big{
    font-size: 18px;
    font-weight: 900;
    color: var(--navy);
    margin-bottom: 10px;
}

.protocol-note{
    color: #9eabbe;
    font-style: italic;
    font-size: 13px;
    font-weight: 700;
}

.protocol-right{
    background: #fafbfc;
    border: 1px solid rgba(11,35,65,.05);
    border-radius: 26px;
    padding: 28px 34px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.protocol-label{
    color: #97a5bc;
    font-size: 11px;
    letter-spacing: 3px;
    font-weight: 900;
    text-transform: uppercase;
    margin-bottom: 14px;
}

.protocol-text{
    margin: 0;
    color: #58657b;
    font-size: 17px;
    line-height: 1.75;
    font-style: italic;
    font-family: Georgia, "Times New Roman", serif;
    font-weight: 600;
}

.success{
    margin-bottom: 18px;
    background: #e4f6e9;
    color: #247245;
    border: 1px solid #bfe3ca;
    border-radius: 16px;
    padding: 14px 18px;
    font-size: 14px;
    font-weight: 700;
}

@media (max-width: 1280px){
    .grid-top{
        grid-template-columns: 1fr;
    }

    .protocol-grid{
        grid-template-columns: 1fr;
    }
}

@media (max-width: 992px){
    .main{
        margin-left: 0;
    }

    .topbar{
        padding: 0 18px;
    }

    .content{
        padding: 24px 18px 40px;
    }

    .hero{
        flex-direction: column;
        align-items: flex-start;
    }
}
    </style>
</head>
<body>
<div class="page">
    <% request.setAttribute("active", "propertyInfo"); %>
    <jsp:include page="/view/manager/sidebar.jsp"/>

    <main class="main">
        

        <section class="content">
            <div class="hero">
                <div>
                    <h1 class="hero-title">Property Intelligence</h1>
                    <p class="hero-subtitle">
                        Maintaining the identity and operational standards of our heritage brand.
                    </p>
                </div>

                <a class="hero-action" href="${pageContext.request.contextPath}/manager/property-info/edit">
                    <i class="bi bi-pencil"></i>
                    <span>Update Registry</span>
                </a>
            </div>

            <div class="divider"></div>

            <c:if test="${param.success == '1'}">
                <div class="success">Cập nhật hotel information thành công.</div>
            </c:if>

            <div class="grid-top">
                <div class="section-card">
                    <div class="section-head">
                        <div class="icon-box icon-gold">
                            <i class="bi bi-building"></i>
                        </div>
                        <div>
                            <div class="eyebrow">Property Profile</div>
                            <h2 class="section-title">Heritage Introduction</h2>
                        </div>
                    </div>

                    <div class="big-name">${hotel.name}</div>

                    <div class="description-box">
                        <p class="description-text">
                            ${hotel.content}
                        </p>
                    </div>
                </div>

                <div class="section-card contact-card-dark">
                    <div class="section-head">
                        <div class="icon-box icon-blue" style="background: rgba(255,255,255,.08); color: var(--gold);">
                            <i class="bi bi-telephone"></i>
                        </div>
                        <div>
                            <div class="eyebrow">Registry Details</div>
                            <h2 class="section-title">Global Communications</h2>
                        </div>
                    </div>

                    <div class="contact-list">
                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="bi bi-geo-alt"></i>
                            </div>
                            <div>
                                <div class="contact-label">Official Address</div>
                                <div class="contact-value">${hotel.address}</div>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="bi bi-telephone"></i>
                            </div>
                            <div>
                                <div class="contact-label">Primary Hotline</div>
                                <div class="contact-value">${hotel.phone}</div>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="bi bi-envelope"></i>
                            </div>
                            <div>
                                <div class="contact-label">Official Email</div>
                                <div class="contact-value">${hotel.email}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bottom-card">
                <div class="bottom-head">
                    <div class="icon-box icon-green">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <div>
                        <div class="eyebrow">Global Standards</div>
                        <h2 class="section-title">Operational Protocols</h2>
                    </div>
                </div>

                <div class="bottom-separator"></div>

                <div class="protocol-grid">
                    <div class="protocol-left">
                        <div class="clock-circle"></div>
                        <div class="protocol-mini">Operational Readiness</div>
                        <div class="protocol-big">Perpetual Access</div>
                        <div class="protocol-note">Concierge Desk Available 24/7</div>
                    </div>

                    <div class="protocol-right">
                        <div class="protocol-label">Property Statutes</div>
                        <p class="protocol-text">
                            Check-in: ${hotel.checkIn != null ? hotel.checkIn.toString().substring(0,5) : ""}<br>
                            Check-out: ${hotel.checkOut != null ? hotel.checkOut.toString().substring(0,5) : ""}<br>
                            Attire: Smart Casual in public areas.<br>
                            Privacy: Absolute non-disclosure policy for all guests.
                        </p>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>