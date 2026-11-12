/* =====================================================================
   SECCIÓN 04 · ¿Qué tipo de Aliado quieres ser? · Credibanco
   USO EN AVADA: pegar en Avada > Options > Custom JS
   ===================================================================== */
(function () {
  'use strict';
  document.querySelectorAll('.cb-aliados:not([data-cb-init])').forEach(function (root, n) {
    root.setAttribute('data-cb-init', '');
    var cards  = Array.prototype.slice.call(root.querySelectorAll('.cb-aliados__card'));
    var panels = Array.prototype.slice.call(root.querySelectorAll('.cb-aliados__detalle'));

    panels.forEach(function (panel) {
      panel.id = 'cb-aliados-' + n + '-' + panel.dataset.panel;
    });
    cards.forEach(function (card) {
      var panel = root.querySelector('.cb-aliados__detalle[data-panel="' + card.dataset.aliado + '"]');
      if (panel) card.setAttribute('aria-controls', panel.id);
    });

    function showPanel(tipo, animate) {
      panels.forEach(function (panel) {
        var on = panel.dataset.panel === tipo;
        panel.hidden = !on;
        panel.classList.remove('is-entering');
        if (on && animate) { void panel.offsetWidth; panel.classList.add('is-entering'); }
      });
    }

    function select(card, opts) {
      opts = opts || {};
      if (card.classList.contains('is-selected') && !opts.force) return;
      cards.forEach(function (c) {
        var on = c === card;
        c.classList.toggle('is-selected', on);
        c.setAttribute('aria-checked', String(on));
        c.tabIndex = on ? 0 : -1;
      });
      showPanel(card.dataset.aliado, !opts.silent);
      if (opts.focus) card.focus();
      if (!opts.silent) {
        document.dispatchEvent(new CustomEvent('cb:aliado-seleccionado', { detail: { tipo: card.dataset.aliado } }));
      }
    }

    cards.forEach(function (card, i) {
      card.addEventListener('click', function () { select(card); });
      card.addEventListener('keydown', function (e) {
        var step = { ArrowRight:1, ArrowDown:1, ArrowLeft:-1, ArrowUp:-1 }[e.key];
        if (!step) return;
        e.preventDefault();
        select(cards[(i + step + cards.length) % cards.length], { focus: true });
      });
    });

    var inicial = root.querySelector('.cb-aliados__card.is-selected') || cards[0];
    if (inicial) select(inicial, { force: true, silent: true });
  });
})();
