
(function () {
  // Tìm input theo name (bạn đang dùng servlet parse theo checkIn/checkOut)
  const ci = document.querySelector('input[name="checkIn"]');
  const co = document.querySelector('input[name="checkOut"]');

  // Nếu bạn có form search riêng, lấy form gần nhất
  const form = ci ? ci.closest('form') : null;
  if (!ci || !co) return;

  function toISO(d) {
    // yyyy-MM-dd
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  function addDays(isoDate, days) {
    // isoDate: yyyy-MM-dd
    const [y, m, d] = isoDate.split('-').map(Number);
    const dt = new Date(y, m - 1, d);
    dt.setDate(dt.getDate() + days);
    return toISO(dt);
  }

  function ensureMinOneNight() {
    if (!ci.value) return;

    const minCO = addDays(ci.value, 1);     // ✅ checkOut phải >= checkIn + 1
    co.min = minCO;

    // nếu checkOut rỗng hoặc <= checkIn => set = checkIn+1
    if (!co.value || co.value <= ci.value) {
      co.value = minCO;
    }
  }

  // Khi đổi check-in -> tự đẩy check-out = check-in + 1
  ci.addEventListener('change', ensureMinOneNight);

  // Khi người dùng đổi check-out mà chọn sai -> ép về check-in + 1
  co.addEventListener('change', function () {
    if (!ci.value) return;
    if (!co.value || co.value <= ci.value) {
      co.value = addDays(ci.value, 1);
    }
  });

  // Khi load trang -> đồng bộ luôn
  window.addEventListener('load', ensureMinOneNight);

  // Khi submit -> chặn chắc (phòng trường hợp browser/datepicker lạ)
  if (form) {
    form.addEventListener('submit', function (e) {
      if (!ci.value || !co.value) return;
      if (co.value <= ci.value) {
        e.preventDefault();
        co.value = addDays(ci.value, 1);
        alert("Khách sạn yêu cầu tối thiểu 1 đêm. Check-out đã được tự động đặt = Check-in + 1.");
      }
    });
  }
})();
