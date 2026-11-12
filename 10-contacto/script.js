/* =====================================================================
   SECCIÓN 10 · Contacto y formulario · Credibanco
   USO EN AVADA: pegar en Avada > Options > Custom JS
   ===================================================================== */
(function () {
  'use strict';
  document.querySelectorAll('.cb-contacto:not([data-cb-init])').forEach(function (root) {
    root.setAttribute('data-cb-init', '');
    var form     = root.querySelector('.cb-contacto__form');
    var selects  = Array.prototype.slice.call(form.querySelectorAll('select'));
    var tipo     = form.querySelector('[name="tipo"]');
    var required = Array.prototype.slice.call(form.querySelectorAll('[required]'));
    var status   = form.querySelector('.cb-contacto__status');
    var modal    = root.querySelector('[data-modal]');

    // Solo números
    Array.prototype.slice.call(form.querySelectorAll('[data-solo-numeros]')).forEach(function (campo) {
      campo.addEventListener('keydown', function (e) {
        if (e.ctrlKey || e.metaKey || e.altKey) return;
        var ok = ['Backspace','Delete','Tab','Enter','Escape','Home','End','ArrowLeft','ArrowRight','ArrowUp','ArrowDown',' '];
        if (ok.indexOf(e.key) !== -1) return;
        if (e.key.length === 1 && !/[0-9]/.test(e.key)) e.preventDefault();
      });
      campo.addEventListener('input', function () {
        var v = campo.value.replace(/[^0-9 ]/g, '');
        if (campo.value !== v) campo.value = v;
      });
    });

    // Modal
    function abrirModal() {
      if (!modal) return;
      modal.hidden = false;
      var btn = modal.querySelector('.cb-contacto__modal-btn');
      if (btn) btn.focus();
      document.addEventListener('keydown', onEsc);
    }
    function cerrarModal() {
      if (!modal) return;
      modal.hidden = true;
      document.removeEventListener('keydown', onEsc);
    }
    function onEsc(e) { if (e.key === 'Escape') cerrarModal(); }
    if (modal) {
      modal.querySelectorAll('[data-modal-close]').forEach(function (el) {
        el.addEventListener('click', cerrarModal);
      });
    }

    function syncSelect(s) { s.classList.toggle('is-empty', !s.value); }
    selects.forEach(function (s) {
      syncSelect(s);
      s.addEventListener('change', function () { syncSelect(s); });
    });

    // Preselección desde módulo 04
    document.addEventListener('cb:aliado-seleccionado', function (e) {
      if (!tipo || !e.detail || !e.detail.tipo) return;
      tipo.value = e.detail.tipo;
      syncSelect(tipo);
    });

    function errorFor(field) {
      var box = field.closest('.cb-contacto__field');
      return box ? box.querySelector('.cb-contacto__error') : null;
    }
    function setError(field, show) {
      var msg = errorFor(field);
      field.setAttribute('aria-invalid', String(show));
      if (!msg) return;
      msg.hidden = !show;
      if (!msg.id) msg.id = field.id + '-error';
      if (show) field.setAttribute('aria-describedby', msg.id);
      else field.removeAttribute('aria-describedby');
    }

    required.forEach(function (field) {
      var evt = field.type === 'checkbox' || field.tagName === 'SELECT' ? 'change' : 'blur';
      field.addEventListener(evt, function () { setError(field, !field.checkValidity()); });
    });

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var first = null;
      required.forEach(function (field) {
        var invalid = !field.checkValidity();
        setError(field, invalid);
        if (invalid && !first) first = field;
      });
      if (first) { status.textContent = ''; first.focus(); return; }
      // TODO: enviar al endpoint real → new FormData(form)
      status.textContent = '';
      form.reset();
      selects.forEach(syncSelect);
      abrirModal();
    });
  });
})();
