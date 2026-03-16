(function () {
  const ci = document.querySelector('input[name="checkIn"]');
  const co = document.querySelector('input[name="checkOut"]');
  const form = ci ? ci.closest('form') : null;

  const MIN_NIGHTS = 1;
  const MAX_NIGHTS = 30;

  if (!ci || !co) return;

  function toISO(d) {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  function addDays(isoDate, days) {
    const [y, m, d] = isoDate.split('-').map(Number);
    const dt = new Date(y, m - 1, d);
    dt.setDate(dt.getDate() + days);
    return toISO(dt);
  }

  function diffDays(fromISO, toISODate) {
    const [y1, m1, d1] = fromISO.split('-').map(Number);
    const [y2, m2, d2] = toISODate.split('-').map(Number);

    const from = new Date(y1, m1 - 1, d1);
    const to = new Date(y2, m2 - 1, d2);

    return Math.round((to - from) / (1000 * 60 * 60 * 24));
  }

  function syncCheckoutRange() {
    if (!ci.value) return;

    const minCO = addDays(ci.value, MIN_NIGHTS);
    const maxCO = addDays(ci.value, MAX_NIGHTS);

    co.min = minCO;
    co.max = maxCO;

    if (!co.value || diffDays(ci.value, co.value) < MIN_NIGHTS) {
      co.value = minCO;
      return;
    }

    if (diffDays(ci.value, co.value) > MAX_NIGHTS) {
      co.value = maxCO;
    }
  }

  ci.addEventListener('change', syncCheckoutRange);

  co.addEventListener('change', function () {
    if (!ci.value) return;

    const nights = diffDays(ci.value, co.value);

    if (!co.value || nights < MIN_NIGHTS) {
      co.value = addDays(ci.value, MIN_NIGHTS);
      alert("Khách sạn yêu cầu tối thiểu 1 đêm.");
      return;
    }

    if (nights > MAX_NIGHTS) {
      co.value = addDays(ci.value, MAX_NIGHTS);
      alert("Khách sạn chỉ cho đặt tối đa " + MAX_NIGHTS + " đêm.");
    }
  });

  window.addEventListener('load', syncCheckoutRange);

  if (form) {
    form.addEventListener('submit', function (e) {
      if (!ci.value || !co.value) return;

      const nights = diffDays(ci.value, co.value);

      if (nights < MIN_NIGHTS) {
        e.preventDefault();
        co.value = addDays(ci.value, MIN_NIGHTS);
        alert("Khách sạn yêu cầu tối thiểu 1 đêm. Check-out đã được tự động đặt = Check-in + 1.");
        return;
      }

      if (nights > MAX_NIGHTS) {
        e.preventDefault();
        co.value = addDays(ci.value, MAX_NIGHTS);
        alert("Khách sạn chỉ cho đặt tối đa " + MAX_NIGHTS + " đêm. Check-out đã được tự động điều chỉnh.");
      }
    });
  }
})();