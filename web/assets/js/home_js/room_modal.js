(function () {
  const modal = document.getElementById("roomModal");
  if (!modal) return;

  const ctx = window.__CTX__ || "";
  const SEP = window.__AMEN_SEP__ || "|";

  const rmImg = document.getElementById("rmImg");
  const title = document.getElementById("roomModalTitle");
  const descEl = document.getElementById("rmDesc");
  const rmSize = document.getElementById("rmSize");
  const rmOcc = document.getElementById("rmOcc");
  const rmBed = document.getElementById("rmBed");
  const rmView = document.getElementById("rmView");
  const rmPrice = document.getElementById("rmPrice");
  const rmCheckBtn = document.getElementById("rmCheckBtn");
  const rmDetailPageBtn = document.getElementById("rmDetailPageBtn");

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

  document.addEventListener("click", function (e) {
    const btn = e.target.closest(".js-room-detail");
    if (!btn) return;
    e.preventDefault();

    const d = btn.dataset;

    const id = d.id || "";
    const name = d.name || "Room";
    const imgUrl = d.img || "";
    const bed = d.bed || "Bed";
    const view = d.view || "View";
    const size = d.size || "N/A";
    const price = d.price;
    const desc = d.desc || "";

    const adult = Number(d.adult || 0);
    const child = (d.child && d.child !== "null" && d.child !== "") ? Number(d.child || 0) : null;

    rmImg.src = imgUrl;
    rmImg.alt = name;
    title.textContent = name;
    descEl.textContent = desc || "A refined blend of comfort and modern design, curated for a restful stay.";

    rmSize.textContent = size;
    rmBed.textContent = bed;
    rmView.textContent = view;

    const rmAmenities = document.getElementById("rmAmenities");
    if (rmAmenities) {
      const raw = (d.amenities || "").trim();
      const items = raw ? raw.split(SEP) : [];
      rmAmenities.innerHTML = items
        .map(x => (x || "").trim())
        .filter(x => x)
        .map(x => '<div class="room-modal__amenity"><span class="ico">✓</span> ' + x + '</div>')
        .join("");
    }

    let occText = "Up to " + adult + " " + plural(adult, "Adult", "Adults");
    if (child !== null) occText += ", " + child + " " + plural(child, "Child", "Children");
    rmOcc.textContent = occText;

    rmPrice.textContent = (price && price !== "null") ? ( price) : "CONTACT";

    rmCheckBtn.href = ctx + "/booking?roomTypeId=" + id;
    rmDetailPageBtn.href = ctx + "/room-type/detail?id=" + id;

    openModal();
  });

  modal.addEventListener("click", function (e) {
    if (e.target.closest('[data-close="1"]')) closeModal();
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && modal.classList.contains("open")) closeModal();
  });
})();
