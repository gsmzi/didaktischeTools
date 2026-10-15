# Palastnetzwerk · Internetsimulator

Eine lokale Client-Server-Simulation zum Rollenspiel „Netzwerk“ für den Informatik-Anfangsunterricht (IuM Klasse 7). Die Anwendung bildet die fünf Bereiche, Namensvermittler, Router-Adressen und die Nachrichtenwege aus dem Arbeitsauftrag ab.

> **Hinweis:** Anders als die übrigen Tools in dieser Sammlung braucht der Simulator einen kleinen Node.js-Server auf dem Lehrerrechner. Er läuft deshalb nicht über GitHub Pages. Diesen Ordner herunterladen und wie unten beschrieben mit `npm start` starten.

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
2. Schülerinnen und Schüler: Rollenkarte anklicken. Die Rolle des Verteilers heißt jetzt Namensvermittler.
3. Namensvermittler geben die sichtbaren Adressen ihres Routers weiter.
4. Mitarbeiter fragen zunächst nach einer Zieladresse und senden dann Nachrichten an diese Adresse.
5. Die Lehrkraft kann zwischen Testphase, Ruhephase und Pause wechseln sowie das Nachrichtenlog leeren.

Die Schüleransicht zeigt ausschließlich den eigenen Raum. Namensvermittler sehen zusätzlich die Namensvermittler der anderen Räume und deren Adressen, sobald diese online sind. Die vollständige Router-Topologie ist nur in der Lehreransicht sichtbar.

Adressen werden pro Router automatisch als `Router.Teilnehmer` vergeben, z. B. `2.3`. Nachrichten werden serverseitig über die im Rollenspiel vorgegebene Router-Topologie protokolliert. Der Server speichert nur die aktuelle Runde im Arbeitsspeicher; beim Neustart ist sie leer.
