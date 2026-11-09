const $ = (selector) => document.querySelector(selector);
const esc = (value) => String(value ?? '').replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }[char]));

let pendingSend = null;
let taskReadyAt = 0, taskTimer = null;
const drafts = {};

let ws, info, areas = {}, links = [], roleForms = {}, me = null, state = null, mode = null, replyTargetId = null, viewedParticipantId = null, selectedGender = 'female';

function toast(message, error = false) {
  const element = $('#toast');
  element.textContent = message;
  element.className = `toast show ${error ? 'error' : ''}`;
  clearTimeout(toast.timer);
  toast.timer = setTimeout(() => element.className = 'toast', 3500);
}
function connection(online) {
  $('#connection').className = `connection ${online ? 'online' : ''}`;
  $('#connection').innerHTML = `<i></i> ${online ? 'verbunden' : 'nicht verbunden'}`;
}
async function api(url, options) {
  const response = await fetch(url, options);
  const data = await response.json();
  if (!response.ok) throw new Error(data.error || 'Fehler');
  return data;
}
function show(id) { ['landing', 'setup', 'student', 'teacher'].forEach(name => $(`#${name}`).classList.toggle('hidden', name !== id)); }
function openSocket() {
  if (ws && ws.readyState < 2) ws.close();
  ws = new WebSocket(`${location.protocol === 'https:' ? 'wss' : 'ws'}://${location.host}`);
  ws.onopen = () => connection(true);
  ws.onclose = () => { connection(false); pendingSend = null; if (mode === 'student') renderStudent(); };
  ws.onmessage = event => handle(JSON.parse(event.data));
}
function send(data) {
  if (!ws || ws.readyState !== WebSocket.OPEN) { toast('Verbindung zum Server fehlt. Dein Entwurf bleibt erhalten.', true); return false; }
  ws.send(JSON.stringify(data));
  return true;
}
function messageStorageKey(kind) { return `palastnetzwerk:${kind}:${state?.code || 'unknown'}:${me?.address || 'unknown'}`; }
function storedMessageIds(kind) {
  try { return new Set(JSON.parse(localStorage.getItem(messageStorageKey(kind)) || '[]')); } catch { return new Set(); }
}
function saveMessageIds(kind, ids) {
  try { localStorage.setItem(messageStorageKey(kind), JSON.stringify([...ids])); } catch { /* local storage can be unavailable */ }
}
function markMessageRead(messageId) {
  if (!messageId) return;
  const read = storedMessageIds('read');
  if (read.has(messageId)) return;
  read.add(messageId); saveMessageIds('read', read);
  const card = document.querySelector(`.student-messages [data-message-id="${messageId}"]`);
  if (card) { card.classList.remove('unread'); card.querySelector('.unread-badge')?.remove(); }
}
function handle(data) {
  if (data.type === 'error') { pendingSend = null; if (mode === 'student') renderStudent(); return toast(data.error, true); }
  if (data.type === 'action-ok') { if (data.message === 'Brief an den Meister übergeben.') finishSend(); return toast(data.message || 'Erledigt.'); }
  if (data.state?.myTaskWait != null) taskReadyAt = Date.now() + data.state.myTaskWait;
  if (data.type === 'joined') { me = data.me; state = data.state; areas = data.areas; links = data.links; roleForms = data.roleForms || roleForms; renderStudent(); return; }
  if (data.type === 'teacher-ready') { state = data.state; areas = data.areas; links = data.links; roleForms = data.roleForms || roleForms; renderTeacher(); return; }
  if (data.type === 'participant-view') { viewedParticipantId = data.participant.id; renderParticipantView(data); return; }
  if (data.type === 'state') { state = data.state; if (mode === 'student') renderStudent(); if (mode === 'teacher') { renderTeacher(); if (viewedParticipantId) send({ type: 'participant-view', id: viewedParticipantId }); } return; }
  if (data.type === 'message') {
    if (!state.messages.some(message => message.id === data.message.id)) state.messages.push(data.message);
    if (data.direction === 'sent') finishSend();
    if (mode === 'student') { renderStudent(); if (data.direction === 'received') toast(`Neue Nachricht von ${data.message.fromName}`); }
    if (mode === 'teacher') renderTeacher();
  }
}
function copyText(text) { navigator.clipboard?.writeText(text).then(() => toast('Link kopiert.')).catch(() => toast(text)); }
function configuredHost() { return info.serverIp || info.serverIps?.[0]?.address || ''; }
function hostOptions() {
  const selected = configuredHost();
  const candidates = (info.serverIps || []).map(item => item.address);
  const values = selected && !candidates.includes(selected) ? [selected, ...candidates] : candidates;
  return `<option value="" ${!info.serverIp ? 'selected' : ''}>Automatisch ermittelte Adresse</option>${values.map(value => `<option value="${esc(value)}" ${value === selected ? 'selected' : ''}>${esc(value)}${(info.serverIps || []).find(item => item.address === value)?.name ? ` · ${esc((info.serverIps || []).find(item => item.address === value).name)}` : ''}</option>`).join('')}`;
}
function cleanHost(value) { return String(value || '').trim().replace(/^https?:\/\//i, '').replace(/\/.*$/, '').replace(/\/$/, ''); }
function urlForHost(value) {
  const host = cleanHost(value); if (!host) return '';
  const hasPort = host.includes(':') && !host.startsWith('[');
  return `http://${host}${hasPort || info.port === 80 ? '' : `:${info.port}`}`;
}
function applyStudentHost(value) {
  const host = cleanHost(value);
  if (!host) {
    const automatic = info.serverIps?.[0]?.address || '127.0.0.1';
    info.serverIp = automatic; info.studentUrl = urlForHost(automatic); info.guideUrl = `${info.studentUrl}/anleitung`; send({ type: 'settings', studentHost: '' }); renderTeacher(); toast('Automatische Adresse wieder aktiviert.'); return;
  }
  const base = urlForHost(host); info.serverIp = host; info.studentUrl = base; info.guideUrl = `${base}/anleitung`; send({ type: 'settings', studentHost: host }); renderTeacher(); toast('Schüler-Link aktualisiert.');
}
function bootstrap() {
  api('/api/info').then(data => {
    info = data; areas = data.areas; links = data.links; roleForms = data.roleForms || {}; state = data.session;
    if (data.isTeacherRequest) teacherHome(data); else studentPicker(data);
  }).catch(error => toast(error.message, true));
}
function teacherHome(data) {
  mode = 'teacher';
  show('teacher');
  $('#teacher').innerHTML = `<div class="panel teacher-welcome"><div class="eyebrow">LEHRERANSICHT · AUTOMATISCH ERKANNT</div><h1>Palastnetzwerk<br><span>für deine Klasse</span></h1><p class="sub">Du bist über <b>localhost</b> verbunden. Die Schülergeräte öffnen den zweiten Link über das lokale Netzwerk.</p><div class="share-card"><div><label>Schüler-Link</label><a class="share-url" href="${esc(data.studentUrl)}" target="_blank">${esc(data.studentUrl)}</a></div><button class="button small" data-copy="${esc(data.studentUrl)}">Kopieren</button><div><label>Anleitung für Schüler</label><a class="share-url" href="${esc(data.guideUrl)}" target="_blank">${esc(data.guideUrl)}</a></div><button class="button small" data-copy="${esc(data.guideUrl)}">Kopieren</button></div><div class="form-actions"><button class="button primary" id="open-monitor">Monitor öffnen</button><button class="button" id="new-session">Neue Runde starten</button></div><p class="hint">Die aktuelle Runde bleibt beim Neuladen erhalten. Mit „Neue Runde“ werden alle Rollen und Nachrichten zurückgesetzt.</p></div>`;
  document.querySelectorAll('[data-copy]').forEach(button => button.onclick = () => copyText(button.dataset.copy));
  $('#open-monitor').onclick = () => connectTeacher(data.session.code);
  $('#new-session').onclick = async () => { try { const result = await api('/api/session', { method: 'POST' }); info = result.info; state = info.session; connectTeacher(state.code); } catch (error) { toast(error.message, true); } };
  connectTeacher(data.session.code);
}
function connectTeacher(code) {
  openSocket();
  ws.addEventListener('open', () => send({ type: 'teacher', code }), { once: true });
}
function roleEntries() {
  return Object.entries(areas).flatMap(([router, area]) => [{ router, area, role: area.mediator, mediator: true }, ...area.roles.map(role => ({ router, area, role, mediator: false }))]);
}
function roleLabel(role, gender = 'female') {
  return gender === 'male' ? role : roleForms[role] || role;
}
function studentPicker(data) {
  mode = 'picker';
  show('setup');
  const taken = new Set(data.session.participants.filter(participant => participant.online !== false).map(participant => participant.roleKey || participant.role));
  $('#setup').innerHTML = `<div class="panel picker-wrap"><div class="eyebrow">SCHÜLERSEITE · ${esc(data.serverIp)}</div><h1>Wähle deine Rolle.</h1><fieldset class="gender-picker"><legend>Rollenbezeichnung</legend><label><input type="radio" name="gender" value="female" ${selectedGender === 'female' ? 'checked' : ''}><span>Weibliche Form</span></label><label><input type="radio" name="gender" value="male" ${selectedGender === 'male' ? 'checked' : ''}><span>Männliche Form</span></label></fieldset><div class="role-picker">${roleEntries().map(entry => `<button class="role-card ${entry.mediator ? 'mediator' : ''}" data-router="${entry.router}" data-role="${esc(entry.role)}" ${taken.has(entry.role) ? 'disabled' : ''}><span class="role-area">Router ${entry.router} · ${esc(entry.area.name)}</span><strong>${esc(roleLabel(entry.role, selectedGender))}</strong><small>${entry.mediator ? (selectedGender === 'female' ? 'Namensvermittlerin' : 'Namensvermittler') : (selectedGender === 'female' ? 'Mitarbeiterin' : 'Mitarbeiter')}${taken.has(entry.role) ? ' · bereits belegt' : ''}</small></button>`).join('')}</div><div class="picker-footer"><span>${taken.size} von ${roleEntries().length} Rollen belegt</span><button class="button small" id="refresh-roles">Liste aktualisieren</button></div></div>`;
  $('#setup .eyebrow').textContent = `SCHÜLERSEITE · ${data.studentUrl || data.serverIp}`;
  document.querySelectorAll('input[name="gender"]').forEach(input => input.onchange = () => { selectedGender = input.value; studentPicker(data); });
  document.querySelectorAll('.role-card:not([disabled])').forEach(button => button.onclick = () => joinStudent(data.session.code, button.dataset.router, button.dataset.role, selectedGender));
  $('#refresh-roles').onclick = () => api('/api/session/current').then(current => studentPicker({ ...data, session: current }));
}
function joinStudent(code, router, role, gender) {
  openSocket();
  ws.addEventListener('open', () => send({ type: 'join', code, router, role, gender }), { once: true });
}
function topology() {
  const positions = { 1: [50, 50], 2: [18, 20], 3: [82, 20], 4: [18, 80], 5: [82, 80] };
  const edges = links.map(([from, to]) => `<line x1="${positions[from][0]}" y1="${positions[from][1]}" x2="${positions[to][0]}" y2="${positions[to][1]}" />`).join('');
  const nodes = Object.entries(areas).map(([id, area]) => `<div class="router-node" style="left:${positions[id][0]}%;top:${positions[id][1]}%" title="${esc(area.name)}"><div><b>${id}</b><span>${esc(area.name)}</span></div></div>`).join('');
  return `<div class="topology"><div class="topology-map"><svg class="topology-lines" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">${edges}</svg>${nodes}</div></div>`;
}
function participantList(showRemove = false) {
  if (!state.participants.length) return '<div class="empty">Noch niemand verbunden.</div>';
  return `<div class="participants">${state.participants.map(participant => `<div class="participant-row"><div class="avatar">${esc((participant.name || '?')[0].toUpperCase())}</div><div class="participant-main"><b>${esc(participant.name)} ${participant.isMediator ? '<span title="Namensvermittler">◆</span>' : ''}</b><span>Router ${participant.router} · ${esc(participant.role)}</span></div><span class="address">${esc(participant.address)}</span><i class="online-dot ${participant.online ? '' : 'offline'}"></i>${showRemove ? `<button class="button small danger remove" data-id="${participant.id}">×</button>` : ''}</div>`).join('')}</div>`;
}
function binaryText(value) {
  return [...new TextEncoder().encode(String(value ?? ''))].map(byte => byte.toString(2).padStart(8, '0')).join(' ');
}
function binaryAddress(value) {
  return String(value ?? '').split('.').map(part => Number(part).toString(2).padStart(4, '0')).join(' ');
}
function messageContent(message, showBinary = false) {
  return `<div class="message-content message-packet"><div class="message-line message-header"><b></b><b>An</b><b>Von</b><b>Nachricht</b></div><div class="message-line"><b>Lesbar</b><span class="packet-to">${esc(message.to)}</span><span class="packet-from">${esc(message.from)}</span><span class="packet-text">${esc(message.text)}</span></div>${showBinary ? `<div class="message-line binary-line"><b>Binär</b><code class="packet-to">${binaryAddress(message.to)}</code><code class="packet-from">${binaryAddress(message.from)}</code><code class="packet-text">${binaryText(message.text)}</code></div>` : ''}</div>`;
}
function messageList(messages = state.messages, showBinary = state?.settings?.showBinary) {
  if (!messages?.length) return '<div class="empty">Noch keine Nachrichten. Die Leitungen warten.</div>';
  return `<div class="messages">${[...messages].reverse().map(message => `<div class="message-card">${messageContent(message, showBinary)}<div class="message-meta"><span class="route">${message.path?.map(router => `R${router}`).join(' · ') || 'lokal'}</span></div></div>`).join('')}</div>`;
}
function studentMessageList(messages) {
  if (!messages?.length) return '<div class="empty">Noch keine Nachrichten. Die Leitungen warten.</div>';
  const read = storedMessageIds('read');
  const answered = new Set(messages.filter(message => message.from === me.address && message.replyTo).map(message => message.replyTo));
  const sortedMessages = [...messages].sort((a, b) => {
    const aUnread = a.to === me.address && !read.has(a.id);
    const bUnread = b.to === me.address && !read.has(b.id);
    if (aUnread !== bUnread) return aUnread ? -1 : 1;
    return new Date(b.sentAt).getTime() - new Date(a.sentAt).getTime();
  });
  return `<div class="messages student-messages">${sortedMessages.map(message => { const incoming = message.to === me.address; const unread = incoming && !read.has(message.id); const hasAnswer = incoming && answered.has(message.id); return `<div class="message-card ${incoming ? 'incoming' : 'outgoing'} ${unread ? 'unread' : ''}" data-message-id="${esc(message.id)}">${messageContent(message, state?.settings?.showBinary)}<div class="message-meta"><span class="route">${message.path?.map(router => `R${router}`).join(' · ') || 'lokal'}</span></div><div class="message-footer"><span class="message-badge ${incoming ? 'received-badge' : 'sent-badge'}">${incoming ? 'empfangen' : 'gesendet'}</span>${unread ? '<span class="message-badge unread-badge">ungelesen</span>' : ''}${hasAnswer ? '<span class="message-badge answered-badge">beantwortet</span>' : ''}${incoming ? `<button type="button" class="button small reply-message" data-message-id="${esc(message.id)}" data-address="${esc(message.from)}" data-name="${esc(message.fromName)}">Antworten</button>` : ''}</div></div>`; }).join('')}</div>`;
}
function stageInfo(stage = state?.settings?.stage) {
  return {
    structured: { number: '1', title: 'Netzwerkspiel', short: 'Klasse 6 · Meister leiten weiter' },
    addressed: { number: '2', title: 'Adressen', short: 'Klasse 8 · Namen, Adressen, Routing' }
  }[stage] || { number: '?', title: 'Spielphase', short: '' };
}
function participantById(id) { return state.participants.find(participant => participant.id === id); }
function classicMessages() { return state.messages.filter(message => message.classic); }
function holderMessages(participantId) { return classicMessages().filter(message => message.currentHolderId === participantId && message.status !== 'delivered'); }
function holderText(message) { return `${message.status === 'delivered' ? 'Angekommen bei' : 'Jetzt bei'} ${esc(message.holder?.name || 'unbekannt')}`; }
function classicNote(message, compact = false) {
  if (!message.text) return `<div class="classic-note hidden-note"><span>✉</span><p>Den Inhalt sehen nur die, die den Brief in der Hand hatten.</p></div>`;
  return `<div class="classic-note structured-note ${compact ? 'compact' : ''}"><div><b>Von</b><span>${esc(message.noteFrom || '—')}</span></div><div><b>An</b><span>${esc(message.noteTo || '—')}</span></div><div class="note-text"><b>Text</b><span>${esc(message.text)}</span></div></div>`;
}
function classicRoute(message) {
  return `<div class="letter-route">${message.history.map((step, index) => `<span class="route-step ${index === message.history.length - 1 ? 'current' : ''}">${esc(step.name)}</span>${index < message.history.length - 1 ? '<i>→</i>' : ''}`).join('')}</div>`;
}
function classicOverview() {
  const positions = { 1: [50, 50], 2: [18, 20], 3: [82, 20], 4: [18, 80], 5: [82, 80] };
  const edges = links.map(([from, to]) => `<line x1="${positions[from][0]}" y1="${positions[from][1]}" x2="${positions[to][0]}" y2="${positions[to][1]}" />`).join('');
  const nodes = Object.entries(areas).map(([id, area]) => {
    const mediator = state.participants.find(participant => participant.router === Number(id) && participant.isMediator);
    const waiting = mediator ? holderMessages(mediator.id).length : 0;
    return `<div class="router-node overview-node ${waiting ? 'has-mail' : ''}" style="left:${positions[id][0]}%;top:${positions[id][1]}%"><div><b>${waiting ? '✉' : id}</b><span>${esc(area.name)}</span>${waiting ? `<em>${waiting}</em>` : ''}</div></div>`;
  }).join('');
  const rooms = Object.entries(areas).map(([id, area]) => {
    const members = state.participants.filter(participant => participant.router === Number(id));
    return `<article class="overview-room" style="--room-color:${area.color}"><header><strong>${esc(area.name)}</strong></header><div class="overview-people">${members.map(participant => { const mail = holderMessages(participant.id).length; return `<span class="overview-person ${participant.isMediator ? 'mediator' : ''}">${participant.isMediator ? '◆' : '•'} ${esc(participant.name)}${mail ? `<b title="Briefe bei dieser Person">✉ ${mail}</b>` : ''}</span>`; }).join('') || '<span class="overview-empty">noch leer</span>'}</div></article>`;
  }).join('');
  return `<div class="classic-overview"><div class="topology overview-map"><div class="topology-map"><svg class="topology-lines" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">${edges}</svg>${nodes}</div></div><div class="overview-rooms">${rooms}</div></div>`;
}
function forwardingTargets(message) {
  const localPeople = state.participants.filter(participant => participant.router === me.router && !participant.isMediator && participant.id !== me.id && participant.online);
  const linkedRouters = new Set(links.filter(edge => edge.includes(me.router)).flat().filter(router => router !== me.router));
  const linkedMediators = state.participants.filter(participant => participant.isMediator && linkedRouters.has(participant.router) && participant.online);
  const button = (participant, kind) => `<button type="button" class="forward-target ${kind}" data-message-id="${esc(message.id)}" data-target-id="${esc(participant.id)}"><span>${kind === 'master' ? '◆' : '●'}</span><strong>${esc(participant.name)}</strong><small>${kind === 'master' ? areas[participant.router].name : 'dein Raum'}</small></button>`;
  return `<div class="forward-panel"><div><h4>In deinem Raum</h4><div class="forward-buttons">${localPeople.map(person => button(person, 'person')).join('') || '<span class="no-targets">niemand online</span>'}</div></div><div><h4>Nachbarmeister</h4><div class="forward-buttons">${linkedMediators.map(master => button(master, 'master')).join('') || '<span class="no-targets">niemand online</span>'}</div></div></div>`;
}
function classicInbox() {
  const inbox = holderMessages(me.id);
  if (!inbox.length) return `<div class="empty">${me.isMediator ? 'Gerade wartet kein Brief.' : 'Bei dir liegt kein Brief.'}</div>`;
  return `<div class="classic-inbox">${inbox.map(message => `<article class="inbox-letter">${classicNote(message)}${classicRoute(message)}${me.isMediator ? forwardingTargets(message) : `<div class="letter-actions"><button type="button" class="button primary reply-classic" data-message-id="${esc(message.id)}" data-from="${esc(message.noteFrom)}">Antworten</button><button type="button" class="button small deliver-classic" data-message-id="${esc(message.id)}">Ablegen</button><button type="button" class="button small return-master" data-message-id="${esc(message.id)}">Nicht für mich: zurück an Meister</button></div>`}</article>`).join('')}</div>`;
}
function classicActivity() {
  const relevant = classicMessages().filter(message => message.fromId === me.id || message.history.some(step => step.participantId === me.id));
  if (!relevant.length) return '<div class="empty">Noch keine Briefe.</div>';
  return `<div class="classic-activity">${[...relevant].reverse().map(message => `<article><div class="activity-head"><span>${message.currentHolderId === me.id && message.status !== 'delivered' ? 'Bei dir' : holderText(message)}</span><small>${message.history.length - 1} Schritte</small></div>${classicNote(message, true)}${classicRoute(message)}</article>`).join('')}</div>`;
}
function studentHead(extra = '') {
  const phase = stageInfo();
  const rule = state.settings.phase === 'paused' ? '<p class="play-status paused" role="status">⏸ Pause: Senden und Weiterleiten sind gerade gesperrt.</p>' : state.settings.phase === 'quiet' ? '<p class="play-status" role="status">🤫 Nicht reden, nur über das Netzwerk.</p>' : '';
  return `<div class="play-head"><div><span class="eyebrow">Phase ${phase.number} · ${esc(phase.title)}</span><h1>${esc(areas[me.router].name)} <span>/</span> ${esc(me.role)}</h1></div>${extra}</div>${rule}`;
}
function roleTask() {
  if (me.isMediator) return '';
  const task = state.myTask;
  return `<div class="play-task"><p><b>Auftrag:</b> ${task ? esc(task) : 'Gerade ist niemand erreichbar. Dein Auftrag kommt, sobald mehr Leute im Netz sind.'}</p>${task ? '<button type="button" class="button small" id="new-task">Neuer Auftrag</button>' : ''}</div>`;
}
function bindNewTask() {
  clearInterval(taskTimer);
  const button = $('#new-task'); if (!button) return;
  const update = () => { const left = Math.ceil((taskReadyAt - Date.now()) / 1000); button.disabled = left > 0; button.textContent = left > 0 ? `Neuer Auftrag (${left} s)` : 'Neuer Auftrag'; button.title = left > 0 ? 'Bearbeite zuerst deinen Auftrag.' : ''; if (left <= 0) clearInterval(taskTimer); };
  update(); taskTimer = setInterval(update, 1000);
  button.onclick = () => { send({ type: 'new-task' }); };
}
function renderClassicStudent() {
  const write = me.isMediator ? '' : `<section class="box play-write"><div class="box-head"><h2>Brief schreiben</h2><small>Von: ${esc(me.name)}</small></div><form id="classic-send-form" class="play-form">${roleTask()}<label>An<input id="classic-to" maxlength="80" placeholder="z. B. Rechner" autocomplete="off" required></label><label>Text<textarea id="classic-text" rows="3" maxlength="1200" placeholder="Deine Nachricht …" required></textarea></label><button class="button primary" type="submit">An meinen Meister geben</button></form></section>`;
  const inboxCount = holderMessages(me.id).length;
  if (inboxCount > (renderClassicStudent.lastCount ?? inboxCount)) toast(me.isMediator ? 'Ein Brief wartet auf dich.' : 'Ein Brief ist bei dir angekommen.');
  renderClassicStudent.lastCount = inboxCount;
  $('#student').innerHTML = `${studentHead()}<div class="play-grid classic ${inboxCount ? 'mail-first' : ''}">${write}<section class="box play-inbox ${inboxCount ? 'has-mail' : ''}"><div class="box-head"><h2>${me.isMediator ? 'Briefe weiterleiten' : 'Briefe bei dir'}</h2><small>${inboxCount} wartend</small></div>${classicInbox()}</section><section class="box play-net"><div class="box-head"><h2>Das Schlossnetz</h2><small>✉ = Brief wartet</small></div>${classicOverview()}</section><section class="box play-log"><div class="box-head"><h2>Deine Briefwege</h2></div>${classicActivity()}</section></div>`;
  bindNewTask();
  $('#classic-send-form')?.addEventListener('submit', event => { event.preventDefault(); submitMessage({ type: 'send-classic', noteTo: $('#classic-to').value, text: $('#classic-text').value }); });
  document.querySelectorAll('.forward-target').forEach(button => button.onclick = () => send({ type: 'forward-classic', messageId: button.dataset.messageId, targetId: button.dataset.targetId }));
  document.querySelectorAll('.deliver-classic').forEach(button => button.onclick = () => send({ type: 'deliver-classic', messageId: button.dataset.messageId }));
  document.querySelectorAll('.reply-classic').forEach(button => button.onclick = () => { $('#classic-to').value = button.dataset.from; send({ type: 'deliver-classic', messageId: button.dataset.messageId }); $('#classic-text').focus(); });
  document.querySelectorAll('.return-master').forEach(button => { const mediator = state.participants.find(participant => participant.router === me.router && participant.isMediator); button.disabled = !mediator?.online; button.onclick = () => mediator && send({ type: 'forward-classic', messageId: button.dataset.messageId, targetId: mediator.id }); });
}
function roomList() {
  const members = state.participants.filter(participant => participant.router === me.router).sort((a, b) => (b.isMediator - a.isMediator) || a.address.localeCompare(b.address, 'de', { numeric: true }));
  return `<ul class="room-list">${members.map(participant => `<li class="${participant.isMediator ? 'mediator' : ''} ${participant.id === me.id ? 'self' : ''}"><span>${participant.isMediator ? '◆' : '•'} ${esc(participant.name)}${participant.id === me.id ? ' (du)' : ''}</span><code>${esc(participant.address)}</code></li>`).join('')}</ul>`;
}
function mediatorList() {
  return `<section class="box play-masters"><div class="box-head"><h2>Andere Namensvermittler</h2></div><ul class="room-list">${Object.entries(areas).filter(([router]) => Number(router) !== me.router).map(([router, area]) => { const mediator = state.participants.find(participant => participant.router === Number(router) && participant.isMediator); return `<li class="mediator ${mediator?.online ? '' : 'offline'}"><span>◆ ${esc(mediator?.name || area.mediator)} · ${esc(area.name)}</span><code>${mediator?.online ? esc(mediator.address) : 'offline'}</code></li>`; }).join('')}</ul></section>`;
}
function renderStudentContent() {
  mode = 'student'; show('student');
  if (state.settings.stage !== 'addressed') return renderClassicStudent();
  const task = me.isMediator ? '<div class="play-task"><p><b>Auftrag:</b> Beantworte Adressanfragen. Für andere Räume fragst du dort den Namensvermittler.</p></div>' : roleTask();
  const mine = state.messages.filter(message => message.to === me.address || message.from === me.address);
  const read = storedMessageIds('read');
  const unread = mine.some(message => message.to === me.address && !read.has(message.id));
  $('#student').innerHTML = `${studentHead(`<div class="my-address"><small>Deine Adresse</small><b>${esc(me.address)}</b></div>`)}<div class="play-grid addressed ${unread ? 'mail-first' : ''}"><section class="box play-write"><div class="box-head"><h2>Nachricht senden</h2><small>Von: ${esc(me.address)}</small></div><form id="send-form" class="play-form">${task}<label>An (Adresse)<input id="to-address" placeholder="z. B. 3.2" autocomplete="off" required /></label><label>Nachricht<textarea id="message-text" rows="3" maxlength="1200" placeholder="Deine Nachricht …" required></textarea></label><p id="reply-context" class="reply-context ${replyTargetId ? '' : 'hidden'}">Du antwortest auf eine Nachricht.</p><button class="button primary" type="submit">Senden</button></form></section><div class="play-side"><section class="box play-room"><div class="box-head"><h2>Dein Raum</h2><small>Router ${me.router}</small></div>${roomList()}</section>${me.isMediator ? mediatorList() : ''}</div><section class="box play-log"><div class="box-head"><h2>Deine Nachrichten</h2><small>${mine.length}</small></div>${studentMessageList(mine)}</section></div>`;
  document.querySelectorAll('.reply-message').forEach(button => button.onclick = () => { markMessageRead(button.dataset.messageId); replyTargetId = button.dataset.messageId; $('#to-address').value = button.dataset.address; $('#reply-context').classList.remove('hidden'); $('#message-text').focus(); });
  document.querySelectorAll('.student-messages .incoming').forEach(card => card.onclick = event => { if (!event.target.closest('button')) markMessageRead(card.dataset.messageId); });
  bindNewTask();
  $('#send-form').onsubmit = event => { event.preventDefault(); submitMessage({ type: 'send', to: $('#to-address').value, text: $('#message-text').value, encoding: state.settings.encoding, replyTo: replyTargetId }); };
}
function readOnlyParticipantList(participants) {
  if (!participants.length) return '<div class="empty">Noch niemand verbunden.</div>';
  return `<div class="participants">${participants.map(participant => `<div class="participant-row"><div class="avatar">${esc((participant.name || '?')[0].toUpperCase())}</div><div class="participant-main"><b>${esc(participant.name)} ${participant.isMediator ? '<span title="Namensvermittler">◆</span>' : ''}</b><span>Router ${participant.router} · ${esc(participant.role)}</span></div><span class="address">${esc(participant.address)}</span><i class="online-dot ${participant.online ? '' : 'offline'}"></i></div>`).join('')}</div>`;
}
function participantLocalLanVisual(participant, viewState) {
  const area = areas[participant.router];
  const members = viewState.participants.filter(other => other.router === participant.router);
  return `<div class="local-lan-visual"><div class="local-router-node"><b>Router ${participant.router}</b><strong>${esc(area.name)}</strong><span>dein Raum</span></div><div class="local-lan-members">${members.map(other => `<div class="local-member ${other.isMediator ? 'mediator' : ''}"><span>${other.isMediator ? '◆' : '•'}</span><strong>${esc(other.name)}</strong><code>${esc(other.address)}</code></div>`).join('')}</div></div>`;
}
function closeParticipantView() {
  viewedParticipantId = null;
  $('#participant-screen-modal')?.remove();
}
function teacherStageControl() {
  const current = state.settings.stage;
  return `<section class="stage-control"><div><span class="eyebrow">SPIELABLAUF</span><strong>Zwei Phasen, gleiche Rollen</strong></div><div class="stage-buttons">${['structured', 'addressed'].map(stage => { const phase = stageInfo(stage); return `<button class="stage-button ${current === stage ? 'active' : ''}" data-stage="${stage}" aria-pressed="${current === stage}"><b>${phase.number}</b><span>${esc(phase.title)}</span><small>${esc(phase.short)}</small></button>`; }).join('')}</div></section>`;
}
function bindTeacherStageControl() {
  document.querySelectorAll('.stage-button').forEach(button => button.onclick = () => {
    if (button.dataset.stage === state.settings.stage) return;
    send({ type: 'settings', stage: button.dataset.stage });
    toast(`Phase ${stageInfo(button.dataset.stage).number} wird geöffnet.`);
  });
}
function teacherClassicLog() {
  const messages = classicMessages();
  if (!messages.length) return '<div class="empty">In dieser Phase wurden noch keine Briefe geschrieben.</div>';
  return `<div class="teacher-classic-log">${[...messages].reverse().map(message => `<article><div class="activity-head"><span>${holderText(message)}</span><small>${message.history.length - 1} Schritte</small></div>${classicNote(message, true)}${classicRoute(message)}</article>`).join('')}</div>`;
}
function renderClassicTeacher() {
  const phase = stageInfo();
  const online = state.participants.filter(participant => participant.online).length;
  const waiting = classicMessages().filter(message => participantById(message.currentHolderId)?.isMediator).length;
  $('#teacher').innerHTML = `<div class="workspace-head"><div><div class="eyebrow">LEHRERANSICHT · PHASE ${phase.number}</div><h1>Palastnetzwerk <span style="color:#a5b4b3">/</span> ${esc(phase.title)}</h1><p>Die Schülergeräte öffnen <a href="${esc(info.studentUrl)}" target="_blank">${esc(info.studentUrl)}</a>.</p></div><div class="workspace-head-actions"><a class="button small" href="${esc(info.guideUrl)}" target="_blank">Schüler-Anleitung</a><button class="button small" id="copy-student-link">Link kopieren</button><button class="button small" id="new-round">Neue Runde</button></div></div>${teacherStageControl()}<div class="teacher-link-box"><div><span class="eyebrow">LINK FÜR DIE KLASSE</span><strong>${esc(info.studentUrl)}</strong><small>Alle Geräte treten derselben Unterrichtsrunde bei.</small></div><button class="button primary" id="copy-student-link-2">Link kopieren</button></div><div class="box"><div class="box-head"><h2>Beobachtbare Netzaktivität</h2><small>Keine Route wird vorgegeben</small></div>${classicOverview()}<div class="stat-row"><div class="stat"><b>${online}</b><span>online</span></div><div class="stat"><b>${classicMessages().length}</b><span>Briefe</span></div><div class="stat"><b>${waiting}</b><span>bei Meistern</span></div></div></div><div class="teacher-grid" style="margin-top:20px"><div class="box"><div class="box-head"><h2>Teilnehmende</h2><small>${online} online</small></div>${participantList(true)}</div><div class="box"><div class="box-head"><h2>Briefwege dieser Phase</h2><small>${classicMessages().length} sichtbar</small></div>${teacherClassicLog()}</div></div>`;
  const linkEditor = document.querySelector('.teacher-link-box > div');
  linkEditor.insertAdjacentHTML('afterbegin', `<label>LAN-IP oder Rechnername<select id="student-host">${hostOptions()}</select></label>`);
  linkEditor.insertAdjacentHTML('beforeend', `<small>Automatisch gefunden: ${esc((info.serverIps || []).map(item => `${item.address} (${item.name})`).join(' · ') || 'keine LAN-Adresse')}</small>`);
  $('#copy-student-link-2').insertAdjacentHTML('beforebegin', '<button class="button" id="update-student-link">Aktualisieren</button>');
  bindTeacherStageControl();
  $('#copy-student-link').onclick = () => copyText(info.studentUrl);
  $('#copy-student-link-2').onclick = () => copyText(info.studentUrl);
  $('#update-student-link').onclick = () => applyStudentHost($('#student-host').value);
  $('#new-round').onclick = newRound;
  document.querySelectorAll('.remove').forEach(button => button.onclick = () => send({ type: 'remove', id: button.dataset.id }));
}
function renderParticipantView(data) {
  const participant = data.participant;
  const viewState = data.state;
  const area = areas[participant.router];
  const myTask = participant.isMediator ? 'Beantworte Adressanfragen und frage bei Bedarf in anderen Räumen nach.' : viewState.myTask || 'Noch kein Auftrag.';
  const previewLog = viewState.settings.stage === 'addressed' ? messageList(viewState.messages) : `<div class="teacher-classic-log">${viewState.messages.map(message => `<article>${classicNote(message)}${classicRoute(message)}</article>`).join('') || '<div class="empty">Noch keine Briefe.</div>'}</div>`;
  const phaseText = viewState.settings.phase === 'quiet' ? 'Ruhephase: Nachrichten werden nur über das Netzwerk ausgetauscht.' : viewState.settings.phase === 'paused' ? 'Die Simulation ist pausiert.' : 'Testphase: Verbinde dich und probiere das Netzwerk aus.';
  $('#participant-screen-modal')?.remove();
  document.body.insertAdjacentHTML('beforeend', `<div class="participant-screen-modal" id="participant-screen-modal"><div class="participant-screen-backdrop"></div><section class="participant-screen-dialog" role="dialog" aria-modal="true" aria-labelledby="participant-screen-title"><div class="participant-screen-head"><div><div class="eyebrow">SCHÜLERANSICHT · NUR LESEN</div><h2 id="participant-screen-title">${esc(area.name)} <span>/</span> ${esc(participant.role)}</h2><p>${esc(participant.name)} · Adresse <span class="room-chip" style="padding:3px 7px;font-size:11px">${esc(participant.address)}</span></p></div><button class="button small" id="close-participant-screen">Schließen</button></div><div class="participant-screen-content"><div class="participant-screen-grid"><div><div class="box"><div class="box-head"><h2>Dein Raum</h2><small>Router ${participant.router} · ${esc(area.name)}</small></div>${participantLocalLanVisual(participant, viewState)}<div class="phase">${phaseText}</div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Deine Aufgabe</h2><small>Rollenkarte</small></div><div style="padding:18px;font-size:14px;line-height:1.6">${esc(myTask)}</div></div></div><div class="box"><div class="box-head"><h2>Teilnehmende</h2><small>${viewState.participants.length} sichtbar</small></div>${readOnlyParticipantList(viewState.participants)}</div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Nachrichtenlog</h2><small>${viewState.messages.length} Nachrichten</small></div>${previewLog}</div></div></section></div>`);
  $('#close-participant-screen').onclick = closeParticipantView;
  $('.participant-screen-backdrop').onclick = closeParticipantView;
}
function renderTeacherContent() {
  mode = 'teacher'; show('teacher');
  if (state.settings.stage !== 'addressed') return renderClassicTeacher();
  const online = state.participants.filter(participant => participant.online).length;
  $('#teacher').innerHTML = `<div class="workspace-head"><div><div class="eyebrow">LEHRERANSICHT · LIVE-MONITOR</div><h1>Palastnetzwerk <span style="color:#a5b4b3">/</span> Unterrichtsrunde</h1><p>Die Schülergeräte öffnen <a href="${esc(info.studentUrl)}" target="_blank">${esc(info.studentUrl)}</a>.</p></div><div class="workspace-head-actions"><a class="button small" href="${esc(info.guideUrl)}" target="_blank">Schüler-Anleitung</a><button class="button small" id="copy-student-link">Link kopieren</button><button class="button small" id="new-round">Neue Runde</button></div></div><div class="teacher-link-box"><div><span class="eyebrow">LINK FÜR DIE KLASSE</span><strong>${esc(info.studentUrl)}</strong><small>Keine Eingabe eines Raumcodes erforderlich.</small></div><button class="button primary" id="copy-student-link-2">Link kopieren</button></div><div class="teacher-grid"><div><div class="box"><div class="box-head"><h2>Netzwerk-Topologie</h2><small>5 Router · 5 Verbindungen</small></div>${topology()}<div class="stat-row"><div class="stat"><b>${online}</b><span>online</span></div><div class="stat"><b>${state.participants.length}</b><span>rollen</span></div><div class="stat"><b>${state.messages.length}</b><span>nachrichten</span></div></div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Nachrichtenanzeige</h2><small>Lehrersteuerung</small></div><div class="control-grid"><label class="binary-toggle"><input type="checkbox" id="show-binary" ${state.settings.showBinary ? 'checked' : ''}> Binärdarstellung anzeigen</label></div></div></div><div><div class="box"><div class="box-head"><h2>Teilnehmende</h2><small>${online} online</small></div>${participantList(true)}</div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Live-Nachrichtenlog</h2><small>Lehreransicht</small></div>${messageList()}</div></div></div>`;
  const linkEditor = document.querySelector('.teacher-link-box > div');
  $('#teacher .workspace-head').insertAdjacentHTML('afterend', teacherStageControl());
  bindTeacherStageControl();
  linkEditor.insertAdjacentHTML('afterbegin', `<label>LAN-IP oder Rechnername<select id="student-host">${hostOptions()}</select></label>`);
  linkEditor.insertAdjacentHTML('beforeend', `<small>Automatisch gefunden: ${esc((info.serverIps || []).map(item => `${item.address} (${item.name})`).join(' · ') || 'keine LAN-Adresse')}</small>`);
  document.querySelector('#copy-student-link-2').insertAdjacentHTML('beforebegin', '<button class="button" id="update-student-link">Aktualisieren</button>');
  $('#copy-student-link').onclick = () => copyText(info.studentUrl); $('#copy-student-link-2').onclick = () => copyText(info.studentUrl); $('#update-student-link').onclick = () => applyStudentHost($('#student-host').value); $('#new-round').onclick = newRound; document.querySelectorAll('.remove').forEach(button => button.onclick = () => send({ type: 'remove', id: button.dataset.id }));
  document.querySelectorAll('#teacher .participant-row').forEach((row, index) => { row.classList.add('participant-selectable'); row.title = 'Bildschirm dieses Teilnehmenden ansehen'; row.onclick = event => { if (event.target.closest('.remove')) return; const participant = state.participants[index]; if (participant) send({ type: 'participant-view', id: participant.id }); }; });
  $('#show-binary').onchange = () => send({ type: 'settings', showBinary: $('#show-binary').checked });
}
async function newRound() { if (!confirm('Neue Runde starten? Alle Rollen und Nachrichten der aktuellen Runde werden zurückgesetzt.')) return; try { closeParticipantView(); const result = await api('/api/session', { method: 'POST' }); info = result.info; state = info.session; connectTeacher(state.code); } catch (error) { toast(error.message, true); } }

function captureView(root) {
  const active = document.activeElement;
  return {
    fields: Object.fromEntries([...root.querySelectorAll('input[id]:not([type="checkbox"]), textarea[id], select[id]')].map(field => [field.id, field.value])),
    opened: [...root.querySelectorAll('details[open][data-learning]')].map(detail => detail.dataset.learning),
    focus: root.contains(active) ? active.id : null,
    start: active?.selectionStart,
    end: active?.selectionEnd
  };
}
function restoreView(root, view) {
  for (const [id, value] of Object.entries(view.fields || {})) {
    const field = document.getElementById(id);
    if (field && root.contains(field)) field.value = value;
  }
  root.querySelectorAll('details[data-learning]').forEach(detail => { detail.open = (view.opened || []).includes(detail.dataset.learning); });
  const field = document.getElementById(view.focus);
  if (field && root.contains(field)) {
    field.focus({ preventScroll: true });
    if (view.start != null && typeof field.setSelectionRange === 'function') {
      try { field.setSelectionRange(view.start, view.end); } catch { /* select inputs have no text selection */ }
    }
  }
}
function submitMessage(data) {
  if (pendingSend) return;
  if (send(data)) {
    pendingSend = { ...data, stage: state.settings.stage };
    $('#student form button[type="submit"]').disabled = true;
  }
}
function finishSend() {
  if (!pendingSend) return;
  const sent = pendingSend;
  pendingSend = null;
  const textId = sent.stage === 'addressed' ? 'message-text' : 'classic-text';
  if (drafts[sent.stage]?.fields[textId] === sent.text) drafts[sent.stage].fields[textId] = '';
  const field = document.getElementById(textId);
  if (state.settings.stage === sent.stage && field?.value === sent.text) {
    field.value = '';
    const to = document.getElementById(sent.stage === 'addressed' ? 'to-address' : 'classic-to');
    if (to) to.value = '';
    if (drafts[sent.stage]?.fields) drafts[sent.stage].fields[to?.id] = '';
  }
  if (sent.stage === 'addressed') replyTargetId = null;
  if (mode === 'student') renderStudent();
}
function renderStudent() {
  const root = $('#student');
  const previousStage = root.dataset.stage;
  if (previousStage) drafts[previousStage] = captureView(root);
  renderStudentContent();
  root.dataset.stage = state.settings.stage;
  const phase = state.settings.phase;
  restoreView(root, drafts[state.settings.stage] || {});
  root.querySelectorAll('form button[type="submit"]').forEach(button => { button.disabled = phase === 'paused' || Boolean(pendingSend); });
  if (phase === 'paused') root.querySelectorAll('.forward-target, .return-master').forEach(button => { button.disabled = true; });
}
function readinessNotes() {
  const online = state.participants.filter(participant => participant.online);
  const missingMasters = Object.entries(areas).filter(([router]) => online.some(participant => participant.router === Number(router)) && !online.some(participant => participant.router === Number(router) && participant.isMediator)).map(([, area]) => area.name);
  const waiting = state.workersWithoutTask || 0;
  return `<ul class="readiness"><li>${missingMasters.length ? `Ohne Meister: ${esc(missingMasters.join(', '))}. Mitarbeitende dort sind nicht erreichbar und bekommen keinen Auftrag.` : 'Jeder besetzte Bereich hat einen Meister.'}</li><li>${waiting ? `${waiting} Mitarbeitende warten noch auf einen Auftrag, weil niemand für sie erreichbar ist.` : 'Alle Mitarbeitenden haben einen Auftrag mit erreichbarem Empfänger.'}</li><li>Die Aufträge entstehen automatisch aus den angemeldeten Rollen. Wenn alle angemeldet sind, einmal „Aufträge neu verteilen“ drücken, damit die Empfänger gleichmäßig verteilt sind.</li></ul>`;
}
function renderTeacher() {
  const root = $('#teacher');
  const view = captureView(root);
  renderTeacherContent();
  const impulse = state.settings.stage === 'addressed' ? 'Wie wurde aus dem Namen eine Adresse (Namensvermittlung)? Wie kam die Nachricht danach ans Ziel (Routing)? Modellgrenze: Adressen wie 2.3 sind keine echten IP-Adressen, Briefe werden nicht in Pakete geteilt.' : 'Welche Angaben braucht ein Meister, um einen Brief weiterzuleiten? Wo entstehen Umwege oder Wartezeiten? Was fehlt noch, damit jeder Brief sicher ankommt?';
  root.querySelector('.stage-control').insertAdjacentHTML('afterend', `<div class="lesson-controls" aria-label="Kommunikationsregel">${[['open', 'Reden erlaubt'], ['quiet', 'Nur im Netzwerk'], ['paused', 'Pause']].map(([phase, label]) => `<button class="button ${phase === state.settings.phase ? 'active' : ''}" data-phase="${phase}" aria-pressed="${phase === state.settings.phase}">${label}</button>`).join('')}<button class="button" id="redistribute-tasks">Aufträge neu verteilen</button></div><details class="teacher-notes" data-learning="teacher"><summary>Unterrichtshilfe</summary><p>Rahmengeschichte zum Vorlesen: Heute Abend feiert der König Geburtstag, alle bereiten das Fest vor. Und irgendwo im Schloss ist sein goldener Löffel verschwunden … Einige Aufträge fragen danach; am Ende kann die Klasse sammeln, wo er überall gesucht wurde.</p><p>Gesprächsimpuls: ${esc(impulse)}</p>${readinessNotes()}</details>`);
  $('#redistribute-tasks').onclick = () => { if (confirm('Alle Aufträge neu verteilen? Angefangene Aufträge werden ersetzt.')) send({ type: 'redistribute-tasks' }); };
  if (state.settings.showBinary) root.insertAdjacentHTML('beforeend', '<p class="encoding-note">Binär-Zusatz: Der Text wird in UTF-8 codiert, nicht allgemein in ASCII. Modelladressen sind keine echten IP-Adressen.</p>');
  root.querySelectorAll('[data-phase]').forEach(button => { button.onclick = () => send({ type: 'settings', phase: button.dataset.phase }); });
  restoreView(root, view);
}

bootstrap();
