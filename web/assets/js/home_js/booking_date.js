
(function () {
  const checkIn = document.getElementById("checkIn");
  const checkOut = document.getElementById("checkOut");
  if (!checkIn || !checkOut) return;

  function syncMinCheckout() {
    if (!checkIn.value) return;
    checkOut.min = checkIn.value;
    if (checkOut.value && checkOut.value < checkIn.value) checkOut.value = checkIn.value;
  }

  checkIn.addEventListener("change", syncMinCheckout);
  syncMinCheckout();
})();
