<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer-rq" id="contact">
  <div class="container rq-wrap">
    <div>
      <div class="rq-brand">
        <div class="rq-mark" aria-hidden="true">
          <svg viewBox="0 0 24 24">
            <path d="M3 9l4 4 5-7 5 7 4-4"/>
            <path d="M5 20h14"/>
            <path d="M6 18h12"/>
            <path d="M6 18l-1-7h14l-1 7"/>
          </svg>
        </div>
        <div>
          <h3 class="rq-brandname">
            <c:out value="${hotel != null ? hotel.name : 'Regal Quintet Hotel'}"/>
          </h3>
          <div class="rq-brandsub">Hotel & Resorts</div>
        </div>
      </div>

      <p class="rq-desc">
        <c:out value="${hotel != null ? hotel.content : 'A refined stay with modern comfort and timeless elegance.'}"/>
      </p>
    </div>

    <div>
      <div class="rq-right-title">Reservations & Location</div>

      <ul class="rq-info">
        <!-- Address -->
        <li class="rq-item">
          <span class="rq-ico" aria-hidden="true">
            <svg viewBox="0 0 24 24">
              <path d="M12 21s7-4.5 7-11a7 7 0 1 0-14 0c0 6.5 7 11 7 11z"/>
              <path d="M12 10.5a2.2 2.2 0 1 0 0-4.4 2.2 2.2 0 0 0 0 4.4z"/>
            </svg>
          </span>
          <span><c:out value="${hotel != null ? hotel.address : '—'}"/></span>
        </li>

        <!-- Phone -->
        <li class="rq-item">
          <span class="rq-ico" aria-hidden="true">
            <svg viewBox="0 0 24 24">
              <path d="M22 16.9v3a2 2 0 0 1-2.2 2c-9.6-.9-17.1-8.4-18-18A2 2 0 0 1 3.9 1h3a2 2 0 0 1 2 1.7c.1 1 .3 2 .6 3a2 2 0 0 1-.5 2.1L8 9a16 16 0 0 0 7 7l1.2-1a2 2 0 0 1 2.1-.5c1 .3 2 .5 3 .6a2 2 0 0 1 1.7 2z"/>
            </svg>
          </span>

          <c:choose>
            <c:when test="${hotel != null && not empty hotel.phone}">
              <a class="rq-link" href="tel:${hotel.phone}">
                <c:out value="${hotel.phone}"/>
              </a>
            </c:when>
            <c:otherwise>
              <span>—</span>
            </c:otherwise>
          </c:choose>
        </li>

        <!-- Email -->
        <li class="rq-item">
          <span class="rq-ico" aria-hidden="true">
            <svg viewBox="0 0 24 24">
              <path d="M4 4h16v16H4z"/>
              <path d="M4 6l8 7 8-7"/>
            </svg>
          </span>

          <c:choose>
            <c:when test="${hotel != null && not empty hotel.email}">
              <a class="rq-link" href="mailto:${hotel.email}">
                <c:out value="${hotel.email}"/>
              </a>
            </c:when>
            <c:otherwise>
              <span>—</span>
            </c:otherwise>
          </c:choose>
        </li>
      </ul>
    </div>
  </div>
</footer>
