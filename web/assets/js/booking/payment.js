(function () {
  const expiresAt = Number(window.__PAY_EXPIRES_AT__ || 0);

  const bannerTimer = document.getElementById("bannerTimer");
  const holdTimer = document.getElementById("holdTimer");
  const confirmBtn = document.getElementById("confirmBtn");

  function pad(n){ return String(n).padStart(2, "0"); }

  function renderTime(ms){
    const totalSec = Math.max(0, Math.floor(ms / 1000));
    const mm = Math.floor(totalSec / 60);
    const ss = totalSec % 60;
    return `${pad(mm)}:${pad(ss)}`;
  }

  function expireUI(){
    const t = "00:00";
    if (bannerTimer) bannerTimer.textContent = t;
    if (holdTimer) holdTimer.textContent = t;

    if (confirmBtn){
      confirmBtn.disabled = true;
      confirmBtn.textContent = "HẾT THỜI GIAN GIỮ PHÒNG";

      // chặn submit form (cho chắc)
      const form = confirmBtn.closest("form");
      if (form){
        form.addEventListener("submit", function(e){
          e.preventDefault();
        });
      }
    }
  }

  function tick(){
    if (!expiresAt || Number.isNaN(expiresAt)) {
      // không có expiresAt thì thôi, không đếm
      return;
    }

    const remain = expiresAt - Date.now();
    if (remain <= 0){
      expireUI();
      return;
    }

    const t = renderTime(remain);
    if (bannerTimer) bannerTimer.textContent = t;
    if (holdTimer) holdTimer.textContent = t;

    setTimeout(tick, 1000);
  }

  tick();
})();