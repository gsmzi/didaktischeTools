const $ = (selector) => document.querySelector(selector);
const esc = (value) => String(value ?? '').replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }[char]));

let ws, info, areas = {}, links = [], tasks = {}, roleForms = {}, me = null, state = null, mode = null, replyTargetId = null, viewedParticipantId = null, selectedGender = 'female';

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
  ws.onclose = () => connection(false);
  ws.onmessage = event => handle(JSON.parse(event.data));
}
function send(data) {
  if (!ws || ws.readyState !== WebSocket.OPEN) return toast('Verbindung zum Server fehlt.', true);
  ws.send(JSON.stringify(data));
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
  if (data.type === 'error') return toast(data.error, true);
  if (data.type === 'joined') { me = data.me; state = data.state; areas = data.areas; links = data.links; tasks = data.tasks; roleForms = data.roleForms || roleForms; renderStudent(); return; }
  if (data.type === 'teacher-ready') { state = data.state; areas = data.areas; links = data.links; tasks = data.tasks; roleForms = data.roleForms || roleForms; renderTeacher(); return; }
  if (data.type === 'participant-view') { viewedParticipantId = data.participant.id; renderParticipantView(data); return; }
  if (data.type === 'state') { state = data.state; if (mode === 'student') renderStudent(); if (mode === 'teacher') { renderTeacher(); if (viewedParticipantId) send({ type: 'participant-view', id: viewedParticipantId }); } return; }
  if (data.type === 'message') {
    state.messages.push(data.message);
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
    info = data; areas = data.areas; links = data.links; tasks = data.tasks; roleForms = data.roleForms || {}; state = data.session;
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
  $('#setup').innerHTML = `<div class="panel picker-wrap"><div class="eyebrow">SCHÜLERSEITE · ${esc(data.serverIp)}</div><h1>Wähle deine Rolle.</h1><p class="sub">Wähle zuerst das Geschlecht für die Rollenform und klicke dann auf deine Rollenkarte.</p><fieldset class="gender-picker"><legend>Geschlecht</legend><label><input type="radio" name="gender" value="female" ${selectedGender === 'female' ? 'checked' : ''}><span>Weiblich</span></label><label><input type="radio" name="gender" value="male" ${selectedGender === 'male' ? 'checked' : ''}><span>Männlich</span></label></fieldset><div class="role-picker">${roleEntries().map(entry => `<button class="role-card ${entry.mediator ? 'mediator' : ''}" data-router="${entry.router}" data-role="${esc(entry.role)}" ${taken.has(entry.role) ? 'disabled' : ''}><span class="role-area">Router ${entry.router} · ${esc(entry.area.name)}</span><strong>${esc(roleLabel(entry.role, selectedGender))}</strong><small>${entry.mediator ? (selectedGender === 'female' ? 'Namensvermittlerin' : 'Namensvermittler') : (selectedGender === 'female' ? 'Mitarbeiterin' : 'Mitarbeiter')}${taken.has(entry.role) ? ' · bereits belegt' : ''}</small></button>`).join('')}</div><div class="picker-footer"><span>${taken.size} von 30 Rollen belegt</span><button class="button small" id="refresh-roles">Liste aktualisieren</button></div></div>`;
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
function mediatorRoster() {
  return `<div class="box mediator-box"><div class="box-head"><h2>Namensvermittler anderer Räume</h2><small>Meister · live</small></div><div class="mediator-grid">${Object.entries(areas).map(([router, area]) => { const mediator = state.participants.find(participant => participant.router === Number(router) && participant.isMediator); return `<div class="mediator-card ${mediator?.online ? 'online' : ''}"><span class="mediator-area">Router ${router} · ${esc(area.name)}</span><strong>${esc(area.mediator)} <em>(Namensvermittler)</em></strong><span class="mediator-state">${mediator?.online ? `● online · ${esc(mediator.address)}` : '○ wartet auf Beitritt'}</span></div>`; }).join('')}</div></div>`;
}
function localLanVisual() {
  const area = areas[me.router];
  const members = state.participants.filter(participant => participant.router === me.router);
  return `<div class="local-lan-visual"><div class="local-router-node"><b>Router ${me.router}</b><strong>${esc(area.name)}</strong><span>dein Raum</span></div><div class="local-lan-members">${members.map(participant => `<div class="local-member ${participant.isMediator ? 'mediator' : ''}"><span>${participant.isMediator ? '◆' : '•'}</span><strong>${esc(participant.name)}</strong><code>${esc(participant.address)}</code></div>`).join('')}</div></div>`;
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
  return `<div class="message-content message-packet"><div class="message-line message-header"><b></b><b>An</b><b>Von</b><b>Nachricht</b></div><div class="message-line"><b>ASCII</b><span class="packet-to">${esc(message.to)}</span><span class="packet-from">${esc(message.from)}</span><span class="packet-text">${esc(message.text)}</span></div>${showBinary ? `<div class="message-line binary-line"><b>Binär</b><code class="packet-to">${binaryAddress(message.to)}</code><code class="packet-from">${binaryAddress(message.from)}</code><code class="packet-text">${binaryText(message.text)}</code></div>` : ''}</div>`;
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
function renderStudent() {
  mode = 'student'; show('student');
  const myTask = tasks[me.roleKey || me.role] || 'Warte auf eine Nachricht oder frage den Namensvermittler nach einer Adresse.';
  $('#student').innerHTML = `<div class="workspace-head"><div><div class="eyebrow">DEIN PALASTNETZWERK · ROUTER ${me.router}</div><h1>${esc(areas[me.router].name)} <span style="color:#a5b4b3">/</span> ${esc(me.role)}</h1><p>Deine Adresse lautet <span class="room-chip" style="padding:3px 7px;font-size:11px">${esc(me.address)}</span></p></div><div class="workspace-head-actions"><a class="button small" href="/anleitung" target="_blank">Anleitung</a></div></div><div class="workspace-grid"><div><div class="box"><div class="box-head"><h2>Netzwerkübersicht</h2><small>Dein Router ist verbunden</small></div>${topology()}<div class="phase ${state.settings.phase === 'quiet' ? 'quiet' : ''}">${state.settings.phase === 'quiet' ? '🤫 Ruhephase: Nachrichten werden nur über das Netzwerk ausgetauscht.' : state.settings.phase === 'paused' ? '⏸ Die Simulation ist pausiert.' : '● Testphase: Verbinde dich und probiere das Netzwerk aus.'}</div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Deine Aufgabe</h2><small>Rollenkarte</small></div><div style="padding:18px;font-size:14px;line-height:1.6">${esc(myTask)}</div></div></div><div><div class="box"><div class="box-head"><h2>Router ${me.router} · ${esc(areas[me.router].name)}</h2><small>${state.participants.filter(participant => participant.router === me.router).length} verbunden</small></div>${participantList()}</div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Nachricht senden</h2><small>Adressiert</small></div><div class="send-box"><form id="send-form"><div class="send-grid"><label>An <input id="to-address" placeholder="z. B. 3.2" required /></label><label>Nachricht <textarea id="message-text" rows="2" maxlength="1200" placeholder="Schreibe deine Nachricht ..." required></textarea></label><button class="button primary" type="submit">Senden</button></div><p id="reply-context" class="reply-context hidden"></p><p class="hint">Tipp: Frage den Namensvermittler nach der Adresse.</p></form></div></div></div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Dein Nachrichtenlog</h2><small>${state.messages.length} Nachrichten im Raum</small></div>${studentMessageList(state.messages.filter(message => message.to === me.address || message.from === me.address))}</div>`;
  const localBox = $('#student .workspace-grid > div > .box');
  localBox.querySelector('.box-head h2').textContent = 'Dein Raum';
  localBox.querySelector('.box-head small').textContent = `Router ${me.router} · ${areas[me.router].name}`;
  localBox.querySelector('.topology').outerHTML = localLanVisual();
  localBox.querySelector('.phase')?.remove();
  const messageBox = $('#send-form').closest('.box');
  messageBox.classList.add('student-message-box');
  $('#student .workspace-grid').appendChild(messageBox);
  if (me.isMediator) $('#student .workspace-head').insertAdjacentHTML('afterend', mediatorRoster());
  document.querySelectorAll('.reply-message').forEach(button => button.onclick = () => { markMessageRead(button.dataset.messageId); replyTargetId = button.dataset.messageId; $('#to-address').value = button.dataset.address; $('#reply-context').textContent = `Antwort an ${button.dataset.name || button.dataset.address} wird vorbereitet.`; $('#reply-context').classList.remove('hidden'); $('#message-text').focus(); });
  document.querySelectorAll('.student-messages .incoming').forEach(card => card.onclick = event => { if (!event.target.closest('button')) markMessageRead(card.dataset.messageId); });
  $('#send-form').onsubmit = event => { event.preventDefault(); send({ type: 'send', to: $('#to-address').value, text: $('#message-text').value, encoding: state.settings.encoding, replyTo: replyTargetId }); $('#message-text').value = ''; replyTargetId = null; $('#reply-context').classList.add('hidden'); };
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
function renderParticipantView(data) {
  const participant = data.participant;
  const viewState = data.state;
  const area = areas[participant.router];
  const myTask = tasks[participant.roleKey || participant.role] || 'Warte auf eine Nachricht oder frage den Namensvermittler nach einer Adresse.';
  const phaseText = viewState.settings.phase === 'quiet' ? 'Ruhephase: Nachrichten werden nur über das Netzwerk ausgetauscht.' : viewState.settings.phase === 'paused' ? 'Die Simulation ist pausiert.' : 'Testphase: Verbinde dich und probiere das Netzwerk aus.';
  $('#participant-screen-modal')?.remove();
  document.body.insertAdjacentHTML('beforeend', `<div class="participant-screen-modal" id="participant-screen-modal"><div class="participant-screen-backdrop"></div><section class="participant-screen-dialog" role="dialog" aria-modal="true" aria-labelledby="participant-screen-title"><div class="participant-screen-head"><div><div class="eyebrow">SCHÜLERANSICHT · NUR LESEN</div><h2 id="participant-screen-title">${esc(area.name)} <span>/</span> ${esc(participant.role)}</h2><p>${esc(participant.name)} · Adresse <span class="room-chip" style="padding:3px 7px;font-size:11px">${esc(participant.address)}</span></p></div><button class="button small" id="close-participant-screen">Schließen</button></div><div class="participant-screen-content"><div class="participant-screen-grid"><div><div class="box"><div class="box-head"><h2>Dein Raum</h2><small>Router ${participant.router} · ${esc(area.name)}</small></div>${participantLocalLanVisual(participant, viewState)}<div class="phase">${phaseText}</div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Deine Aufgabe</h2><small>Rollenkarte</small></div><div style="padding:18px;font-size:14px;line-height:1.6">${esc(myTask)}</div></div></div><div class="box"><div class="box-head"><h2>Teilnehmende</h2><small>${viewState.participants.length} sichtbar</small></div>${readOnlyParticipantList(viewState.participants)}</div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Nachrichtenlog</h2><small>${viewState.messages.length} Nachrichten</small></div>${messageList(viewState.messages)}</div></div></section></div>`);
  $('#close-participant-screen').onclick = closeParticipantView;
  $('.participant-screen-backdrop').onclick = closeParticipantView;
}
function renderTeacher() {
  mode = 'teacher'; show('teacher');
  const online = state.participants.filter(participant => participant.online).length;
  $('#teacher').innerHTML = `<div class="workspace-head"><div><div class="eyebrow">LEHRERANSICHT · LIVE-MONITOR</div><h1>Palastnetzwerk <span style="color:#a5b4b3">/</span> Unterrichtsrunde</h1><p>Die Schülergeräte öffnen <a href="${esc(info.studentUrl)}" target="_blank">${esc(info.studentUrl)}</a>.</p></div><div class="workspace-head-actions"><a class="button small" href="${esc(info.guideUrl)}" target="_blank">Schüler-Anleitung</a><button class="button small" id="copy-student-link">Link kopieren</button><button class="button small" id="new-round">Neue Runde</button></div></div><div class="teacher-link-box"><div><span class="eyebrow">LINK FÜR DIE KLASSE</span><strong>${esc(info.studentUrl)}</strong><small>Keine Eingabe eines Raumcodes erforderlich.</small></div><button class="button primary" id="copy-student-link-2">Link kopieren</button></div><div class="teacher-grid"><div><div class="box"><div class="box-head"><h2>Netzwerk-Topologie</h2><small>5 Router · 5 Verbindungen</small></div>${topology()}<div class="stat-row"><div class="stat"><b>${online}</b><span>online</span></div><div class="stat"><b>${state.participants.length}</b><span>rollen</span></div><div class="stat"><b>${state.messages.length}</b><span>nachrichten</span></div></div></div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Nachrichtenanzeige</h2><small>Lehrersteuerung</small></div><div class="control-grid"><label class="binary-toggle"><input type="checkbox" id="show-binary" ${state.settings.showBinary ? 'checked' : ''}> Binärdarstellung anzeigen</label></div></div></div><div><div class="box"><div class="box-head"><h2>Teilnehmende</h2><small>${online} online</small></div>${participantList(true)}</div><div class="box" style="margin-top:20px"><div class="box-head"><h2>Live-Nachrichtenlog</h2><small>Lehreransicht</small></div>${messageList()}</div></div></div>`;
  const linkEditor = document.querySelector('.teacher-link-box > div');
  linkEditor.insertAdjacentHTML('afterbegin', `<label>LAN-IP oder Rechnername<select id="student-host">${hostOptions()}</select></label>`);
  linkEditor.insertAdjacentHTML('beforeend', `<small>Automatisch gefunden: ${esc((info.serverIps || []).map(item => `${item.address} (${item.name})`).join(' · ') || 'keine LAN-Adresse')}</small>`);
  document.querySelector('#copy-student-link-2').insertAdjacentHTML('beforebegin', '<button class="button" id="update-student-link">Aktualisieren</button>');
  $('#copy-student-link').onclick = () => copyText(info.studentUrl); $('#copy-student-link-2').onclick = () => copyText(info.studentUrl); $('#update-student-link').onclick = () => applyStudentHost($('#student-host').value); $('#new-round').onclick = newRound; document.querySelectorAll('.remove').forEach(button => button.onclick = () => send({ type: 'remove', id: button.dataset.id }));
  document.querySelectorAll('#teacher .participant-row').forEach((row, index) => { row.classList.add('participant-selectable'); row.title = 'Bildschirm dieses Teilnehmenden ansehen'; row.onclick = event => { if (event.target.closest('.remove')) return; const participant = state.participants[index]; if (participant) send({ type: 'participant-view', id: participant.id }); }; });
  $('#show-binary').onchange = () => send({ type: 'settings', showBinary: $('#show-binary').checked });
}
async function newRound() { try { closeParticipantView(); const result = await api('/api/session', { method: 'POST' }); info = result.info; state = info.session; connectTeacher(state.code); } catch (error) { toast(error.message, true); } }

bootstrap();
