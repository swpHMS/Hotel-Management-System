<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${mode == 'create' ? 'Create Property Information' : 'Update Property Information'}</title>
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
            }

            .topbar{
                height: 82px;
                background: rgba(255,255,255,0.55);
                backdrop-filter: blur(8px);
                border-bottom: 1px solid rgba(11,35,65,.08);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 28px;
            }

            .topbar-left{
                display: flex;
                align-items: center;
                gap: 18px;
            }

            .back-btn{
                width: 40px;
                height: 40px;
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
                font-size: 24px;
                font-weight: 700;
                color: var(--navy);
            }

            .topbar-right{
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .manager-meta{
                text-align: right;
            }

            .manager-name{
                font-weight: 700;
                font-size: 15px;
                color: var(--navy);
            }

            .manager-role{
                font-size: 12px;
                color: var(--gold);
                font-weight: 900;
                letter-spacing: 1.4px;
                text-transform: uppercase;
            }

            .manager-avatar{
                width: 48px;
                height: 48px;
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
                padding: 30px 34px 48px;
            }

            .hero{
                margin-bottom: 22px;
            }

            .hero-title{
                font-family: Georgia, "Times New Roman", serif;
                font-size: 28px;
                font-weight: 800;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                color: var(--navy);
                margin: 0 0 6px;
            }

            .hero-subtitle{
                margin: 0;
                color: #6e7d93;
                font-size: 14px;
                font-style: italic;
                font-weight: 600;
            }

            .form-grid{
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 26px;
                align-items: start;
            }

            .form-card{
                background: var(--card);
                border: 1px solid rgba(11,35,65,.06);
                border-radius: 28px;
                padding: 22px 24px;
                box-shadow: var(--shadow);
            }

            .form-card.full{
                grid-column: 1 / -1;
            }

            .section-head{
                display: flex;
                align-items: center;
                gap: 14px;
                margin-bottom: 20px;
            }

            .icon-box{
                width: 58px;
                height: 58px;
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
                font-size: 12px;
                font-weight: 900;
                letter-spacing: 2.4px;
                text-transform: uppercase;
                margin-bottom: 4px;
            }

            .section-title{
                font-size: 19px;
                font-weight: 900;
                color: var(--navy);
                margin: 0;
            }

            .field{
                margin-bottom: 18px;
            }

            .field:last-child{
                margin-bottom: 0;
            }

            .field label{
                display: block;
                color: #97a5bc;
                font-size: 12px;
                font-weight: 900;
                letter-spacing: 1.8px;
                text-transform: uppercase;
                margin-bottom: 8px;
            }

            .field input,
            .field textarea{
                width: 100%;
                border: 1px solid #d9e0ea;
                background: #f7f9fc;
                color: var(--navy);
                border-radius: 16px;
                padding: 14px 16px;
                font-size: 15px;
                outline: none;
                transition: .2s ease;
                font-family: inherit;
            }

            .field input:focus,
            .field textarea:focus{
                border-color: #9eb2d0;
                background: #fff;
                box-shadow: 0 0 0 4px rgba(16,43,76,.05);
            }

            .field textarea{
                min-height: 170px;
                resize: vertical;
                line-height: 1.6;
            }

            .dual-row{
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px;
            }

            .actions{
                display: flex;
                justify-content: flex-end;
                gap: 14px;
                margin-top: 28px;
            }

            .btn{
                border: none;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                min-width: 190px;
                padding: 14px 20px;
                border-radius: 18px;
                font-size: 15px;
                font-weight: 900;
                letter-spacing: .2px;
                cursor: pointer;
            }

            .btn-secondary{
                background: #e7ecf3;
                color: #66758b;
            }

            .btn-primary{
                background: var(--navy);
                color: #fff;
                box-shadow: 0 12px 22px rgba(11,35,65,.18);
            }

            .error{
                margin-bottom: 16px;
                background: #fde8e8;
                color: #b42318;
                border: 1px solid #f3b6b6;
                border-radius: 14px;
                padding: 12px 16px;
                font-size: 15px;
                font-weight: 700;
            }

            @media (max-width: 1200px){
                .form-grid{
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 992px){
                .main{
                    margin-left: 0;
                }

                .content{
                    padding: 24px 18px 40px;
                }

                .topbar{
                    padding: 0 18px;
                }

                .dual-row{
                    grid-template-columns: 1fr;
                }

                .actions{
                    flex-direction: column;
                    align-items: stretch;
                }

                .btn{
                    width: 100%;
                    min-width: unset;
                }
            }
            .field-error{
                margin-top: 6px;
                color: #b42318;
                font-size: 13px;
                font-weight: 600;
            }

            .input-error{
                border-color: #f04438 !important;
                background: #fff5f5 !important;
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
                        <h1 class="hero-title">Property Intelligence</h1>
                        <p class="hero-subtitle">
                            Maintaining the identity and operational standards of our heritage brand.
                        </p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/manager/property-info/save" method="post">
                        <input type="hidden" name="hotelId" value="${hotel.hotelId}"/>

                        <div class="form-grid">
                            <div class="form-card">
                                <div class="section-head">
                                    <div class="icon-box icon-gold">
                                        <i class="bi bi-info-circle"></i>
                                    </div>
                                    <div>
                                        <div class="eyebrow">Property Profile</div>
                                        <h2 class="section-title">Heritage Introduction</h2>
                                    </div>
                                </div>

                                <div class="field">
                                    <label>Property Name</label>
                                    <input type="text" name="name" value="${hotel.name}"
                                           class="${not empty errors.name ? 'input-error' : ''}" required>
                                    <c:if test="${not empty errors.name}">
                                        <div class="field-error">${errors.name}</div>
                                    </c:if>
                                </div>

                                <div class="field">
                                    <label>Brand Introduction</label>
                                    <textarea name="content" class="${not empty errors.content ? 'input-error' : ''}" required>${hotel.content}</textarea>
                                    <c:if test="${not empty errors.content}">
                                        <div class="field-error">${errors.content}</div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="form-card">
                                <div class="section-head">
                                    <div class="icon-box icon-blue">
                                        <i class="bi bi-telephone"></i>
                                    </div>
                                    <div>
                                        <div class="eyebrow">Registry Details</div>
                                        <h2 class="section-title">Global Communications</h2>
                                    </div>
                                </div>

                                <div class="field">
                                    <label>Official Address</label>
                                    <input type="text" name="address" value="${hotel.address}"
                                           class="${not empty errors.address ? 'input-error' : ''}" required>
                                    <c:if test="${not empty errors.address}">
                                        <div class="field-error">${errors.address}</div>
                                    </c:if>
                                </div>

                                <div class="dual-row">
                                    <div class="field">
                                        <label>Primary Hotline</label>
                                        <input type="text" name="phone" value="${hotel.phone}"
                                               class="${not empty errors.phone ? 'input-error' : ''}" required>
                                        <c:if test="${not empty errors.phone}">
                                            <div class="field-error">${errors.phone}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <label>Official Email</label>
                                        <input type="email" name="email" value="${hotel.email}"
                                               class="${not empty errors.email ? 'input-error' : ''}" required>
                                        <c:if test="${not empty errors.email}">
                                            <div class="field-error">${errors.email}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <div class="form-card full">
                                <div class="section-head">
                                    <div class="icon-box icon-green">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                    <div>
                                        <div class="eyebrow">Global Standards</div>
                                        <h2 class="section-title">Operational Protocols & Policies</h2>
                                    </div>
                                </div>

                                <div class="dual-row">
                                    <div class="field">
                                        <label>Check-in Time</label>
                                        <input type="time" name="checkInTime"
                                               class="${not empty errors.checkInTime ? 'input-error' : ''}"
                                               value="${hotel.checkIn != null ? hotel.checkIn.toString().substring(0,5) : ''}" required>
                                        <c:if test="${not empty errors.checkInTime}">
                                            <div class="field-error">${errors.checkInTime}</div>
                                        </c:if>
                                    </div>

                                    <div class="field">
                                        <label>Check-out Time</label>
                                        <input type="time" name="checkOutTime"
                                               class="${not empty errors.checkOutTime ? 'input-error' : ''}"
                                               value="${hotel.checkOut != null ? hotel.checkOut.toString().substring(0,5) : ''}" required>
                                        <c:if test="${not empty errors.checkOutTime}">
                                            <div class="field-error">${errors.checkOutTime}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="actions">
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/manager/property-info">
                                Discard Changes
                            </a>

                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-floppy"></i>
                                <span>${mode == 'create' ? 'Create Hotel Information' : 'Confirm Updates'}</span>
                            </button>
                        </div>
                    </form>
                </section>
            </main>
        </div>
    </body>
</html>