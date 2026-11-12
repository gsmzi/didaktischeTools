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
const TASK_WAIT_MS = Number(process.env.TASK_WAIT_MS || 60 * 1000); // Nach jedem neuen Auftrag 60 s Sperre für „Neuer Auftrag“, damit niemand Aufträge durchklickt.
// Auftragsgenerator: kurze, frei erfundene Festgeschichten. Pro Nachricht genügt ein Satz.
// Einige Aufträge führen nach der Antwort zu einer kurzen Rückmeldung; der Löffel bleibt ein gemeinsames Gerücht.
// Die Texte hängen vom Bereich des Empfängers ab. {ziel} wird zu „den Koch“ bzw. „die Köchin“.
const taskTemplates = {
  1: [
    'Die Geburtstagssuppe schmeckt nach Badewasser. Bitte {ziel} um eine Rettungsidee.',
    'Der König wünscht sich eckige Kartoffeln. Frage {ziel}, wie das gehen soll.',
    'Du hast das Probeessen ganz aufgegessen. Bitte {ziel} um eine gute Ausrede für den König.',
    'Der Pudding raucht verdächtig. Frage {ziel}, ob er noch auf die Festtafel darf. Antworte danach kurz, ob du dich traust, ihn zu probieren.',
    'Der goldene Löffel ist weg. Frage {ziel} nach einem verdächtigen Fund in der Küche.',
    'Für das Fest fehlt ein Nachtisch. Bitte {ziel} um einen verrückten Vorschlag. Schreibe zurück, ob du ihn bestellst.',
    'Die Festsoße glitzert im Dunkeln. Frage {ziel} nach der geheimen Zutat.',
    'Der König will Suppe mit der Gabel essen. Bitte {ziel} um einen Tipp. Antworte danach kurz, ob du ihn ausprobierst.'
  ],
  2: [
    'Die Geburtstagstorte passt nicht durch die Tür. Bitte {ziel} um einen Plan. Die Tür muss heil bleiben.',
    'Die Festbrezeln sind hart wie Ziegelsteine. Frage {ziel}, wofür man sie noch gebrauchen kann.',
    'Das königliche Pferd will auch ein Stück Torte. Frage {ziel} nach einer passenden Geschmacksrichtung.',
    'Bitte {ziel} um ein Plätzchen mit einem lustigen Spruch für den König.',
    'Der goldene Löffel ist weg. Frage {ziel}, ob etwas Goldenes aus dem Brotteig ragt.',
    'Du brauchst eine Torte in Drachenform. Frage {ziel}, ob das klappt. Antworte auf den Bescheid mit einem Dank oder einem Ersatzwunsch.',
    'Auf der Torte ist nur Platz für eine Kerze. Bitte {ziel} um eine Lösung. Schreibe zurück, ob der König damit zufrieden wäre.',
    'Du willst es beim Fest Mehl schneien lassen. Frage {ziel} nach einer besseren Idee. Schreibe zurück, ob du sie nimmst.'
  ],
  3: [
    'Du willst dem König eine goldene Kartoffel schenken. Bitte {ziel} mit einer kurzen Begründung um zwölf Taler.',
    'Deine Festschuhe quietschen bei jedem Schritt. Frage {ziel}, ob die Kasse neue bezahlt. Antworte danach mit einem Dank oder einem Gegenvorschlag.',
    'Ein Gast möchte mit Schokomünzen bezahlen. Frage {ziel}, ob das beim Fest erlaubt ist.',
    'Der goldene Löffel ist weg. Frage {ziel}, ob jemand versucht hat, ihn gegen Kleingeld zu tauschen.',
    'Im Geldsäckchen klappert nur ein Knopf. Bitte {ziel} um eine Erklärung.',
    'Das Geld reicht nur für Musik oder Nachtisch. Frage {ziel} nach einer Empfehlung. Schreibe zurück, wofür du dich entscheidest.',
    'Die frisch gewaschenen Münzen tropfen noch. Frage {ziel}, wo man sie zum Trocknen aufhängen darf.',
    'Die Musikanten wollen als Lohn Kuchen. Bitte {ziel} um ein Angebot in Kuchenstücken. Schreibe zurück, ob du es fair findest.'
  ],
  4: [
    'Der Festmantel ist nach der Wäsche puppengroß. Bitte {ziel} um Hilfe. Der König weiß noch nichts.',
    'Der Soßenfleck auf der Tischdecke sieht aus wie der König. Frage {ziel}, ob er wegmuss oder als Deko bleiben darf.',
    'Alle Königssocken sind plötzlich rosa. Bitte {ziel} um eine Ausrede. Schreibe zurück, ob du sie dem König erzählen würdest.',
    'Der goldene Löffel ist weg. Frage {ziel}, ob beim Waschen etwas Verdächtiges in einer Hosentasche war.',
    'Deine Festschürze steht vor lauter Stärke von allein. Frage {ziel}, wie du wieder hineinkommst.',
    'Die Servietten riechen nach Zwiebelsuppe. Bitte {ziel} um einen Rettungsvorschlag. Schreibe zurück, ob du ihn ausprobieren willst.',
    'Auf der Wäscheleine hängen nur linke Socken. Frage {ziel}, wohin die rechten verschwunden sind.',
    'Die Stinkestiefel des Königs dürfen nicht in den Festsaal. Bitte {ziel} um eine Idee. Schreibe zurück, ob du sie nimmst.'
  ],
  5: [
    'Du brauchst eine Festhose mit Geheimtasche für drei Brötchen. Frage {ziel}, ob das unauffällig geht.',
    'Die Schleppe des Königs ist länger als der Festsaal. Bitte {ziel} um eine Lösung, bei der niemand stolpert.',
    'Die goldenen Knöpfe sind alle weg. Bitte {ziel} um einen lustigen Ersatz. Schreibe zurück, ob du ihn annähen lässt.',
    'Deine Festmütze rutscht dir bis zum Kinn. Frage {ziel}, wie sie oben bleibt.',
    'Der goldene Löffel ist weg. Frage {ziel}, ob er versehentlich in ein Festgewand eingenäht wurde.',
    'Für deinen Umhang gibt es nur Rosa oder Erbsengrün. Frage {ziel} nach einer Empfehlung. Schreibe zurück, welche Farbe du nimmst.',
    'Die Festhose des Königs ist hinten gerissen. Bitte {ziel} um eine unauffällige Lösung. Schreibe zurück, ob du dem Plan vertraust.',
    'Du willst aus dem alten Thronvorhang ein Festgewand machen lassen. Bitte {ziel} mit einer kurzen Begründung darum.'
  ]
};
function shuffle(list) { const copy = [...list]; for (let i = copy.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [copy[i], copy[j]] = [copy[j], copy[i]]; } return copy; }
function onlineWorkers(session) { return [...session.participants.values()].filter(p => !p.isMediator && clients.has(p.id)); }
function mediatorOnline(session, router) { return [...session.participants.values()].some(p => p.isMediator && p.router === router && clients.has(p.id)); }
// Phase 1: Der Brief braucht eine Kette von online-Meistern. Phase 2: Beide Namensvermittler müssen online sein, den Weg übernimmt das Routing.
function reachable(session, from, to) {
  if (!mediatorOnline(session, from) || !mediatorOnline(session, to)) return false;
  if (session.settings.stage === 'addressed' || from === to) return true;
  const seen = new Set([from]); const queue = [from];
  while (queue.length) {
    const router = queue.shift();
    for (const [a, b] of links) {
      const next = a === router ? b : b === router ? a : null;
      if (next === null || seen.has(next) || !mediatorOnline(session, next)) continue;
      if (next === to) return true;
      seen.add(next); queue.push(next);
    }
  }
  return false;
}
function taskValid(session, p) {
  const target = p.task && session.participants.get(p.task.targetId);
  return Boolean(target && clients.has(target.id) && reachable(session, p.router, target.router));
}
function assignTask(session, p, avoidTargetId = null) {
  const load = id => onlineWorkers(session).filter(other => other.id !== p.id && other.task?.targetId === id).length;
  const candidates = onlineWorkers(session).filter(other => other.id !== p.id && reachable(session, p.router, other.router));
  if (!candidates.length) { p.task = null; return; }
  const ranked = shuffle(candidates).sort((a, b) => (a.id === avoidTargetId) - (b.id === avoidTargetId) || load(a.id) - load(b.id) || (a.router === p.router) - (b.router === p.router));
  const target = ranked[0];
  p.usedTasks = p.usedTasks || [];
  const fresh = taskTemplates[target.router].filter(text => !p.usedTasks.includes(text));
  const template = shuffle(fresh.length ? fresh : taskTemplates[target.router])[0];
  p.usedTasks = [...p.usedTasks, template].slice(-12);
  p.nextTaskAt = Date.now() + TASK_WAIT_MS;
  p.task = { targetId: target.id, text: template.replace('{ziel}', `${target.gender === 'male' ? 'den' : 'die'} ${target.name}`) };
}
// Ergänzt fehlende und ersetzt ungültig gewordene Aufträge (Ziel weg, Meister weg, Phasenwechsel).
function refreshTasks(session) { for (const p of onlineWorkers(session)) if (!taskValid(session, p)) assignTask(session, p); }
// Lehrerknopf: alle Aufträge gleichmäßig neu verteilen, z. B. wenn alle angemeldet sind.
function redistributeTasks(session) { const workers = shuffle(onlineWorkers(session)); workers.forEach(p => { p.task = null; }); workers.forEach(p => assignTask(session, p)); }

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
  if (session.settings.stage !== 'addressed') return participants;
  if (viewer.isMediator) return participants.filter(participant => participant.router === viewer.router || participant.isMediator);
  return participants.filter(participant => participant.router === viewer.router);
}
function publicMessage(session, message, viewer = null) {
  if (!message.classic) return message;
  const holder = session.participants.get(message.currentHolderId);
  const mayRead = !viewer || viewer.id === message.fromId || viewer.id === message.currentHolderId || message.history.some(step => step.participantId === viewer.id);
  return {
    ...message,
    text: mayRead ? message.text : '',
    noteFrom: mayRead ? message.noteFrom : '',
    noteTo: mayRead ? message.noteTo : '',
    holder: holder ? publicParticipant(holder) : null
  };
}
function sessionView(session, viewer = null) {
  const participantAddresses = viewer ? new Set([viewer.address]) : null;
  const currentMessages = session.messages.filter(message => message.stage === session.settings.stage);
  const messages = session.settings.stage === 'addressed'
    ? (viewer ? currentMessages.filter(message => participantAddresses.has(message.from) || participantAddresses.has(message.to)) : currentMessages)
    : currentMessages;
  return {
    code: session.code,
    createdAt: session.createdAt,
    participants: visibleParticipants(session, viewer).map(publicParticipant),
    messages: messages.slice(-100).map(message => publicMessage(session, message, viewer)),
    settings: session.settings,
    ...(viewer ? { myTask: viewer.task?.text || null, myTaskWait: Math.max(0, (viewer.nextTaskAt || 0) - Date.now()) } : { workersWithoutTask: onlineWorkers(session).filter(p => !p.task).length })
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
  const available = Array.from({ length: 101 }, (_, slot) => slot).filter(slot => !used.has(slot));
  if (!available.length) throw new Error('In diesem Raum ist keine Teilnehmernummer mehr frei.');
  const slot = available[crypto.randomInt(available.length)];
  return `${router}.${slot}`;
}
function removeParticipant(session, participant) {
  if (!session || !participant) return false;
  const current = session.participants.get(participant.id);
  if (current !== participant) return false;
  session.participants.delete(participant.id);
  clients.delete(participant.id);
  refreshTasks(session);
  broadcastState(session);
  return true;
}
function nextId() { return crypto.randomBytes(8).toString('hex'); }
function makeSession() {
  let code = makeCode(); while (sessions.has(code)) code = makeCode();
  const session = { code, createdAt: new Date().toISOString(), participants: new Map(), messages: [], teacher: null, settings: { stage: 'structured', phase: 'open', encoding: 'ascii', showBinary: false, showTasks: true, studentHost: '' } };
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
  return { isTeacherRequest: requestIsLocal(req), serverIp: selectedHost, serverIps: addresses, teacherUrl: baseUrl('localhost'), studentUrl, guideUrl: `${studentUrl}/anleitung`, port: activePort, session: requestIsLocal(req) ? sessionView(session) : pickerView(session), areas, links, roleForms };
}
function parseBody(req) {
  return new Promise((resolve, reject) => { let body = ''; req.on('data', chunk => { body += chunk; if (body.length > 10000) req.destroy(); }); req.on('end', () => { try { resolve(JSON.parse(body || '{}')); } catch { reject(new Error('Ungültige JSON-Daten')); } }); req.on('error', reject); });
}
function routeMessage(session, sender, data) {
  if (session.settings.phase === 'paused') return { error: 'Denkpause: Lies und beobachte. Senden ist nach der Freigabe wieder möglich.' };
  if (session.settings.stage !== 'addressed') return { error: 'Adressierte Nachrichten gibt es erst in Phase 2.' };
  const text = clean(data.text, 1200); const to = clean(data.to, 30);
  if (!text || !to) return { error: 'Bitte Zieladresse und Nachricht ausfüllen.' };
  const recipient = findParticipant(session, to);
  if (!recipient) return { error: `Die Adresse ${to} ist im Palastnetzwerk nicht angemeldet.` };
  if (!clients.has(recipient.id)) return { error: 'Das Ziel ist gerade offline. Warte auf die erneute Verbindung.' };
  const message = { id: nextId(), stage: 'addressed', from: sender.address, fromName: sender.name, to: recipient.address, toName: recipient.name, replyTo: clean(data.replyTo, 80) || null, text, sentAt: new Date().toISOString(), path: routePath(sender.router, recipient.router), encoding: data.encoding === 'binary' ? 'binary' : 'ascii' };
  session.messages.push(message); if (session.messages.length > 500) session.messages.shift();
  const recipientSocket = clients.get(recipient.id); if (recipientSocket) recipientSocket.send(JSON.stringify({ type: 'message', direction: 'received', message }));
  const senderSocket = clients.get(sender.id); if (senderSocket) senderSocket.send(JSON.stringify({ type: 'message', direction: 'sent', message }));
  if (session.teacher) session.teacher.send(JSON.stringify({ type: 'message', direction: 'monitor', message }));
  return { ok: true, message };
}

function localMediator(session, router) {
  return [...session.participants.values()].find(participant => participant.router === router && participant.isMediator);
}
function routersAreLinked(from, to) {
  return links.some(edge => edge.includes(from) && edge.includes(to));
}
function sendClassicMessage(session, sender, data) {
  if (session.settings.phase === 'paused') return { error: 'Denkpause: Lies und beobachte. Senden ist nach der Freigabe wieder möglich.' };
  const stage = session.settings.stage;
  if (stage !== 'structured') return { error: 'Briefe über die Meister gibt es nur in Phase 1.' };
  if (sender.isMediator) return { error: 'Meister vermitteln die Briefe. Neue Aufträge schreiben die Mitarbeitenden.' };
  const text = clean(data.text, 1200);
  const noteTo = clean(data.noteTo, 80);
  if (!text) return { error: 'Bitte schreibe etwas auf den Brief.' };
  if (!noteTo) return { error: 'Bitte trage einen Empfänger bei „An“ ein.' };
  const mediator = localMediator(session, sender.router);
  if (!mediator) return { error: `Der Meister in ${areas[sender.router].name} ist noch nicht im Netzwerk.` };
  if (!clients.has(mediator.id)) return { error: 'Dein Meister ist gerade offline. Warte auf die erneute Verbindung.' };
  const sentAt = new Date().toISOString();
  const message = {
    id: nextId(), classic: true, stage, fromId: sender.id, fromName: sender.name,
    noteFrom: sender.name, noteTo,
    text, currentHolderId: mediator.id, status: 'waiting', sentAt,
    history: [
      { participantId: sender.id, name: sender.name, router: sender.router, at: sentAt },
      { participantId: mediator.id, name: mediator.name, router: mediator.router, at: sentAt }
    ]
  };
  session.messages.push(message); if (session.messages.length > 500) session.messages.shift();
  broadcastState(session);
  return { ok: true, message };
}
function forwardClassicMessage(session, holder, data) {
  if (session.settings.phase === 'paused') return { error: 'Denkpause: Briefwege bleiben stehen. Nach der Freigabe kannst du weiterleiten.' };
  if (session.settings.stage !== 'structured') return { error: 'Manuelle Vermittlung gibt es nur in Phase 1.' };
  const message = session.messages.find(entry => entry.id === clean(data.messageId, 80) && entry.classic && entry.stage === session.settings.stage);
  if (!message) return { error: 'Der Brief wurde nicht gefunden.' };
  if (message.currentHolderId !== holder.id || message.status === 'delivered') return { error: 'Dieser Brief liegt nicht mehr bei dir.' };
  const target = session.participants.get(clean(data.targetId, 80));
  if (!target || !clients.has(target.id)) return { error: 'Das gewählte Ziel ist nicht mehr online.' };
  if (holder.isMediator) {
    const localPerson = target.router === holder.router && !target.isMediator;
    const linkedMediator = target.isMediator && target.router !== holder.router && routersAreLinked(holder.router, target.router);
    if (!localPerson && !linkedMediator) return { error: 'Du kannst nur an Personen in deinem Raum oder direkt verbundene Meister weiterleiten.' };
  } else {
    const mediator = localMediator(session, holder.router);
    if (!mediator || target.id !== mediator.id) return { error: 'Mitarbeitende können Briefe nur an ihren eigenen Meister weitergeben.' };
  }
  message.currentHolderId = target.id;
  message.status = target.isMediator ? 'waiting' : 'with-person';
  message.history.push({ participantId: target.id, name: target.name, router: target.router, at: new Date().toISOString() });
  broadcastState(session);
  return { ok: true, message };
}
function deliverClassicMessage(session, holder, data) {
  const message = session.messages.find(entry => entry.id === clean(data.messageId, 80) && entry.classic);
  if (!message || message.currentHolderId !== holder.id || holder.isMediator) return { error: 'Dieser Brief liegt nicht bei dir.' };
  message.status = 'delivered';
  broadcastState(session);
  return { ok: true, message };
}

function handleHttp(req, res) {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  if (req.method === 'GET' && url.pathname === '/api/info') return sendJson(res, 200, serverInfo(req));
  if (req.method === 'GET' && url.pathname === '/api/session/current') return sendJson(res, 200, pickerView(getCurrentSession()));
  if (req.method === 'GET' && url.pathname === '/api/areas') return sendJson(res, 200, { areas, links, roleForms });
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
    session.participants.set(participant.id, participant); ws.session = session; ws.participant = participant; clients.set(participant.id, ws); refreshTasks(session); ws.send(JSON.stringify({ type: 'joined', me: publicParticipant(participant), state: sessionView(session, participant), areas, links, roleForms })); broadcastState(session); return;
  }
  if (data.type === 'teacher') { const session = sessions.get(clean(data.code, 10).toUpperCase()); if (!session) return ws.send(JSON.stringify({ type: 'error', error: 'Raum nicht gefunden.' })); ws.session = session; session.teacher = ws; return ws.send(JSON.stringify({ type: 'teacher-ready', state: sessionView(session), areas, links, roleForms })); }
  const session = ws.session; if (!session) return ws.send(JSON.stringify({ type: 'error', error: 'Noch keinem Raum beigetreten.' }));
  if (data.type === 'participant-view' && session.teacher === ws) {
    const participant = session.participants.get(data.id);
    if (!participant) return ws.send(JSON.stringify({ type: 'error', error: 'Teilnehmender nicht gefunden.' }));
    return ws.send(JSON.stringify({ type: 'participant-view', participant: publicParticipant(participant), state: sessionView(session, participant), areas, links, roleForms }));
  }
  if (data.type === 'send' && ws.participant) { const result = routeMessage(session, ws.participant, data); if (result.error) ws.send(JSON.stringify({ type: 'error', error: result.error })); return; }
  if (data.type === 'send-classic' && ws.participant) { const result = sendClassicMessage(session, ws.participant, data); ws.send(JSON.stringify(result.error ? { type: 'error', error: result.error } : { type: 'action-ok', message: 'Brief an den Meister übergeben.' })); return; }
  if (data.type === 'forward-classic' && ws.participant) { const result = forwardClassicMessage(session, ws.participant, data); ws.send(JSON.stringify(result.error ? { type: 'error', error: result.error } : { type: 'action-ok', message: 'Brief weitergeleitet.' })); return; }
  if (data.type === 'deliver-classic' && ws.participant) { const result = deliverClassicMessage(session, ws.participant, data); ws.send(JSON.stringify(result.error ? { type: 'error', error: result.error } : { type: 'action-ok', message: 'Brief abgelegt.' })); return; }
  if (data.type === 'settings' && session.teacher === ws) { session.settings = { ...session.settings, stage: ['structured', 'addressed'].includes(data.stage) ? data.stage : session.settings.stage, phase: ['open', 'paused'].includes(data.phase) ? data.phase : session.settings.phase, encoding: data.encoding === undefined ? session.settings.encoding : data.encoding === 'binary' ? 'binary' : 'ascii', showBinary: data.showBinary === undefined ? session.settings.showBinary : data.showBinary === true, showTasks: data.showTasks === undefined ? session.settings.showTasks : data.showTasks === true, studentHost: data.studentHost === undefined ? session.settings.studentHost : clean(data.studentHost, 120) }; refreshTasks(session); broadcastState(session); return; }
  if (data.type === 'new-task' && ws.participant && !ws.participant.isMediator) { const wait = Math.ceil(((ws.participant.nextTaskAt || 0) - Date.now()) / 1000); if (wait > 0) return ws.send(JSON.stringify({ type: 'error', error: `Einen neuen Auftrag gibt es erst in ${wait} s. Bearbeite zuerst diesen.` })); assignTask(session, ws.participant, ws.participant.task?.targetId); broadcastState(session); return; }
  if (data.type === 'redistribute-tasks' && session.teacher === ws) { redistributeTasks(session); broadcastState(session); return ws.send(JSON.stringify({ type: 'action-ok', message: 'Aufträge neu verteilt.' })); }
  if (data.type === 'clear-log' && session.teacher === ws) { session.messages = []; broadcastState(session); return; }
  if (data.type === 'remove' && session.teacher === ws) { const p = session.participants.get(data.id); if (p) { const client = clients.get(p.id); if (client) { client.send(JSON.stringify({ type: 'error', error: 'Du wurdest aus dem Raum entfernt.' })); client.socket.end(); } session.participants.delete(p.id); clients.delete(p.id); refreshTasks(session); broadcastState(session); } }
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
