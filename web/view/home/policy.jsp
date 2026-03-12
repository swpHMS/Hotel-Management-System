<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>Hotel Policy</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/header_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/body_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/footer_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home_css/policy.css">
</head>

<body>

<!-- HEADER -->
<jsp:include page="/view/home/header.jsp"/>

<!-- HERO -->
<section class="policy-hero">
    <div class="container policy-hero__inner">
        <div class="policy-hero__eyebrow">GUEST INFORMATION</div>
        <h1 class="policy-hero__title">Hotel Policies</h1>
        <p class="policy-hero__sub">
            Everything you need to know for a smooth stay — check-in/out, cancellation, children, pets, and payment.
        </p>

        <div class="policy-hero__badges">
            <span class="policy-badge">Check-in 14:00</span>
            <span class="policy-badge">Check-out 12:00</span>
            <span class="policy-badge">Support 24/7</span>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="policy-section">
    <div class="container policy-layout">

        <!-- TOC -->
        <aside class="policy-toc" aria-label="Policy navigation">
            <div class="policy-card policy-toc__card">
                <div class="policy-card__title">On this page</div>

                <c:forEach var="p" items="${policies}">
                    <a class="policy-toc__link" href="#p${p.policyId}">
                        <c:out value="${p.name}"/>
                    </a>
                </c:forEach>

                <c:if test="${empty policies}">
                    <div class="policy-toc__hint">No policies found.</div>
                </c:if>
            </div>
        </aside>

        <!-- MAIN -->
        <main class="policy-main">
            <div class="policy-grid">

                <c:forEach var="p" items="${policies}">
                    <article class="policy-card" id="p${p.policyId}">
                        <div class="policy-card__head">
                            <h2 class="policy-card__h">
                                <c:out value="${p.name}"/>
                            </h2>
                        </div>

                        <!-- Render content (already formatted in Servlet) -->
                        <div class="policy-note">
                            <c:out value="${p.content}" escapeXml="false"/>
                        </div>
                    </article>
                </c:forEach>

                <c:if test="${empty policies}">
                    <article class="policy-card">
                        <h2 class="policy-card__h">No policies available</h2>
                        <p class="policy-card__p">
                            Please insert data into <b>policy_rules</b> table first.
                        </p>
                    </article>
                </c:if>

            </div>
        </main>

    </div>
</section>

<!-- FOOTER -->
<jsp:include page="/view/home/footer.jsp"/>

</body>
</html>
