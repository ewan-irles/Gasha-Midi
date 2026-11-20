// Tarpin Faim — petit serveur local, sans dépendance. Lancer : node server.js
// Ouvre ensuite http://localhost:5173 . Option : node server.js --lan (accessible depuis le Wi-Fi).
const http = require('http'), fs = require('fs'), path = require('path');
const PORT = +process.env.PORT || 5173;
const HOST = process.argv.includes('--lan') ? '0.0.0.0' : '127.0.0.1';
const ROOT = __dirname;
const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8',
  '.json': 'application/json', '.webmanifest': 'application/manifest+json', '.png': 'image/png', '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml', '.ico': 'image/x-icon', '.woff2': 'font/woff2', '.md': 'text/plain; charset=utf-8' };
http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0]);
  if (p.endsWith('/')) p += 'index.html';
  const file = path.normalize(path.join(ROOT, p));
  if (!file.startsWith(ROOT + path.sep) && file !== ROOT) { res.writeHead(403); return res.end('403'); }
  fs.readFile(file, (err, data) => {
    if (err) { res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' }); return res.end('404 : fichier introuvable'); }
    res.writeHead(200, { 'Content-Type': TYPES[path.extname(file).toLowerCase()] || 'application/octet-stream', 'Cache-Control': 'no-store' });
    res.end(data);
  });
}).listen(PORT, HOST, () => {
  console.log(`\n  Tarpin Faim tourne sur  http://localhost:${PORT}\n  (Ctrl + C pour arrêter)\n`);
  if (HOST === '0.0.0.0') console.log('  Mode réseau local : ouvre http://<IP-de-ton-PC>:' + PORT + ' depuis ton téléphone (même Wi-Fi).\n');
});
