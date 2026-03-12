(function () {

  /* =========================
     SLIDER
  ========================== */
  function initSliders() {
    document.querySelectorAll(".bk-gallery").forEach(gallery => {
      const slides = Array.from(gallery.querySelectorAll(".bk-slide"));
      const dots = Array.from(gallery.querySelectorAll(".bk-dot"));
      const prev = gallery.querySelector(".bk-prev");
      const next = gallery.querySelector(".bk-next");

      if (slides.length <= 1) {
        if (prev) prev.style.display = "none";
        if (next) next.style.display = "none";
        return;
      }

      if (gallery.dataset.inited === "1") return;
      gallery.dataset.inited = "1";

      let idx = 0;

      function render() {
        slides.forEach((s, i) => s.classList.toggle("is-active", i === idx));
        dots.forEach((d, i) => d.classList.toggle("is-active", i === idx));
      }

      function go(step) {
        idx = (idx + step + slides.length) % slides.length;
        render();
      }

      prev?.addEventListener("click", e => {
        e.preventDefault();
        e.stopPropagation();
        go(-1);
      });

      next?.addEventListener("click", e => {
        e.preventDefault();
        e.stopPropagation();
        go(1);
      });

      dots.forEach((d, i) => {
        d.addEventListener("click", e => {
          e.preventDefault();
          e.stopPropagation();
          idx = i;
          render();
        });
      });

      render();
    });
  }

  /* =========================
     GUESTS
  ========================== */
  function renderGuestText() {
    const a = parseInt(document.getElementById("bkAdults")?.value || "2", 10);
    const c = parseInt(document.getElementById("bkChildren")?.value || "0", 10);
    const t = document.getElementById("bkGuestText");
    if (t) t.textContent = `${a} Adults, ${c} Children`;
  }

  function setGuestOpen(open) {
    const dd = document.getElementById("bkGuestDd");
    const btn = document.getElementById("bkGuestBtn");
    if (!dd || !btn) return;
    dd.classList.toggle("is-open", open);
    btn.setAttribute("aria-expanded", open ? "true" : "false");
  }

  function initGuests() {
    const root = document.documentElement;
    if (root.dataset.guestsInited === "1") return;
    root.dataset.guestsInited = "1";

    renderGuestText();

    const btn = document.getElementById("bkGuestBtn");
    const dd = document.getElementById("bkGuestDd");
    const wrap = document.querySelector(".bk-field.bk-guest");

    if (btn && dd) {
      btn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        setGuestOpen(!dd.classList.contains("is-open"));
      });
    }

    document.addEventListener("click", function (e) {
      if (!wrap) return;
      if (wrap.contains(e.target)) return;
      setGuestOpen(false);
    }, true);
  }

  // gplus/gminus cho guests
  document.addEventListener("click", function (e) {
    const plus = e.target.closest(".gplus");
    const minus = e.target.closest(".gminus");
    if (!plus && !minus) return;

    e.preventDefault();
    e.stopPropagation();

    const kind = (plus || minus).dataset.target; // "adults" | "children"
    const hidden = document.getElementById(kind === "adults" ? "bkAdults" : "bkChildren");
    const view = document.getElementById(kind === "adults" ? "bkAdultsView" : "bkChildrenView");
    if (!hidden || !view) return;

    const min = parseInt(view.getAttribute("min") || (kind === "adults" ? "1" : "0"), 10);
    const max = parseInt(view.getAttribute("max") || (kind === "adults" ? "30" : "15"), 10);
    let val = parseInt(view.value || hidden.value || (kind === "adults" ? "2" : "0"), 10);

    if (plus && val < max) val++;
    if (minus && val > min) val--;

    view.value = val;
    hidden.value = val;
    renderGuestText();
  });

  /* =========================
     ROOM QTY LIMIT HELPERS
  ========================== */
  function getRoomLimit() {
    return parseInt(document.getElementById("roomQty")?.value || "1", 10);
  }

  function getAllQtyInputs() {
    return Array.from(document.querySelectorAll(".bk-qty .qty-input"));
  }

  function getTotalSelectedRooms() {
    return getAllQtyInputs().reduce((sum, input) => {
      return sum + parseInt(input.value || "0", 10);
    }, 0);
  }

  function refreshRoomQtyButtons() {
    const limit = getRoomLimit();
    const inputs = getAllQtyInputs();
    const total = getTotalSelectedRooms();

    inputs.forEach(input => {
      const wrap = input.closest(".bk-qty");
      if (!wrap) return;

      const plusBtn = wrap.querySelector(".qty-btn.plus");
      const minusBtn = wrap.querySelector(".qty-btn.minus");
      const current = parseInt(input.value || "0", 10);
      const min = parseInt(input.getAttribute("min") || "0", 10);
      const max = parseInt(input.getAttribute("max") || "20", 10);

      if (minusBtn) {
        minusBtn.disabled = current <= min;
      }

      if (plusBtn) {
        const reachedGlobalLimit = total >= limit;
        const reachedLocalMax = current >= max;
        plusBtn.disabled = reachedGlobalLimit || reachedLocalMax;
      }
    });
  }

  /* =========================
     QTY BUTTONS (rooms per card)
  ========================== */
  document.addEventListener("click", function (e) {
    const plusBtn = e.target.closest(".qty-btn.plus");
    const minusBtn = e.target.closest(".qty-btn.minus");

    if (!plusBtn && !minusBtn) return;

    e.preventDefault();
    e.stopPropagation();

    const wrap = (plusBtn || minusBtn).closest(".bk-qty");
    const input = wrap?.querySelector(".qty-input");
    if (!input) return;

    const max = parseInt(input.getAttribute("max") || "20", 10);
    const min = parseInt(input.getAttribute("min") || "0", 10);
    let val = parseInt(input.value || "0", 10);

    if (plusBtn) {
      const total = getTotalSelectedRooms();
      const limit = getRoomLimit();

      if (total >= limit) {
        refreshRoomQtyButtons();
        return;
      }

      if (val < max) val++;
    }

    if (minusBtn && val > min) {
      val--;
    }

    input.value = val;
    refreshRoomQtyButtons();
  });

  /* =========================
     ROOM DETAIL MODAL
  ========================== */
  function openRoomModalFromLink(a) {
    const modal = document.getElementById("rmModal");
    if (!modal) return;

    const rmTitle = document.getElementById("rmTitle");
    const rmSub = document.getElementById("rmSub");
    const rmOcc = document.getElementById("rmOcc");
    const rmPrice = document.getElementById("rmPrice");
    const rmAmenities = document.getElementById("rmAmenities");
    const rmImg = document.getElementById("rmImg");

    const rmSize = document.getElementById("rmSize");
    const rmBed = document.getElementById("rmBed");
    const rmView = document.getElementById("rmView");

    // Data from link
    const title = a.dataset.title || "Room";
    const maxA = a.dataset.maxadult || "—";
    const maxC = a.dataset.maxchildren || "—";
    const price = a.dataset.price || "";
    const amenitiesPipe = (a.dataset.amenities || "").trim();

    if (rmTitle) rmTitle.textContent = title;

    // derive info from card desc
    const cardEl = a.closest(".bk-card");
    const descEl = cardEl?.querySelector(".bk-desc");
    const descText = (descEl?.textContent || "").replace(/\s+/g, " ").trim();

    if (rmSub) rmSub.textContent = descText || "Explore details & amenities";

    const parts = descText.split("|").map(s => s.trim()).filter(Boolean);
    const sizePart = parts.find(p => /sqm|m2|m²/i.test(p)) || "";
    const bedPart = parts.find(p => /bed/i.test(p)) || (parts[0] || "");
    const viewPart = parts.find(p => /view/i.test(p)) || (parts[1] || "");

    if (rmSize) rmSize.textContent = sizePart || "—";
    if (rmBed) rmBed.textContent = bedPart || "—";
    if (rmView) rmView.textContent = viewPart || "—";

    if (rmOcc) rmOcc.textContent = `${maxA} adults • ${maxC} children`;

    if (rmPrice) {
      const n = Number(price);
      rmPrice.textContent = Number.isFinite(n) ? `${n.toLocaleString("vi-VN")} đ / night` : "Contact";
    }

    // Amenities
    if (rmAmenities) {
      rmAmenities.innerHTML = "";

      const items = amenitiesPipe
        .split("|")
        .map(s => s.trim())
        .filter(Boolean);

      if (items.length === 0) {
        const div = document.createElement("div");
        div.className = "rm-amenity";
        div.textContent = "No amenities information";
        rmAmenities.appendChild(div);
      } else {
        items.forEach(text => {
          const div = document.createElement("div");
          div.className = "rm-amenity";
          div.textContent = text;
          rmAmenities.appendChild(div);
        });
      }
    }

    // Pick image from current card slider
    const active = cardEl?.querySelector(".bk-gallery .bk-slide.is-active");
    const first = cardEl?.querySelector(".bk-gallery .bk-slide");
    const src = active?.getAttribute("src") || first?.getAttribute("src") || "";
    if (rmImg && src) rmImg.src = src;

    // Open modal
    modal.classList.add("is-open");
    modal.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
  }

  function closeRoomModal() {
    const modal = document.getElementById("rmModal");
    if (!modal) return;
    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  }

  document.addEventListener("click", function (e) {
    const a = e.target.closest(".js-open-detail");
    if (!a) return;
    e.preventDefault();
    e.stopPropagation();
    openRoomModalFromLink(a);
  });

  document.addEventListener("click", function (e) {
    if (e.target?.id === "rmBackdrop" || e.target?.id === "rmClose") {
      e.preventDefault();
      closeRoomModal();
    }
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") closeRoomModal();
  });

  /* =========================
     BOOK NOW + VALIDATION
  ========================== */
  document.addEventListener("click", function (e) {
    const btn = e.target.closest(".js-book-now");
    if (!btn) return;

    e.preventDefault();

    const card = btn.closest(".bk-card");
    if (!card) return;

    const adults = parseInt(document.getElementById("bkAdults")?.value || "2", 10);
    const children = parseInt(document.getElementById("bkChildren")?.value || "0", 10);

    const checkIn = document.querySelector('input[name="checkIn"]')?.value || "";
    const checkOut = document.querySelector('input[name="checkOut"]')?.value || "";

    const qty = parseInt(card.querySelector(".qty-input")?.value || "0", 10);

    if (!checkIn || !checkOut) {
      showCardError(card, "Please select check-in and check-out dates.");
      return;
    }

    if (qty <= 0) {
      showCardError(card, "Please select at least 1 room before booking.");
      return;
    }

    const maxAdult = parseInt(btn.dataset.maxadult || "0", 10);
    const maxChildren = parseInt(btn.dataset.maxchildren || "0", 10);

    const capAdultTotal = maxAdult * qty;
    const capChildrenTotal = maxChildren * qty;

    if (adults > capAdultTotal || children > capChildrenTotal) {
      showCardError(
        card,
        `This room allows maximum ${capAdultTotal} adults and ${capChildrenTotal} children. ` +
        `You selected ${adults} adults and ${children} children.`
      );
      return;
    }

    hideAllCardErrors();

    const ctx = document.body.getAttribute("data-ctx") || "";
    const roomTypeId = btn.dataset.roomtype;

    const url =
      `${ctx}/booking/confirm?roomTypeId=${encodeURIComponent(roomTypeId)}` +
      `&roomQty=${encodeURIComponent(qty)}` +
      `&adults=${encodeURIComponent(adults)}` +
      `&children=${encodeURIComponent(children)}` +
      `&checkIn=${encodeURIComponent(checkIn)}` +
      `&checkOut=${encodeURIComponent(checkOut)}`;

    window.location.href = url;
  });

  function hideAllCardErrors() {
    document.querySelectorAll(".bk-room-error").forEach(el => {
      el.style.display = "none";
    });
  }

  function showCardError(card, message) {
    hideAllCardErrors();

    const box = card.querySelector(".bk-room-error");
    if (!box) return;

    box.textContent = message;
    box.style.display = "block";
    box.scrollIntoView({ behavior: "smooth", block: "center" });
  }

  document.addEventListener("DOMContentLoaded", function () {
    initSliders();
    initGuests();
    refreshRoomQtyButtons();

    const roomQtyFilter = document.getElementById("roomQty");
    if (roomQtyFilter) {
      roomQtyFilter.addEventListener("input", refreshRoomQtyButtons);
      roomQtyFilter.addEventListener("change", refreshRoomQtyButtons);
    }
  });

})();