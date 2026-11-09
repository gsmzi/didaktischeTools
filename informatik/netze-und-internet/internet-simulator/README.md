# Palastnetzwerk · Internetsimulator

Digitale Fortsetzung des Rollenspiels „Netzwerk“ (Schlossnetzwerk): gleiche fünf Bereiche, gleiche Rollen, gleiche Verbindungen zwischen den Meistern. Alle Geräte der Klasse verbinden sich mit einem kleinen Server auf dem Lehrerrechner.

> **Hinweis:** Anders als die übrigen Tools in dieser Sammlung braucht der Simulator einen kleinen Node.js-Server auf dem Lehrerrechner. Er läuft deshalb nicht über GitHub Pages. Diesen Ordner herunterladen und wie unten beschrieben mit `npm start` starten.

## Zwei Phasen

| Phase | Klasse | Was passiert |
| --- | --- | --- |
| 1 · Netzwerkspiel | 6 | Das Netzwerkspiel in digital: Briefe mit Von · An · Text gehen an den eigenen Meister, Meister leiten jeden Brief von Hand an eine Person im Raum oder einen verbundenen Meister weiter. |
| 2 · Adressen | 8 | Jede Rolle hat eine Adresse `Router.Teilnehmer` (z. B. `2.3`). Die Meister sind Namensvermittler (wie DNS); die Weiterleitung übernimmt der Simulator (Routing). |

Die Schülerseite zeigt nur das Nötigste, Erklärungen kommen von der Lehrkraft vorab: oben Rolle und (in Phase 2) die eigene Adresse, darunter direkt „Brief schreiben“ bzw. „Nachricht senden“ mit dem Rollenauftrag, die wartenden Briefe, das Netz bzw. der eigene Raum und die eigenen Briefwege. Empfangene Briefe kann man in Phase 1 beantworten, ablegen oder an den Meister zurückgeben.

### Steuerung

- Die Lehrkraft schaltet die Phase für alle Geräte gleichzeitig um. Rollen bleiben erhalten.
- **Reden erlaubt / Nur im Netzwerk / Pause:** In der Pause sind Senden und Weiterleiten auf dem Server gesperrt, Lesen bleibt möglich.
- Die aufklappbare **Unterrichtshilfe** zeigt einen Gesprächsimpuls und fehlende Meister bzw. unbesetzte Auftragsziele.
- `npm test` prüft beide Phasen, Weiterleiten, Ablegen, adressierte Zustellung und die Pause (Node.js 22 oder neuer).

## Was ist npm?

`npm` steht für „Node Package Manager“. Es ist ein Kommandozeilenprogramm, das normalerweise zusammen mit **Node.js** installiert wird. In diesem Projekt wird npm nur verwendet, um den Simulationsserver mit `npm start` zu starten. Zusätzliche Pakete müssen für dieses Projekt nicht installiert werden.

### Node.js und npm unter Windows installieren

1. Die offizielle Node.js-Webseite öffnen: <https://nodejs.org/>
2. Die **LTS-Version** herunterladen und den Installationsassistenten mit den Standardeinstellungen durchführen.
3. Danach PowerShell oder die Eingabeaufforderung neu öffnen.
4. Die Installation prüfen:

```text
node --version
npm --version
```

Wenn beide Befehle eine Versionsnummer anzeigen, sind Node.js und npm einsatzbereit. Falls Windows meldet, dass `node` oder `npm` nicht gefunden wurde, muss das Terminal nach der Installation neu geöffnet werden.

Beim ersten Start kann die Windows-Firewall fragen, ob Node.js Netzwerkzugriff erhalten darf. Dieser Zugriff muss für **private Netzwerke** zugelassen werden, damit die Schülergeräte im Klassenraum den Server erreichen können. Den Zugriff für öffentliche Netzwerke sollte man nicht freigeben.

## Start im Klassenraum

Voraussetzung ist Node.js 18 oder neuer. Im Projektordner:

```text
npm start
```

Die Anwendung versucht standardmäßig, Port 80 zu verwenden. Wenn dieser Port bereits belegt ist oder nicht geöffnet werden darf, verwendet sie automatisch Port 8080. Ein anderer Port kann mit `PORT=8080 npm start` festgelegt werden.

Auf dem Lehrerrechner wird im Browser `http://localhost` geöffnet. Der Server erkennt `localhost` automatisch und zeigt die Lehreransicht. Dort stehen der Schüler-Link und ein Link zur Schüler-Anleitung inklusive erkannter LAN-IP. Wenn der Rechner mehrere Netzwerkkarten besitzt, werden alle gefundenen Adressen angezeigt und die richtige LAN-IP kann im Feld **LAN-IP oder Rechnername** eingetragen werden.

Im Live-Monitor kann die Lehrkraft die gewünschte Adresse aus einem Dropdown auswählen. Die Auswahl wird in der laufenden Runde gespeichert und anschließend auch auf der Schülerseite sowie in der Schüler-Anleitung verwendet.

Die Schülergeräte öffnen den angezeigten Schüler-Link, zum Beispiel `http://192.168.178.25`. Die Schülerseite zeigt direkt die noch freien Rollen als anklickbare Namen. Raumcodes und manuelle Namenseingaben sind nicht erforderlich. Eine Webseite kann die IP-Adresse des Servers nicht selbst zuverlässig erraten; sie kennt nur die Adresse, unter der sie geöffnet wurde. Deshalb ist die IP-Auswahl auf der Lehrerseite absichtlich editierbar.

Falls die Windows-Firewall beim ersten Start fragt, muss der Zugriff im privaten Netzwerk erlaubt werden. Port 80 ist bequem, kann aber durch IIS, Skype, andere Webserver oder Sicherheitssoftware belegt sein. Der automatische Fallback auf Port 8080 ist deshalb absichtlich eingebaut.

## Unterrichtsablauf

1. Lehrkraft: `http://localhost` öffnen und den angezeigten Schüler-Link weitergeben.
2. Schülerinnen und Schüler klicken ihre Rollenkarte an. Zuerst die fünf Meisterrollen besetzen.
3. Phase 1 (Kl. 6): Mitarbeitende schreiben Briefe an ihren Meister, Meister leiten von Hand weiter. Alle sehen das ganze Netz mit wartenden Briefen, aber nicht, welcher Weg richtig wäre.
4. Phase 2 (Kl. 8): Mitarbeitende fragen ihren Namensvermittler nach der Zieladresse und senden dann an diese Adresse. Sie sehen nur ihren eigenen Raum; Namensvermittler sehen zusätzlich die anderen Namensvermittler mit Adresse.

Der Server speichert nur die aktuelle Runde im Arbeitsspeicher; beim Neustart ist sie leer.
