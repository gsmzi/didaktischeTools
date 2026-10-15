const http = require('http');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const os = require('os');

const REQUESTED_PORT = Number(process.env.PORT || 80);
let activePort = REQUESTED_PORT;
const ROOT = __dirname;
const clients = new Map();
const sessions = new Map();
let activeSession = null;

const areas = {
  1: { name: 'Küche', mediator: 'Küchenmeister', color: '#f2a65a', roles: ['Abschmecker', 'Kartoffelschäler', 'Geschirrspüler', 'Koch', 'Chefkoch'] },
  2: { name: 'Bäckerei', mediator: 'Bäckermeister', color: '#e8c07d', roles: ['Einkäufer', 'Backofenwächter', 'Tortenverzierer', 'Teigmischer', 'Teigkneter'] },
  3: { name: 'Kämmerei', mediator: 'Kämmereimeister', color: '#8ecae6', roles: ['Geldzähler', 'Steuereintreiber', 'Rechner', 'Geldwäscher', 'Gelddrucker'] },
  4: { name: 'Wäscherei', mediator: 'Wäschereimeister', color: '#90be6d', roles: ['Klarspüler', 'Bügler', 'Wassererhitzer', 'Schrubber', 'Aufhänger'] },
  5: { name: 'Schneiderei', mediator: 'Schneidermeister', color: '#cdb4db', roles: ['Vermesser', 'Näher', 'Knopfsucher', 'Fadenaufwickler', 'Zuschneider'] }
};
const roleForms = {
  'Küchenmeister': 'Küchenmeisterin', 'Abschmecker': 'Abschmeckerin', 'Kartoffelschäler': 'Kartoffelschälerin', 'Geschirrspüler': 'Geschirrspülerin', 'Koch': 'Köchin', 'Chefkoch': 'Chefköchin',
  'Bäckermeister': 'Bäckermeisterin', 'Einkäufer': 'Einkäuferin', 'Backofenwächter': 'Backofenwächterin', 'Tortenverzierer': 'Tortenverziererin', 'Teigmischer': 'Teigmischerin', 'Teigkneter': 'Teigkneterin',
  'Kämmereimeister': 'Kämmereimeisterin', 'Geldzähler': 'Geldzählerin', 'Steuereintreiber': 'Steuereintreiberin', 'Rechner': 'Rechnerin', 'Geldwäscher': 'Geldwäscherin', 'Gelddrucker': 'Gelddruckerin',
  'Wäschereimeister': 'Wäschereimeisterin', 'Klarspüler': 'Klarspülerin', 'Bügler': 'Büglerin', 'Wassererhitzer': 'Wassererhitzerin', 'Schrubber': 'Schrubberin', 'Aufhänger': 'Aufhängerin',
  'Schneidermeister': 'Schneidermeisterin', 'Vermesser': 'Vermesserin', 'Näher': 'Näherin', 'Knopfsucher': 'Knopfsucherin', 'Fadenaufwickler': 'Fadenaufwicklerin', 'Zuschneider': 'Zuschneiderin'
};
const links = [[1, 2], [1, 3], [1, 5], [2, 4], [4, 5]];
const roleTasks = {
  'Einkäufer': 'Frage den Gelddrucker, wann du ihn am Nachmittag abholen kannst.',
  'Backofenwächter': 'Frage den Geschirrspüler nach sauberen Kuchenformen und der Abholung der schmutzigen Formen.',
  'Tortenverzierer': 'Frage den Steuereintreiber nach den Farben seines Lieblingsfußballvereins.',
  'Teigmischer': 'Frage den Rechner, wie viel drei Achtel von 16 kg Mehl sind.',
  'Teigkneter': 'Frage den Geldwäscher, wie seine Schwester heißt und ob er sie vorstellen kann.',
  'Abschmecker': 'Frage den Näher nach Stoff, einem neuen Gewand und dem Preis.',
  'Kartoffelschäler': 'Frage den Schrubber, wann er deine helle Hose waschen kann.',
  'Geschirrspüler': 'Frage den Teigkneter, ob er die schweren Teigschüsseln abholen kann.',
  'Koch': 'Frage den Geldzähler, wie viel Geld für den Einkauf zur Verfügung steht.',
  'Chefkoch': 'Frage den Gelddrucker, welche Summe er bis 17 Uhr drucken kann.',
  'Geldzähler': 'Frage den Teigmischer, ob deine Münzen in seine Teigschüssel gefallen sind.',
  'Steuereintreiber': 'Frage den Tortenverzierer, wann er heute mit der Arbeit fertig ist.',
  'Rechner': 'Frage den Koch, ob er am Nachmittag eine halbe Stunde Zeit hat.',
  'Geldwäscher': 'Frage den Backofenwächter, ob er einen Korb Geld trocknen kann.',
  'Gelddrucker': 'Frage den Einkäufer, wann du ihn am Nachmittag abholen kannst.',
  'Vermesser': 'Frage den Abschmecker, wann du seine Maße nehmen kannst.',
  'Näher': 'Frage den Klarspüler, ob er den Blutfleck auf dem Jagdgewand entfernen kann.',
  'Knopfsucher': 'Frage den Zuschneider, ob du dir seine Schere leihen kannst.',
  'Fadenaufwickler': 'Frage den Aufhänger, ob auf seiner Wäscheleine Platz zum Trocknen ist.',
  'Zuschneider': 'Frage den Bügler, wann er die zerknitterten Stoffteile bügeln kann.',
  'Klarspüler': 'Frage den Vermesser, ob er einen Messbecher besitzt.',
  'Bügler': 'Frage den Knopfsucher nach Ersatzknöpfen.',
  'Wassererhitzer': 'Frage den Kartoffelschäler, ob er ein paar Kartoffeln beiseitelegen kann.',
  'Schrubber': 'Frage den Wassererhitzer, wann das heiße Wasser fertig ist.',
  'Aufhänger': 'Frage den Fadenaufwickler, ob er ein paar Minuten vorbeikommen möchte.'
};

function clean(value, max = 240) {
  return String(value ?? '').trim().replace(/[<>]/g, '').slice(0, max);
}
function roleLabel(role, gender = 'female') { return gender === 'male' ? role : roleForms[role] || role; }
function makeCode() { return crypto.randomBytes(3).toString('hex').toUpperCase(); }
function sendJson(res, status, data) {
  const body = JSON.stringify(data);
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
  res.end(body);
}
function visibleParticipants(session, viewer) {
  const participants = [...session.participants.values()];
  if (!viewer) return participants;
  if (viewer.isMediator) return participants.filter(participant => participant.router === viewer.router || participant.isMediator);
  return participants.filter(participant => participant.router === viewer.router);
}
function sessionView(session, viewer = null) {
  const participantAddresses = viewer ? new Set([viewer.address]) : null;
  return {
    code: session.code,
    createdAt: session.createdAt,
    participants: visibleParticipants(session, viewer).map(publicParticipant),
    messages: (viewer ? session.messages.filter(message => participantAddresses.has(message.from) || participantAddresses.has(message.to)) : session.messages).slice(-100),
    settings: session.settings
  };
}
function pickerView(session) {
  return { code: session.code, createdAt: session.createdAt, participants: [...session.participants.values()].map(participant => ({ role: participant.role, router: participant.router, online: clients.has(participant.id) })), messages: [], settings: session.settings };
}
function publicParticipant(p) {
  return { id: p.id, name: p.name, role: roleLabel(p.role, p.gender), roleKey: p.role, gender: p.gender, router: p.router, address: p.address, isMediator: p.isMediator, online: clients.has(p.id), joinedAt: p.joinedAt };
}
function broadcast(session, event) {
  const message = JSON.stringify(event);
  for (const p of session.participants.values()) {
    const socket = clients.get(p.id);
    if (socket) socket.send(message);
  }
  if (session.teacher) session.teacher.send(message);
}
function broadcastState(session) {
  for (const participant of session.participants.values()) {
    const socket = clients.get(participant.id);
    if (socket) socket.send(JSON.stringify({ type: 'state', state: sessionView(session, participant) }));
  }
  if (session.teacher) session.teacher.send(JSON.stringify({ type: 'state', state: sessionView(session) }));
}
function findParticipant(session, address) { return [...session.participants.values()].find(p => p.address.toLowerCase() === clean(address, 30).toLowerCase()); }
function routePath(from, to) {
  if (from === to) return [from];
  const queue = [[from]]; const seen = new Set([from]);
  while (queue.length) {
    const current = queue.shift();
    const last = current[current.length - 1];
    for (const edge of links) {
      if (!edge.includes(last)) continue;
      const next = edge[0] === last ? edge[1] : edge[0];
      if (seen.has(next)) continue;
      const nextPath = [...current, next];
      if (next === to) return nextPath;
      seen.add(next); queue.push(nextPath);
    }
  }
  return [];
}
function assignAddress(session, router) {
  const used = new Set([...session.participants.values()].filter(p => p.router === router).map(p => Number(p.address.split('.')[1])));
  let slot = 1; while (used.has(slot)) slot += 1;
  return `${router}.${slot}`;
}
function removeParticipant(session, participant) {
  if (!session || !participant) return false;
  const current = session.participants.get(participant.id);
  if (current !== participant) return false;
  session.participants.delete(participant.id);
  clients.delete(participant.id);
  broadcastState(session);
  return true;
}
function nextId() { return crypto.randomBytes(8).toString('hex'); }
function makeSession() {
  let code = makeCode(); while (sessions.has(code)) code = makeCode();
  const session = { code, createdAt: new Date().toISOString(), participants: new Map(), messages: [], teacher: null, settings: { phase: 'open', encoding: 'ascii', showBinary: false, showTasks: true, studentHost: '' } };
  sessions.set(code, session); activeSession = session; return session;
}
function getCurrentSession() { return activeSession || makeSession(); }
function localAddresses() {
  const interfaces = os.networkInterfaces();
  const addresses = [];
  for (const [name, entries] of Object.entries(interfaces)) for (const entry of entries || []) {
    if (entry.family === 'IPv4' && !entry.internal && !entry.address.startsWith('169.254.')) addresses.push({ name, address: entry.address });
  }
  const virtual = /(virtual|vmware|vbox|hyper-v|docker|wsl|loopback)/i;
  return [...addresses.filter(item => !virtual.test(item.name)), ...addresses.filter(item => virtual.test(item.name))];
}
function localAddress() {
  return localAddresses()[0]?.address || '127.0.0.1';
}
function baseUrl(hostname) { return `http://${hostname}${activePort === 80 ? '' : `:${activePort}`}`; }
function configuredBaseUrl(hostname) {
  const host = clean(hostname, 120).replace(/^https?:\/\//i, '').replace(/\/.*$/, '');
  if (!host) return baseUrl(localAddress());
  const hasPort = host.includes(':') && !host.startsWith('[');
  return `http://${host}${hasPort || activePort === 80 ? '' : `:${activePort}`}`;
}
function requestIsLocal(req) {
  const rawHost = String(req.headers.host || '');
  const host = (rawHost.startsWith('[') ? rawHost.slice(1, rawHost.indexOf(']')) : rawHost.split(':')[0]).toLowerCase();
  return host === 'localhost' || host === '127.0.0.1' || host === '::1';
}
function serverInfo(req) {
  const session = getCurrentSession();
  const addresses = localAddresses();
  const selectedHost = session.settings.studentHost || addresses[0]?.address || '127.0.0.1';
  const studentUrl = configuredBaseUrl(selectedHost);
  return { isTeacherRequest: requestIsLocal(req), serverIp: selectedHost, serverIps: addresses, teacherUrl: baseUrl('localhost'), studentUrl, guideUrl: `${studentUrl}/anleitung`, port: activePort, session: requestIsLocal(req) ? sessionView(session) : pickerView(session), areas, links, tasks: roleTasks, roleForms };
}
function parseBody(req) {
  return new Promise((resolve, reject) => { let body = ''; req.on('data', chunk => { body += chunk; if (body.length > 10000) req.destroy(); }); req.on('end', () => { try { resolve(JSON.parse(body || '{}')); } catch { reject(new Error('Ungültige JSON-Daten')); } }); req.on('error', reject); });
}
function routeMessage(session, sender, data) {
  const text = clean(data.text, 1200); const to = clean(data.to, 30);
  if (!text || !to) return { error: 'Bitte Zieladresse und Nachricht ausfüllen.' };
  const recipient = findParticipant(session, to);
  if (!recipient) return { error: `Die Adresse ${to} ist im Palastnetzwerk nicht angemeldet.` };
  const message = { id: nextId(), from: sender.address, fromName: sender.name, to: recipient.address, toName: recipient.name, replyTo: clean(data.replyTo, 80) || null, text, sentAt: new Date().toISOString(), path: routePath(sender.router, recipient.router), encoding: data.encoding === 'binary' ? 'binary' : 'ascii' };
  session.messages.push(message); if (session.messages.length > 500) session.messages.shift();
  const recipientSocket = clients.get(recipient.id); if (recipientSocket) recipientSocket.send(JSON.stringify({ type: 'message', direction: 'received', message }));
  const senderSocket = clients.get(sender.id); if (senderSocket) senderSocket.send(JSON.stringify({ type: 'message', direction: 'sent', message }));
  if (session.teacher) session.teacher.send(JSON.stringify({ type: 'message', direction: 'monitor', message }));
  return { ok: true, message };
}

function handleHttp(req, res) {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  if (req.method === 'GET' && url.pathname === '/api/info') return sendJson(res, 200, serverInfo(req));
  if (req.method === 'GET' && url.pathname === '/api/session/current') return sendJson(res, 200, pickerView(getCurrentSession()));
  if (req.method === 'GET' && url.pathname === '/api/areas') return sendJson(res, 200, { areas, links, tasks: roleTasks, roleForms });
  if (req.method === 'POST' && url.pathname === '/api/session') { const session = makeSession(); return sendJson(res, 201, { code: session.code, info: serverInfo(req) }); }
  if (req.method === 'GET' && url.pathname.startsWith('/api/session/')) { const code = url.pathname.split('/').pop().toUpperCase(); const session = sessions.get(code); return session ? sendJson(res, 200, requestIsLocal(req) ? sessionView(session) : pickerView(session)) : sendJson(res, 404, { error: 'Raum nicht gefunden.' }); }
  let file = url.pathname === '/' ? '/index.html' : url.pathname === '/anleitung' ? '/guide.html' : url.pathname;
  file = path.normalize(file).replace(/^([.][.][\\/])+/, '');
  const full = path.join(ROOT, 'public', file);
  if (!full.startsWith(path.join(ROOT, 'public'))) return sendJson(res, 403, { error: 'Verboten' });
  fs.readFile(full, (err, data) => { if (err) return sendJson(res, 404, { error: 'Nicht gefunden' }); const ext = path.extname(full); const type = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8', '.svg': 'image/svg+xml' }[ext] || 'application/octet-stream'; res.writeHead(200, { 'Content-Type': type }); res.end(data); });
}

function acceptWebSocket(req, socket) {
  const key = req.headers['sec-websocket-key']; if (!key) return socket.destroy();
  const accept = crypto.createHash('sha1').update(key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').digest('base64');
  socket.write(`HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${accept}\r\n\r\n`);
  socket.setNoDelay(true); const ws = { socket, buffer: Buffer.alloc(0), session: null, participant: null, send(text) { const payload = Buffer.from(text); const header = payload.length < 126 ? Buffer.from([0x81, payload.length]) : Buffer.from([0x81, 126, payload.length >> 8, payload.length & 255]); socket.write(Buffer.concat([header, payload])); } }; 
  socket.on('data', chunk => { ws.buffer = Buffer.concat([ws.buffer, chunk]); readFrames(ws); });
  socket.on('close', () => { if (ws.participant) removeParticipant(ws.session, ws.participant); if (ws.session?.teacher === ws) ws.session.teacher = null; });
  socket.on('error', () => socket.destroy());
}
function readFrames(ws) {
  while (ws.buffer.length >= 2) {
    const first = ws.buffer[0], second = ws.buffer[1]; const opcode = first & 15; let length = second & 127; let header = 2;
    if (length === 126) { if (ws.buffer.length < 4) return; length = ws.buffer.readUInt16BE(2); header = 4; }
    if (length === 127) return ws.socket.destroy();
    const masked = (second & 128) !== 0; const fullHeader = header + (masked ? 4 : 0); if (ws.buffer.length < fullHeader + length) return;
    const mask = masked ? ws.buffer.subarray(header, fullHeader) : null; const data = Buffer.from(ws.buffer.subarray(fullHeader, fullHeader + length)); ws.buffer = ws.buffer.subarray(fullHeader + length);
    if (mask) for (let i = 0; i < data.length; i++) data[i] ^= mask[i % 4];
    if (opcode === 8) return ws.socket.end(); if (opcode === 9) { ws.socket.write(Buffer.from([0x8A, 0])); continue; } if (opcode !== 1) continue;
    try { onSocketMessage(ws, JSON.parse(data.toString('utf8'))); } catch { ws.send(JSON.stringify({ type: 'error', error: 'Nachricht konnte nicht verarbeitet werden.' })); }
  }
}
function onSocketMessage(ws, data) {
  if (data.type === 'join') {
    const session = sessions.get(clean(data.code, 10).toUpperCase()); if (!session) return ws.send(JSON.stringify({ type: 'error', error: 'Raum nicht gefunden.' }));
    const router = Number(data.router); const area = areas[router]; if (!area) return ws.send(JSON.stringify({ type: 'error', error: 'Bereich nicht gefunden.' }));
    const name = clean(data.name, 50); const role = clean(data.role, 50); const gender = data.gender === 'male' ? 'male' : 'female'; if (!area.roles.includes(role) && role !== area.mediator) return ws.send(JSON.stringify({ type: 'error', error: 'Rolle passt nicht zum gewählten Bereich.' }));
    const offlineParticipant = [...session.participants.values()].find(p => p.role.toLowerCase() === role.toLowerCase() && !clients.has(p.id));
    if (offlineParticipant) removeParticipant(session, offlineParticipant);
    if ([...session.participants.values()].some(p => p.role.toLowerCase() === role.toLowerCase())) return ws.send(JSON.stringify({ type: 'error', error: 'Diese Rolle ist bereits vergeben. Bitte wähle eine andere.' }));
    const participant = { id: nextId(), name: name || roleLabel(role, gender), role, gender, router, address: assignAddress(session, router), isMediator: role === area.mediator, joinedAt: new Date().toISOString() };
    session.participants.set(participant.id, participant); ws.session = session; ws.participant = participant; clients.set(participant.id, ws); ws.send(JSON.stringify({ type: 'joined', me: publicParticipant(participant), state: sessionView(session, participant), areas, links, tasks: roleTasks, roleForms })); broadcastState(session); return;
  }
  if (data.type === 'teacher') { const session = sessions.get(clean(data.code, 10).toUpperCase()); if (!session) return ws.send(JSON.stringify({ type: 'error', error: 'Raum nicht gefunden.' })); ws.session = session; session.teacher = ws; return ws.send(JSON.stringify({ type: 'teacher-ready', state: sessionView(session), areas, links, tasks: roleTasks, roleForms })); }
  const session = ws.session; if (!session) return ws.send(JSON.stringify({ type: 'error', error: 'Noch keinem Raum beigetreten.' }));
  if (data.type === 'participant-view' && session.teacher === ws) {
    const participant = session.participants.get(data.id);
    if (!participant) return ws.send(JSON.stringify({ type: 'error', error: 'Teilnehmender nicht gefunden.' }));
    return ws.send(JSON.stringify({ type: 'participant-view', participant: publicParticipant(participant), state: sessionView(session, participant), areas, links, tasks: roleTasks, roleForms }));
  }
  if (data.type === 'send' && ws.participant) { const result = routeMessage(session, ws.participant, data); if (result.error) ws.send(JSON.stringify({ type: 'error', error: result.error })); return; }
  if (data.type === 'settings' && session.teacher === ws) { session.settings = { ...session.settings, phase: ['open', 'quiet', 'paused'].includes(data.phase) ? data.phase : session.settings.phase, encoding: data.encoding === 'binary' ? 'binary' : 'ascii', showBinary: data.showBinary === undefined ? session.settings.showBinary : data.showBinary === true, showTasks: data.showTasks !== false, studentHost: data.studentHost === undefined ? session.settings.studentHost : clean(data.studentHost, 120) }; broadcastState(session); return; }
  if (data.type === 'clear-log' && session.teacher === ws) { session.messages = []; broadcastState(session); return; }
  if (data.type === 'remove' && session.teacher === ws) { const p = session.participants.get(data.id); if (p) { const client = clients.get(p.id); if (client) { client.send(JSON.stringify({ type: 'error', error: 'Du wurdest aus dem Raum entfernt.' })); client.socket.end(); } session.participants.delete(p.id); clients.delete(p.id); broadcastState(session); } }
}

function startServer(port) {
  const server = http.createServer(handleHttp);
  server.on('upgrade', (req, socket) => acceptWebSocket(req, socket));
  server.on('error', error => {
    if (!process.env.PORT && port === 80 && ['EACCES', 'EADDRINUSE'].includes(error.code)) {
      console.warn(`Port 80 ist nicht verfügbar (${error.code}). Verwende automatisch Port 8080.`);
      activePort = 8080;
      startServer(8080);
      return;
    }
    throw error;
  });
  server.listen(port, '0.0.0.0', () => console.log(`Palastnetzwerk läuft auf http://localhost${port === 80 ? '' : `:${port}`}`));
  return server;
}
startServer(REQUESTED_PORT);
