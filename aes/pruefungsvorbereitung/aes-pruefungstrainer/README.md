# AES-Prüfungstrainer

Übungs-App zur schriftlichen Realschulabschlussprüfung im Fach Alltagskultur, Ernährung, Soziales (AES) in Baden-Württemberg. Die Inhalte folgen den Schwerpunkten für 2027 aus den Ausführungsbestimmungen des Kultusministeriums (Stand 2025/26). Die Prüfung wird auf Papier geschrieben, der Trainer übt das Wissen und das Arbeiten mit Etiketten, Fällen und Grafiken.

**Module**

1. **Etiketten-Detektiv** – zufällig erzeugte erfundene Packungen mit Vorderseite und Rückseite: Grundpreis, Zucker pro Packung, Allergene, fehlende Pflichtangabe, Pyramide, Werbeversprechen, Siegel, Qualitätsfächer, Gentechnik, Nutri-Score, Nahrungsergänzungsmittel.
2. **Fall-Trainer** – Versicherungen zuordnen (schwer mit Fallen wie eigenem Schaden oder Absicht), Budget, Ratenkauf, Wohnen, Schulden.
3. **Grafik-Check** – zufällige Kreis-, Balken- und Liniendiagramme: ablesen, Kernaussage, Zusammenhang, begründen und prüfen, was die Grafik nicht belegt.
4. **Wissens-Sprint** – Runden mit 8 Karten zu 12 Themen, auch zum Siegel-Erkennen mit verdecktem Schriftzug. Unsichere Karten kommen öfter (Lernkartei). Auf Stufe schwer formuliert man selbst und hakt die Punkte ehrlich ab.

**Für alle Module**

- Stufen leicht / mittel / schwer.
- „Prüfen“ ist nach einer falschen Antwort 10 Sekunden gesperrt (`LOCK_SECONDS`). Punkte zählen nur beim ersten Versuch. „Lösung zeigen“ erscheint nach zwei Fehlversuchen.
- Der Reiter „Stand“ zeigt den Fortschritt. Er liegt nur im Browser des Geräts und lässt sich per Code auf ein anderes Gerät übertragen.

**Einsatz:** Über GitHub Pages öffnen und auf dem iPhone oder iPad in Safari mit „Teilen“ → „Zum Home-Bildschirm“ installieren, unter Windows in Edge oder Chrome mit „App installieren“. Danach läuft der Trainer offline (`sw.js`, `manifest.webmanifest`). Auf dem Computer funktioniert auch ein Doppelklick auf `index.html`, dann aber ohne Offline-Speicher.

**Quellen und Rechte**

- Alle Marken, Produkte, Personen und Zahlen in den Aufgaben sind erfunden. Originalaufgaben und SchulLV-Lösungen sind bewusst nicht enthalten, da Prüfungsaufgaben nicht im Internet veröffentlicht werden dürfen.
- Die Siegel sind vereinfacht nachgezeichnet und dienen nur dem Erkennen beim Lernen. Es sind nicht die Originalzeichen, die Rechte daran liegen bei den Inhabern.
- Ernährungsempfehlungen nach DGE „Gut essen und trinken“ (2024) und der BZfE-Ernährungspyramide.

**Bewusste Abweichungen von alten Lösungen**

- „10 Regeln der DGE“ fehlen, weil sie 2024 ersetzt wurden.
- Bei Milch gelten 2 Portionen täglich (DGE und Darstellung der neuen Pyramide), nicht 3.
- Bei Hackfleisch steht das Verbrauchsdatum, nicht das Mindesthaltbarkeitsdatum.
- Funktionelle Lebensmittel fehlen, weil sie nicht mehr zu den Schwerpunkten gehören.

Die Inhalte wurden aus den Prüfungsaufgaben 2021–2026 abgeleitet und sollten mit dem Unterricht abgeglichen werden. Das Logo der Fair Wear Foundation ist frei nachempfunden, weil es in den Unterlagen nicht abgebildet war.
