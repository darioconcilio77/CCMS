/* CCMS Help – Navigation helper */

(function () {
  'use strict';

  /* ── Active link highlight ─────────────────────────────── */
  function markActive() {
    const current = location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.sidebar__nav a').forEach(function (a) {
      const href = a.getAttribute('href').split('/').pop();
      if (href === current) {
        a.classList.add('active');
        // scroll into view in sidebar
        a.scrollIntoView({ block: 'nearest' });
      }
    });
  }

  /* ── Mobile sidebar toggle ─────────────────────────────── */
  function initMobileMenu() {
    const btn = document.querySelector('.topbar__menu-btn');
    const sidebar = document.querySelector('.sidebar');
    if (!btn || !sidebar) return;

    btn.addEventListener('click', function () {
      sidebar.classList.toggle('open');
    });

    // close on outside click
    document.addEventListener('click', function (e) {
      if (sidebar.classList.contains('open') &&
          !sidebar.contains(e.target) &&
          !btn.contains(e.target)) {
        sidebar.classList.remove('open');
      }
    });
  }

  /* ── Smooth anchor scrolling with offset ──────────────── */
  function initAnchorScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(function (a) {
      a.addEventListener('click', function (e) {
        const target = document.querySelector(a.getAttribute('href'));
        if (!target) return;
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        history.replaceState(null, '', a.getAttribute('href'));
      });
    });
  }

  /* ── Init ──────────────────────────────────────────────── */
  document.addEventListener('DOMContentLoaded', function () {
    markActive();
    initMobileMenu();
    initAnchorScroll();
  });
}());
