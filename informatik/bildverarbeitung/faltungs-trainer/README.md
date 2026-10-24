# Faltungs-Trainer

Interaktive Übungsseite zur Faltung (Mehrpixeloperationen) in der digitalen Bildbearbeitung. Die Aufgaben werden zufällig erzeugt.

Passend zur Unterrichtseinheit *Digitale Bildbearbeitung* in IMP, Klasse 10, Blätter 03 „Faltung“ und 04 „Faltung – Puzzle“. Für Bilder als Arrays, Spiegeln, Drehen und Farben gibt es den [Pixel-Trainer](../pixel-trainer/).

**Aufgabentypen**

1. Ausprobieren – eigene Filtermatrix (auch Brüche wie 1/9) oder Vorlage auf Beispielbilder anwenden, Summe der Einträge, „alle Werte verdoppeln“ (wie Blatt 03, Aufgabe 4)
2. Ein Pixel berechnen – mit Rechenweg wie auf Blatt 03 und Rückmeldung zu typischen Fehlern (Matrix gekippt oder verkehrt angelegt, x und y vertauscht, Vorzeichen, Begrenzung, Runden statt Abschneiden)
3. Ausschnitt falten – alle inneren Pixel eines 5×5-Ausschnitts, Randpixel bleiben
4. Filter erkennen – Wirkung einer Matrix wählen bzw. (schwer) aus Original und Ergebnis die Matrix bestimmen
5. Summe der Einträge – Wirkung auf ein einfarbiges Bild (Blatt 03, Aufgabe 6)
6. Methode faltung verstehen – `laenge`, `halb`, Schleifengrenzen, `xx`/`yy` und Pixelkoordinaten zu `filter[i][j]` (Blatt 04, Aufgabe 8)

**Stufen** leicht / mittel / schwer: Filter mit 0, 1, 2 und kleinen Intensitäten · auch negative Einträge (Kanten, Schärfen, Relief) · Intensitäten 0…255 mit Begrenzung und `(int)` wie in der Methode `faltung`.

Konventionen wie auf den Blättern: Die obere Zeile der Matrix gehört zu den Pixeln darüber, Randpixel bleiben unverändert. Hinweis für die Lehrkraft: Im Puzzle-Code gehört `i` in `filter[i][j]` zur x-Richtung; eine in Java zeilenweise notierte Matrix wird dort also gespiegelt an der Diagonale angewendet. Bei symmetrischen Filtern ändert das nichts, bei Kantenfiltern tauschen „waagerecht“ und „senkrecht“. Stufe schwer von Typ 6 weist darauf hin.

Die Beispielbilder werden im Browser gezeichnet, es gibt keine externen Dateien. Der Lernfortschritt wird nur im Browser gespeichert.

**Einsatz:** [index.html](index.html) im Browser öffnen, keine Installation nötig.
