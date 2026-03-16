(function () {
  const btn = document.getElementById("viewAllBtn");
  const wrapper = document.getElementById("roomsWrapper");
  if (!btn || !wrapper) return;

  btn.addEventListener("click", function (e) {
    e.preventDefault();

    wrapper.classList.toggle("rooms-collapsed");
    const expanded = !wrapper.classList.contains("rooms-collapsed");

    btn.innerHTML = expanded
      ? 'HIDE OPTIONS <span class="arrow" aria-hidden="true">↑</span>'
      : 'VIEW ALL RESIDENTIAL OPTIONS <span class="arrow" aria-hidden="true">→</span>';
  });
})();