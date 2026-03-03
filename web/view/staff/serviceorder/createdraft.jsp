<%-- 
    Document   : createdraft
    Created on : Mar 1, 2026, 10:22:25 PM
    Author     : DieuBHHE191686
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="en_US"/>

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  .so-modal {
    position: fixed !important;
    inset: 0 !important;
    z-index: 999999 !important;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    font-family: system-ui, -apple-system, sans-serif;
  }

  .so-backdrop {
    position: absolute; inset: 0;
    background: rgba(30,40,70,.35);
    backdrop-filter: blur(8px);
  }

  .so-dialog {
    position: relative;
    width: min(1100px, 94vw);
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
  .so-head {
    display: flex; justify-content: space-between; align-items: center;
    padding: 20px 28px;
    border-bottom: 1px solid #e9edf4;
    background: #fff;
    flex-shrink: 0;
  }
  .so-title { font-size: 19px; font-weight: 700; color: #111827; }
  .so-x {
    width: 32px; height: 32px; border-radius: 8px;
    border: 1px solid #e2e8f0; background: #f8fafc;
    color: #64748b; font-size: 18px; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    transition: all .15s; flex-shrink: 0;
  }
  .so-x:hover { background: #f1f5f9; color: #111827; border-color: #cbd5e1; }

  /* BODY */
  .so-body {
    display: grid;
    grid-template-columns: 1fr 300px;
    flex: 1;
    overflow: hidden;
    min-height: 0;
  }
  .so-left { padding: 24px 28px; overflow-y: auto; border-right: 1px solid #e9edf4; }
  .so-right { background: #f8fafc; display: flex; flex-direction: column; overflow: hidden; }

  /* STEPS */
  .so-step { margin-bottom: 24px; }
  .so-step-h { display: flex; align-items: center; gap: 10px; margin-bottom: 13px; }
  .so-badge {
    width: 24px; height: 24px; border-radius: 50%;
    background: #4f46e5; color: #fff;
    font-size: 11px; font-weight: 700;
    display: flex; align-items: center; justify-content: center; flex-shrink: 0;
  }
  .so-step-title { font-size: 11px; font-weight: 700; letter-spacing: .1em; color: #374151; text-transform: uppercase; }
  .so-label { font-size: 11px; font-weight: 600; color: #6b7280; letter-spacing: .06em; text-transform: uppercase; margin-bottom: 6px; }

  /* GRID */
  .so-grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  .so-grid2-item { margin-top: 10px; }

  .so-input, .so-select {
    width: 100%; padding: 10px 13px; border-radius: 10px;
    border: 1.5px solid #e2e8f0; background: #fff;
    color: #111827; font-family: inherit; font-size: 14px; font-weight: 500;
    outline: none; transition: border-color .18s, box-shadow .18s;
    -webkit-appearance: none;
  }
  .so-select {
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%234f46e5' stroke-width='2.5'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
    background-repeat: no-repeat; background-position: right 12px center;
    padding-right: 34px; cursor: pointer;
  }
  .so-input:focus, .so-select:focus {
    border-color: #818cf8;
    box-shadow: 0 0 0 3px rgba(99,102,241,.12);
  }

  /* TABS */
  .so-tabs {
    display: grid; grid-template-columns: repeat(3, 1fr);
    gap: 5px; background: #f1f5f9;
    border: 1px solid #e2e8f0; padding: 5px; border-radius: 13px;
  }
  .so-tab {
    text-align: center; border: none; cursor: pointer;
    padding: 10px 6px; border-radius: 9px;
    font-family: inherit; font-size: 11px; font-weight: 700; letter-spacing: .1em;
    color: #94a3b8; background: transparent; transition: all .18s;
  }
  .so-tab:hover { color: #475569; background: rgba(255,255,255,.7); }
  .so-tab.active { background: #fff; color: #4f46e5; box-shadow: 0 2px 8px rgba(0,0,0,.09); }

  /* CARD */
  .so-card {
    background: #fff; border: 1px solid #e2e8f0;
    border-radius: 16px; padding: 18px;
    box-shadow: 0 1px 4px rgba(0,0,0,.04);
  }

  .so-btn-add {
    width: 100%; margin-top: 13px; padding: 11px;
    border: none; border-radius: 10px;
    background: #4f46e5; color: #fff;
    font-family: inherit; font-size: 14px; font-weight: 700;
    cursor: pointer; transition: all .18s;
    box-shadow: 0 3px 12px rgba(79,70,229,.28);
  }
  .so-btn-add:hover { background: #4338ca; transform: translateY(-1px); box-shadow: 0 5px 16px rgba(79,70,229,.38); }
  .so-btn-add:active { transform: translateY(0); }

  /* RIGHT PANEL */
  .so-right-head {
    display: flex; justify-content: space-between; align-items: center;
    padding: 16px 18px 13px; border-bottom: 1px solid #e9edf4; flex-shrink: 0;
  }
  .so-right-title { font-size: 11px; font-weight: 700; letter-spacing: .1em; color: #374151; text-transform: uppercase; }
  .so-pill { background: #4f46e5; color: #fff; font-size: 10px; font-weight: 700; letter-spacing: .08em; padding: 4px 10px; border-radius: 999px; }

  .so-items { flex: 1; overflow-y: auto; padding: 13px 14px; }

  .so-item {
    background: #fff; border: 1px solid #e2e8f0;
    border-radius: 12px; padding: 12px 13px; margin-bottom: 7px;
    transition: border-color .15s, box-shadow .15s;
    animation: slideIn .18s ease;
  }
  @keyframes slideIn { from { opacity:0; transform:translateY(-5px); } to { opacity:1; transform:translateY(0); } }
  .so-item:hover { border-color: #a5b4fc; box-shadow: 0 2px 8px rgba(99,102,241,.1); }

  .so-item-type { font-size: 10px; font-weight: 700; letter-spacing: .12em; color: #4f46e5; text-transform: uppercase; }
  .so-item-name { margin-top: 4px; font-size: 13px; font-weight: 600; color: #111827; }
  .so-item-sub { margin-top: 6px; font-size: 12px; color: #6b7280; display: flex; justify-content: space-between; }
  .so-item-sub span:last-child { font-weight: 700; color: #4f46e5; }
  .so-item-actions { margin-top: 8px; }
  .so-mini-btn {
    border: 1px solid #fecaca; background: #fff5f5;
    color: #ef4444; font-family: inherit; font-size: 11px; font-weight: 600;
    padding: 4px 10px; border-radius: 7px; cursor: pointer; transition: all .15s;
  }
  .so-mini-btn:hover { background: #fee2e2; border-color: #fca5a5; }

  /* RIGHT FOOT */
  .so-right-foot {
    border-top: 1px solid #e9edf4; padding: 14px 18px;
    flex-shrink: 0; background: #fff;
    display: flex; justify-content: space-between; align-items: flex-end;
  }
  .so-label-foot { font-size: 10px; font-weight: 700; letter-spacing: .12em; color: #94a3b8; text-transform: uppercase; margin-bottom: 4px; }
  .so-total { font-size: 26px; font-weight: 800; color: #111827; letter-spacing: -.02em; }
  .so-total-sym { font-size: 15px; color: #4f46e5; font-weight: 700; }
  .so-newitems-num { font-size: 26px; font-weight: 800; color: #111827; text-align: right; margin-top: 4px; }

  /* FOOTER */
  .so-foot {
    display: flex; justify-content: space-between; align-items: center;
    padding: 15px 28px; border-top: 1px solid #e9edf4;
    background: #fff; flex-shrink: 0;
  }
  .so-btn-cancel {
    border: 1px solid #e2e8f0; background: #fff; color: #374151;
    font-family: inherit; font-size: 14px; font-weight: 600;
    padding: 9px 18px; border-radius: 10px; cursor: pointer; transition: all .15s;
  }
  .so-btn-cancel:hover { background: #f8fafc; border-color: #cbd5e1; }
  .so-form { display: flex; align-items: center; gap: 12px; }
  .so-btn-create {
    border: none; cursor: pointer;
    padding: 10px 22px; border-radius: 10px;
    background: #4f46e5; color: #fff;
    font-family: inherit; font-size: 14px; font-weight: 700;
    transition: all .18s; box-shadow: 0 3px 12px rgba(79,70,229,.3);
  }
  .so-btn-create:hover { background: #4338ca; transform: translateY(-1px); box-shadow: 0 6px 18px rgba(79,70,229,.38); }
  .so-btn-create:disabled { opacity: .5; cursor: not-allowed; transform: none; }
</style>

<!-- MODAL -->
<div id="soModal" class="so-modal" style="display:flex;">
  <div class="so-backdrop" onclick="closeSOModal()"></div>

  <div class="so-dialog" role="dialog" aria-modal="true">

    <!-- HEAD -->
    <div class="so-head">
      <div class="so-title">Add Service Order</div>
      <button type="button" class="so-x" onclick="closeSOModal()">✕</button>
    </div>

    <!-- BODY -->
    <div class="so-body">

      <!-- LEFT -->
      <div class="so-left">

        <!-- Step 1: Context -->
        <div class="so-step">
          <div class="so-step-h">
            <div class="so-badge">1</div>
            <div class="so-step-title">Context</div>
          </div>
          <div class="so-grid2">
            <div>
              <div class="so-label">Room Number</div>
              <input id="roomNumber" class="so-input" placeholder="e.g., 201"/>
            </div>
            <div>
              <div class="so-label">Booking ID *</div>
              <input id="bookingId" class="so-input" placeholder="e.g., 8821" required/>
            </div>
          </div>
        </div>

        <!-- Step 2: Service Type -->
        <div class="so-step">
          <div class="so-step-h">
            <div class="so-badge">2</div>
            <div class="so-step-title">Service Type</div>
          </div>
          <div class="so-tabs">
            <button type="button" class="so-tab active" data-type="MINIBAR"   onclick="switchType('MINIBAR')">MINIBAR</button>
            <button type="button" class="so-tab"        data-type="LAUNDRY"   onclick="switchType('LAUNDRY')">LAUNDRY</button>
            <button type="button" class="so-tab"        data-type="CLEANING"  onclick="switchType('CLEANING')">CLEANING</button>
          </div>
        </div>

        <!-- Step 3: Add Item -->
        <div class="so-step">
          <div class="so-step-h">
            <div class="so-badge">3</div>
            <div class="so-step-title">Add Item</div>
          </div>
          <div class="so-card">
            <div class="so-grid2 so-grid2-item">
              <div>
                <div class="so-label">Service Name</div>

                <select id="serviceSelect_MINIBAR" class="so-select">
                  <option value="">Select a service...</option>
                  <c:forEach var="s" items="${svMinibar}">
                    <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}" data-type="MINIBAR">
                      <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>)
                    </option>
                  </c:forEach>
                </select>

                <select id="serviceSelect_LAUNDRY" class="so-select" style="display:none;">
                  <option value="">Select a service...</option>
                  <c:forEach var="s" items="${svLaundry}">
                    <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}" data-type="LAUNDRY">
                      <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>)
                    </option>
                  </c:forEach>
                </select>

                <select id="serviceSelect_CLEANING" class="so-select" style="display:none;">
                  <option value="">Select a service...</option>
                  <c:forEach var="s" items="${svCleaning}">
                    <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}" data-type="CLEANING">
                      <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>)
                    </option>
                  </c:forEach>
                </select>

                <select id="serviceSelect_SURCHARGE" class="so-select" style="display:none;">
                  <option value="">Select a service...</option>
                  <c:forEach var="s" items="${servicesSurcharge}">
                    <option value="${s.serviceId}" data-price="${s.unitPrice}" data-name="${fn:escapeXml(s.name)}" data-type="SURCHARGE">
                      <c:out value="${s.name}"/> ($<fmt:formatNumber value="${s.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>)
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div>
                <div class="so-label">Quantity</div>
                <input id="qtyInput" class="so-input" type="number" min="1" value="1"/>
              </div>
            </div>

            <button type="button" class="so-btn-add" onclick="addToList()">＋ Add to List</button>
          </div>
        </div>

      </div>

      <!-- RIGHT: Preview -->
      <div class="so-right">
        <div class="so-right-head">
          <div class="so-right-title">Ticket Items</div>
          <div class="so-pill"><span id="itemCount">0</span> ITEMS</div>
        </div>

        <div id="ticketItems" class="so-items">
          <div style="height:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;padding:30px;">
            <div style="font-size:30px;opacity:.25;">🛒</div>
            <div style="font-size:11px;font-weight:600;color:#94a3b8;letter-spacing:.08em;text-transform:uppercase;">No items added yet</div>
          </div>
        </div>

        <div class="so-right-foot">
          <div>
            <div class="so-label-foot">Estimated Total</div>
            <div class="so-total"><span class="so-total-sym">$</span><span id="estTotal">0.00</span></div>
          </div>
          <div style="text-align:right;">
            <div class="so-label-foot">New Items</div>
            <div class="so-newitems-num" id="newItems">0</div>
          </div>
        </div>
      </div>

    </div>

    <!-- FOOTER -->
    <div class="so-foot">
      <button type="button" class="so-btn-cancel" onclick="closeSOModal()">Cancel</button>

      <form id="createDraftForm" method="post"
            action="${pageContext.request.contextPath}/staff/service-orders/create"
            class="so-form">
        <input type="hidden" name="bookingId" id="bookingIdHidden"/>
        <input type="hidden" name="roomId"    id="roomIdHidden"/>
        <div id="hiddenItems"></div>
        <button type="submit" class="so-btn-create" onclick="return beforeSubmitCreateDraft()">
          Create Service Ticket (Draft) →
        </button>
      </form>
    </div>

  </div>
</div>

<script>
  document.body.style.overflow = 'hidden';
  window.addEventListener('beforeunload', () => document.body.style.overflow = '');

  let currentType = 'MINIBAR';
  const ticket = [];

  function openSOModal() {
    document.getElementById('soModal').style.display = 'flex';
  }

  function closeSOModal() {
    const params = new URLSearchParams(window.location.search);
    const returnId = params.get("returnId");
    let url = "${pageContext.request.contextPath}/staff/service-orders";
    if (returnId && returnId.trim() !== "") {
      url += "?id=" + encodeURIComponent(returnId);
    }
    window.location.href = url;
  }

  function switchType(type) {
    currentType = type;
    document.querySelectorAll('.so-tab').forEach(b => b.classList.remove('active'));
    document.querySelector('.so-tab[data-type="' + type + '"]').classList.add('active');
    ['MINIBAR','LAUNDRY','CLEANING','SURCHARGE'].forEach(t => {
      document.getElementById('serviceSelect_' + t).style.display = (t === type) ? 'block' : 'none';
    });
    document.getElementById('qtyInput').value = 1;
  }

  function getCurrentSelect() {
    return document.getElementById('serviceSelect_' + currentType);
  }

  function addToList() {
    const sel = getCurrentSelect();
    const opt = sel.options[sel.selectedIndex];
    const serviceId = sel.value;
    const qty = parseInt(document.getElementById('qtyInput').value || '1', 10);

    if (!serviceId) { showToast('Please select a service.'); return; }
    if (qty < 1)    { showToast('Quantity must be at least 1.'); return; }

    const price = parseFloat(opt.getAttribute('data-price'));
    const name  = opt.getAttribute('data-name');
    const type  = opt.getAttribute('data-type');

    ticket.push({ serviceId, name, type, price, qty });
    sel.value = '';
    document.getElementById('qtyInput').value = 1;
    renderTicket();
  }

  function removeItem(idx) {
    ticket.splice(idx, 1);
    renderTicket();
  }

  function renderTicket() {
    const wrap = document.getElementById('ticketItems');
    wrap.innerHTML = '';

    if (ticket.length === 0) {
      wrap.innerHTML = '<div style="height:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;padding:30px;"><div style="font-size:30px;opacity:.25;">🛒</div><div style="font-size:11px;font-weight:600;color:#94a3b8;letter-spacing:.08em;text-transform:uppercase;">No items added yet</div></div>';
      document.getElementById('itemCount').innerText = 0;
      document.getElementById('newItems').innerText = 0;
      document.getElementById('estTotal').innerText = '0.00';
      return;
    }

    let total = 0;
    ticket.forEach((it, idx) => {
      const line = it.price * it.qty;
      total += line;
      const div = document.createElement('div');
      div.className = 'so-item';
      div.innerHTML =
        '<div class="so-item-type">' + it.type + '</div>' +
        '<div class="so-item-name">' + it.name + '</div>' +
        '<div class="so-item-sub"><span>QTY × ' + it.qty + '</span><span>$' + line.toFixed(2) + '</span></div>' +
        '<div class="so-item-actions"><button type="button" class="so-mini-btn" onclick="removeItem(' + idx + ')">Remove</button></div>';
      wrap.appendChild(div);
    });

    document.getElementById('itemCount').innerText = ticket.length;
    document.getElementById('newItems').innerText = ticket.length;
    document.getElementById('estTotal').innerText = total.toFixed(2);
  }

  function beforeSubmitCreateDraft() {
    const bookingId = document.getElementById('bookingId').value.trim();
    const roomId    = document.getElementById('roomNumber').value.trim();

    if (!bookingId) { showToast('Booking ID is required.'); return false; }
    if (ticket.length === 0) { showToast('Please add at least 1 item.'); return false; }

    document.getElementById('bookingIdHidden').value = bookingId;
    document.getElementById('roomIdHidden').value    = roomId;

    const hiddenWrap = document.getElementById('hiddenItems');
    hiddenWrap.innerHTML = '';
    ticket.forEach(it => {
      const s = document.createElement('input');
      s.type = 'hidden'; s.name = 'serviceId'; s.value = it.serviceId;
      hiddenWrap.appendChild(s);
      const q = document.createElement('input');
      q.type = 'hidden'; q.name = 'quantity'; q.value = it.qty;
      hiddenWrap.appendChild(q);
    });
    return true;
  }

  function showToast(msg) {
    const t = document.createElement('div');
    t.style.cssText = 'position:fixed;bottom:24px;left:50%;transform:translateX(-50%);background:#1e293b;color:#f1f5f9;padding:10px 20px;border-radius:10px;font-family:inherit;font-size:14px;font-weight:500;z-index:9999999;box-shadow:0 8px 24px rgba(0,0,0,.2);';
    t.innerText = msg;
    document.body.appendChild(t);
    setTimeout(() => t.remove(), 2500);
  }
</script>
