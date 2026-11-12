/* =====================================================================
   SECCIÓN 08 · Preguntas frecuentes · Credibanco
   USO EN AVADA: pegar en Avada > Options > Custom JS
   ===================================================================== */
(function () {
  'use strict';
  document.querySelectorAll('.cb-faq:not([data-cb-init])').forEach(function (root, n) {
    root.setAttribute('data-cb-init', '');

    // Pestañas
    var tabs = Array.prototype.slice.call(root.querySelectorAll('.cb-faq__tab'));
    function activate(tab, focus) {
      tabs.forEach(function (t) {
        var on = t === tab;
        t.classList.toggle('is-active', on);
        t.setAttribute('aria-selected', String(on));
        t.tabIndex = on ? 0 : -1;
      });
      if (focus) tab.focus();
    }
    tabs.forEach(function (tab, i) {
      tab.tabIndex = tab.classList.contains('is-active') ? 0 : -1;
      tab.addEventListener('click', function () { activate(tab, false); });
      tab.addEventListener('keydown', function (e) {
        var step = { ArrowRight: 1, ArrowLeft: -1 }[e.key];
        if (!step) return;
        e.preventDefault();
        activate(tabs[(i + step + tabs.length) % tabs.length], true);
      });
    });

    // Acordeón
    root.querySelectorAll('.cb-faq__item').forEach(function (item, i) {
      var trigger = item.querySelector('.cb-faq__trigger');
      var panel   = item.querySelector('.cb-faq__panel');
      if (panel) {
        var id = 'cb-faq-' + n + '-' + i;
        panel.id  = id;
        trigger.id = id + '-btn';
        trigger.setAttribute('aria-controls', id);
        panel.setAttribute('aria-labelledby', trigger.id);
        panel.hidden = trigger.getAttribute('aria-expanded') !== 'true';
      }
      trigger.addEventListener('click', function () {
        var open = trigger.getAttribute('aria-expanded') === 'true';
        trigger.setAttribute('aria-expanded', String(!open));
        item.classList.toggle('is-open', !open);
        if (panel) panel.hidden = open;
      });
    });
  });
})();
