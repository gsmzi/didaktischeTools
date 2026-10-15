/**
 * Hauptprogramm: p03_listenvarianten_benchmark (Musterlösung)
 * 
 * Bietet eine interaktive Umgebung zum Vergleich von Listen und Sortieralgorithmen:
 * - Listenvarianten: ListeMitArray, ListeIterativ (Verkettung), ListeMitEnde (Verkettung+Endezeiger)
 * - Sortierverfahren: InsertionSort, SelectionSort, MergeSort
 * 
 * Features:
 * - Gesamt-Benchmark: Führt alle 9 Kombinationen für ein gewähltes N aus und zeichnet
 *   Balkendiagramme der Laufzeiten, Lesezugriffe und Schreibzugriffe.
 * - Live-Sortierung: Visualisiert den Sortiervorgang von 30 Elementen live als Balkendiagramm,
 *   wobei aktive Indizes farbig hervorgehoben werden (animiert im Hintergrund-Thread).
 * - Große Menüknöpfe (140% Skalierung), Zoom, Scroll-Unterstützung und Log-Konsole.
 * 
 * @author Antigravity
 * @version September 2026
 */

// Listeninstanzen für den Benchmark
ListeMitArray<Integer> arrayList;
ListeIterativ<Integer> linkedList;
ListeMitEnde<Integer> tailList;

// Benchmark-Ergebnisse (3 Algorithmen x 3 Listen)
// Indizes: [Algo: 0=Insertion, 1=Selection, 2=Merge][List: 0=Array, 1=Linked, 2=Tail]
BenchmarkResult[][] ergebnisse = new BenchmarkResult[3][3];

// Benchmark-Parameter
int [] nOptionen = { 10, 50, 100, 500, 1000 };
int nAuswahlIndex = 2; // Standard: N = 100
int anzeigeModus = 0;  // 0 = Laufzeit (ms), 1 = Lese-Zugriffe, 2 = Schreib-Zugriffe
boolean benchmarkAusgefuehrt = false;

// Live-Sortierdaten (N = 30)
int[] liveDaten = new int[30];
boolean liveSortieren = false;
int liveAktiverIndex = -1;
int liveVergleichsIndex = -1;
int liveVerzoegerung = 40; // in ms
SortThread aktiverSortThread = null;

// Ausgewählte Kombination für Live-Sortierung
int liveAlgoIndex = 0; // 0=Insertion, 1=Selection, 2=Merge

// Ansichtsmodus
boolean imLiveModus = false; // true = Live-Sortierung, false = Benchmark-Charts

// Zoom und Scrollen
float zoomFaktor = 1.0;
float scrollX = 0;
float scrollY = 0;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnN10, btnN50, btnN100, btnN500, btnN1000;
Button btnShowZeit, btnShowLese, btnShowSchreib;
Button btnStartBenchmark;
Button btnSwitchModus;
Button btnStartLiveSort;
Button btnAlgoInsert, btnAlgoSelect, btnAlgoMerge;
Button btnZoomDec, btnZoomInc;

void setup()
{
    size(1350, 700);
    surface.setResizable(true);
    
    // Listen instanziieren
    arrayList = new ListeMitArray<Integer>();
    linkedList = new ListeIterativ<Integer>();
    tailList = new ListeMitEnde<Integer>();
    
    // Live-Daten mit Zufallszahlen initialisieren
    liveDatenGenerieren();
    
    // Zoom-Koordinaten initial zentrieren
    scrollX = 40;
    scrollY = 180;
    
    // UI-Buttons initialisieren
    color colAktiv = color(16, 185, 129);      // Smaragdgrün
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    color colOrange = color(245, 158, 11);     // Orange
    
    // N-Auswahl
    btnN10 = new Button(50, 95, 40, 25, "10", colStandard);
    btnN50 = new Button(95, 95, 40, 25, "50", colStandard);
    btnN100 = new Button(140, 95, 40, 25, "100", colAktiv);
    btnN500 = new Button(185, 95, 40, 25, "500", colStandard);
    btnN1000 = new Button(230, 95, 45, 25, "1000", colStandard);
    
    // Anzeige-Modus
    btnShowZeit = new Button(310, 95, 100, 25, "Zeit (ms)", colAktiv);
    btnShowLese = new Button(415, 95, 100, 25, "Lese-Zugriffe", colStandard);
    btnShowSchreib = new Button(520, 95, 100, 25, "Schreib-Zugriffe", colStandard);
    
    // Aktionen
    btnStartBenchmark = new Button(650, 95, 170, 25, "Benchmark starten", colAktion);
    btnSwitchModus = new Button(830, 95, 150, 25, "Wechsle Modus", colOrange);
    
    // Zoom
    btnZoomDec = new Button(1000, 95, 25, 25, "-", colStandard);
    btnZoomInc = new Button(1060, 95, 25, 25, "+", colStandard);
    
    // Live-Sortier-GUI
    btnStartLiveSort = new Button(300, 135, 140, 25, "Live-Sort starten", colAktiv);
    btnAlgoInsert = new Button(470, 135, 100, 25, "InsertionSort", colAktiv);
    btnAlgoSelect = new Button(575, 135, 100, 25, "SelectionSort", colStandard);
    btnAlgoMerge = new Button(680, 135, 100, 25, "MergeSort", colStandard);
    
    logHinzufuegen("Listen-Benchmark gestartet. Wähle N und klicke 'Benchmark starten'.");
}

void draw()
{
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate
    
    pushMatrix();
    scale(GUI_SCALE);
    
    // 1. Header
    fill(30, 41, 59);
    noStroke();
    rect(0, 0, w, 70);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text("Didaktische Analyse: Listenvarianten & Sortier-Benchmark", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Vergleich von ArrayList vs. Linked Chain vs. Tail Pointer anhand von O(N²) & O(N log N) Algorithmen", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.1 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Modus-Badge
    fill(imLiveModus ? color(245, 158, 11, 40) : color(16, 185, 129, 40));
    stroke(imLiveModus ? color(245, 158, 11) : color(16, 185, 129));
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text("MODUS: " + (imLiveModus ? "LIVE-SORTIERUNG (N=30)" : "BENCHMARK-DIAGRAMME"), w - 130, 34);
    
    // 2. Control Panel
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, imLiveModus ? 90 : 50, 8);
    
    // Update Button Farben
    btnN10.col = (nAuswahlIndex == 0) ? color(16, 185, 129) : color(51, 65, 85);
    btnN50.col = (nAuswahlIndex == 1) ? color(16, 185, 129) : color(51, 65, 85);
    btnN100.col = (nAuswahlIndex == 2) ? color(16, 185, 129) : color(51, 65, 85);
    btnN500.col = (nAuswahlIndex == 3) ? color(16, 185, 129) : color(51, 65, 85);
    btnN1000.col = (nAuswahlIndex == 4) ? color(16, 185, 129) : color(51, 65, 85);
    
    btnShowZeit.col = (anzeigeModus == 0) ? color(16, 185, 129) : color(51, 65, 85);
    btnShowLese.col = (anzeigeModus == 1) ? color(16, 185, 129) : color(51, 65, 85);
    btnShowSchreib.col = (anzeigeModus == 2) ? color(16, 185, 129) : color(51, 65, 85);
    
    btnAlgoInsert.col = (liveAlgoIndex == 0) ? color(245, 158, 11) : color(51, 65, 85);
    btnAlgoSelect.col = (liveAlgoIndex == 1) ? color(245, 158, 11) : color(51, 65, 85);
    btnAlgoMerge.col = (liveAlgoIndex == 2) ? color(245, 158, 11) : color(51, 65, 85);
    
    // Buttons zeichnen
    if (!imLiveModus) {
        btnN10.zeichnen();
        btnN50.zeichnen();
        btnN100.zeichnen();
        btnN500.zeichnen();
        btnN1000.zeichnen();
        
        btnShowZeit.zeichnen();
        btnShowLese.zeichnen();
        btnShowSchreib.zeichnen();
        
        btnStartBenchmark.zeichnen();
    } else {
        btnStartLiveSort.zeichnen();
        btnAlgoInsert.zeichnen();
        btnAlgoSelect.zeichnen();
        btnAlgoMerge.zeichnen();
        
        fill(255);
        textSize(11);
        textAlign(LEFT, CENTER);
        text("Wähle Sortierverfahren:", 50, 147);
    }
    
    btnSwitchModus.zeichnen();
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Zoom-Wert zeichnen
    fill(255);
    textSize(11);
    textAlign(CENTER, CENTER);
    text(round(zoomFaktor * 100) + "%", 1042, 107);
    
    // 3. Visualisierungsbereich
    pushMatrix();
    translate(scrollX, scrollY);
    scale(zoomFaktor);
    
    if (!imLiveModus)
    {
        // Zeichne Benchmark-Charts
        diagrammZeichnen(0, 0, w - 100, h - 380);
    }
    else
    {
        // Zeichne Live-Sortiervorgang
        liveSortierungZeichnen(0, 0, w - 100, h - 340);
    }
    popMatrix();
    
    // Scroll-Hinweis
    fill(148, 163, 184, 150);
    textSize(11);
    textAlign(RIGHT, BOTTOM);
    text("↔↕ Ziehe mit der Maus im Zeichenbereich zum Verschieben", w - 30, h - 130);
    
    // 4. Log-Konsole (unten)
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, h - 120, w - 60, 95, 8);
    
    fill(51, 65, 85);
    rect(30, h - 120, w - 60, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(10);
    textAlign(LEFT, CENTER);
    text("BENCHMARK PROTOKOLL & AKTIONSLOG", 45, h - 110);
    
    textSize(12);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 50, h - 90 + i * 16);
    }
    
    popMatrix();
}

/**
 * Zeichnet das Benchmark-Vergleichsdiagramm.
 */
void diagrammZeichnen(float x, float y, float w, float h)
{
    if (!benchmarkAusgefuehrt)
    {
        fill(100, 116, 139);
        textSize(15);
        textAlign(CENTER, CENTER);
        text("Noch keine Benchmark-Daten vorhanden.\nKlicke oben auf 'Benchmark starten', um alle 9 Messungen durchzuführen.", w / 2, h / 2);
        return;
    }
    
    // Bestimme den Maximalwert für die Skalierung
    double maxWert = 0.0001; // Verhindert Division durch 0
    for (int a = 0; a < 3; a++) {
        for (int l = 0; l < 3; l++) {
            double wert = 0;
            if (anzeigeModus == 0) wert = ergebnisse[a][l].zeitMs;
            else if (anzeigeModus == 1) wert = ergebnisse[a][l].leseZugriffe;
            else if (anzeigeModus == 2) wert = ergebnisse[a][l].schreibZugriffe;
            
            if (wert > maxWert) maxWert = wert;
        }
    }
    
    // Titel des Diagramms
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    String einheit = (anzeigeModus == 0) ? "Laufzeit in Millisekunden (ms)" : ((anzeigeModus == 1) ? "Anzahl der Lese-Zugriffe (Knoten/Array)" : "Anzahl der Schreib-Zugriffe (Kopieren/Zuweisen)");
    text("Ergebnisse für N = " + nOptionen[nAuswahlIndex] + " (" + einheit + ")", w / 2, y - 25);
    
    // Zeichne Achsen
    stroke(71, 85, 105);
    strokeWeight(2);
    float diagrammLinks = x + 120;
    float diagrammUnten = y + h - 50;
    float diagrammRechts = x + w - 240;
    float diagrammOben = y + 20;
    
    line(diagrammLinks, diagrammOben, diagrammLinks, diagrammUnten); // Y-Achse
    line(diagrammLinks, diagrammUnten, diagrammRechts, diagrammUnten); // X-Achse
    
    // Hilfslinien & Skalierung
    int hilfslinienCount = 4;
    stroke(51, 65, 85, 100);
    strokeWeight(1);
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, CENTER);
    for (int i = 0; i <= hilfslinienCount; i++) {
        float hY = lerp(diagrammUnten, diagrammOben, (float)i / hilfslinienCount);
        line(diagrammLinks - 5, hY, diagrammRechts, hY);
        double wert = maxWert * i / hilfslinienCount;
        
        String formatWert;
        if (anzeigeModus == 0) formatWert = nf((float)wert, 1, 2) + " ms";
        else formatWert = nfc((int)wert);
        
        text(formatWert, diagrammLinks - 10, hY);
    }
    
    // Algorithmen-Gruppen auf der X-Achse zeichnen
    String[] algos = { "InsertionSort", "SelectionSort", "MergeSort" };
    String[] listen = { "Array-Liste", "Verkettung", "Verkettung+Ende" };
    color[] listenFarben = { color(16, 185, 129), color(59, 130, 246), color(139, 92, 246) };
    
    float gruppenBreite = (diagrammRechts - diagrammLinks) / 3;
    float barBreite = gruppenBreite / 5;
    
    for (int a = 0; a < 3; a++)
    {
        float gruppeX = diagrammLinks + a * gruppenBreite;
        
        // Gruppenüberschrift (Algorithmus)
        fill(255);
        textSize(12);
        textAlign(CENTER, TOP);
        text(algos[a], gruppeX + gruppenBreite / 2, diagrammUnten + 10);
        
        // 3 Balken für die 3 Listenvarianten zeichnen
        for (int l = 0; l < 3; l++)
        {
            double wert = 0;
            if (anzeigeModus == 0) wert = ergebnisse[a][l].zeitMs;
            else if (anzeigeModus == 1) wert = ergebnisse[a][l].leseZugriffe;
            else if (anzeigeModus == 2) wert = ergebnisse[a][l].schreibZugriffe;
            
            float balkenHoehe = (float)(wert / maxWert * (diagrammUnten - diagrammOben));
            float balkenX = gruppeX + (l + 1) * barBreite;
            float balkenY = diagrammUnten - balkenHoehe;
            
            // Balken zeichnen
            fill(listenFarben[l]);
            stroke(255, 30);
            rect(balkenX, balkenY, barBreite - 5, balkenHoehe, 4, 4, 0, 0);
            
            // Text über Balken zeichnen
            fill(226, 232, 240);
            textSize(8);
            textAlign(CENTER, BOTTOM);
            String txt;
            if (anzeigeModus == 0) {
                txt = wert < 0.01 ? "<0.01ms" : nf((float)wert, 1, 2) + "ms";
            } else {
                txt = nfc((int)wert);
            }
            // Zeige Text nur, wenn Balken nicht zu nah beieinander
            text(txt, balkenX + (barBreite - 5)/2, balkenY - 2);
        }
    }
    
    // Legende zeichnen
    float legendeX = diagrammRechts + 30;
    float legendeY = diagrammOben;
    fill(30, 41, 59, 200);
    stroke(51, 65, 85);
    rect(legendeX, legendeY, 180, 75, 6);
    
    for (int l = 0; l < 3; l++)
    {
        fill(listenFarben[l]);
        noStroke();
        rect(legendeX + 10, legendeY + 10 + l * 20, 12, 12, 3);
        
        fill(241, 245, 249);
        textSize(10);
        textAlign(LEFT, CENTER);
        text(listen[l], legendeX + 30, legendeY + 16 + l * 20);
    }
}

/**
 * Zeichnet die Live-Sortier-Balkengrafik.
 */
void liveSortierungZeichnen(float x, float y, float w, float h)
{
    fill(241, 245, 249);
    textSize(14);
    textAlign(CENTER, TOP);
    String algoName = (liveAlgoIndex == 0) ? "InsertionSort" : ((liveAlgoIndex == 1) ? "SelectionSort" : "MergeSort");
    text("Live-Visualisierung: " + algoName + " (N = 30)", w / 2, y - 25);
    
    // Spielfeld-Begrenzung
    fill(30, 41, 59, 100);
    stroke(51, 65, 85);
    rect(x, y, w, h, 8);
    
    float abstand = 4;
    float balkenBreite = (w - (liveDaten.length + 1) * abstand) / liveDaten.length;
    
    // Zeichne Balken
    for (int i = 0; i < liveDaten.length; i++)
    {
        float barH = map(liveDaten[i], 0, 320, 10, h - 40);
        float barX = x + abstand + i * (balkenBreite + abstand);
        float barY = y + h - barH - 10;
        
        // Farbliche Hervorhebung bei aktiver Sortierung
        if (i == liveAktiverIndex)
        {
            fill(239, 68, 68); // Rot für das aktuell betrachtete/verschobene Element
        }
        else if (i == liveVergleichsIndex)
        {
            fill(59, 130, 246); // Blau für das Vergleichselement
        }
        else
        {
            fill(16, 185, 129); // Smaragdgrün für den Rest
        }
        
        noStroke();
        rect(barX, barY, balkenBreite, barH, 4, 4, 0, 0);
        
        // Wert unter dem Balken drucken
        fill(148, 163, 184);
        textSize(8);
        textAlign(CENTER, TOP);
        text(liveDaten[i], barX + balkenBreite / 2, y + h - 8);
    }
}

void liveDatenGenerieren()
{
    for (int i = 0; i < liveDaten.length; i++) {
        liveDaten[i] = int(random(15, 300));
    }
    liveAktiverIndex = -1;
    liveVergleichsIndex = -1;
}

void mousePressed()
{
    // Klicks im Benchmark-Modus abfangen
    if (!imLiveModus)
    {
        if (btnN10.mouseOver()) nAuswahlIndex = 0;
        if (btnN50.mouseOver()) nAuswahlIndex = 1;
        if (btnN100.mouseOver()) nAuswahlIndex = 2;
        if (btnN500.mouseOver()) nAuswahlIndex = 3;
        if (btnN1000.mouseOver()) nAuswahlIndex = 4;
        
        if (btnShowZeit.mouseOver()) anzeigeModus = 0;
        if (btnShowLese.mouseOver()) anzeigeModus = 1;
        if (btnShowSchreib.mouseOver()) anzeigeModus = 2;
        
        if (btnStartBenchmark.mouseOver())
        {
            runAllBenchmarks();
        }
    }
    else
    {
        // Klicks im Live-Modus abfangen
        if (btnAlgoInsert.mouseOver() && !liveSortieren) liveAlgoIndex = 0;
        if (btnAlgoSelect.mouseOver() && !liveSortieren) liveAlgoIndex = 1;
        if (btnAlgoMerge.mouseOver() && !liveSortieren) liveAlgoIndex = 2;
        
        if (btnStartLiveSort.mouseOver())
        {
            if (liveSortieren)
            {
                logHinzufuegen("Es läuft bereits eine Sortierung!");
            }
            else
            {
                liveDatenGenerieren();
                String name = (liveAlgoIndex == 0) ? "Insertion" : ((liveAlgoIndex == 1) ? "Selection" : "Merge");
                aktiverSortThread = new SortThread(name);
                aktiverSortThread.start();
                logHinzufuegen("Live-Sortierung (" + name + "Sort) gestartet.");
            }
        }
    }
    
    // Umschalter Modus
    if (btnSwitchModus.mouseOver())
    {
        imLiveModus = !imLiveModus;
        logHinzufuegen("Modus gewechselt zu: " + (imLiveModus ? "Live-Sortierung" : "Benchmark-Diagramme"));
    }
    
    // Zoom
    if (btnZoomDec.mouseOver() && zoomFaktor > 0.5)
    {
        zoomFaktor -= 0.1;
    }
    if (btnZoomInc.mouseOver() && zoomFaktor < 2.0)
    {
        zoomFaktor += 0.1;
    }
}

void mouseDragged()
{
    float lmY = mouseY / GUI_SCALE;
    float h = height / GUI_SCALE;
    if (lmY > 150 && lmY < (h - 130))
    {
        scrollX += (mouseX - pmouseX) / GUI_SCALE;
        scrollY += (mouseY - pmouseY) / GUI_SCALE;
        
        scrollX = constrain(scrollX, -500, width / GUI_SCALE - 50);
        scrollY = constrain(scrollY, 50, height / GUI_SCALE - 50);
    }
}

void logHinzufuegen(String msg)
{
    String zeit = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    aktionsLogs.add("[" + zeit + "] " + msg);
    if (aktionsLogs.size() > 4)
    {
        aktionsLogs.remove(0);
    }
}

/**
 * Führt alle 9 Kombinationen des Benchmarks synchron aus.
 */
void runAllBenchmarks()
{
    int N = nOptionen[nAuswahlIndex];
    logHinzufuegen("Berechne Benchmark für N = " + N + " ... Bitte warten.");
    
    // Listen- und Sortier-Instanzen
    InsertionSort insArr = new InsertionSort(arrayList);
    InsertionSort insLnk = new InsertionSort(linkedList);
    InsertionSort insEnd = new InsertionSort(tailList);
    
    SelectionSort selArr = new SelectionSort(arrayList);
    SelectionSort selLnk = new SelectionSort(linkedList);
    SelectionSort selEnd = new SelectionSort(tailList);
    
    MergeSort mrgArr = new MergeSort(arrayList);
    MergeSort mrgLnk = new MergeSort(linkedList);
    MergeSort mrgEnd = new MergeSort(tailList);
    
    // InsertionSort
    ergebnisse[0][0] = insArr.ausfuehren(N);
    ergebnisse[0][1] = insLnk.ausfuehren(N);
    ergebnisse[0][2] = insEnd.ausfuehren(N);
    
    // SelectionSort
    ergebnisse[1][0] = selArr.ausfuehren(N);
    ergebnisse[1][1] = selLnk.ausfuehren(N);
    ergebnisse[1][2] = selEnd.ausfuehren(N);
    
    // MergeSort
    ergebnisse[2][0] = mrgArr.ausfuehren(N);
    ergebnisse[2][1] = mrgLnk.ausfuehren(N);
    ergebnisse[2][2] = mrgEnd.ausfuehren(N);
    
    benchmarkAusgefuehrt = true;
    logHinzufuegen("Benchmark für N = " + N + " erfolgreich abgeschlossen.");
}

// Background Thread für die Live-Animation
class SortThread extends Thread
{
    String algo;
    
    SortThread(String algo)
    {
        this.algo = algo;
    }
    
    public void run()
    {
        liveSortieren = true;
        if (algo.equals("Insertion"))
        {
            insertionSortLive();
        }
        else if (algo.equals("Selection"))
        {
            selectionSortLive();
        }
        else if (algo.equals("Merge"))
        {
            mergeSortLive(0, liveDaten.length - 1);
        }
        liveSortieren = false;
        liveAktiverIndex = -1;
        liveVergleichsIndex = -1;
        logHinzufuegen("Live-Sortierung beendet.");
    }
}

// --- Live-Sorting Algorithmen ---
void insertionSortLive()
{
    for (int i = 1; i < liveDaten.length; i++)
    {
        int key = liveDaten[i];
        int j = i - 1;
        liveAktiverIndex = i;
        
        while (j >= 0 && liveDaten[j] > key)
        {
            liveVergleichsIndex = j;
            liveDaten[j + 1] = liveDaten[j];
            j = j - 1;
            delay(liveVerzoegerung);
        }
        liveDaten[j + 1] = key;
        delay(liveVerzoegerung * 2);
    }
}

void selectionSortLive()
{
    for (int i = 0; i < liveDaten.length - 1; i++)
    {
        int minIdx = i;
        liveAktiverIndex = i;
        
        for (int j = i + 1; j < liveDaten.length; j++)
        {
            liveVergleichsIndex = j;
            if (liveDaten[j] < liveDaten[minIdx])
            {
                minIdx = j;
            }
            delay(liveVerzoegerung);
        }
        
        // Tauschen
        int temp = liveDaten[i];
        liveDaten[i] = liveDaten[minIdx];
        liveDaten[minIdx] = temp;
        delay(liveVerzoegerung * 2);
    }
}

void mergeSortLive(int l, int r)
{
    if (l < r)
    {
        int m = l + (r - l) / 2;
        mergeSortLive(l, m);
        mergeSortLive(m + 1, r);
        mergeLive(l, m, r);
    }
}

void mergeLive(int l, int m, int r)
{
    int n1 = m - l + 1;
    int n2 = r - m;
    int[] L = new int[n1];
    int[] R = new int[n2];
    
    for (int i = 0; i < n1; ++i) L[i] = liveDaten[l + i];
    for (int j = 0; j < n2; ++j) R[j] = liveDaten[m + 1 + j];
    
    int i = 0, j = 0;
    int k = l;
    
    while (i < n1 && j < n2)
    {
        liveAktiverIndex = k;
        if (L[i] <= R[j])
        {
            liveDaten[k] = L[i];
            i++;
        }
        else
        {
            liveDaten[k] = R[j];
            j++;
        }
        k++;
        delay(liveVerzoegerung);
    }
    
    while (i < n1)
    {
        liveAktiverIndex = k;
        liveDaten[k] = L[i];
        i++;
        k++;
        delay(liveVerzoegerung);
    }
    
    while (j < n2)
    {
        liveAktiverIndex = k;
        liveDaten[k] = R[j];
        j++;
        k++;
        delay(liveVerzoegerung);
    }
}

/**
 * Hilfsklasse für interaktive GUI-Buttons.
 */
class Button
{
    float x, y, w, h;
    String label;
    color col;
    
    Button(float x, float y, float w, float h, String label, color col)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.label = label;
        this.col = col;
    }
    
    void zeichnen()
    {
        boolean hover = mouseOver();
        color zeichnFarbe = hover ? lerpColor(col, color(255), 0.15) : col;
        
        fill(zeichnFarbe);
        stroke(255, 30);
        strokeWeight(1);
        rect(x, y, w, h, 4);
        
        fill(255);
        textSize(10);
        textAlign(CENTER, CENTER);
        text(label, x + w / 2, y + h / 2 - 2);
    }
    
    boolean mouseOver()
    {
        float lmX = mouseX / GUI_SCALE;
        float lmY = mouseY / GUI_SCALE;
        return lmX >= x && lmX <= x + w && lmY >= y && lmY <= y + h;
    }
}