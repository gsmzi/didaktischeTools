---
name: didaktische-tools
description: Erfahrungswerte und Konventionen für die interaktiven Unterrichtstools in diesem Repository (Trainer, Simulationen, Visualisierungen in eigenständigen HTML-Dateien). Immer nutzen, wenn ein Tool neu gebaut, geändert, erweitert oder getestet wird, auch bei kleinen Wünschen zu Layout, Rückmeldung, Aufgabengenerator, Prüfen-Button oder Schreibweisen, und auch wenn das Wort „Tool“ nicht fällt (z. B. „beim Pixel-Trainer sollte …“, „im Flipflop fehlt …“). Nicht für Arbeitsblätter oder Klausuren, dafür gibt es unterrichtsmaterial-zimmer und klausurerstellung.
---

# Didaktische Tools

Die Tools werden von Schülerinnen und Schülern selbstständig genutzt, meist zur Vorbereitung auf eine Klassenarbeit auf Papier. Ein Tool ist dann gut, wenn man nur durch Nachdenken ans Ziel kommt. Alle Regeln unten folgen daraus.

Die Regeln stammen aus Rückmeldungen von M. Zimmer. Ältere Tools erfüllen nicht alle davon. Bei einer Änderung gilt: das Gewünschte umsetzen und auf andere Tools mit demselben Problem hinweisen, sie aber nicht ungefragt mitändern.

## Lösungen dürfen nicht erratbar sein

Vor dem Fertigstellen fragen: Wie käme jemand ohne Nachdenken zur Lösung? Typische Schlupflöcher:

- **Durchklicken:** Nach einer falschen Antwort ist „Prüfen“ 10 Sekunden gesperrt, mit Countdown auf dem Button. Muster siehe unten.
- **Rückmeldung verrät die Lösung:** Wenn jede falsche Zelle rot wird, reicht es, überall 1 einzutragen und die roten Zellen umzudrehen. Daher so grob wie möglich zurückmelden, z. B. nur die erste falsche Spalte nennen. Die Rückmeldung soll trotzdem helfen und sagen, wo man weiterdenken muss.
- **Unvollständige Eingaben:** Sie werden weder gewertet noch gefärbt und lösen keine Sperre aus. Es kommt nur ein Hinweis wie „Es sind noch 15 Zellen leer.“ Färbung vor dieser Prüfung ist ein Leck, weil es ohne Sperre Teilergebnisse verrät.
- **Hilfen im Aufgabenmodus:** Animationen oder Anzeigen, die das Ergebnis zeigen, sind dort klar gesperrt. Gesperrtes nennt den Grund oder die Restzeit, sonst wirkt es wie ein Fehler.
- **Selbst bestimmen statt ablesen:** Was geübt werden soll, wird abgefragt und nicht vorgegeben. Auf Stufe schwer darf mehr selbst bestimmt werden als auf leicht.
- **Aufbau der Aufgabe verrät die Lösung:** Schon die Auswahl der Felder darf nichts zeigen, z. B. welche Atome sich ändern. Auf Stufe schwer kommen deshalb Ablenker dazu.
- **Auswahlmöglichkeiten:** Keine doppelten Optionen, und die Reihenfolge verrät nichts.

Punkte zählen nur beim ersten Versuch.

## Sperre von „Prüfen“

So umgesetzt im Aussagenlogik- und im Pixel-Trainer (dort in `count(ok)`, das bei jeder gewerteten Antwort läuft). Andere Trainer prüfen anders aufgebaut; dann die Stelle suchen, an der eine falsche Antwort gewertet wird.

```js
const LOCK_SECONDS = 10;
let lockTimer = null;
function unlockCheck() { clearInterval(lockTimer); const b = $('#check'); b.disabled = false; b.textContent = 'Prüfen'; }
function lockCheck() {
  unlockCheck();
  const b = $('#check'); let left = LOCK_SECONDS;
  const show = () => { b.textContent = `Prüfen (${left} s)`; };
  b.disabled = true; show();
  lockTimer = setInterval(() => { if (--left > 0) show(); else unlockCheck(); }, 1000);
}
```

Dazu `if (!ok) lockCheck();` beim Werten, `unlockCheck();` am Anfang von `newTask()` (eine neue Aufgabe hebt die Sperre auf, das Warten hätte dann keinen Zweck) und `.btn:disabled{opacity:.55;cursor:not-allowed}` im CSS. Tipp und Eingaben bleiben während der Sperre bedienbar.

## Bedienung

- **Die Aufgabe bleibt beim Antworten sichtbar.** Keine aufklappenden Menüs mit vielen Einträgen, denn sie legen sich über die Aufgabe. Längere Auswahlen stehen als feste Liste daneben (ab 800 px Breite zwei Spalten, darunter untereinander mit eigenem Scrollbereich; Muster: `.work.two` und `.lawpick` im Aussagenlogik-Trainer).
- Desktop und Handy müssen beide funktionieren, ohne waagerechtes Scrollen der Seite. Lange Terme und Formeln dürfen in schmalen Spalten umbrechen. Grid-Spalten mit `minmax(0,1fr)` und `min-width:0` anlegen, denn `1fr` wird nicht schmaler als der Inhalt; breite Teile scrollen in ihrem eigenen Panel.
- Aufbau der Trainer: Reiter für Aufgabentypen, Stufen leicht / mittel / schwer (nur das for-Schleifen-Puzzle: Einfach / Mittel / Profi), Aufgabe, Knöpfe „Prüfen“, „Tipp“, „Neue Aufgabe“, Rückmeldung, aufklappbare Begriffe. Punktestand nur in `localStorage`, Zugriffe in `try/catch`.
- **Die Stufenwahl muss auffallen,** z. B. als eigener Block mit Karten direkt über der Aufgabe (Muster: for-Schleifen-Puzzle). Einen kleinen Umschalter in der Kopfzeile haben dort alle Lernenden übersehen.
- Bei festen Aufgabensätzen bekommt jede Stufe eigene Aufgaben, damit man die Stufen nacheinander lösen kann.
- Löschende Knöpfe (Leeren, Zurücksetzen) stehen weit weg von oft benutzten Knöpfen, weil sie sonst versehentlich getroffen werden.
- Neue Tools unterstützen den Dunkelmodus über CSS-Variablen.

## Fachliche Schreibweisen

Das Tool richtet sich nach dem Unterricht und der Klassenarbeit, nicht nach der üblichsten Schreibweise. Bei Abweichungen nachfragen.

- Keine zwei Vorzeichen oder Negationen ohne Klammer hintereinander: `¬(¬a)` statt `¬¬a`, wie in Mathe bei zwei Minuszeichen. Eingaben von Lernenden dürfen großzügiger sein als die Ausgabe des Tools.
- Im gezeigten Code steht `i=i+2` und `i=i-2`, nicht `i+=2` und `i-=2`; diese Kurzform ist im Unterricht nicht erwünscht. `i++` bleibt erlaubt.
- Nummerierungen und Namen (z. B. der Rechengesetze) wie in den Unterlagen der Klasse.
- Was nicht Inhalt der Klassenarbeit ist, wird als solches gekennzeichnet.
- Texte auf Deutsch mit echten Umlauten, die Lernenden werden geduzt, Rückmeldungen sind sachlich und ermutigend.
- Aufgaben werden nach Möglichkeit zufällig erzeugt. Antworten werden inhaltlich geprüft (alle Belegungen, Ausführen des Codes), nicht per Textvergleich. Gleichwertige Lösungen gelten als richtig.

## AES-Prüfungstrainer: Relevanzprüfung für die Abschlussprüfung 2027

Bei allen Aufgaben, Inhalten, Modulen und Erweiterungen des AES-Prüfungstrainers (`aes/pruefungsvorbereitung/aes-pruefungstrainer/`) muss zwingend beachtet werden, ob sie für die **Realschulabschlussprüfung 2027 in Baden-Württemberg** relevant sind (gemäß den amtlichen Ausführungsbestimmungen des Kultusministeriums Baden-Württemberg, Az. 33-6610-12/23/3):

- **Keine ungeprüfte Übernahme alter Aufgaben:** Aufgaben aus den Prüfungen 2021–2026 dürfen nur herangezogen werden, wenn die Inhalte durch die Schwerpunkte 2027 abgedeckt sind.
- **Verbindliche Schwerpunkte für 2027:**
  - **Pflichtteil A:**
    - *Ernährung & Gesundheit:* Aktuelle Produktionstechniken (Gentechnik); Labels (Bioland, demeter, EU-Biosiegel, Naturland, ohne Gentechnik, Fairtrade, Europäisches V-Label [vegan/vegetarisch], Nutri-Score); Werbeversprechen; Ernährungstrends (Nahrungsergänzungsmittel, vegetarische und vegane Ernährung); Consumer Citizenship.
    - *Lebensgestaltung & Konsum:* Formen des Zusammenlebens; Zusammenhang von Lebensstil, Konsumverhalten und nachhaltiger Entwicklung (Ressourcenschonung, Flächennutzungskonkurrenz, Tauschbörsen); Finanzmanagement im privaten Haushalt; Finanzielle Absicherung von Risiken (gesetzliche Sozialversicherungen, freiwillige Individualversicherungen: Privathaftpflichtversicherung, Berufsunfähigkeitsversicherung, Hausratversicherung, private Unfallversicherung).
  - **Wahlteil B:**
    - *Lernen durch Engagement:* Bürgerschaftliches Engagement als aktive Teilhabe in einer Demokratie für Einzelne und Gesellschaft.
    - *Ernährung:* Ernährungsbezogenes Wissen (bedarfsgerechte Ernährung, Energie- und Nährstoffträger); Ernährungsempfehlungen von BZfE und DGE (Stand 2024 / neue Ernährungspyramide mit 2 Milchportionen, „10 Regeln der DGE“ entfallen); Lebensmittelqualität beurteilen mit dem BZfE-Qualitätsfächer; alternative Ernährungsformen.
    - *Gesundheit:* WHO-Definition Gesundheit; persönliche Gesundheitsressourcen und Steigerungsmöglichkeiten; Körper und Körpergestaltungen (temporäre und permanente Körpergestaltungen, Funktionen von Bekleidung).
    - *Konsum:* Konsumentscheidungen, Marketing-/Verkaufsstrategien, Werbeversprechen; Qualitätsorientierung; Qualitätsinformationen und Produktkennzeichnungen (Grüner Knopf, Fair Wear Foundation [FWF], GOTS, Lebensmittelsiegel); Konsum in globalen Zusammenhängen (Wertschöpfungskette, ungleiche globale Handelsbeziehungen, Kinderarbeit, Billigprodukte, Umwelt); nachhaltiges Handeln (Ökologischer Fußabdruck).
    - *Lebensbewältigung und Lebensgestaltung:* Haushalt und Familie (unterschiedliche Formen der Arbeit); bewusste Freizeitgestaltung (Funktionen von Freizeit: Work-Life-Balance).
- **Themen, die für 2027 NICHT prüfungsrelevant sind (z. B. erst ab 2028 oder früher entfallen):**
  - Funktionelle Lebensmittel, proteinreiche Ernährung (erst ab 2028).
  - Tierwohlsiegel (erst ab 2028).
  - Kreditaufnahme / Chancen und Risiken / Überschuldung (erst ab 2028).
  - Medizinische Vorsorgemaßnahmen, Erste-Hilfe-/Sofortmaßnahmen (erst ab 2028).
  - Stressoren, Stressreaktionen, Stressmanagement (erst ab 2028).
  - Virtuelles Wasser, Recycling (erst ab 2028).
  - Verbraucherrechte, Onlinegeschäfte, Verbraucherschutzinstitutionen (erst ab 2028).
  - „10 Regeln der DGE“ (2024 durch neues DGE-Positionspapier/Lebensmittelkreis abgelöst).

## Technik und Ablage

- Eine eigenständige `index.html` ohne Abhängigkeiten und ohne Build-Schritt; sie muss per Doppelklick und über GitHub Pages laufen. Keine gemeinsamen JS-Dateien zwischen Tools, wiederkehrende Muster werden kopiert. Bestehende Ausnahmen: Internet-Simulator (braucht Node), Zählschleife-Übungen (laden Processing.js von einem CDN, laufen also nicht offline).
- Beim Ändern den Stil der Datei übernehmen, die Trainer sind kompakt geschrieben.
- Ordner `<fach>/<thema>/<tool-name>/`: klein, ohne Umlaute, mit Bindestrichen.
- Neues Tool: Schritte unter „Neues Tool hinzufügen“ in der Haupt-`README.md` (README im Ordner, Zeile im Katalog, Karte in der Start-`index.html`).
- Ändert sich das Verhalten für Lernende, die README des Tools mitpflegen.
- Material nach fremden Vorlagen nennt Quelle und Lizenz im README des Ordners.

## Testen

Vor dem Abschluss im eingebauten Browser mit der `file://`-Adresse prüfen, nicht nur den Code lesen:

- Zufällige Aufgaben per JavaScript in Masse erzeugen (einige hundert, alle Aufgabentypen und Stufen) und auf Fehler, Überlauf und unerwünschte Ausgaben durchsuchen. Die längsten Aufgaben zeigen sich meist erst auf Stufe schwer.
- Die Wege durchspielen: leer, unvollständig, falsch, richtig, neue Aufgabe, Wechsel von Stufe und Aufgabentyp.
- Desktop-Breite und Handy-Breite ansehen, Konsole auf Fehler prüfen.
- Im Abschlussbericht sagen, was tatsächlich getestet wurde und was nicht.

## Git

Direkt auf `main`, nur auf Wunsch committen und pushen; von dort geht es über GitHub Pages online. Commit-Nachrichten auf Deutsch im Stil `Tool-Name: was sich geändert hat`.

## Skill pflegen

Kommt eine neue Rückmeldung mit allgemeiner Bedeutung für die Tools, dem Nutzer vorschlagen, sie hier als kurze Regel mit Begründung aufzunehmen.
