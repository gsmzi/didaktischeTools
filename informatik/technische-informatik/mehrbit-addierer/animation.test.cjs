const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const vm = require('node:vm');

// Exercise the page's actual event handlers and rendering with a small DOM double
// and a controllable clock. No browser or additional dependencies are required.
const html = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');
const script = html.match(/<script>([\s\S]*?)<\/script>/)[1];

function loadPage() {
  class Element {
    constructor() {
      this.children = [];
      this.dataset = {};
      this.className = '';
      this.listeners = {};
      this.attributes = {};
      this.style = { setProperty() {} };
      this.classList = {
        toggle: (name, on) => {
          const names = new Set(this.className.split(/\s+/).filter(Boolean));
          if (on ?? !names.has(name)) names.add(name);
          else names.delete(name);
          this.className = [...names].join(' ');
        },
        add: name => this.classList.toggle(name, true),
        remove: (...names) => names.forEach(name => this.classList.toggle(name, false)),
        contains: name => this.className.split(/\s+/).includes(name)
      };
    }
    set textContent(value) { this.text = String(value); this.children = []; }
    get textContent() { return (this.text ?? '') + this.children.map(child => child.textContent).join(''); }
    set innerHTML(value) { this.markup = value; this.text = ''; this.children = []; }
    get innerHTML() { return this.markup ?? ''; }
    appendChild(child) { this.children.push(child); }
    setAttribute(name, value) { this.attributes[name] = String(value); }
    addEventListener(name, handler) { this.listeners[name] = handler; }
    fire(name, value) {
      if (value !== undefined) this.value = value;
      this.listeners[name]({ target: this });
    }
  }

  const ids = Object.fromEntries([...html.matchAll(/id="([^"]+)"/g)].map(([, id]) => [id, new Element()]));
  const buttons = {};
  for (const name of ['width', 'mode', 'op', 'task-overflow']) {
    buttons[`[data-${name}]`] = [...html.matchAll(new RegExp(`data-${name}="([^"]+)"`, 'g'))].map(([, value]) => {
      const button = new Element();
      button.dataset[name.replace(/-([a-z])/g, (_, c) => c.toUpperCase())] = value;
      return button;
    });
  }
  const timers = new Map();
  let timerId = 0;
  const context = vm.createContext({
    document: {
      documentElement: new Element(),
      getElementById(id) { assert.ok(ids[id], `Missing HTML element: ${id}`); return ids[id]; },
      createElement() { return new Element(); },
      querySelectorAll(selector) { return buttons[selector] ?? []; },
      addEventListener() {}
    },
    setInterval(callback) { timers.set(++timerId, callback); return timerId; },
    clearInterval(id) { timers.delete(id); }
  });
  vm.runInContext(script, context);
  return {
    ids, timers, buttons,
    run: code => vm.runInContext(code, context),
    tick() { [...timers.values()].forEach(callback => callback()); },
    play() { ids.playBtn.fire('click'); },
    sum() { return ids.sumLine.textContent; },
    carry() { return ids.carryLine.textContent; },
    activeBits() { return ids.adderGrid.children.filter(stage => stage.classList.contains('animation-active')).map(stage => stage.dataset.hoverBit); }
  };
}

for (const width of [4, 8]) {
  for (const op of ['add', 'sub']) {
    test(`${width}-bit ${op}: reveal each stage, carry and final result in order`, () => {
      const page = loadPage();
      page.run(`setWidth(${width}); setOp('${op}'); state.a = ${2 ** width - 1}; state.b = 1; render();`);
      const result = page.run('computeState()');
      const expected = result.resultRaw.toString(2).padStart(width, '0');
      page.play();
      assert.equal(page.sum(), '?'.repeat(width));
      assert.equal(page.ids.sumValue.textContent, '?');
      assert.equal(page.ids.overflowValue.textContent, '?');
      assert.equal(page.ids.playBtn.attributes['aria-pressed'], 'true');
      assert.equal(page.timers.size, 1);
      for (let bit = 0; bit < width; bit++) {
        page.tick();
        assert.equal(page.sum(), '?'.repeat(width - bit - 1) + expected.slice(width - bit - 1));
        assert.deepEqual(page.activeBits(), [bit]);
        assert.ok(page.ids.animationStatus.textContent.startsWith(`Bit ${bit}:`));
        const stage = page.ids.adderGrid.children.find(el => el.dataset.hoverBit === bit);
        assert.ok(stage.innerHTML.includes(`<b>${result.stages[bit].sum}</b>`));
        if (bit < width - 1) assert.equal(page.ids.overflowValue.textContent, '?');
      }
      assert.equal(page.carry().includes('?'), false);
      assert.equal(page.ids.sumValue.textContent, String(result.resultRaw));
      page.tick();
      assert.equal(page.timers.size, 0);
      assert.deepEqual(page.activeBits(), []);
      assert.equal(page.ids.playBtn.textContent, '▶ Animation');
      assert.ok(page.ids.animationStatus.textContent.includes('abgeschlossen'));
      page.play();
      page.tick();
      page.play();
      assert.equal(page.timers.size, 0);
      assert.equal(page.sum(), expected);
    });
  }
}

test('carry inputs stay hidden until the preceding stage has run', () => {
  const page = loadPage();
  page.play();
  const stage = bit => page.ids.adderGrid.children.find(el => el.dataset.hoverBit === bit);
  assert.match(stage(1).innerHTML, /Carry in<\/small><b>\?<\/b>/);
  page.tick();
  assert.doesNotMatch(stage(1).innerHTML, /Carry in<\/small><b>\?<\/b>/);
  assert.match(stage(2).innerHTML, /Carry in<\/small><b>\?<\/b>/);
});

test('unsolved task disables animation with an explanation; checking unlocks it', () => {
  const page = loadPage();
  page.run('startTask()');
  assert.equal(page.sum(), '????');
  assert.equal(page.ids.playBtn.disabled, true);
  assert.match(page.ids.animationStatus.textContent, /ungeprüft/);
  assert.match(html, /id="playBtn" aria-describedby="animationStatus"/);
  page.play();
  assert.equal(page.timers.size, 0);
  assert.equal(page.sum(), '????');
  page.run('state.task.overflowGuess = "no"; checkTask()');
  assert.equal(page.ids.playBtn.disabled, false);
  assert.doesNotMatch(page.ids.animationStatus.textContent, /gesperrt/);
  page.play();
  assert.equal(page.timers.size, 1);
  page.ids.predictionBits.children[0].fire('click');
  assert.equal(page.timers.size, 0);
  assert.equal(page.ids.playBtn.disabled, true);
  page.run('checkTask()');
  page.play();
  for (let i = 0; i < 5; i++) page.tick();
  assert.match(page.sum(), /^[01]{4}$/);
  page.run('startTask()');
  assert.equal(page.sum(), '????');
  assert.equal(page.ids.playBtn.disabled, true);
  assert.equal(page.timers.size, 0);
  page.run('setTaskEnabled(false)');
  assert.equal(page.ids.playBtn.disabled, false);
  assert.doesNotMatch(page.ids.animationStatus.textContent, /gesperrt/);
});

test('changing calculation or task mode cancels the previous timer', () => {
  const actions = [
    page => page.ids.aNumber.fire('input', '5'),
    page => page.ids.bNumber.fire('input', '5'),
    page => page.ids.aRange.fire('input', '5'),
    page => page.ids.bRange.fire('input', '5'),
    page => page.ids.aBits.children[0].fire('click'),
    page => page.ids.randomBtn.fire('click'),
    page => page.run('setWidth(8)'),
    page => page.run('setMode("signed")'),
    page => page.run('setOp("sub")'),
    page => page.run('setTaskEnabled(true)'),
    page => page.run('startTask()')
  ];
  for (const action of actions) {
    const page = loadPage();
    page.play();
    page.tick();
    action(page);
    assert.equal(page.timers.size, 0);
    assert.equal(page.run('state.animStep'), null);
    assert.deepEqual(page.activeBits(), []);
    if (page.run('answersHidden()')) page.run('setTaskEnabled(false)');
    page.play();
    assert.equal(page.timers.size, 1);
    assert.equal(page.run('state.animStep'), -1);
  }
});
