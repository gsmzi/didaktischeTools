# Palastnetzwerk · Internetsimulator

Eine lokale Client-Server-Simulation zum Rollenspiel „Netzwerk“ für den Informatik-Anfangsunterricht in Klasse 8. Die Anwendung bildet die fünf Bereiche, Namensvermittler, Router-Adressen und die Nachrichtenwege aus dem Arbeitsauftrag ab.

> **Hinweis:** Anders als die übrigen Tools in dieser Sammlung braucht der Simulator einen kleinen Node.js-Server auf dem Lehrerrechner. Er läuft deshalb nicht über GitHub Pages. Diesen Ordner herunterladen und wie unten beschrieben mit `npm start` starten.

## Einsatz in Klasse 8

Die drei Phasen führen vom Entdecken eines Kommunikationsproblems über einen gemeinsamen Nachrichtenaufbau zur Namensauflösung und zum Routing. Jede Phase zeigt einen kurzen Lernauftrag mit Lernziel, Rollenauftrag, aufklappbarem Tipp, Denkstopp und Zusatzauftrag. Meister erhalten eigene Arbeitsschritte. Reflexionen werden im Heft festgehalten; der Simulator sammelt keine Antworten oder Bewertungen.

### Vorschlag für 45 Minuten

| Zeit | Unterrichtsschritt | Sicherung |
| --- | --- | --- |
| 5 Min. | Einstieg: „Wie findet eine Nachricht ihr Ziel?“ Rollen verteilen. | Zuerst alle fünf Meisterrollen besetzen. |
| 8 Min. | Phase 1: zunächst einen freien Brief pro Team verschicken. | Ein beobachtetes Problem und eine mögliche Regel nennen. |
| 8 Min. | Phase 2: denselben Auftrag mit Von, An und Text wiederholen. | Wirkung der Struktur vergleichen; verbleibende Probleme benennen. |
| 12 Min. | Phase 3: Zieladresse durch Nachrichten erfragen, dann eigentliche Frage senden und beantworten. | Namensauflösung und Routerweg getrennt erklären. |
| 8 Min. | Gemeinsame Auswertung und kurzer Heftauftrag. | Drei Fachbegriffe mit einem konkreten Beispiel erklären; eine Modellgrenze nennen. |
| 4 Min. | Puffer für Verbindungsaufbau oder Rückfragen. | |

Für 90 Minuten können Briefwege systematisch verglichen, die Rollen in einer weiteren Runde gewechselt und die Zusatzaufträge besprochen werden. Die Binärdarstellung eignet sich als Erweiterung, sobald Adressierung und Vermittlung verstanden sind.

### Steuerung und Klassenorganisation

- **Erkunden:** Ausprobieren und miteinander sprechen.
- **Nur im Netzwerk:** Informationen nur über den Simulator austauschen. Diese Gesprächsregel wird pädagogisch vereinbart.
- **Denkpause:** Senden und Weiterleiten werden auf dem Server gesperrt; Lesen und Beobachten bleiben möglich. So können laufende Briefwege gemeinsam ausgewertet werden. Die Pause bleibt beim Wechsel der Spielphase bestehen und muss bewusst aufgehoben werden.
- Unter **Unterrichtshilfe · Klasse 8** stehen Gesprächsimpulse, Zeitvorschlag und Hinweise auf fehlende Meister sowie unbesetzte Auftragsziele. Bei kleineren Klassen Ziele gemeinsam anpassen; bei größeren Klassen Zweierteams bilden.
- Passende Antworten auf Rollenfragen dürfen erfunden werden. Persönliche Angaben sind nicht erforderlich.
- Texteingaben, Cursorposition und aufgeklappte Hilfen bleiben bei Live-Aktualisierungen erhalten. Entwürfe werden pro Phase im geöffneten Tab gehalten; Neuladen oder Schließen des Tabs verwirft sie. Das Textfeld wird erst nach erfolgreicher Sendebestätigung geleert. Eine neue Runde erfordert einen Bestätigungsklick.

### Fachliche Einordnung und erwartbare Antworten

- **Protokoll:** Vereinbarte Regeln, beispielsweise ein gemeinsamer Aufbau mit Absender, Empfänger und Inhalt. Der Aufbau erleichtert das Lesen, legt aber noch keinen Weiterleitungsweg fest.
- **Namensauflösung:** Ein Name wird einer Adresse zugeordnet. Im Modell erledigen das die Meister durch Rückfragen; im Internet übernimmt DNS unter anderem die Zuordnung von Domainnamen zu IP-Adressen.
- **Routing:** Nachrichten werden zwischen Netzen weitergeleitet. In Phase 3 übernimmt das der Server automatisch; die Namensvermittler transportieren die eigentlichen Nachrichten dann nicht mehr.
- **Modellgrenzen:** Adressen wie `2.3` sind keine echten IPv4-Adressen. Ganze Briefe werden sofort auf einem kürzesten Routerweg übertragen. Paketaufteilung, Übertragungsdauer, Verluste und erneutes Senden fehlen. Echte Netze treffen Entscheidungen anhand ihrer Routingtabellen.
- **Binär-Zusatz:** Text wird mit UTF-8 codiert (8 Bit pro Byte; Umlaute können mehrere Bytes beanspruchen). Modelladressen werden separat in zwei Gruppen zu je 4 Bit dargestellt. Diese Anzeige bildet kein echtes IP-Paketformat ab.

Die Lernenden finden die Einordnung unter **Vom Palast zum Internet: Begriffe und Modellgrenzen**. Sie ist aufklappbar, damit die freie Erkundung zunächst ohne vorweggenommene Erklärung erfolgen kann.

### Überprüfung

`npm test` prüft die drei Spielphasen einschließlich manueller Weiterleitung und adressierter Zustellung sowie die serverseitige Denkpause, die Freigabe danach und den Erhalt anderer Einstellungen. Der Test benötigt Node.js 22 oder neuer wegen des eingebauten WebSocket-Clients; für den Server genügt weiterhin Node.js 18.

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
2. Schülerinnen und Schüler klicken ihre Rollenkarte an und behalten diese Rolle in allen drei Phasen.
3. In Phase 1 schreiben Mitarbeitende freie Zettel. Meister vermitteln jeden Brief von Hand.
4. In Phase 2 erhalten die Briefe die feste Struktur `Von · An · Text`; die Vermittlung bleibt manuell.
5. In Phase 3 werden Adressen und Namensvermittlung verwendet. Diese Phase entspricht der bisherigen Simulation.

Die Lehrkraft schaltet die Phase für alle Geräte gleichzeitig um. In Phase 1 und 2 können Meister einen wartenden Brief mit einem Klick an eine Person im eigenen Raum oder einen direkt verbundenen Meister weitergeben. Alle Teilnehmenden sehen eine gemeinsame Übersicht mit aktuellen Briefhaltern, Warteschlangen und bisherigen Wegen. Die Oberfläche zeigt dabei nicht, welche Weiterleitung richtig wäre.

In Phase 1 und 2 sehen alle die beobachtbare Gesamtübersicht. In Phase 3 zeigt die Schüleransicht ausschließlich den eigenen Raum. Namensvermittler sehen dann zusätzlich die Namensvermittler der anderen Räume und deren Adressen, sobald diese online sind. Die vollständige Router-Topologie der Adressphase ist nur in der Lehreransicht sichtbar.

Adressen werden pro Router automatisch als `Router.Teilnehmer` vergeben, z. B. `2.3`. Nachrichten werden serverseitig über die im Rollenspiel vorgegebene Router-Topologie protokolliert. Der Server speichert nur die aktuelle Runde im Arbeitsspeicher; beim Neustart ist sie leer.
