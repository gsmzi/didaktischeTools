# Didaktische Tools

Interaktive Werkzeuge und Programmierbeispiele für den Unterricht, sortiert nach **Fach → Thema → Tool**.

Die HTML-Tools sind eigenständige Dateien ohne Abhängigkeiten. Man kann sie direkt im Browser öffnen oder über GitHub Pages aufrufen.

## Katalog

### Informatik

| Thema | Tool | Stufe | Art | Online |
|---|---|---|---|---|
| Daten und Codierung | [Zweierkomplement](informatik/daten-und-codierung/zweierkomplement/) | Sek II | Interaktive Visualisierung | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/daten-und-codierung/zweierkomplement/) |
| Algorithmen und Programmierung | [for-Schleifen-Puzzle](informatik/algorithmen-und-programmierung/for-schleifen-puzzle/) | Kl. 9 (IMP) | Puzzle | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/algorithmen-und-programmierung/for-schleifen-puzzle/) |
| Algorithmen und Programmierung | [Zählschleifen-Training](informatik/algorithmen-und-programmierung/zaehlschleifen-training/) | Kl. 9 (IMP) | Übungsaufgaben (zufällig erzeugt) | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/algorithmen-und-programmierung/zaehlschleifen-training/) |
| Bildverarbeitung | [Pixel-Trainer](informatik/bildverarbeitung/pixel-trainer/) | Kl. 10 (IMP) | Übungsaufgaben (zufällig erzeugt) | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/bildverarbeitung/pixel-trainer/) |
| Bildverarbeitung | [Faltungs-Trainer](informatik/bildverarbeitung/faltungs-trainer/) | Kl. 10 (IMP) | Übungsaufgaben (zufällig erzeugt) | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/bildverarbeitung/faltungs-trainer/) |
| Datenstrukturen | [ADT-Programmierbeispiele](informatik/datenstrukturen/adt-programmierbeispiele/) | Kursstufe | Processing-Vorlagen + Lösungen | – |
| Netze und Internet | [Internet-Simulator (Palastnetzwerk)](informatik/netze-und-internet/internet-simulator/) | Kl. 7 (IuM) | Client-Server-Rollenspiel im Klassennetz | – (lokaler Node.js-Server) |
| Technische Informatik | [Mehrbit-Addierer](informatik/technische-informatik/mehrbit-addierer/) | Sek II | Interaktive Visualisierung | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/technische-informatik/mehrbit-addierer/) |
| Technische Informatik | [RS-Flipflop](informatik/technische-informatik/rs-flipflop/) | Sek II | Interaktive Visualisierung | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/technische-informatik/rs-flipflop/) |

### Chemie

| Thema | Tool | Stufe | Art | Online |
|---|---|---|---|---|
| Energetik | [Gibbs-Helmholtz-Explorer](chemie/energetik/gibbs-helmholtz/) | Kursstufe (LF) | Interaktive Visualisierung + Übungsaufgaben | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/chemie/energetik/gibbs-helmholtz/) |

### Mathematik

| Thema | Tool | Stufe | Art | Online |
|---|---|---|---|---|
| Aussagenlogik | [Aussagenlogik-Trainer](mathematik/aussagenlogik/aussagenlogik-trainer/) | Kl. 10 (IMP) | Übungsaufgaben (zufällig erzeugt) | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/mathematik/aussagenlogik/aussagenlogik-trainer/) |

## Struktur

```
<fach>/<thema>/<tool-name>/
├── index.html   (bei Web-Tools: das Tool selbst)
└── README.md    (Lernziel, Stufe, Hinweise zum Einsatz)
```

Ordnernamen sind klein geschrieben, ohne Umlaute und mit Bindestrichen, damit sie als Web-Adressen funktionieren.

## Lizenz

Material, das auf Vorlagen anderer Autorinnen und Autoren beruht, nennt die Quelle und Lizenz im README des jeweiligen Ordners.

## Neues Tool hinzufügen

1. Einen Ordner `fach/thema/tool-name/` anlegen. Ein neues Fach oder Thema bekommt einfach einen neuen Ordner.
2. Web-Tools als `index.html` ablegen.
3. Eine kurze `README.md` mit Lernziel und Stufe schreiben.
4. Eine Zeile in den Katalog oben eintragen.
