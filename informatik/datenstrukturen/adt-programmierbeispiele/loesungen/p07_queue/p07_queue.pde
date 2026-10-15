/**
 * Hauptprogramm: p07_queue (Musterlösung)
 * 
 * Bietet ein interaktives, visuelles Testgerüst für die Warteschlange (Queue).
 * Hier können die ArrayQueue (Ringpuffer) und die LinkedQueue (Verkettung)
 * live getestet und im Betrieb miteinander verglichen werden.
 * 
 * Steuerungsoptionen:
 * - Umschalten zwischen ArrayQueue (Ringpuffer) und LinkedQueue
 * - Elemente hinten anfügen (enqueue) mit Zufallswerten (10-99)
 * - Elemente vorne entnehmen (dequeue) mit Anzeige des Werts
 * - Vorderstes Element betrachten (front)
 * - Schlange komplett leeren
 * - Verschieben per Drag & Drop mit der Maus im Visualisierungsbereich
 * - Flexibler Zoom NUR für die Schlange
 * - Große, lesbare Menüknöpfe (fest auf 140% skaliert)
 * - Stufenlos vergrößerbares Anwendungsfenster
 * 
 * @author Antigravity
 * @version September 2026
 */

Queue<Integer> aktiveQueue;
ArrayQueue<Integer> arrayQueue;
LinkedQueue<Integer> linkedQueue;

// Zustand für die GUI
int aktiverTyp = 0; // 0 = ArrayQueue, 1 = LinkedQueue

// Zoom-Faktor NUR für die Queue
float zoomFaktor = 1.0;

// Fester Skalierungsfaktor für die Benutzeroberfläche (Schaltflächen, Texte, Panels)
final float GUI_SCALE = 1.4;

// UI Scroll-Steuerung für die Queue
float scrollX = 0;
float scrollY = 0;

// Log-Historie für Aktionen
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnArray;
Button btnLinked;
Button btnEnqueue;
Button btnDequeue;
Button btnFront;
Button btnLeeren;

Button btnZoomDec;
Button btnZoomInc;

void setup()
{
    // Größeres Standardfenster, damit die 140% vergrößerten Schaltflächen gut Platz haben
    size(1350, 700);
    
    // Macht das Fenster flexibel vergrößerbar
    surface.setResizable(true);
    
    // Queues instanziieren
    arrayQueue = new ArrayQueue<Integer>();
    linkedQueue = new LinkedQueue<Integer>();
    
    // Standardmäßig mit der ArrayQueue starten
    aktiveQueue = arrayQueue;
    
    // Einige Standardwerte zum Start einfügen
    aktiveQueue.enqueue(23);
    aktiveQueue.enqueue(45);
    aktiveQueue.enqueue(89);
    
    // Scroll-Koordinaten initial zentrieren
    scrollX = width / (2.0 * GUI_SCALE);
    scrollY = height / (2.0 * GUI_SCALE) + 80;
    
    // UI-Buttons initialisieren (x, y, breite, hoehe, label, farbe)
    color colAktiv = color(16, 185, 129);      // Smaragdgrün
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    
    btnArray = new Button(50, 95, 110, 30, "ArrayQueue", colAktiv);
    btnLinked = new Button(170, 95, 110, 30, "LinkedQueue", colStandard);
    
    btnEnqueue = new Button(300, 95, 130, 30, "+ Enqueue (Zufall)", colAktion);
    btnDequeue = new Button(440, 95, 100, 30, "- Dequeue", colGefahr);
    btnFront = new Button(550, 95, 80, 30, "Front", colAktion);
    btnLeeren = new Button(640, 95, 80, 30, "Leeren", colGefahr);
    
    // Zoomsteuerung für die Grafik
    btnZoomDec = new Button(795, 95, 30, 30, "-", colStandard);
    btnZoomInc = new Button(885, 95, 30, 30, "+", colStandard);
    
    logHinzufuegen("Queue-Visualisierung gestartet. ArrayQueue geladen.");
}

void draw()
{
    // Berechne die logischen Dimensionen des skalierten Viewports
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate (dunkler Hintergrund)
    
    // Wende die GUI-Skalierung an (Menü und Schaltflächen dauerhaft vergrößert auf 140%)
    pushMatrix();
    scale(GUI_SCALE);
    
    // 1. Header zeichnen
    fill(30, 41, 59);
    noStroke();
    rect(0, 0, w, 70);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text("Didaktische Visualisierung: Warteschlange (Queue)", 30, 25);
    
    fill(148, 163, 184);
    textSize(12);
    text("Gymnasiale Oberstufe | FIFO-Prinzip & Circular Buffer (Ringpuffer)", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge rechts oben
    color badgeBorder = color(51, 65, 85);
    color badgeFill = color(30, 41, 59);
    String typName = "ARRAYQUEUE";
    if (aktiverTyp == 0) {
        badgeBorder = color(16, 185, 129);
        badgeFill = color(16, 185, 129, 40);
        typName = "ARRAYQUEUE (RINGPUFFER)";
    } else if (aktiverTyp == 1) {
        badgeBorder = color(59, 130, 246);
        badgeFill = color(59, 130, 246, 40);
        typName = "LINKEDQUEUE (VERKETTUNG)";
    }
    
    fill(badgeFill);
    stroke(badgeBorder);
    strokeWeight(1);
    rect(w - 270, 20, 240, 30, 6);
    
    fill(255);
    textSize(11);
    textAlign(CENTER, CENTER);
    text("AKTIV: " + typName, w - 150, 34);
    
    // 2. Control Panel Hintergrund
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, 60, 8);
    
    // Buttons aktualisieren und zeichnen
    btnArray.col = (aktiverTyp == 0) ? color(16, 185, 129) : color(51, 65, 85);
    btnLinked.col = (aktiverTyp == 1) ? color(59, 130, 246) : color(51, 65, 85);
    
    btnArray.zeichnen();
    btnLinked.zeichnen();
    btnEnqueue.zeichnen();
    btnDequeue.zeichnen();
    btnFront.zeichnen();
    btnLeeren.zeichnen();
    
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Zoom-Texte zeichnen (Zeigt den Zoom der Grafik an)
    fill(148, 163, 184);
    textSize(13);
    textAlign(LEFT, CENTER);
    text("Zoom:", 745, 110);
    fill(255);
    textAlign(CENTER, CENTER);
    text(round(zoomFaktor * 100) + "%", 855, 110);
    
    // 3. Visualisierungsbereich zeichnen (mit Zoom)
    pushMatrix();
    translate(scrollX, scrollY);
    scale(zoomFaktor); // ZoomFaktor steuert NUR noch die Queue!
    
    // Die Queue zeichnen
    float visualisierungsBreite = 250;
    float visualisierungsHoehe = 150;
    
    aktiveQueue.grafischZeichnen(0, 0, visualisierungsBreite, visualisierungsHoehe);
    popMatrix();
    
    // Scroll-Hinweis zeichnen
    fill(148, 163, 184, 150);
    textSize(11);
    textAlign(RIGHT, BOTTOM);
    text("↔↕ Ziehe mit der Maus im Visualisierungsbereich zum Verschieben", w - 30, h - 130);
    
    // 4. Log-Konsole (unten) zeichnen (dynamisch positioniert bei h - 120)
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, h - 120, w - 60, 95, 8);
    
    fill(51, 65, 85);
    rect(30, h - 120, w - 60, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(10);
    textAlign(LEFT, CENTER);
    text("AKTIONSHISTORIE (LOG)", 45, h - 110);
    
    // Log-Einträge zeichnen
    textSize(12);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50); // Ältere Einträge verblassen leicht
        text(aktionsLogs.get(i), 50, h - 90 + i * 16);
    }
    
    popMatrix();
}

void mousePressed()
{
    // Klick auf Array umschalten
    if (btnArray.mouseOver() && aktiverTyp != 0)
    {
        ArrayQueue<Integer> neueQueue = new ArrayQueue<Integer>();
        queueUebertragen(aktiveQueue, neueQueue);
        arrayQueue = neueQueue;
        aktiveQueue = arrayQueue;
        aktiverTyp = 0;
        logHinzufuegen("Auf ArrayQueue (Ringpuffer) gewechselt (Daten übertragen).");
    }
    
    // Klick auf Linked umschalten
    if (btnLinked.mouseOver() && aktiverTyp != 1)
    {
        LinkedQueue<Integer> neueQueue = new LinkedQueue<Integer>();
        queueUebertragen(aktiveQueue, neueQueue);
        linkedQueue = neueQueue;
        aktiveQueue = linkedQueue;
        aktiverTyp = 1;
        logHinzufuegen("Auf LinkedQueue gewechselt (Daten übertragen).");
    }
    
    // Klick auf Enqueue (Element einreihen)
    if (btnEnqueue.mouseOver())
    {
        int wert = int(random(10, 100));
        aktiveQueue.enqueue(wert);
        logHinzufuegen("Wert " + wert + " hinten eingereiht (enqueue).");
    }
    
    // Klick auf Dequeue (Element entnehmen)
    if (btnDequeue.mouseOver())
    {
        if (aktiveQueue.isEmpty())
        {
            logHinzufuegen("FEHLER: Schlange ist leer. dequeue() nicht möglich!");
        }
        else
        {
            Integer wert = aktiveQueue.dequeue();
            logHinzufuegen("Wert " + wert + " vorne entnommen (dequeue).");
        }
    }
    
    // Klick auf Front (Vorderstes Element prüfen)
    if (btnFront.mouseOver())
    {
        if (aktiveQueue.isEmpty())
        {
            logHinzufuegen("Vorderstes Element (front): (Schlange leer)");
        }
        else
        {
            Integer wert = aktiveQueue.front();
            logHinzufuegen("Vorderstes Element (front) ist: " + wert);
        }
    }
    
    // Klick auf Leeren
    if (btnLeeren.mouseOver())
    {
        if (aktiverTyp == 0)
        {
            arrayQueue = new ArrayQueue<Integer>();
            aktiveQueue = arrayQueue;
        }
        else if (aktiverTyp == 1)
        {
            linkedQueue = new LinkedQueue<Integer>();
            aktiveQueue = linkedQueue;
        }
        logHinzufuegen("Die Warteschlange wurde geleert.");
    }
    
    // Zoom verringern/erhöhen
    if (btnZoomDec.mouseOver() && zoomFaktor > 0.5)
    {
        zoomFaktor -= 0.1;
        logHinzufuegen("Zoom verkleinert auf: " + round(zoomFaktor * 100) + "%");
    }
    if (btnZoomInc.mouseOver() && zoomFaktor < 2.0)
    {
        zoomFaktor += 0.1;
        logHinzufuegen("Zoom vergrößert auf: " + round(zoomFaktor * 100) + "%");
    }
}

void mouseDragged()
{
    // Wenn die Maus im Visualisierungsbereich bewegt wird, verschiebe die Ansicht
    float lmY = mouseY / GUI_SCALE;
    float h = height / GUI_SCALE;
    if (lmY > 150 && lmY < (h - 130))
    {
        scrollX += (mouseX - pmouseX) / GUI_SCALE;
        scrollY += (mouseY - pmouseY) / GUI_SCALE;
        
        scrollX = constrain(scrollX, 50, width / GUI_SCALE - 50);
        scrollY = constrain(scrollY, 150, height / GUI_SCALE - 50);
    }
}

// Log-Historie pflegen (maximal 4 Einträge)
void logHinzufuegen(String msg)
{
    String zeit = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    aktionsLogs.add("[" + zeit + "] " + msg);
    if (aktionsLogs.size() > 4)
    {
        aktionsLogs.remove(0);
    }
}

// Übertragungsmethoden zur Synchronisation der Daten beim Umschalten des ADTs
void queueUebertragen(Queue<Integer> quelle, Queue<Integer> ziel)
{
    ArrayList<Integer> temp = new ArrayList<Integer>();
    
    // 1. Alle Elemente entnehmen
    while (!quelle.isEmpty())
    {
        temp.add(quelle.dequeue());
    }
    
    // 2. In gleicher FIFO-Reihenfolge wieder in beide Queues einreihen
    for (int i = 0; i < temp.size(); i++)
    {
        Integer wert = temp.get(i);
        quelle.enqueue(wert);
        ziel.enqueue(wert);
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
        
        // Hover-Effekt: Etwas hellere Farbe, wenn die Maus darüber schwebt
        color zeichnFarbe = hover ? lerpColor(col, color(255), 0.15) : col;
        
        fill(zeichnFarbe);
        stroke(255, 30);
        strokeWeight(1);
        rect(x, y, w, h, 6);
        
        fill(255);
        textSize(12);
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