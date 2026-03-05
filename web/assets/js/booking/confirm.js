(function () {
  const body = document.body;
  const holdMs = parseInt(body.getAttribute("data-holdms") || "900000", 10);

  const agree = document.getElementById("cfAgree");
  const btn = document.getElementById("cfContinue");
  const timerEl = document.getElementById("cfTimer");

  if (agree && btn) {
    agree.addEventListener("change", () => {
      if (agree.checked) btn.classList.add("enabled");
      else btn.classList.remove("enabled");
    });
  }

  let remain = isNaN(holdMs) ? 900000 : holdMs;

  function pad(n) { return n < 10 ? "0" + n : "" + n; }

  function tick() {
    if (!timerEl) return;

    if (remain <= 0) {
      timerEl.textContent = "00:00";
      if (btn) {
        btn.classList.remove("enabled");
        btn.style.opacity = ".35";
        btn.style.pointerEvents = "none";
      }
      return;
    }

    remain -= 1000;
    const s = Math.floor(remain / 1000);
    timerEl.textContent = pad(Math.floor(s / 60)) + ":" + pad(s % 60);
    setTimeout(tick, 1000);
  }

  tick();
})();