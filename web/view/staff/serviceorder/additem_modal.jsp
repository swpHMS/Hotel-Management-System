<%-- 
    Document   : additem_modal
    Created on : Mar 3, 2026, 3:28:05 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  .aim-overlay {
    position: fixed !important;
    inset: 0 !important;
    z-index: 999999 !important;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    font-family: system-ui, -apple-system, sans-serif;
  }
  .aim-backdrop {
    position: absolute; inset: 0;
    background: rgba(30,40,70,.35);
    backdrop-filter: blur(8px);
  }
  .aim-dialog {
    position: relative;
    width: min(980px, 94vw);
    max-height: 90vh;
    background: #fff;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 8px 40px rgba(0,0,0,.14), 0 2px 8px rgba(0,0,0,.08);
    display: flex;
    flex-direction: column;
    z-index: 1;
  }

  /* HEAD */
  .aim-head {
    display: flex; justify-content: space-between; align-items: flex-start;
    padding: 22px 28px 18px;
    border-bottom: 1px solid #e9edf4;
    background: #fff;
    flex-shrink: 0;
  }
  .aim-title { font-size: 19px; font-weight: 700; color: #111827; letter-spacing: -.01em; }
  .aim-pills { display: flex; gap: 7px; flex-wrap: wrap; margin-top: 10px; }
  .aim-pill {
    display: inline-flex; align-items: center;
    padding: 4px 11px; border-radius: 999px;
    background: #f1f5f9; border: 1px solid #e2e8f0;
    font-size: 11px; font-weight: 600; color: #475569; letter-spacing: .04em;
  }
  .aim-close {
    width: 32px; height: 32px; border-radius: 8px;
    border: 1px solid #e2e8f0; background: #f8fafc;
    color: #64748b; font-size: 17px; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    transition: all .15s; flex-shrink: 0; margin-top: 2px;
  }
  .aim-close:hover { background: #f1f5f9; color: #111827; border-color: #cbd5e1; }

  /* BODY */
  .aim-body { display: grid; grid-template-columns: 1fr 300px; flex: 1; overflow: hidden; min-height: 0; }
  .aim-left { padding: 24px 28px; overflow-y: auto; }
  .aim-right { background: #f8fafc; border-left: 1px solid #e9edf4; display: flex; flex-direction: column; overflow: hidden; }

  /* STEPS */
  .aim-step { margin-bottom: 22px; }
  .aim-step-label { display: flex; align-items: center; gap: 10px; margin-bottom: 13px; }
  .aim-step-num {
    width: 24px; height: 24px; border-radius: 50%;
    background: #4f46e5; color: #fff;
    font-size: 11px; font-weight: 700;
    display: flex; align-items: center; justify-content: center; flex-shrink: 0;
  }
  .aim-step-name { font-size: 11px; font-weight: 700; letter-spacing: .1em; color: #374151; text-transform: uppercase; }

  /* TABS */
  .aim-tabs {
    display: grid; grid-template-columns: repeat(3,1fr);
    gap: 5px; background: #f1f5f9;
    border: 1px solid #e2e8f0; padding: 5px; border-radius: 13px;
  }
  .aim-tab {
    text-align: center; text-decoration: none;
    padding: 10px 6px; border-radius: 9px;
    font-size: 11px; font-weight: 700; letter-spacing: .1em;
    color: #94a3b8; background: transparent; transition: all .18s;
  }
  .aim-tab:hover { color: #475569; background: rgba(255,255,255,.7); }
  .aim-tab.active { background: #fff; color: #4f46e5; box-shadow: 0 2px 8px rgba(0,0,0,.09); }

  /* CARD */
  .aim-card { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 18px; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
  .aim-fields { display: grid; grid-template-columns: 1fr 120px; gap: 12px; align-items: end; }
  .aim-field-label { font-size: 11px; font-weight: 600; color: #6b7280; letter-spacing: .06em; margin-bottom: 6px; text-transform: uppercase; }

  .aim-select, .aim-input {
    width: 100%; padding: 10px 13px; border-radius: 10px;
    border: 1.5px solid #e2e8f0; background: #fff;
    color: #111827; font-family: inherit; font-size: 14px; font-weight: 500;
    outline: none; transition: border-color .18s, box-shadow .18s; -webkit-appearance: none;
  }
  .aim-select {
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%234f46e5' stroke-width='2.5'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
    background-repeat: no-repeat; background-position: right 12px center;
    padding-right: 34px; cursor: pointer;
  }
  .aim-select:focus, .aim-input:focus { border-color: #818cf8; box-shadow: 0 0 0 3px rgba(99,102,241,.12); }

  .aim-add-btn {
    width: 100%; margin-top: 13px; padding: 11px;
    border: none; border-radius: 10px;
    background: #4f46e5; color: #fff;
    font-family: inherit; font-size: 14px; font-weight: 700;
    cursor: pointer; transition: all .18s;
    box-shadow: 0 3px 12px rgba(79,70,229,.28);
  }
  .aim-add-btn:hover { background: #4338ca; box-shadow: 0 5px 16px rgba(79,70,229,.38); transform: translateY(-1px); }
  .aim-add-btn:active { transform: translateY(0); }

  /* RIGHT PANEL */
  .aim-right-head { display: flex; justify-content: space-between; align-items: center; padding: 16px 18px 13px; border-bottom: 1px solid #e9edf4; flex-shrink: 0; }
  .aim-right-title { font-size: 11px; font-weight: 700; letter-spacing: .1em; color: #374151; text-transform: uppercase; }
  .aim-count-badge { background: #4f46e5; color: #fff; font-size: 10px; font-weight: 700; letter-spacing: .08em; padding: 4px 10px; border-radius: 999px; }

  .aim-items-list { flex: 1; overflow-y: auto; padding: 13px 14px; }
  .aim-empty { height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; padding: 30px; }
  .aim-empty-icon { font-size: 32px; opacity: .3; }
  .aim-empty-text { font-size: 11px; font-weight: 600; color: #94a3b8; letter-spacing: .08em; text-transform: uppercase; }

  /* ITEM CARDS */
  .aim-item { background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 12px 13px; margin-bottom: 7px; transition: border-color .15s, box-shadow .15s; animation: slideIn .18s ease; }
  @keyframes slideIn { from { opacity:0; transform:translateY(-5px); } to { opacity:1; transform:translateY(0); } }
  .aim-item:hover { border-color: #a5b4fc; box-shadow: 0 2px 8px rgba(99,102,241,.1); }
  .aim-item-name { font-size: 14px; font-weight: 600; color: #111827; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .aim-item-row { display: flex; justify-content: space-between; align-items: center; margin-top: 7px; }
  .aim-item-qty { font-size: 12px; font-weight: 600; color: #6b7280; background: #f1f5f9; padding: 2px 8px; border-radius: 6px; }
  .aim-item-price { font-size: 14px; font-weight: 700; color: #4f46e5; }
  .aim-remove-btn { margin-top: 8px; border: 1px solid #fecaca; background: #fff5f5; color: #ef4444; font-family: inherit; font-size: 12px; font-weight: 600; padding: 4px 10px; border-radius: 7px; cursor: pointer; transition: all .15s; }
  .aim-remove-btn:hover { background: #fee2e2; border-color: #fca5a5; }

  /* TOTAL */
  .aim-right-foot { border-top: 1px solid #e9edf4; padding: 14px 18px; flex-shrink: 0; background: #fff; }
  .aim-total-label { font-size: 11px; font-weight: 700; letter-spacing: .12em; color: #94a3b8; text-transform: uppercase; margin-bottom: 4px; }
  .aim-total-amount { font-size: 28px; font-weight: 800; color: #111827; letter-spacing: -.02em; }
  .aim-total-sym { font-size: 16px; color: #4f46e5; font-weight: 700; }

  /* FOOTER */
  .aim-foot { display: flex; justify-content: space-between; align-items: center; padding: 15px 28px; border-top: 1px solid #e9edf4; background: #fff; flex-shrink: 0; }
  .aim-cancel { border: 1px solid #e2e8f0; background: #fff; color: #374151; font-family: inherit; font-size: 14px; font-weight: 600; padding: 9px 18px; border-radius: 10px; cursor: pointer; transition: all .15s; }
  .aim-cancel:hover { background: #f8fafc; border-color: #cbd5e1; }
  .aim-save { display: flex; align-items: center; gap: 7px; border: none; background: #4f46e5; color: #fff; font-family: inherit; font-size: 14px; font-weight: 700; padding: 10px 22px; border-radius: 10px; cursor: pointer; transition: all .18s; box-shadow: 0 3px 12px rgba(79,70,229,.3); }
  .aim-save:hover { background: #4338ca; transform: translateY(-1px); box-shadow: 0 6px 18px rgba(79,70,229,.38); }

  /* TOAST */
  .aim-toast { position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%); background: #1e293b; color: #f1f5f9; padding: 10px 20px; border-radius: 10px; font-family: inherit; font-size: 14px; font-weight: 500; z-index: 9999999; box-shadow: 0 8px 24px rgba(0,0,0,.2); }
</style>

<div class="aim-overlay" style="display:flex;">
  <div class="aim-backdrop"
       onclick="window.location = '${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}'"></div>

  <div class="aim-dialog" role="dialog" aria-modal="true">

    <!-- HEAD -->
    <div class="aim-head">
      <div>
        <div class="aim-title">Add Items to Order Service Id-${selected.serviceOrderId}</div>
        <div class="aim-pills">
          <span class="aim-pill">ROOM ${selected.roomNo}</span>
          <span class="aim-pill">BOOKING ID ${selected.bookingId}</span>
          <span class="aim-pill">Order Service Id-${selected.serviceOrderId}</span>
        </div>
      </div>
      <button type="button" class="aim-close"
              onclick="window.location = '${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}'">✕</button>
    </div>

    <!-- BODY -->
    <div class="aim-body">

      <!-- LEFT -->
      <div class="aim-left">

        <!-- Step 1 -->
        <div class="aim-step">
          <div class="aim-step-label">
            <div class="aim-step-num">1</div>
            <div class="aim-step-name">Service Type</div>
          </div>
          <div class="aim-tabs">
            <a class="aim-tab ${type==1?'active':''}"
               href="${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}&modal=addItems&type=1">MINIBAR</a>
            <a class="aim-tab ${type==2?'active':''}"
               href="${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}&modal=addItems&type=2">LAUNDRY</a>
            <a class="aim-tab ${type==3?'active':''}"
               href="${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}&modal=addItems&type=3">CLEANING</a>
          </div>
        </div>

        <!-- Step 2 -->
        <div class="aim-step">
          <div class="aim-step-label">
            <div class="aim-step-num">2</div>
            <div class="aim-step-name">Select Service</div>
          </div>
          <div class="aim-card">
            <div class="aim-fields">
              <div>
                <div class="aim-field-label">Service Name</div>
                <select id="serviceSelect" class="aim-select">
                  <option value="">Select a service...</option>
                  <c:choose>
                    <c:when test="${type==1}">
                      <c:forEach var="s" items="${svMinibar}">
                        <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}">
                          <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2"/>)
                        </option>
                      </c:forEach>
                    </c:when>
                    <c:when test="${type==2}">
                      <c:forEach var="s" items="${svLaundry}">
                        <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}">
                          <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2"/>)
                        </option>
                      </c:forEach>
                    </c:when>
                    <c:when test="${type==3}">
                      <c:forEach var="s" items="${svCleaning}">
                        <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}">
                          <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2"/>)
                        </option>
                      </c:forEach>
                    </c:when>
                  </c:choose>
                </select>
              </div>
              <div>
                <div class="aim-field-label">Quantity</div>
                <input id="qtyInput" class="aim-input" type="number" min="1" value="1"/>
              </div>
            </div>
            <button type="button" class="aim-add-btn" onclick="addToNewItems()">＋ Add to Order</button>
          </div>
        </div>

      </div>

      <!-- RIGHT -->
      <div class="aim-right">
        <div class="aim-right-head">
          <div class="aim-right-title">New Items Preview</div>
          <div class="aim-count-badge"><span id="newCount">0</span> ITEMS</div>
        </div>
        <div class="aim-items-list" id="newItemsWrap">
          <div class="aim-empty">
            <div class="aim-empty-icon">🛒</div>
            <div class="aim-empty-text">No items added yet</div>
          </div>
        </div>
        <div class="aim-right-foot">
          <div class="aim-total-label">New Items Total</div>
          <div class="aim-total-amount">
            <span class="aim-total-sym">$</span><span id="newTotal">0.00</span>
          </div>
        </div>
      </div>

    </div>

    <!-- FOOTER -->
    <div class="aim-foot">
      <button type="button" class="aim-cancel"
              onclick="window.location = '${pageContext.request.contextPath}/staff/service-orders?id=${selected.serviceOrderId}'">Cancel</button>

      <form method="post" action="${pageContext.request.contextPath}/staff/service-orders/add-items"
            style="display:flex; align-items:center; gap:12px;"
            onsubmit="return beforeSaveItems()">
        <input type="hidden" name="orderId" value="${selected.serviceOrderId}"/>
        <input type="hidden" name="type" value="${type}"/>
        <div id="hiddenNewItems"></div>
        <button type="submit" class="aim-save">💾 Save Items</button>
      </form>
    </div>

  </div>
</div>

<script>
  document.body.style.overflow = 'hidden';
  window.addEventListener('beforeunload', () => document.body.style.overflow = '');

  const newItems = [];

  function addToNewItems() {
    const sel = document.getElementById('serviceSelect');
    const opt = sel.options[sel.selectedIndex];
    const serviceId = sel.value;
    const qty = parseInt(document.getElementById('qtyInput').value || '1', 10);

    if (!serviceId) { showToast('Please select a service.'); return; }
    if (qty < 1)    { showToast('Quantity must be at least 1.'); return; }

    const price = parseFloat(opt.getAttribute('data-price'));
    const name  = opt.getAttribute('data-name');

    newItems.push({ serviceId, name, price, qty });
    sel.value = '';
    document.getElementById('qtyInput').value = 1;
    renderNewItems();
  }

  function removeNewItem(idx) {
    newItems.splice(idx, 1);
    renderNewItems();
  }

  function renderNewItems() {
    const wrap = document.getElementById('newItemsWrap');
    wrap.innerHTML = '';

    if (newItems.length === 0) {
      wrap.innerHTML = '<div class="aim-empty"><div class="aim-empty-icon">🛒</div><div class="aim-empty-text">No items added yet</div></div>';
      document.getElementById('newCount').innerText = 0;
      document.getElementById('newTotal').innerText = '0.00';
      return;
    }

    let total = 0;
    newItems.forEach((it, idx) => {
      const line = it.price * it.qty;
      total += line;
      const div = document.createElement('div');
      div.className = 'aim-item';
      div.innerHTML =
        '<div class="aim-item-name">' + it.name + '</div>' +
        '<div class="aim-item-row">' +
          '<span class="aim-item-qty">QTY × ' + it.qty + '</span>' +
          '<span class="aim-item-price">$' + line.toFixed(2) + '</span>' +
        '</div>' +
        '<button type="button" class="aim-remove-btn" onclick="removeNewItem(' + idx + ')">Remove</button>';
      wrap.appendChild(div);
    });

    document.getElementById('newCount').innerText = newItems.length;
    document.getElementById('newTotal').innerText = total.toFixed(2);
  }

  function beforeSaveItems() {
    if (newItems.length === 0) { showToast('Please add at least 1 item.'); return false; }
    const hidden = document.getElementById('hiddenNewItems');
    hidden.innerHTML = '';
    newItems.forEach(it => {
      const s = document.createElement('input');
      s.type = 'hidden'; s.name = 'serviceId'; s.value = it.serviceId;
      hidden.appendChild(s);
      const q = document.createElement('input');
      q.type = 'hidden'; q.name = 'quantity'; q.value = it.qty;
      hidden.appendChild(q);
    });
    return true;
  }

  function showToast(msg) {
    const t = document.createElement('div');
    t.className = 'aim-toast';
    t.innerText = msg;
    document.body.appendChild(t);
    setTimeout(() => t.remove(), 2500);
  }
</script>
