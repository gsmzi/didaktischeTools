# Pixel-Trainer

Interaktive Übungsseite zu Bildern als zweidimensionale Arrays: Spiegeln, Drehen, Koordinaten, Farbanteile und Graustufen. Alle Aufgaben werden zufällig erzeugt.

Passend zur Unterrichtseinheit *Digitale Bildbearbeitung* in IMP, Klasse 10 (Blätter 01_alg_bilderalsarray und 02_alg_farbmodell, siehe [imp10-bildbearbeitung](../imp10-bildbearbeitung/)), und zur Vorbereitung auf die Klassenarbeit (Bearbeitung dort auf Papier). Der Code entspricht der aktuellen Processing-Vorlage: `color[][]`, `pixel[x][y]`, Breite `pixel.length`, Höhe `pixel[0].length`, neues Ergebnisarray `pixelNeu`.

**Aufgabentypen**

1. Code → Bild – Methode lesen, Ergebnisbild wählen (mit Erklärung des Denkfehlers) bzw. ins Raster eintragen; schwer zusätzlich Breite und Höhe angeben
2. Bild → Code – Arraygröße und beide Indizes wählen; geprüft wird durch Ausführen, auch eine ArrayIndexOutOfBoundsException wird erkannt
3. Koordinaten – neue Bildgröße, „Woher kommt Pixel (x|y)?“, „Wohin wandert Pixel (i|j)?“ bei größeren Bildern
4. Farben rechnen – Graustufen (Durchschnitt, Min, Max, natürlich), Invertieren, Faktoren mit Kappen, Hexcode ↔ RGB, „heller bei gleichem Farbton“
5. Lückenprogramm – Spiegeln/Drehen, Graustufen, invertiere, Kappen aus farbaenderung; Ablenker mit gezielter Rückmeldung, wechselnde Schleifenreihenfolge

**Für alle Aufgabentypen**

- **Stufen** leicht / mittel / schwer: Spiegeln und 180° · zusätzlich Drehen um 90° · zusätzlich Spiegeln an den Diagonalen und größere Bilder.
- **Erst vorhersagen** (zuschaltbar, Code → Bild): erst auf Papier skizzieren, dann die Auswahl zeigen.
- **Begriffe** (aufklappbar), u. a. Breite/Höhe, Ergebnisarray, Index-Fehler, RGB, Hexcode, Kappen; Hinweis, dass Methoden in Processing in `setup()` aufgerufen werden müssen.

Die Seite führt nur die Indexlogik und die Farbrechnungen aus, kein vollständiges Processing. Der Lernfortschritt wird nur im Browser gespeichert.

**Einsatz:** [index.html](index.html) im Browser öffnen, keine Installation nötig.
