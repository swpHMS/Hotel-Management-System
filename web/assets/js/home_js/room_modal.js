(function () {
  const modal = document.getElementById("roomModal");
  if (!modal) return;

  const ctx = window.__CTX__ || "";
  const SEP = window.__AMEN_SEP__ || "|";

  // ===== elements (gallery) =====
  const rmMainImg = document.getElementById("rmMainImg");
  const rmPrev = document.getElementById("rmPrev");
  const rmNext = document.getElementById("rmNext");
  const rmDots = document.getElementById("rmDots");
  const rmBadge = document.getElementById("rmBadge");

  // ===== elements (content) =====
  const title = document.getElementById("roomModalTitle");
  const descEl = document.getElementById("rmDesc");
  const rmSize = document.getElementById("rmSize");
  const rmOcc = document.getElementById("rmOcc");
  const rmBed = document.getElementById("rmBed");
  const rmView = document.getElementById("rmView");
  const rmPrice = document.getElementById("rmPrice");
  const rmCheckBtn = document.getElementById("rmCheckBtn");
  const rmDetailPageBtn = document.getElementById("rmDetailPageBtn");

  // ===== state =====
  let gallery = [];
  let idx = 0;

  function openModal() {
    modal.classList.add("open");
    modal.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
  }
  function closeModal() {
    modal.classList.remove("open");
    modal.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  }
  function plural(n, one, many) { n = Number(n || 0); return n === 1 ? one : many; }

  function setImg(i) {
    if (!gallery.length) return;
    idx = (i + gallery.length) % gallery.length;

    const url = gallery[idx];
    rmMainImg.src = url;
    rmMainImg.alt = title?.textContent || "Room";

    // active dot
    if (rmDots) {
      [...rmDots.querySelectorAll(".rm-dot")].forEach((d, k) => {
        d.classList.toggle("active", k === idx);
      });
    }

    // ẩn/hiện nav nếu chỉ có 1 ảnh
    const showNav = gallery.length > 1;
    if (rmPrev) rmPrev.style.display = showNav ? "" : "none";
    if (rmNext) rmNext.style.display = showNav ? "" : "none";
    if (rmDots) rmDots.style.display = showNav ? "" : "none";
  }

  function buildDots() {
    if (!rmDots) return;
    rmDots.innerHTML = "";

    gallery.forEach((_, i) => {
      const dot = document.createElement("span");
      dot.className = "rm-dot" + (i === idx ? " active" : "");
      dot.addEventListener("click", () => setImg(i));
      rmDots.appendChild(dot);
    });
  }

  function parseGallery(d) {
    // ưu tiên data-images (danh sách), fallback data-img (1 ảnh)
    const listRaw = (d.images || "").trim();
    const list = listRaw ? listRaw.split("|").map(s => s.trim()).filter(Boolean) : [];

    const single = (d.img || "").trim();
    if (list.length) return list;

    if (single) return [single];
    return [];
  }

  function renderAmenities(raw) {
    const rmAmenities = document.getElementById("rmAmenities");
    if (!rmAmenities) return;

    const items = (raw || "").trim()
      ? raw.split(SEP).map(x => (x || "").trim()).filter(Boolean)
      : [];

    rmAmenities.innerHTML = items
      .map(x => '<div class="room-modal__amenity"><span class="ico">✓</span> ' + x + '</div>')
      .join("");
  }

  // click DETAILS
  document.addEventListener("click", function (e) {
    const btn = e.target.closest(".js-room-detail");
    if (!btn) return;
    e.preventDefault();

    const d = btn.dataset;

    const id = d.id || "";
    const name = d.name || "Room";
    const bed = d.bed || "Bed";
    const view = d.view || "View";
    const size = d.size || "N/A";
    const price = d.price;
    const desc = d.desc || "";

    const adult = Number(d.adult || 0);
    const child = (d.child && d.child !== "null" && d.child !== "") ? Number(d.child || 0) : null;

    // ===== content =====
    title.textContent = name;
    descEl.textContent = desc || "A refined blend of comfort and modern design, curated for a restful stay.";
    rmSize.textContent = size;
    rmBed.textContent = bed;
    rmView.textContent = view;

    let occText = "Up to " + adult + " " + plural(adult, "Adult", "Adults");
    if (child !== null) occText += ", " + child + " " + plural(child, "Child", "Children");
    rmOcc.textContent = occText;

    rmPrice.textContent = (price && price !== "null") ? price : "CONTACT";

    rmCheckBtn.href = ctx + "/booking?roomTypeId=" + id;
    rmDetailPageBtn.href = ctx + "/room-type/detail?id=" + id;

    renderAmenities(d.amenities || "");

    // ===== gallery =====
    gallery = parseGallery(d);
    idx = 0;

    // badge text (tuỳ bạn)
    if (rmBadge) rmBadge.textContent = (name || "ROOM") + " GALLERY";

    if (!gallery.length) {
      // fallback nếu không có ảnh -> để ảnh placeholder
      rmMainImg.src = "";
      rmMainImg.removeAttribute("src");
    } else {
      buildDots();
      setImg(0);
    }

    openModal();
  });

  // nav buttons
  if (rmPrev) rmPrev.addEventListener("click", () => setImg(idx - 1));
  if (rmNext) rmNext.addEventListener("click", () => setImg(idx + 1));

  // close
  modal.addEventListener("click", function (e) {
    if (e.target.closest('[data-close="1"]')) closeModal();
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && modal.classList.contains("open")) closeModal();
    if (!modal.classList.contains("open")) return;
    if (e.key === "ArrowLeft") setImg(idx - 1);
    if (e.key === "ArrowRight") setImg(idx + 1);
  });
})();
