# Didaktische Tools

Interaktive Werkzeuge und Programmierbeispiele für den Unterricht, sortiert nach **Fach → Thema → Tool**.

Die HTML-Tools sind eigenständige Dateien ohne Abhängigkeiten. Man kann sie direkt im Browser öffnen oder über GitHub Pages aufrufen.

## Katalog

### Informatik

| Thema | Tool | Stufe | Art | Online |
|---|---|---|---|---|
| Daten und Codierung | [Zweierkomplement](informatik/daten-und-codierung/zweierkomplement/) | Sek II | Interaktive Visualisierung | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/daten-und-codierung/zweierkomplement/) |
| Algorithmen und Programmierung | [for-Schleifen-Puzzle](informatik/algorithmen-und-programmierung/for-schleifen-puzzle/) | Kl. 9 (IMP) | Puzzle | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/algorithmen-und-programmierung/for-schleifen-puzzle/) |
| Datenstrukturen | [ADT-Programmierbeispiele](informatik/datenstrukturen/adt-programmierbeispiele/) | Kursstufe | Processing-Vorlagen + Lösungen | – |
| Technische Informatik | [Mehrbit-Addierer](informatik/technische-informatik/mehrbit-addierer/) | Sek II | Interaktive Visualisierung | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/technische-informatik/mehrbit-addierer/) |
| Technische Informatik | [RS-Flipflop](informatik/technische-informatik/rs-flipflop/) | Sek II | Interaktive Visualisierung | [▶ öffnen](https://gsmzi.github.io/didaktischeTools/informatik/technische-informatik/rs-flipflop/) |

## Struktur

```
<fach>/<thema>/<tool-name>/
├── index.html   (bei Web-Tools: das Tool selbst)
└── README.md    (Lernziel, Stufe, Hinweise zum Einsatz)
```

Ordnernamen sind klein geschrieben, ohne Umlaute und mit Bindestrichen, damit sie als Web-Adressen funktionieren.

## Neues Tool hinzufügen

1. Einen Ordner `fach/thema/tool-name/` anlegen. Ein neues Fach oder Thema bekommt einfach einen neuen Ordner.
2. Web-Tools als `index.html` ablegen.
3. Eine kurze `README.md` mit Lernziel und Stufe schreiben.
4. Eine Zeile in den Katalog oben eintragen.
