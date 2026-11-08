const learningPlan = {
  explore: {
    goal: 'Ich kann an einem Briefweg erklären, warum gemeinsame Regeln für die Kommunikation nötig sind.',
    steps: ['Bearbeite deinen Rollenauftrag. Verschicke zunächst nur einen Brief.', 'Beobachte: Wo wartet dein Brief? Kann die nächste Person erkennen, wohin er gehört?', 'Notiere ein Problem und schlage eine Regel vor.'],
    mediator: ['Leite einen wartenden Brief an eine Person im Raum oder einen verbundenen Meister weiter.', 'Beobachte, welche Angaben dir für deine Entscheidung fehlen.', 'Sammelt eine Regel, die allen bei der Zustellung helfen würde.'],
    hint: 'Stell dir vor, jemand liest deinen Zettel ohne weitere Erklärung. Was müsste diese Person wissen?',
    reflection: 'An welcher Stelle gab es ein Problem? Welche gemeinsame Regel würde helfen?',
    challenge: 'Vergleicht zwei Briefwege: Wodurch entstehen Wartezeiten oder Umwege?',
    teacher: 'Erkunden · ca. 8 Minuten. Erst ausprobieren lassen. Anschließend pausieren und aus konkreten Problemen gemeinsame Regeln ableiten.',
    discussion: 'Welche Angaben haben gefehlt? Einigt euch auf einen gemeinsamen Aufbau für alle Briefe.'
  },
  structured: {
    goal: 'Ich kann erklären, wie ein festgelegter Nachrichtenaufbau die Zustellung erleichtert und welche Probleme bleiben.',
    steps: ['Bearbeite denselben Auftrag mit den Feldern Von, An und Text.', 'Vergleiche den Weg mit Phase 1. Beantworte auch eingehende Fragen; passende Antworten darfst du erfinden.', 'Belege mit einem Beispiel, was besser funktioniert und was weiterhin schwierig ist.'],
    mediator: ['Lies Von und An und entscheide über den nächsten Schritt.', 'Vergleiche deine Entscheidungen mit Phase 1.', 'Notiere ein Problem, das der feste Briefaufbau noch nicht löst.'],
    hint: 'Ein gemeinsamer Aufbau ist eine vereinbarte Regel, also Teil eines Protokolls. Wissen dadurch schon alle, in welchem Raum eine Person ist?',
    reflection: 'Was erleichtern Von und An? Warum reicht ein Name allein nicht immer für die Weiterleitung?',
    challenge: 'Entwerft eine Regel, mit der neue Mitarbeitende zuverlässig gefunden werden können.',
    teacher: 'Vergleichen · ca. 8 Minuten. Möglichst denselben Auftrag erneut nutzen, damit die Wirkung der Struktur erkennbar wird.',
    discussion: 'Was löst der feste Aufbau? Welche zusätzliche Information braucht das Netz für die Weiterleitung?'
  },
  addressed: {
    goal: 'Ich kann Namensauflösung und Weiterleitung unterscheiden und einen protokollierten Nachrichtenweg erklären.',
    steps: ['Frage deinen Namensvermittler nach der Zieladresse. Seine Adresse steht in deiner Raumübersicht.', 'Schicke danach deine Rollenfrage an die ermittelte Adresse und beantworte eingehende Fragen.', 'Lies den Weg im Nachrichtenlog: Welche Router hat die Nachricht durchlaufen?'],
    mediator: ['Beantworte Adressanfragen zu Personen in deinem Raum anhand der Raumübersicht.', 'Liegt das Ziel in einem anderen Raum? Frage dessen Namensvermittler; seine Adresse steht oben.', 'Antworte mit der Zieladresse. Die eigentliche Nachricht sendet die anfragende Person selbst.'],
    hint: 'Eine Anfrage könnte lauten: „Welche Adresse hat die Rolle Koch?“ Liegt sie in einem anderen Raum, fragt dein Namensvermittler dort nach. Antworten darfst du im Rollenspiel passend erfinden.',
    reflection: 'Beschreibe getrennt: Wie wurde aus dem Namen eine Adresse? Wie kam danach die Nachricht zum Ziel?',
    challenge: 'Warum können zwei Nachrichten an dasselbe Ziel im echten Internet unterschiedliche Wege nehmen? Welche Vereinfachung erkennst du hier?',
    teacher: 'Übertragen · ca. 12 Minuten. Namensauflösung zunächst durch Nachrichten ausführen lassen. Danach einen Weg gemeinsam auswerten. Binärdarstellung erst als Zusatz öffnen.',
    discussion: 'Welche Aufgabe übernimmt die Namensvermittlung, welche das Routing? Wo vereinfacht unser Modell das echte Internet?'
  }
};

function learningPanel(participant, stage) {
  const plan = learningPlan[stage];
  const steps = participant.isMediator ? plan.mediator : plan.steps;
  return `<section class="box learning-panel"><div class="box-head"><h2>Dein Lernauftrag · Klasse 8</h2><small>Phase ${stageInfo(stage).number}</small></div><div class="learning-body"><p><strong>Lernziel:</strong> ${esc(plan.goal)}</p>${!participant.isMediator ? `<p class="role-task"><strong>Dein Rollenauftrag:</strong> ${esc(tasks[participant.roleKey || participant.role] || "Vereinbare mit der Lehrkraft ein Nachrichtenziel.")}</p>` : ""}<ol>${steps.map(step => `<li>${esc(step)}</li>`).join('')}</ol><details data-learning="hint"><summary>Ich brauche einen Tipp</summary><p>${esc(plan.hint)}</p></details><details data-learning="reflection"><summary>Kurzer Denkstopp</summary><p>${esc(plan.reflection)}</p><p>Notiere ein Beispiel und deine Erklärung im Heft. Vergleicht anschließend zu zweit.</p></details><details data-learning="challenge"><summary>Schon fertig? Zusatzauftrag</summary><p>${esc(plan.challenge)}</p></details></div></section>`;
}

function modelNotes() {
  return `<details class="model-notes" data-learning="model"><summary>Vom Palast zum Internet: Begriffe und Modellgrenzen</summary><dl><dt>Mitarbeitende → Endgeräte</dt><dd>Sie erstellen und empfangen Nachrichten.</dd><dt>Meister → zwei getrennte Aufgaben</dt><dd>In Phase 1 und 2 vermitteln sie Briefe. In Phase 3 spielen sie die Namensvermittlung (ähnlich DNS). Die Weiterleitung (Routing) führt dann der Simulator automatisch aus. Im Internet sind DNS und Router unterschiedliche Dienste bzw. Geräte.</dd><dt>Name → Adresse</dt><dd>DNS ordnet im Internet zum Beispiel einem Domainnamen eine IP-Adresse zu. Unsere Rollennamen stehen vereinfacht für solche Namen.</dd><dt>Adresse und Weg</dt><dd>Eine Modelladresse wie 2.3 bedeutet hier Router 2, Teilnehmer 3. Sie ist keine echte IPv4-Adresse. Der Simulator wählt einen kürzesten Routerweg; echte Netze entscheiden anhand ihrer Routingtabellen und können andere Wege verwenden.</dd><dt>Nachricht und Datenpakete</dt><dd>Hier bleibt jeder Brief ganz und kommt sofort an. Aufteilung in Pakete, Übertragungszeit, Verluste und erneutes Senden werden nicht simuliert.</dd><dt>Binärdarstellung als Zusatz</dt><dd>Der Text wird mit UTF-8 in Bytes zu je 8 Bit codiert; Umlaute können mehrere Bytes brauchen. Die Modelladresse wird getrennt davon in zwei Gruppen zu je 4 Bit dargestellt. Das ist kein echtes IP-Paketformat.</dd></dl></details>`;
}
