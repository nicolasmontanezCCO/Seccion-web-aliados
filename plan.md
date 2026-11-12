# Plan de implementación — Landing responsive (tablet + móvil)

Archivo único a editar (ruta absoluta exacta):
`c:\Users\NMONTANEZ\OneDrive - Credibanco S.A\Documentos\Diseños kiro\index.html`

Las imágenes están sueltas en esa misma carpeta con rutas planas (`src="hero-bg.png"`). NO se mueven ni se renombran. NO se tocan: el snippet de Maze del `<head>`, el `<meta name="viewport">`, ni el JavaScript existente (radiogroup de aliados, tabs/acordeón FAQ, formulario + modal + bloqueo numérico, navegación por hash). Ningún cambio altera el DOM que esos scripts consultan por clase/atributo.

## Alcance y verificación

Trabajo 100% CSS (más, como mucho, un `<span>` decorativo sin JS para el icono hamburguesa del menú). Es un sitio estático de un solo archivo: NO hay build, NO hay gestor de paquetes, NO hay test runner. La verificación de cada paso es visual, abriendo el archivo en el navegador y usando las herramientas de desarrollo con tamaños de viewport concretos.

Comando para abrir el archivo en el navegador por defecto (PowerShell, desde la carpeta del proyecto):

```
Invoke-Item "c:\Users\NMONTANEZ\OneDrive - Credibanco S.A\Documentos\Diseños kiro\index.html"
```

Anchos de viewport a comprobar en DevTools (modo responsive) en CADA paso:
- **Desktop ≥ 1025px** (p. ej. 1280px y 1440px): debe verse EXACTAMENTE igual que antes del cambio. Esta es la restricción dura.
- **Tablet**: 1024px y 768px.
- **Móvil**: 480px, 390px y 360px.

Criterios transversales que deben cumplirse al final de cada paso:
1. No aparece scroll horizontal a 360px, 390px, 480px, 768px ni 1024px.
2. Ningún texto, imagen o tarjeta desborda su contenedor.
3. El desktop (≥1025px) queda idéntico (no se borró ni modificó ninguna regla existente fuera de media queries).
4. Las interacciones JS siguen funcionando: seleccionar tarjeta de aliado cambia el panel, el acordeón FAQ abre/cierra, el formulario valida y abre el modal, el campo celular bloquea no-numéricos, y el hash de la URL cambia al hacer scroll.

## Estrategia general (aplica a TODOS los pasos)

- **Breakpoints**: tablet `@media (max-width: 1024px)` (ajustes mayores alineados al diseño de 768px de Figma) y móvil `@media (max-width: 480px)`. Donde el diseño tablet (768px) difiera de 1024px, el objetivo del breakpoint de 1024px es el layout tablet de Figma; se permite un ajuste intermedio adicional con `@media (max-width: 768px)` solo si hace falta para que no desborde entre 1024 y 768.
- **Dónde va el CSS**: cada media query se añade DENTRO del bloque `<style>` de su sección, al final del bloque (justo antes de `</style>`), para conservar el patrón de "CSS por sección". NO crear un `<style>` global nuevo.
- **No destructivo**: nunca se borran ni editan reglas existentes. Las reglas responsive sobreescriben por especificidad/orden dentro del media query. Cuando haya que neutralizar un ancho fijo, se sobreescribe con `width: 100%` / `max-width: 100%` / `width: auto` dentro del media query.
- **Márgenes laterales objetivo (Figma)**: tablet = 48px, móvil = 24px.
- **Regla de oro**: todo ancho fijo en px mayor al viewport se vuelve fluido; paddings laterales de 120–125px bajan a 48px (tablet) y 24px (móvil); font-sizes de títulos grandes se reducen según las medidas de Figma listadas por sección.
- **Orden**: los pasos van en el orden del documento (de arriba a abajo). Son mayormente independientes entre sí (cada uno toca su propio bloque `<style>`), pero el Paso 1 (reset anti-overflow) debe ir primero porque habilita la comprobación "sin scroll horizontal" del resto.

---

## Paso 0 (preparación, sin cambios de código)

- [ ] 0. Abrir `index.html` en el navegador y, en DevTools, capturar el estado desktop a 1280px como referencia (screenshot mental o real) de las 11 secciones. Sirve para comparar al final que el desktop no cambió.
      Archivos: ninguno.
      Verificar: el sitio carga, las imágenes se ven, y las 4 interacciones JS responden a 1280px.

---

## Paso 1 — Base anti-overflow global

- [ ] 1. Añadir, dentro del `<style>` del `<head>` existente (el que ya contiene `body { margin:0; ... }`), reglas base responsive de alcance global mínimo: `html, body { overflow-x: hidden; }` y `img, svg { max-width: 100%; }` **solo** dentro de un `@media (max-width: 1024px)` para no alterar desktop. Esto crea una red de seguridad contra desbordes sin tocar el layout desktop.
      Nota: NO poner `img { max-width:100% }` global fuera del media query, porque varias imágenes desktop usan anchos mayores a su caja a propósito (p. ej. `.cb-faq__img img` con `width:194.43%`, `.cb-vincularte__photo img` con `width:179.86%`). Por eso se limita al breakpoint y además cada sección que use esos trucos se ajusta en su propio paso.
      Archivos: `c:\Users\NMONTANEZ\OneDrive - Credibanco S.A\Documentos\Diseños kiro\index.html` (bloque `<style>` del `<head>`).
      Verificar: a 1280px nada cambia; a 1024/768/480/360 no hay aún layout correcto pero el scroll horizontal del documento global desaparece parcialmente. Confirmar que a 1280px la foto del FAQ y la de vincularte siguen recortadas igual que antes.

---

## Paso 2 — `.cb-menu` (header / navegación)

Clase raíz: `.cb-menu`. Medidas Figma: tablet y móvil colapsan a **logo (206×40) + botón hamburguesa oscuro 48×48, radius 14px, icono 22px**; sin barra de utilidades ni enlaces de nav. Padding lateral: tablet 48px, móvil 24px.

- [ ] 2. En el `<style>` de `.cb-menu`, añadir:
      - `@media (max-width: 1024px)`: `.cb-menu` → `height: auto; padding: 16px 48px; flex-direction: row; align-items: center; gap: 0;`. Ocultar la barra de utilidades (`.cb-menu__util { display: none; }`) y los enlaces de navegación (`.cb-menu__nav { display: none; }`). `.cb-menu__bar` ya es `flex ... space-between`, así queda logo a la izquierda. Escalar el logo (`.cb-menu__logo img { width: 206px; height: auto; }`). Añadir un botón hamburguesa visible: ver nota de markup abajo.
      - `@media (max-width: 480px)`: `.cb-menu { padding: 14px 24px; }`.
      Decisión de markup (hamburguesa): el HTML actual NO tiene botón hamburguesa y el repo NO tiene un icono de hamburguesa como archivo. Para no añadir dependencias de imagen ni JavaScript nuevo (restricción: no romper/añadir JS), se añade un elemento decorativo **dentro de `.cb-menu__bar`**, después de `.cb-menu__nav`:
      `<span class="cb-menu__burger" aria-hidden="true"></span>`
      y se dibuja el icono con CSS (3 líneas con `box-shadow`/pseudo-elementos) sobre un cuadro 48×48 `background:#1d1d1d; border-radius:14px`. Se muestra SOLO en `@media (max-width:1024px)` (`display:flex`) y permanece `display:none` en desktop. Es visual (coincide con Figma); se documenta como no interactivo. Justificación: el diseño de Figma no define el contenido del menú desplegado y el alcance de la tarea es responsividad de layout, no una nueva feature de navegación.
      Alternativa considerada y descartada: implementar un menú desplegable funcional — descartada porque exige JS nuevo y contenido de menú que Figma no especifica, y la tarea pide explícitamente no romper/añadir lógica.
      Archivos: `c:\Users\NMONTANEZ\OneDrive - Credibanco S.A\Documentos\Diseños kiro\index.html` (HTML de `.cb-menu__bar` + su `<style>`).
      Verificar: a 1280px el menú se ve idéntico (utilidades + 4 enlaces, sin hamburguesa). A 768px y 390px: solo logo a la izquierda + cuadro hamburguesa oscuro a la derecha, sin desbordes, sin scroll horizontal.

---

## Paso 3 — `.cb-hero`

Clase raíz: `.cb-hero`. Medidas Figma — Tablet: padding `110px 48px 52px`, gap 20px, título **44px / line-height 1.08 SIN nowrap**, texto 18px/1.45 ancho completo, badge 24px, botones en fila (primario 180px, outline 230px), altura automática. Móvil: padding `120px 24px 52px`, gap 20px, título **34px**, botones **apilados a ancho completo** (columna).

- [ ] 3. En el `<style>` de `.cb-hero`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-hero { height: auto; padding: 110px 48px 52px; }`
        - `.cb-hero__content { height: auto; gap: 20px; }`
        - `.cb-hero__title { white-space: normal; font-size: 44px; line-height: 1.08; }` (quitar el `nowrap`; mantener el `<br>` existente no es problema porque ya envuelve).
        - `.cb-hero__text { width: 100%; font-size: 18px; line-height: 1.45; }`
      - `@media (max-width: 480px)`:
        - `.cb-hero { padding: 120px 24px 52px; }`
        - `.cb-hero__title { font-size: 34px; }`
        - `.cb-hero__actions { flex-direction: column; width: 100%; }`
        - `.cb-hero__btn { width: 100%; justify-content: center; }`
      Archivos: `...\index.html` (`<style>` de `.cb-hero`).
      Verificar: a 1280px el hero no cambia (título en una línea con nowrap, altura 498px). A 768px el título envuelve en varias líneas sin cortarse ni desbordar y la imagen de fondo cubre toda la caja. A 390px los dos botones ocupan el ancho y van uno debajo del otro.

---

## Paso 4 — `.cb-breadcrumb`

Clase raíz: `.cb-breadcrumb`. Padding lateral grande (125px) → 48px tablet / 24px móvil. El contenido es una fila corta; con reducir padding basta.

- [ ] 4. En el `<style>` de `.cb-breadcrumb`, añadir:
      - `@media (max-width: 1024px)`: `.cb-breadcrumb { padding: 10px 48px; }`
      - `@media (max-width: 480px)`: `.cb-breadcrumb { padding: 10px 24px; } .cb-breadcrumb ol { flex-wrap: wrap; }`
      Archivos: `...\index.html` (`<style>` de `.cb-breadcrumb`).
      Verificar: a 1280px igual. A 390px la miga de pan no desborda y, si no cabe, envuelve.

---

## Paso 5 — `.cb-aliados` (tipos de aliado: tarjetas + panel de detalle + CTA)

Clase raíz: `.cb-aliados`. Medidas Figma — Tablet: sección padding `72px 48px`, gap 32px; `.cb-aliados__inner` ancho completo; título 38px; tarjetas en fila con `flex:1 0 0` (ancho fluido, ~214px c/u a 768px), gap 16px, imagen de tarjeta **180px** de alto (no 309), copy con padding `0 18px 20px`; panel de detalle en 2 columnas `flex:1 0 0` c/u, gap 24px. Móvil: padding `56px 24px`, gap 32px, título 30px, tarjetas **apiladas 1 por fila a ancho completo**, panel de detalle **apilado a 1 columna**.

- [ ] 5. En el `<style>` de `.cb-aliados`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-aliados { padding: 72px 48px; border-radius: 0; }`
        - `.cb-aliados__inner { width: 100%; gap: 32px; }`
        - `.cb-aliados__title { font-size: 38px; line-height: 1.12; }`
        - `.cb-aliados__cards { width: 100%; margin-top: 0; gap: 16px; }`
        - `.cb-aliados__card { flex: 1 1 0; width: auto; height: auto; }` (ancho fluido; altura automática).
        - Como la imagen de tarjeta usa posicionamiento absoluto con `.cb-aliados__card-img { width:357px; height:309px }` y `.cb-aliados__card-body { position:absolute; top:339px; width:313px }`, en fluido eso rompe. Reestructurar a flujo normal SOLO en el media query: `.cb-aliados__card-img { position: static; width: 100%; height: 180px; }`, `.cb-aliados__card-body { position: static; width: 100%; top: auto; left: auto; padding: 0 18px 20px; }`. Así la tarjeta pasa a ser una columna (imagen arriba, texto abajo), como en Figma. (El `box-sizing` ya es border-box.)
        - `.cb-aliados__detalle { width: 100%; gap: 24px; }`
        - `.cb-aliados__beneficios { width: auto; flex: 1 1 0; height: auto; }`
        - `.cb-aliados__portafolio { height: auto; }`
        - `.cb-aliados__btn { width: 100%; max-width: 292px; }`
      - `@media (max-width: 480px)`:
        - `.cb-aliados { padding: 56px 24px; }`
        - `.cb-aliados__title { font-size: 30px; }`
        - `.cb-aliados__cards { flex-direction: column; }`
        - `.cb-aliados__card { flex: 1 1 auto; width: 100%; }`
        - `.cb-aliados__detalle { flex-direction: column; }`
        - `.cb-aliados__beneficios { width: 100%; }`
      Nota JS: el script de aliados solo lee `.cb-aliados__card[data-aliado]`, `.cb-aliados__detalle[data-panel]` y alterna `hidden`/`.is-selected`. Ninguno de esos ganchos se toca; solo cambian propiedades de CSS de layout. La animación `.is-entering` sigue válida.
      Archivos: `...\index.html` (`<style>` de `.cb-aliados`).
      Verificar: a 1280px idéntico (3 tarjetas 357px, panel en 2 columnas 1082px). A 768px las 3 tarjetas caben en fila a ancho fluido con imagen de 180px y texto debajo; al hacer clic en cada tarjeta cambia el panel. A 390px las 3 tarjetas se apilan y el panel de detalle queda en 1 columna; clic sigue cambiando el panel sin scroll horizontal.

---

## Paso 6 — `.cb-vincularte` (banner con hover → dos bloques apilados)

Clase raíz: `.cb-vincularte`. Este es el cambio de concepto clave.

Estado desktop (se conserva intacto ≥1025px): un frame de 642px donde `.cb-vincularte__default` (banner oscuro con título "¿Cómo puedes vincularte?") se funde al pasar el cursor hacia `.cb-vincularte__hover` (bloque foto + panel "Proceso de vinculación" con 3 pasos).

Objetivo tablet/móvil (Figma): DOS bloques apilados SIEMPRE visibles, SIN hover:
1. **Linking banner** oscuro con solo el título. Tablet: padding `72px 48px`, overlay `rgba(0,0,0,0.62)`, título **46px**/1.08, ancho 430px. Móvil: padding `72px 24px`, título **38px**, ancho completo.
2. **Linking process** en fondo claro: título "Proceso de vinculación" (tablet 38px / móvil 30px) + 3 pasos en lista vertical; cada paso = tarjeta `#f6f9fc`, radius 16px, padding 24px, gap 18px, badge circular `#00afaa` de **44px** (número 18px blanco), título de paso 20px, descripción 16px `#5b5c5c`. Sección: padding tablet `72px 48px` / móvil `56px 24px`, gap 32px.

Decisión de markup/CSS (elegida): **reutilizar el markup existente sin añadir nodos nuevos.** El markup actual ya contiene todo lo necesario:
- `.cb-vincularte__default` → ya es el banner oscuro con el título correcto.
- `.cb-vincularte__hover` → ya contiene `.cb-vincularte__heading` ("Proceso de vinculación") y 3 `.cb-vincularte__step` (badge + título + texto).
Estrategia: en los media queries se desactiva la mecánica de superposición absoluta y de hover, y se recoloca cada bloque en flujo normal, apilados:
- Convertir `.cb-vincularte` a `height: auto` y quitar la capa absoluta: `.cb-vincularte__default, .cb-vincularte__hover { position: static; inset: auto; opacity: 1 !important; transform: none !important; transition: none; pointer-events: auto; }`.
- Neutralizar el disparador hover dentro del media query repitiendo las reglas `:hover`/`:focus-within` con `opacity:1; transform:none` (no se borran las de desktop; se sobreescriben solo bajo el breakpoint). Como el bloque hover pasa a estar siempre visible, el efecto de "revelar al pasar el cursor" deja de aplicar en móvil (donde no hay cursor), que es justo lo pedido.
- Banner (`.cb-vincularte__default`): `display:flex; min-height: 240px (tablet)/200px (móvil); align-items:center; padding:72px 48px (tablet)/72px 24px (móvil)`. Mantener las capas de imagen de fondo `.cb-vincularte__layer` pero hacerlas cubrir la caja: dentro del media query `.cb-vincularte__layer { position:absolute; inset:0; width:100%; height:100%; top:0 !important; }` y su `img { width:100%; height:100%; object-fit:cover; }`. Oscurecer con el overlay existente `::after` (ya presente). Título: `.cb-vincularte__title { position:relative; width:100%; max-width:430px; margin:0; font-size:46px (tablet)/38px (móvil); line-height:1.08; }`.
- Proceso (`.cb-vincularte__hover`): `background:#fff; display:block; padding:72px 48px (tablet)/56px 24px (móvil);`. Dentro, deshacer la composición foto+panel: `.cb-vincularte__block { position:static; width:100%; height:auto; }`, **ocultar la foto** `.cb-vincularte__photo { display:none; }` (en Figma tablet/móvil el proceso no lleva la foto solapada), `.cb-vincularte__panel { position:static; width:100%; height:auto; background:transparent; border-radius:0; }`, `.cb-vincularte__content { position:static; transform:none; left:auto; top:auto; width:100%; gap:32px; }`.
- Reestilizar cada paso como tarjeta: `.cb-vincularte__step { background:#f6f9fc; border-radius:16px; padding:24px; gap:18px; }` y pasar la cabecera del paso a fila badge+título (ya lo es con `.cb-vincularte__step-head`). Badge circular 44px: `.cb-vincularte__badge { width:44px; height:44px; border-radius:50%; background:#00afaa; font-size:18px; }` (sobre el estilo desktop que era 32px/radius 8px). El badge del paso 1 (`--ring`) ya tiene el círculo; con el badge ya redondo el `::before` del anillo es redundante en móvil → `.cb-vincularte__badge--ring::before { display:none; }`.
      Encabezado del proceso: `.cb-vincularte__heading { font-size:38px (tablet)/30px (móvil); color:#1d1d1d; text-shadow:none; }` (en Figma el título del proceso es gris oscuro, no verde; se ajusta solo en el media query).
- `@media (max-width: 480px)`: además de lo anterior, `.cb-vincularte__step-head { flex-wrap: nowrap; }` y comprobar que el texto del paso no desborda.
      Archivos: `...\index.html` (`<style>` de `.cb-vincularte`).
      Verificar: a 1280px el banner sigue mostrando el estado oscuro y al pasar el cursor revela el panel "Proceso de vinculación" con la foto, igual que antes (hover intacto). A 768px y 390px se ven DOS bloques apilados sin necesidad de hover: arriba el banner oscuro con el título, debajo el bloque claro "Proceso de vinculación" con 3 tarjetas de paso (badge redondo 44px + título + texto), sin foto, sin scroll horizontal.

---

## Paso 7 — `.cb-beneficios`

Clase raíz: `.cb-beneficios`. Medidas Figma — Tablet/Móvil cambian el concepto: en vez de "texto a la izquierda + lista con scroll de 352px a la derecha", pasa a **flujo vertical**: eyebrow + título + texto arriba, y debajo las 4 tarjetas de beneficio como cajas `#ebfffe` (sin el scroll fijo). Tablet: sección padding `72px 48px`, gap 28px, título 42px; tarjetas en `flex-wrap`, cada una ancho 328px (2 por fila a 768px), min-height 132px, padding 22px, radius 20px, gap 16px. Móvil: padding `56px 24px`, título 32px, tarjetas **1 por fila a ancho completo**.

- [ ] 7. En el `<style>` de `.cb-beneficios`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-beneficios { padding: 72px 48px; }`
        - `.cb-beneficios__inner { flex-direction: column; align-items: stretch; width: 100%; gap: 28px; }`
        - `.cb-beneficios__copy { width: 100%; }`
        - `.cb-beneficios__title { font-size: 42px; line-height: 1.12; }`
        - `.cb-beneficios__text { width: 100%; }`
        - Convertir el scroll en rejilla sin scroll: `.cb-beneficios__scroll { width: 100%; height: auto; padding: 0; overflow: visible; flex-direction: row; flex-wrap: wrap; gap: 16px; }`.
        - Reestilizar cada item como tarjeta y **neutralizar los pseudo-marcos** `::before`/`::after` (que usan px absolutos): `.cb-beneficios__item { flex: 1 1 328px; min-width: 280px; height: auto; min-height: 132px; padding: 22px; gap: 16px; background: #ebfffe; border-radius: 20px; box-shadow: 0 4px 2px rgba(67,67,67,.08); }`, `.cb-beneficios__item::before, .cb-beneficios__item::after { content: none; }`.
        - Reposicionar icono y texto a flujo normal: `.cb-beneficios__icon { position: static; width: 55.52px; height: 55.52px; }`, `.cb-beneficios__item p { position: static; width: auto; margin-left: 0; font-size: 18px; line-height: 1.35; flex: 1; }`.
      - `@media (max-width: 480px)`:
        - `.cb-beneficios { padding: 56px 24px; }`
        - `.cb-beneficios__title { font-size: 32px; }`
        - `.cb-beneficios__scroll { flex-direction: column; }`
        - `.cb-beneficios__item { flex: 1 1 auto; width: 100%; }`
      Nota: `.cb-beneficios__scroll` tiene `tabindex=0` y `aria-label`; sigue siendo un `<ul>` válido, solo cambia su CSS. No hay JS asociado.
      Archivos: `...\index.html` (`<style>` de `.cb-beneficios`).
      Verificar: a 1280px idéntico (texto 502px + columna con scroll 458px/352px, barra oculta). A 768px: título arriba y 4 tarjetas `#ebfffe` en rejilla de 2 columnas, sin scroll interno. A 390px: las 4 tarjetas apiladas a ancho completo, sin desborde.

---

## Paso 8 — `.cb-resultados`

Clase raíz: `.cb-resultados`. Medidas Figma — Tablet/Móvil cambian de "título a la izquierda + grid 2×2 a la derecha" a **flujo vertical**: título arriba y debajo las 4 cifras como **tarjetas blancas** (`bg #fff`, radius 16px, padding 24px) en `flex-wrap`. Tablet: sección padding `72px 48px`, gap 36px, título 44px, cifra 60px, tarjeta ancho 324px (2 por fila), gap 24px. Móvil: padding `56px 24px`, título 34px, cifra 52px, tarjetas 1 por fila.

- [ ] 8. En el `<style>` de `.cb-resultados`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-resultados { padding: 72px 48px; }`
        - `.cb-resultados__inner { flex-direction: column; align-items: stretch; width: 100%; gap: 36px; }`
        - `.cb-resultados__title { width: 100%; font-size: 44px; line-height: 1.12; }`
        - `.cb-resultados__grid { display: flex; flex-wrap: wrap; width: 100%; gap: 24px; }`
        - `.cb-resultados__stat { flex: 1 1 324px; min-width: 280px; background: #fff; border-radius: 16px; padding: 24px; gap: 12px; }`
        - `.cb-resultados__stat dt { font-size: 60px; line-height: normal; }`
      - `@media (max-width: 480px)`:
        - `.cb-resultados { padding: 56px 24px; }`
        - `.cb-resultados__title { font-size: 34px; }`
        - `.cb-resultados__stat { flex: 1 1 auto; width: 100%; }`
        - `.cb-resultados__stat dt { font-size: 52px; }`
      Nota de contenido: las cifras (00%, 0,0%, 000, 105) y su color rojo vienen así del diseño; no se cambian (solo layout).
      Archivos: `...\index.html` (`<style>` de `.cb-resultados`).
      Verificar: a 1280px idéntico (título 396px + grid 2×293px). A 768px: título arriba, 4 tarjetas blancas en 2 columnas. A 390px: 4 tarjetas apiladas, cifra 52px, sin desborde.

---

## Paso 9 — `.cb-faq` (aside imagen + tabs + acordeón)

Clase raíz: `.cb-faq`. Medidas Figma — Tablet/Móvil **apilan en una sola columna**: imagen como **banner superior a ancho completo** (alto 290px, radius 24px), luego título (tablet 40px / móvil ~30px), subtítulo 16px, fila de tabs (pastillas que envuelven, `#ebfffe` activa), y acordeón a ancho completo. Sección padding tablet `72px 48px` / móvil `56px 24px`, gap 24px.

- [ ] 9. En el `<style>` de `.cb-faq`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-faq { flex-direction: column; height: auto; padding: 72px 48px; gap: 24px; }`
        - Aside → banner: `.cb-faq__aside { flex-direction: column; width: 100%; height: auto; padding: 0; gap: 24px; }`, `.cb-faq__heading { padding: 0; white-space: normal; }`, `.cb-faq__title { font-size: 40px; }`.
        - Imagen a banner full-width: `.cb-faq__img { order: -1; width: 100%; height: 290px; border-radius: 24px; }` y neutralizar el recorte desktop: `.cb-faq__img img { position: static; left: auto; width: 100%; height: 100%; object-fit: cover; }`.
        - Main: `.cb-faq__main { width: 100%; padding: 0; gap: 16px; }`, `.cb-faq__tabs { width: 100%; flex-wrap: wrap; gap: 8px; }`, `.cb-faq__accordion { width: 100%; }`.
        - Tabs como pastillas (alineado a Figma): `.cb-faq__tab { flex: 0 0 auto; height: auto; padding: 10px 14px; border: 0; border-radius: 12px; background: #f6f9fc; }`, `.cb-faq__tab.is-active { background: #ebfffe; border: 0; color: #000; }`.
      - `@media (max-width: 480px)`:
        - `.cb-faq { padding: 56px 24px; }`
        - `.cb-faq__title { font-size: 30px; }`
        - `.cb-faq__img { height: 220px; }`
      Nota JS: el script FAQ lee `.cb-faq__tab`, `.cb-faq__item`, `.cb-faq__trigger`, `.cb-faq__panel` y alterna `is-active`/`is-open`/`hidden`/`aria-expanded`. Solo se cambia CSS; ningún gancho se altera. El `order:-1` de la imagen es puramente visual.
      Archivos: `...\index.html` (`<style>` de `.cb-faq`).
      Verificar: a 1280px idéntico (aside imagen izquierda 427px + main derecha, alto 878px). A 768px: imagen banner arriba (290px), luego título/subtítulo, tabs en pastillas que envuelven, acordeón a ancho completo; abrir/cerrar preguntas funciona y cambiar de tab marca la activa. A 390px igual con imagen 220px y sin scroll horizontal.

---

## Paso 10 — `.cb-entidades`

Clase raíz: `.cb-entidades`. La imagen `logos-bancos.svg` tiene width fijo 1280 y está posicionada absoluta → desborda. Hacerla fluida.

- [ ] 10. En el `<style>` de `.cb-entidades`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-entidades { height: auto; padding-bottom: 32px; }`
        - `.cb-entidades__title { padding-top: 56px; font-size: 32px; padding-left: 48px; padding-right: 48px; }`
        - Imagen fluida en flujo: `.cb-entidades__logos { position: static; width: 100%; max-width: 100%; height: auto; margin-top: 24px; }`.
      - `@media (max-width: 480px)`:
        - `.cb-entidades__title { padding-top: 40px; font-size: 26px; padding-left: 24px; padding-right: 24px; }`
      Archivos: `...\index.html` (`<style>` de `.cb-entidades`).
      Verificar: a 1280px idéntico (imagen 1280×359 posicionada). A 768px y 390px la imagen de logos se reduce proporcionalmente (max-width:100%, height:auto) sin desbordar ni generar scroll horizontal; el título no se corta.

---

## Paso 11 — `.cb-contacto` (copy + formulario + modal)

Clase raíz: `.cb-contacto`. Medidas Figma — Tablet: fila copy + formulario, gap 36px, padding `72px 48px`; copy `flex:1 0 0` (fluido), título 42px; formulario ancho 400px. Móvil: **apilado a 1 columna**, formulario a ancho completo; padding `56px 24px`; título copy 34px. El modal de éxito ya es `position:fixed` y responsive (`max-width:340px`), no requiere cambios.

- [ ] 11. En el `<style>` de `.cb-contacto`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-contacto { padding: 72px 48px; }`
        - `.cb-contacto__inner { width: 100%; gap: 36px; }`
        - `.cb-contacto__copy { flex: 1 1 0; width: auto; min-width: 0; }`
        - `.cb-contacto__title { font-size: 42px; line-height: 1.12; }`
        - `.cb-contacto__pasos { width: 100%; }`
        - `.cb-contacto__form { flex: 0 0 400px; width: 400px; }`
      - `@media (max-width: 480px)`:
        - `.cb-contacto { padding: 56px 24px; }`
        - `.cb-contacto__inner { flex-direction: column; align-items: stretch; }`
        - `.cb-contacto__copy { width: 100%; }`
        - `.cb-contacto__title { font-size: 34px; }`
        - `.cb-contacto__form { flex: 1 1 auto; width: 100%; padding: 32px 20px; }`
      Nota JS: el script de contacto lee `.cb-contacto__form`, `[required]`, `select`, `[name="tipo"]`, `[data-solo-numeros]`, `.cb-contacto__status`, `[data-modal]`, `[data-modal-close]`, y escucha `cb:aliado-seleccionado`. Solo se cambia CSS de layout; ningún gancho se toca. El bloqueo numérico y la validación siguen intactos.
      Archivos: `...\index.html` (`<style>` de `.cb-contacto`).
      Verificar: a 1280px idéntico (copy 440px + form 500px, inner 1002px). A 768px copy fluido + form 400px lado a lado sin desbordar. A 390px copy arriba y formulario debajo a ancho completo; rellenar y enviar abre el modal; el campo celular rechaza letras; seleccionar tipo de aliado arriba (sección aliados) preselecciona el `select`.

---

## Paso 12 — `.cb-footer`

Clase raíz: `.cb-footer`. Medidas Figma — Tablet/Móvil: `flex-col`, logo arriba, columnas de enlaces apiladas/reducidas, iconos sociales, copyright. Padding tablet `56px 48px 32px` / móvil `56px 24px 32px`, gap 32px. El footer real tiene 4 columnas (grid 296/296/296/257), una imagen `vigilado` posicionada absoluta, bloque de stores/certs, y una barra inferior (`.cb-footer__bottom`). Estrategia: tablet → grid de 2 columnas; móvil → 1 columna; la imagen `vigilado` absoluta pasa a estática para no solaparse.

- [ ] 12. En el `<style>` de `.cb-footer`, añadir:
      - `@media (max-width: 1024px)`:
        - `.cb-footer__top { grid-template-columns: repeat(2, 1fr); height: auto; padding: 56px 48px 32px; gap: 40px 28px; }`
        - Sacar `vigilado` del posicionamiento absoluto para que fluya: `.cb-footer__vigilado { position: static; left: auto; top: auto; margin-top: 8px; }` (quedará dentro del flujo del grid como un item más; aceptable y sin solapes).
        - `.cb-footer__col ul { max-width: none; }`
        - `.cb-footer__bottom { height: auto; padding: 24px 48px; gap: 16px; }`
      - `@media (max-width: 480px)`:
        - `.cb-footer__top { grid-template-columns: 1fr; padding: 56px 24px 32px; gap: 32px; }`
        - `.cb-footer__bottom { flex-direction: column; align-items: flex-start; padding: 24px; gap: 12px; }`
      Nota: el footer no tiene JS. Como `.cb-footer__top` es un grid con un item absoluto (`vigilado`), al volverlo estático pasa a ocupar su propia celda; verificar que no deja un hueco raro — si lo hiciera, alternativa: `.cb-footer__vigilado { grid-column: 1 / -1; }` en el mismo media query.
      Archivos: `...\index.html` (`<style>` de `.cb-footer`).
      Verificar: a 1280px idéntico (grid 4 columnas 296/296/296/257, vigilado posicionado, bottom bar). A 768px: 2 columnas, vigilado sin solaparse, sin scroll horizontal. A 390px: 1 columna, logo y copyright apilados, todo legible y sin desborde.

---

## Paso 13 — Verificación integral

- [ ] 13. Recorrer todo el documento en DevTools a 1440px, 1280px, 1024px, 768px, 480px, 390px y 360px.
      Archivos: ninguno (solo revisión).
      Verificar, en este orden:
      1. **Desktop (1440/1280)**: comparar contra la referencia del Paso 0. Las 11 secciones deben verse idénticas. Confirmar que el hover de `.cb-vincularte` sigue revelando el panel con la foto.
      2. **Sin scroll horizontal** en 1024/768/480/390/360 (comprobar `document.scrollingElement.scrollWidth === clientWidth`).
      3. **Interacciones JS** a 768px y a 390px: (a) clic en cada tarjeta de aliado cambia el panel; (b) acordeón FAQ abre/cierra y las tabs marcan activa; (c) formulario valida, el campo celular bloquea letras, el `select` de tipo se preselecciona al elegir aliado, y enviar abre el modal (y se cierra con "Entendido"/Esc/overlay); (d) al hacer scroll el hash de la URL cambia (Maze).
      4. **Imágenes**: hero-bg, fotos de aliado, vincularte, faq y logos-bancos se ven correctamente escaladas, sin recortes erróneos ni desbordes.

---

## Notas y supuestos

- **Hamburguesa del menú (Paso 2)**: se implementa como icono visual CSS sin JS ni nuevo asset, por fidelidad a Figma sin añadir una feature de navegación que el diseño no especifica. Si se quiere un menú desplegable funcional, es un trabajo aparte (requiere definir contenido y JS).
- **Tarjetas de resultados/beneficios con fondo (Pasos 7 y 8)**: el fondo de tarjeta (`#ebfffe` / `#fff`) solo aparece en tablet/móvil según Figma; en desktop no se añade (se respeta el diseño actual).
- **Color del título "Proceso de vinculación" (Paso 6)**: en desktop es verde (`--cb-tertiary`); el diseño responsive de Figma lo muestra gris oscuro. Se ajusta a gris oscuro solo dentro de los media queries.
- **Diferencias de contenido Figma vs HTML**: algunos textos/listas del Figma responsive difieren del HTML actual (p. ej. teléfonos del footer, textos de tarjetas). NO se cambia el contenido: la tarea es de layout responsive, no de reescritura de copy. Solo se adoptan medidas de layout (paddings, gaps, tamaños, columnas).
- **`@media (max-width: 768px)` intermedio**: si entre 1024px y 768px alguna sección queda apretada (p. ej. 3 tarjetas de aliado o 2 columnas de beneficios), se permite añadir un breakpoint intermedio a 768px dentro del bloque de esa sección para apilar antes. Decidir durante la implementación según lo que se observe en DevTools.
