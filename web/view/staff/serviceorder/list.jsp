<%-- 
    
    Created on : Mar 1, 2026, 10:21:35 PM
    Author     : DieuBHHE191686
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="page" value="serviceorder" />
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>Staff | Service Orders</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff/app.css"/>

        <style>
            :root {
                --cream:       #f5f0e8;
                --cream-dark:  #ede7d9;
                --cream-light: #faf7f2;
                --brown:       #5c3d2e;
                --brown-light: #8b6248;
                --amber:       #c47b2b;
                --amber-light: #e8a44a;
                --amber-pale:  #f5deb8;
                --sage:        #5a7a5c;
                --sage-pale:   #ddeedd;
                --rust:        #b84c3c;
                --rust-pale:   #fae0dc;
                --border:      #ddd5c8;
                --shadow:      rgba(92,61,46,0.10);
                --text:        #2c1a0e;
                --muted:       #8a7060;
            }

            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                background: var(--cream);
                color: var(--text);
            }

            /* ── TOPBAR ── */
            .topbar {
                height: 78px;
                background: var(--cream-light);
                border-bottom: 1.5px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 30px;
                position: sticky;
                top: 0;
                z-index: 10;
                box-shadow: 0 2px 12px var(--shadow);
            }

            .title {

                font-size: 22px;
                font-weight: 900;
                color: var(--brown);
                letter-spacing: -.01em;
            }

            .crumb {
                font-size: 11px;
                font-weight: 700;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: .14em;
                margin-bottom: 3px;
            }

            .btn-primary {
                background: var(--amber);
                color: #fff;
                border: 0;
                padding: 12px 20px;
                border-radius: 12px;
                font-weight: 800;
                cursor: pointer;
                box-shadow: 0 6px 20px rgba(196,123,43,.28);
                text-decoration: none;
                display: inline-flex;
                gap: 8px;
                align-items: center;
                font-size: 13px;
                transition: background .18s, box-shadow .18s, transform .12s;
            }
            .btn-primary:hover {
                background: var(--amber-light);
                box-shadow: 0 8px 28px rgba(196,123,43,.38);
                transform: translateY(-1px);
            }

            /* ── LAYOUT ── */
            .wrap {
                padding: 28px 30px;
            }

            .grid {
                display: grid;
                grid-template-columns: 560px 1fr;
                gap: 24px;
                min-height: calc(100vh - 78px - 56px);
            }

            /* ── CARD ── */
            .card {
                background: var(--cream-light);
                border: 1.5px solid var(--border);
                border-radius: 20px;
                box-shadow: 0 8px 32px var(--shadow);
                overflow: hidden;
            }

            .panel-pad {
                padding: 20px;
            }

            /* ── INPUTS ── */
            .input {
                width: 100%;
                padding: 11px 14px;
                border-radius: 12px;
                border: 1.5px solid var(--border);
                background: var(--cream);
                outline: none;
                font-weight: 600;
                font-size: 13px;
                color: var(--text);
                font-family: 'DM Sans', sans-serif;
                transition: border-color .18s, box-shadow .18s;
            }
            .input::placeholder {
                color: var(--muted);
                font-weight: 500;
            }
            .input:focus {
                border-color: var(--amber);
                box-shadow: 0 0 0 3px rgba(196,123,43,.14);
            }

            /* ── TABS ── */
            .tabs {
                display: flex;
                background: var(--cream-dark);
                padding: 5px;
                border-radius: 14px;
                gap: 4px;
            }
            .tab {
                flex: 1;
                border: 0;
                background: transparent;
                padding: 9px 0;
                border-radius: 10px;
                font-weight: 800;
                letter-spacing: .12em;
                text-transform: uppercase;
                font-size: 10px;
                color: var(--muted);
                cursor: pointer;
                font-family: 'DM Sans', sans-serif;
                transition: background .18s, color .18s, box-shadow .18s;
            }
            .tab.active {
                background: var(--amber);
                color: #fff;
                box-shadow: 0 4px 14px rgba(196,123,43,.30);
            }
            .tab:not(.active):hover {
                background: var(--amber-pale);
                color: var(--brown);
            }

            /* ── TABLE ── */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
            }

            th {
                text-align: left;
                font-size: 10px;
                letter-spacing: .14em;
                text-transform: uppercase;
                color: var(--muted);
                padding: 11px 14px;
                background: var(--cream-dark);
                border-bottom: 1.5px solid var(--border);
                font-family: 'DM Sans', sans-serif;
                font-weight: 700;
            }

            td {
                padding: 13px 14px;
                border-bottom: 1px solid var(--cream-dark);
                font-weight: 700;
                color: var(--text);
                font-size: 13px;
            }

            tr.click {
                transition: background .14s;
            }
            tr.click:hover {
                background: var(--amber-pale);
                cursor: pointer;
            }
            tr.click.selected {
                background: #f5e8d0;
            }

            /* ── BADGES ── */
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 10px;
                font-weight: 800;
                letter-spacing: .12em;
                text-transform: uppercase;
                padding: 6px 10px;
                border-radius: 999px;
                border: 1.5px solid var(--border);
            }
            .b-draft    {
                background: var(--amber-pale);
                color: var(--amber);
                border-color: #e2c080;
            }
            .b-posted   {
                background: var(--sage-pale);
                color: var(--sage);
                border-color: #a8c8a8;
            }
            .b-cancel   {
                background: var(--rust-pale);
                color: var(--rust);
                border-color: #dda090;
            }

            /* ── DETAIL PANEL ── */
            .detail-head {
                padding: 24px 28px;
                border-bottom: 1.5px solid var(--border);
                display: flex;
                justify-content: space-between;
                gap: 14px;
                background: linear-gradient(135deg, #fdf8f0 0%, var(--cream-light) 100%);
            }

            .so-code {

                font-size: 26px;
                font-weight: 900;
                color: var(--brown);
                letter-spacing: -.02em;
                line-height: 1.15;
            }

            .meta {
                color: var(--muted);
                font-size: 11px;
                font-weight: 700;
                letter-spacing: .12em;
                text-transform: uppercase;
                margin-top: 6px;
            }

            .big-room {

                font-size: 56px;
                font-weight: 900;
                letter-spacing: -.05em;
                color: var(--brown);
                line-height: 1;
            }

            .detail-body {
                padding: 22px 28px;
            }

            .row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
            }

            .section-title {

                font-size: 15px;
                font-weight: 700;
                color: var(--brown);
                letter-spacing: .01em;
            }

            .link-primary {
                color: var(--amber);
                font-weight: 800;
                font-size: 13px;
                text-decoration: none;
                border: 1.5px solid var(--amber-pale);
                padding: 7px 14px;
                border-radius: 10px;
                transition: background .16s, border-color .16s;
            }
            .link-primary:hover {
                background: var(--amber-pale);
                border-color: var(--amber);
            }

            .items-box {
                margin-top: 14px;
                border: 1.5px solid var(--border);
                border-radius: 14px;
                overflow: hidden;
            }

            /* ── QTY CONTROLS ── */
            .qty-btn {
                width: 34px;
                height: 34px;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                background: var(--cream);
                font-weight: 900;
                cursor: pointer;
                font-size: 16px;
                color: var(--brown);
                transition: background .14s, border-color .14s;
            }
            .qty-btn:hover {
                background: var(--amber-pale);
                border-color: var(--amber);
            }

            .danger {
                color: var(--rust);
            }

            .btn-link {
                border: 0;
                background: transparent;
                font-weight: 800;
                cursor: pointer;
                font-family: 'DM Sans', sans-serif;
                font-size: 13px;
                padding: 7px 14px;
                border-radius: 10px;
                transition: background .16s;
            }
            .btn-link.danger {
                color: var(--rust);
                border: 1.5px solid var(--rust-pale);
            }
            .btn-link.danger:hover {
                background: var(--rust-pale);
            }

            /* ── FOOTER ACTIONS ── */
            .footer-actions {
                padding: 18px 28px;
                background: var(--cream-dark);
                border-top: 1.5px solid var(--border);
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 10px;
            }

            /* ── EMPTY STATE ── */
            .empty-state {
                padding: 60px 40px;
                text-align: center;
                color: var(--muted);
            }
            .empty-state svg {
                opacity: .3;
                margin-bottom: 16px;
            }
            .empty-state p {
                font-weight: 700;
                font-size: 14px;
            }

            /* ── DECORATIVE DIVIDER ── */
            .ornament {
                display: flex;
                align-items: center;
                gap: 10px;
                margin: 16px 0;
                color: var(--border);
                font-size: 12px;
            }
            .ornament::before, .ornament::after {
                content: '';
                flex: 1;
                height: 1px;
                background: var(--border);
            }
        </style>
    </head>

    <body>
        <div class="staff-layout">
            <jsp:include page="/view/staff/sidebar_staff/sidebar_staff.jsp"/>

            <div class="staff-content">
                <div class="topbar">
                    <div>
                        <div class="title">Manage Services</div>
                    </div>
                    <a class="btn-primary"
                       href="${pageContext.request.contextPath}/staff/service-orders/create?returnId=${selected != null ? selected.serviceOrderId : ''}">
                        + Add Service Order
                    </a>
                </div>

                <div class="wrap">
                    <div class="grid">

                        <!-- ═══ LEFT: LIST ═══ -->
                        <div class="card">
                            <div class="panel-pad" style="border-bottom:1.5px solid var(--border);">

                                <div class="tabs">
                                    <form method="get" action="${pageContext.request.contextPath}/staff/service-orders" style="display:contents;">
                                        <button class="tab ${empty param.status ? 'active' : ''}" name="status" value="">All</button>
                                        <button class="tab ${param.status == '0' ? 'active' : ''}" name="status" value="0">Draft</button>
                                        <button class="tab ${param.status == '1' ? 'active' : ''}" name="status" value="1">Posted</button>
                                        <button class="tab ${param.status == '2' ? 'active' : ''}" name="status" value="2">Cancelled</button>
                                    </form>
                                </div>

                                <div class="ornament">✦</div>

                                <form method="get" action="${pageContext.request.contextPath}/staff/service-orders">
                                    <input type="hidden" name="status" value="${fn:escapeXml(param.status)}"/>
                                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                                        <input class="input" name="roomNo"    placeholder="Room Number…"  value="${fn:escapeXml(param.roomNo)}"/>
                                        <input class="input" name="bookingId" placeholder="Booking ID…"  value="${fn:escapeXml(param.bookingId)}"/>
                                    </div>
                                    <div style="height:12px;"></div>
                                    <div style="display:flex; justify-content:flex-end;">
                                        <button class="btn-primary" type="submit" style="background:var(--brown); box-shadow:0 6px 20px rgba(92,61,46,.22);">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                            Apply Filter
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <div class="panel-pad" style="padding:0; max-height:calc(100vh - 340px); overflow:auto;">
                                <table>
                                    <thead>
                                        <tr>
                                            <th style="width:130px;">Order ID</th>
                                            <th style="width:100px;">Room Number</th>
                                            <th style="width:110px;">Booking ID</th>
                                            <th style="width:100px;">Status</th>
                                            <th style="text-align:right; padding-right:18px;">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="o" items="${orders}">
                                            <tr class="click"
                                                onclick="location.href = '${pageContext.request.contextPath}/staff/service-orders?id=${o.serviceOrderId}&status=${fn:escapeXml(param.status)}&roomId=${fn:escapeXml(param.roomId)}&bookingId=${fn:escapeXml(param.bookingId)}'">
                                                <td>#${o.serviceOrderId}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.roomNo == null}"><span style="color:var(--muted);">—</span></c:when>
                                                        <c:otherwise><c:out value="${o.roomNo}"/></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${o.bookingId}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.status == 0}"><span class="badge b-draft">Draft</span></c:when>
                                                        <c:when test="${o.status == 1}"><span class="badge b-posted">Posted</span></c:when>
                                                        <c:otherwise><span class="badge b-cancel">Cancelled</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align:right; padding-right:18px; color:var(--amber); font-weight:800;">
                                                    <fmt:formatNumber value="${o.total}" type="number" maxFractionDigits="0"/>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty orders}">
                                            <tr>
                                                <td colspan="5">
                                                    <div class="empty-state">
                                                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="3"/><line x1="9" y1="9" x2="15" y2="9"/><line x1="9" y1="12" x2="15" y2="12"/><line x1="9" y1="15" x2="12" y2="15"/></svg>
                                                        <p>No service orders found</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- ═══ RIGHT: DETAIL ═══ -->
                        <div class="card">
                            <c:if test="${selected == null}">
                                <div class="empty-state" style="padding:80px 40px;">
                                    <svg width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                    <p>Select an order to view details</p>
                                    <p style="font-size:12px; margin-top:6px; font-weight:500;">Click any row on the left</p>
                                </div>
                            </c:if>

                            <c:if test="${selected != null}">
                                <!-- HEADER -->
                                <div class="detail-head">
                                    <div>
                                        <div class="meta">Service Order</div>
                                        <div class="so-code">Service Order ID #${selected.serviceOrderId}</div>
                                        <div style="display:flex; align-items:center; gap:8px; margin-top:10px;">
                                            <c:choose>
                                                <c:when test="${selected.status == 0}"><span class="badge b-draft">Draft</span></c:when>
                                                <c:when test="${selected.status == 1}"><span class="badge b-posted">Posted</span></c:when>
                                                <c:otherwise><span class="badge b-cancel">Cancelled</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="meta" style="margin-top:10px;">
                                            Booking ID : ${selected.bookingId}
                                            <c:if test="${selected.postedAt != null}">
                                                &nbsp;·&nbsp; Posted: <c:out value="${selected.postedAt}"/>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div style="text-align:right;">
                                        <div class="meta">Room Number</div>
                                        <div class="big-room"><c:out value="${selected.roomNo == null ? '—' : selected.roomNo}"/></div>
                                    </div>
                                </div>

                                <!-- BODY -->
                                <div class="detail-body">
                                    <div class="row">
                                        <div class="section-title">
                                            Service Items
                                            <span class="badge" style="margin-left:8px; background:var(--amber-pale); border-color:#e2c080; color:var(--amber); font-size:9px;">
                                                <c:out value="${fn:length(selected.items)}"/>
                                            </span>
                                        </div>
                                        <c:if test="${selected.status == 0}">
                                            <a href="${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}&modal=addItems&type=1"
                                               class="link-primary">+ Add Items</a>
                                        </c:if>
                                    </div>

                                    <div class="items-box">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Service</th>
                                                    <th style="text-align:center;">Qty</th>
                                                    <th style="text-align:right;">Line Total</th>
                                                    <c:if test="${selected.status == 0}"><th style="width:50px;"></th></c:if>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="it" items="${selected.items}">
                                                    <tr>
                                                        <td>
                                                            <div style="font-weight:800; color:var(--text);"><c:out value="${it.serviceName}"/></div>
                                                            <div style="font-size:11px; font-weight:600; color:var(--muted); margin-top:2px;">
                                                                Unit: <c:out value="${it.unitPriceSnapshot}"/>
                                                            </div>
                                                        </td>

                                                        <td style="text-align:center;">
                                                            <c:choose>
                                                                <c:when test="${selected.status == 0}">
                                                                    <form style="display:inline-flex; align-items:center; gap:8px;"
                                                                          method="post" action="${pageContext.request.contextPath}/staff/service-orders/status">
                                                                        <input type="hidden" name="action"  value="qty"/>
                                                                        <input type="hidden" name="itemId"  value="${it.serviceOrderItemId}"/>
                                                                        <input type="hidden" name="orderId" value="${selected.serviceOrderId}"/>
                                                                        <button class="qty-btn" name="delta" value="-1" type="submit">−</button>
                                                                        <span style="min-width:22px; display:inline-block; font-weight:800; color:var(--brown);">
                                                                            <c:out value="${it.quantity}"/>
                                                                        </span>
                                                                        <button class="qty-btn" name="delta" value="1" type="submit">+</button>
                                                                    </form>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span style="font-weight:800;"><c:out value="${it.quantity}"/></span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td style="text-align:right; font-weight:800; color:var(--amber);">
                                                            <c:set var="line" value="${it.quantity * it.unitPriceSnapshot}"/>
                                                            <c:out value="${line}"/>
                                                        </td>

                                                        <c:if test="${selected.status == 0}">
                                                            <td style="text-align:center;">
                                                                <form method="post" action="${pageContext.request.contextPath}/staff/service-orders/status">
                                                                    <input type="hidden" name="action"  value="remove"/>
                                                                    <input type="hidden" name="itemId"  value="${it.serviceOrderItemId}"/>
                                                                    <input type="hidden" name="orderId" value="${selected.serviceOrderId}"/>
                                                                    <button class="btn-link danger" type="submit" 
                                                                            style="padding:6px 8px; font-size:14px; border-radius:8px;">
                                                                        🗑
                                                                    </button>
                                                                </form>
                                                            </td>
                                                        </c:if>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <c:set var="detailTotal" value="0" />
                                <c:forEach var="it" items="${selected.items}">
                                    <c:set var="detailTotal" value="${detailTotal + (it.quantity * it.unitPriceSnapshot)}" />
                                </c:forEach>                

                                <!-- FOOTER -->
                                <div class="footer-actions">

                                    <!--  LEFT: TOTAL -->
                                    <div style="display:flex; flex-direction:column; gap:4px;">
                                        <div class="meta" style="margin-top:0;">Total</div>

                                        <div style="font-size:24px; font-weight:900; color:var(--amber); line-height:1;">
                                            <fmt:formatNumber value="${detailTotal}" pattern="#,##0"/>
                                        </div>
                                    </div>

                                    <!--  RIGHT: ACTIONS -->
                                    <div style="display:flex; gap:10px; align-items:center;">
                                        <c:if test="${selected.status == 0}">
                                            <form method="post" action="${pageContext.request.contextPath}/staff/service-orders/status">
                                                <input type="hidden" name="action"  value="cancel"/>
                                                <input type="hidden" name="orderId" value="${selected.serviceOrderId}"/>
                                                <button class="btn-link danger" type="submit">🗑 Cancel Draft</button>
                                            </form>

                                            <form method="post" action="${pageContext.request.contextPath}/staff/service-orders/status">
                                                <input type="hidden" name="action"  value="post"/>
                                                <input type="hidden" name="orderId" value="${selected.serviceOrderId}"/>
                                                <button class="btn-primary" type="submit">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                    <polyline points="20 6 9 17 4 12"/>
                                                    </svg>
                                                    Mark as Posted
                                                </button>
                                            </form>
                                        </c:if>

                                        <c:if test="${selected.status == 1}">
                                            <span class="badge b-posted" style="padding:10px 16px;">✓ Posted</span>
                                        </c:if>

                                        <c:if test="${selected.status == 2}">
                                            <span class="badge b-cancel" style="padding:10px 16px;">Cancelled</span>
                                        </c:if>

                                        <c:if test="${modal == 'addItems' && selected != null}">
                                            <jsp:include page="/view/staff/serviceorder/additem_modal.jsp"/>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
