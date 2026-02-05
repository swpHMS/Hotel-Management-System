(function () {
  const field = document.getElementById("guestField");
  const trigger = document.getElementById("guestTrigger");
  const panel = document.getElementById("guestPanel");
  if (!field || !trigger || !panel) return;

  const valueEl = document.getElementById("guestValue");
  const adultsHidden = document.getElementById("adultsHidden");
  const childrenHidden = document.getElementById("childrenHidden");
  const adultsInput = document.getElementById("adultsValue");
  const childrenInput = document.getElementById("childrenValue");
  const btnApply = document.getElementById("guestApply");

  const LIMITS = { adults: { min: 1, max: 30 }, children: { min: 0, max: 15 } };

  function openPanel() { panel.classList.add("open"); trigger.setAttribute("aria-expanded", "true"); }
  function closePanel() { panel.classList.remove("open"); trigger.setAttribute("aria-expanded", "false"); }

  function clamp(n, min, max) {
    if (Number.isNaN(n)) return min;
    return Math.max(min, Math.min(max, n));
  }
  function plural(n, one, many) { return n === 1 ? one : many; }
  function formatText(a, c) {
    return a + " " + plural(a, "Adult", "Adults") + ", " + c + " " + plural(c, "Child", "Children");
  }

  function setStepperUI(a, c) {
    adultsInput.value = String(a);
    childrenInput.value = String(c);

    panel.querySelectorAll('.step-btn[data-step="adults"][data-dir="-1"]').forEach(b => b.disabled = (a <= LIMITS.adults.min));
    panel.querySelectorAll('.step-btn[data-step="adults"][data-dir="1"]').forEach(b => b.disabled = (a >= LIMITS.adults.max));
    panel.querySelectorAll('.step-btn[data-step="children"][data-dir="-1"]').forEach(b => b.disabled = (c <= LIMITS.children.min));
    panel.querySelectorAll('.step-btn[data-step="children"][data-dir="1"]').forEach(b => b.disabled = (c >= LIMITS.children.max));
  }

  function syncFromHidden() {
    const a = clamp(parseInt(adultsHidden.value || "2", 10), LIMITS.adults.min, LIMITS.adults.max);
    const c = clamp(parseInt(childrenHidden.value || "0", 10), LIMITS.children.min, LIMITS.children.max);
    valueEl.textContent = formatText(a, c);
    setStepperUI(a, c);
  }

  syncFromHidden();

  trigger.addEventListener("click", () => panel.classList.contains("open") ? closePanel() : openPanel());

  panel.addEventListener("click", (e) => {
    const btn = e.target.closest(".step-btn");
    if (!btn) return;

    const step = btn.dataset.step;
    const dir = parseInt(btn.dataset.dir, 10);

    let a = clamp(parseInt(adultsInput.value || "2", 10), LIMITS.adults.min, LIMITS.adults.max);
    let c = clamp(parseInt(childrenInput.value || "0", 10), LIMITS.children.min, LIMITS.children.max);

    if (step === "adults") a = clamp(a + dir, LIMITS.adults.min, LIMITS.adults.max);
    else c = clamp(c + dir, LIMITS.children.min, LIMITS.children.max);

    setStepperUI(a, c);
  });
  
    // ✅ clamp ngay khi gõ tay vào input (trước đây bạn chưa có)
  function syncFromTyping() {
    let a = clamp(parseInt(adultsInput.value || "2", 10), LIMITS.adults.min, LIMITS.adults.max);
    let c = clamp(parseInt(childrenInput.value || "0", 10), LIMITS.children.min, LIMITS.children.max);
    setStepperUI(a, c); // set lại value => sẽ nhảy về max/min ngay
  }

  adultsInput.addEventListener("input", syncFromTyping);
  childrenInput.addEventListener("input", syncFromTyping);

  // optional: đảm bảo khi rời ô cũng ép lại
  adultsInput.addEventListener("blur", syncFromTyping);
  childrenInput.addEventListener("blur", syncFromTyping);


  btnApply.addEventListener("click", () => {
    const a = clamp(parseInt(adultsInput.value || "1", 10), LIMITS.adults.min, LIMITS.adults.max);
    const c = clamp(parseInt(childrenInput.value || "0", 10), LIMITS.children.min, LIMITS.children.max);

    adultsHidden.value = String(a);
    childrenHidden.value = String(c);
    valueEl.textContent = formatText(a, c);
    closePanel();
  });

  document.addEventListener("click", (e) => { if (!field.contains(e.target)) closePanel(); });
  document.addEventListener("keydown", (e) => { if (e.key === "Escape") closePanel(); });
})();
