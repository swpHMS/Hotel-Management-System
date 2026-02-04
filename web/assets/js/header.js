(function () {
  document.querySelectorAll('.hms-header').forEach(function (header) {
    const btn = header.querySelector('.hms-avatarBtn');
    const menu = header.querySelector('.hms-menu');
    if (!btn || !menu) return;

    function closeMenu() {
      menu.classList.remove('open');
      btn.setAttribute('aria-expanded', 'false');
    }
    function toggleMenu() {
      const isOpen = menu.classList.toggle('open');
      btn.setAttribute('aria-expanded', String(isOpen));
    }

    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      toggleMenu();
    });
    menu.addEventListener('click', function (e) {
      e.stopPropagation();
    });
    document.addEventListener('click', closeMenu);
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closeMenu();
    });
  });

  // Active menu
  const path = window.location.pathname; // vd: /Hotel_Management_System/home
  document.querySelectorAll('.hms-nav .hms-link').forEach(function (a) {
    const href = a.getAttribute('href') || '';
    if (!href) return;

    // So khớp theo "kết thúc bằng" để khỏi phụ thuộc contextPath
    if (path.endsWith('/home') && href.endsWith('/home')) a.classList.add('is-active');
    if (path.includes('/rooms') && href.includes('/rooms')) a.classList.add('is-active');
    if (path.includes('/contact') && href.includes('/contact')) a.classList.add('is-active');
  });
})();

(function(){
  const header = document.querySelector(".hms-header");
  if (!header) return;

  function updateHeaderState(){
    if (window.scrollY > 8) {
      header.classList.remove("is-top");
      header.classList.add("is-sticky");
    } else {
      header.classList.remove("is-sticky");
      header.classList.add("is-top");
    }
  }

  // init
  updateHeaderState();

  // listen scroll
  window.addEventListener("scroll", updateHeaderState);
})();
