<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2 style="margin:0 0 12px; color:#111827;">Past Stays</h2>

<c:choose>
  <c:when test="${empty pastStays}">
    <div class="empty">
      <div class="icon">🏨</div>
      <h3>No past stays</h3>
      <p>Your stay history will appear here.</p>
    </div>
  </c:when>

  <c:otherwise>
    <ul>
      <c:forEach var="b" items="${pastStays}">
        <li style="margin:10px 0;">
          <b>#${b.bookingId}</b> | ${b.statusText} |
          ${b.roomTypeName} |
          ${b.checkInDate} → ${b.checkOutDate} |
          total=${b.totalAmount}
        </li>
      </c:forEach>
    </ul>
  </c:otherwise>
</c:choose>