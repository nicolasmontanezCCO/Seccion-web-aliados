import fs from 'node:fs';

const lines = [];
function log(s){ lines.push(String(s)); }

try {
  const res = await fetch('http://localhost:8137/');
  const html = await res.text();
  log('SERVER STATUS: ' + res.status);
  log('HTML LENGTH: ' + html.length);
  log('HAS MAZE SNIPPET: ' + html.includes('maze-universal-loader.js'));
  log('HAS META VIEWPORT: ' + html.includes('name="viewport"'));
  log('HAS BURGER: ' + html.includes('cb-menu__burger'));
  log('MEDIA QUERY COUNT (max-width:1024px): ' + (html.match(/max-width:\s*1024px/g)||[]).length);
  log('MEDIA QUERY COUNT (max-width:480px): ' + (html.match(/max-width:\s*480px/g)||[]).length);
  log('MEDIA QUERY COUNT (max-width:768px): ' + (html.match(/max-width:\s*768px/g)||[]).length);
} catch (e) {
  log('FETCH ERROR: ' + e.message);
}

fs.writeFileSync(new URL('./check-out.txt', import.meta.url), lines.join('\n') + '\n');
