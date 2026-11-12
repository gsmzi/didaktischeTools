const { spawn } = require('child_process');
const assert = require('assert');

const port = 8091;
const base = `http://127.0.0.1:${port}`;
const server = spawn(process.execPath, ['server.js'], {
  cwd: require('path').join(__dirname, '..'),
  env: { PORT: String(port), TASK_WAIT_MS: '1500' },
  stdio: ['ignore', 'pipe', 'pipe']
});

function delay(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }
async function waitForServer() {
  for (let attempt = 0; attempt < 40; attempt += 1) {
    try { const response = await fetch(`${base}/api/info`); if (response.ok) return; } catch { /* retry */ }
    await delay(100);
  }
  throw new Error('Testserver wurde nicht erreichbar.');
}
function socketClient() {
  const socket = new WebSocket(`ws://127.0.0.1:${port}`);
  const queued = [];
  const waiters = [];
  socket.addEventListener('message', event => {
    const data = JSON.parse(event.data);
    const match = waiters.findIndex(waiter => waiter.predicate(data));
    if (match >= 0) waiters.splice(match, 1)[0].resolve(data); else queued.push(data);
  });
  return {
    socket,
    ready: new Promise((resolve, reject) => { socket.addEventListener('open', resolve, { once: true }); socket.addEventListener('error', reject, { once: true }); }),
    send(data) { socket.send(JSON.stringify(data)); },
    discard(predicate) {
      for (let index = queued.length - 1; index >= 0; index -= 1) {
        if (predicate(queued[index])) queued.splice(index, 1);
      }
    },
    wait(predicate, timeout = 2500) {
      const match = queued.findIndex(predicate);
      if (match >= 0) return Promise.resolve(queued.splice(match, 1)[0]);
      return new Promise((resolve, reject) => {
        const waiter = { predicate, resolve };
        waiters.push(waiter);
        setTimeout(() => { const index = waiters.indexOf(waiter); if (index >= 0) waiters.splice(index, 1); reject(new Error('WebSocket-Antwort fehlt.')); }, timeout);
      });
    },
    close() { socket.close(); }
  };
}
async function join(code, router, role, gender = 'male') {
  const client = socketClient(); await client.ready;
  client.send({ type: 'join', code, router, role, gender });
  const joined = await client.wait(message => message.type === 'joined');
  client.me = joined.me;
  return client;
}

(async () => {
  const clients = [];
  try {
    await waitForServer();
    const created = await fetch(`${base}/api/session`, { method: 'POST' }).then(response => response.json());
    const code = created.code;
    const teacher = socketClient(); clients.push(teacher); await teacher.ready; teacher.send({ type: 'teacher', code }); await teacher.wait(message => message.type === 'teacher-ready');
    const kitchenMaster = await join(code, 1, 'Küchenmeister'); clients.push(kitchenMaster);
    const cook = await join(code, 1, 'Koch'); clients.push(cook);
    const bakeryMaster = await join(code, 2, 'Bäckermeister'); clients.push(bakeryMaster);
    const buyer = await join(code, 2, 'Einkäufer'); clients.push(buyer);

    // Auftragsgenerator: Ziel ist eine erreichbare Person, nie man selbst, nie ein Meister.
    let cookState = await cook.wait(message => message.type === 'state' && message.state.myTask);
    assert.match(cookState.state.myTask, /den Einkäufer/);
    assert.ok(cookState.state.myTaskWait > 0, 'Nach einem neuen Auftrag läuft die Wartezeit.');
    cook.send({ type: 'new-task' });
    await cook.wait(message => message.type === 'error' && /erst in/.test(message.error));
    await delay(1600);
    cook.discard(() => true);
    cook.send({ type: 'new-task' });
    cookState = await cook.wait(message => message.type === 'state' && message.state.myTask);
    assert.match(cookState.state.myTask, /den Einkäufer/, 'Ist nur ein Ziel erreichbar, bleibt es dieses Ziel.');
    const calculator = await join(code, 3, 'Rechner', 'female'); clients.push(calculator);
    assert.equal((await fetch(`${base}/api/session/${code}`).then(r => r.json())).participants.length, 5);
    calculator.discard(() => true);
    const treasuryMaster = await join(code, 3, 'Kämmereimeister'); clients.push(treasuryMaster);
    const calcState = await calculator.wait(message => message.type === 'state' && message.state.myTask);
    assert.match(calcState.state.myTask, /den (Koch|Einkäufer)/, 'Erst mit eigenem Meister gibt es einen Auftrag.');
    const initialAddresses = new Map(clients.filter(client => client.me).map(client => [client.me.id, client.me.address]));
    assert.equal(new Set(initialAddresses.values()).size, initialAddresses.size, 'Alle vollständigen Adressen sind eindeutig.');
    for (const client of clients.filter(client => client.me)) {
      const [router, slot] = client.me.address.split('.').map(Number);
      assert.equal(router, client.me.router, 'Die erste Zahl bezeichnet weiterhin den Raum.');
      assert.ok(Number.isInteger(slot) && slot >= 0 && slot <= 100, 'Teilnehmer und Meister haben Nummern von 0 bis 100.');
    }
    const buyerState = await buyer.wait(message => message.type === 'state' && message.state.myTask);
    assert.ok(/den Koch|die Rechnerin/.test(buyerState.state.myTask));

    cook.send({ type: 'send-classic', text: 'Ohne Empfänger' });
    await cook.wait(message => message.type === 'error' && /Empfänger/.test(message.error));
    cook.send({ type: 'send-classic', noteTo: 'Einkäufer', text: 'Wie viel Geld ist da?' });
    await cook.wait(message => message.type === 'action-ok');
    let view = await teacher.wait(message => message.type === 'state' && message.state.messages.length === 1);
    let letter = view.state.messages[0];
    assert.equal(letter.stage, 'structured');
    assert.equal(letter.noteFrom, cook.me.name);
    assert.equal(letter.currentHolderId, kitchenMaster.me.id);

    teacher.send({ type: 'settings', phase: 'paused', showTasks: false, encoding: 'binary' });
    await teacher.wait(message => message.type === 'state' && message.state.settings.phase === 'paused');
    cook.send({ type: 'send-classic', text: 'Darf in der Pause nicht gesendet werden' });
    await cook.wait(message => message.type === 'error' && /Denkpause/.test(message.error));
    kitchenMaster.send({ type: 'forward-classic', messageId: letter.id, targetId: bakeryMaster.me.id });
    await kitchenMaster.wait(message => message.type === 'error' && /Denkpause/.test(message.error));
    const paused = await fetch(`${base}/api/session/${code}`).then(response => response.json());
    assert.equal(paused.messages.length, 1);
    assert.equal(paused.messages[0].currentHolderId, kitchenMaster.me.id);
    teacher.discard(message => message.type === 'state');
    teacher.send({ type: 'settings', phase: 'open' });
    const resumed = await teacher.wait(message => message.type === 'state' && message.state.settings.phase === 'open');
    assert.equal(resumed.state.settings.showTasks, false, 'Einzelne Einstellungen dürfen andere nicht zurücksetzen.');
    assert.equal(resumed.state.settings.encoding, 'binary');

    kitchenMaster.send({ type: 'forward-classic', messageId: letter.id, targetId: bakeryMaster.me.id });
    await kitchenMaster.wait(message => message.type === 'action-ok');
    view = await teacher.wait(message => message.type === 'state' && message.state.messages[0]?.currentHolderId === bakeryMaster.me.id);
    letter = view.state.messages[0];
    bakeryMaster.send({ type: 'forward-classic', messageId: letter.id, targetId: buyer.me.id });
    await bakeryMaster.wait(message => message.type === 'action-ok');
    view = await teacher.wait(message => message.type === 'state' && message.state.messages[0]?.currentHolderId === buyer.me.id);
    assert.equal(view.state.messages[0].status, 'with-person');
    kitchenMaster.send({ type: 'deliver-classic', messageId: letter.id });
    await kitchenMaster.wait(message => message.type === 'error');
    buyer.send({ type: 'deliver-classic', messageId: letter.id });
    await buyer.wait(message => message.type === 'action-ok');
    view = await teacher.wait(message => message.type === 'state' && message.state.messages[0]?.status === 'delivered');
    buyer.send({ type: 'forward-classic', messageId: letter.id, targetId: bakeryMaster.me.id });
    await buyer.wait(message => message.type === 'error' && /nicht mehr bei dir/.test(message.error));

    teacher.send({ type: 'settings', stage: 'explore' });
    await delay(150);
    const stillStructured = await fetch(`${base}/api/session/${code}`).then(response => response.json());
    assert.equal(stillStructured.settings.stage, 'structured', 'Die alte Phase explore gibt es nicht mehr.');

    teacher.send({ type: 'settings', stage: 'addressed' });
    const addressedState = await teacher.wait(message => message.type === 'state' && message.state.settings.stage === 'addressed');
    for (const participant of addressedState.state.participants) assert.equal(participant.address, initialAddresses.get(participant.id), 'Der Phasenwechsel ändert keine Adresse.');
    cook.send({ type: 'send', to: buyer.me.address, text: 'Adressierte Testnachricht' });
    const delivered = await buyer.wait(message => message.type === 'message' && message.direction === 'received');
    assert.equal(delivered.message.stage, 'addressed');
    assert.deepEqual(delivered.message.path, [1, 2]);

    teacher.send({ type: 'settings', phase: 'paused' });
    await teacher.wait(message => message.type === 'state' && message.state.settings.phase === 'paused');
    cook.send({ type: 'send', to: buyer.me.address, text: 'Gesperrt' });
    await cook.wait(message => message.type === 'error' && /Denkpause/.test(message.error));
    const addressedPause = await fetch(`${base}/api/session/${code}`).then(response => response.json());
    assert.equal(addressedPause.messages.length, 1);
    teacher.send({ type: 'settings', phase: 'open' });
    await teacher.wait(message => message.type === 'state' && message.state.settings.phase === 'open');
    cook.send({ type: 'send', to: buyer.me.address, text: 'Nach Freigabe' });
    await buyer.wait(message => message.type === 'message' && message.message.text === 'Nach Freigabe');

    console.log('Smoke-Test erfolgreich: zwei Phasen, Ablegen, Denkpause, Freigabe und unveränderte Einstellungen.');
  } finally {
    clients.forEach(client => client.close());
    server.kill();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
