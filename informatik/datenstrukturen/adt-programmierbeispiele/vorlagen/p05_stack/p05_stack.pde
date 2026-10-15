/**
 * Hauptprogramm: p05_stack (Schülervorlage)
 * 
 * Vergleicht drei Implementierungsformen des ADT Stack (Array, Verkettung, Cantor-Paarung).
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - ArrayStack.pde:
 *   Stapelspeicher basierend auf einem dynamischen Array (Object[] daten, int anzahl).
 *   Zu programmieren: isEmpty(), push(T wert) [mit resize], pop(), top().
 * - LinkedStack.pde:
 *   Stapelspeicher basierend auf einer verketteten Knotenstruktur (Listenknoten topNode).
 *   Zu programmieren: isEmpty(), push(T wert), pop(), top().
 * - CantorStack.pde:
 *   Mathematischer Stapel, der Elemente über die Cantorsche Paarungsfunktion
 *   in einer einzigen BigInteger-Zahl kodiert.
 *   Zu programmieren: isEmpty(), push(Integer wert), pop(), top().
 * - (Vorgegeben: Stack.pde [Interface], Listenknoten.pde [Knotenklasse],
 *    p05_stack.pde [GUI & Live-Visualisierung])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

Stack<Integer> aktiverStack;
ArrayStack<Integer> arrayStack;
LinkedStack<Integer> linkedStack;
CantorStack cantorStack;

// Zustand für die GUI
int aktiverTyp = 0; // 0 = ArrayStack, 1 = LinkedStack, 2 = CantorStack

// Zoom-Faktor NUR für den Stapel
float zoomFaktor = 1.0;

// Fester Skalierungsfaktor für die Benutzeroberfläche (Schaltflächen, Texte, Panels)
final float GUI_SCALE = 1.4;

// UI Scroll-Steuerung für den Stapel
float scrollX = 0;
float scrollY = 0;

// Log-Historie für Aktionen
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnArray;
Button btnLinked;
Button btnCantor;
Button btnPush;
Button btnPop;
Button btnTop;
Button btnLeeren;

Button btnZoomDec;
Button btnZoomInc;

void setup()
{
    // Größeres Standardfenster, damit die 140% vergrößerten Schaltflächen gut Platz haben
    size(1350, 700);
    
    // Macht das Fenster flexibel vergrößerbar (Fensterränder ziehbar)
    surface.setResizable(true);
    
    // Stacks instanziieren
    arrayStack = new ArrayStack<Integer>();
    linkedStack = new LinkedStack<Integer>();
    cantorStack = new CantorStack();
    
    // Standardmäßig mit dem ArrayStack starten
    aktiverStack = arrayStack;
    
    // Standardwerte zum Start einfügen, damit der Stapel nicht leer ist
    aktiverStack.push(23);
    aktiverStack.push(45);
    aktiverStack.push(89);
    
    // Scroll-Koordinaten initial zentrieren
    scrollX = width / (2.0 * GUI_SCALE);
    scrollY = height / (2.0 * GUI_SCALE) + 120;
    
    // UI-Buttons initialisieren (x, y, breite, hoehe, label, farbe)
    color colAktiv = color(16, 185, 129);      // Smaragdgrün
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    
    btnArray = new Button(50, 95, 100, 30, "ArrayStack", colAktiv);
    btnLinked = new Button(160, 95, 100, 30, "LinkedStack", colStandard);
    btnCantor = new Button(270, 95, 100, 30, "CantorStack", colStandard);
    
    btnPush = new Button(390, 95, 105, 30, "+ Push (Zufall)", colAktion);
    btnPop = new Button(505, 95, 70, 30, "- Pop", colGefahr);
    btnTop = new Button(585, 95, 65, 30, "Top", colAktion);
    btnLeeren = new Button(660, 95, 75, 30, "Leeren", colGefahr);
    
    // Zoomsteuerung für die Grafik
    btnZoomDec = new Button(805, 95, 30, 30, "-", colStandard);
    btnZoomInc = new Button(895, 95, 30, 30, "+", colStandard);
    
    logHinzufuegen("Stapel-Visualisierung gestartet. ArrayStack aktiv.");
    logHinzufuegen("Hinweis: In den Klassen-Tabs isEmpty(), push(), pop() und top() implementieren.");
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
    text("Didaktische Visualisierung: Stapelspeicher (Stack)", 30, 25);
    
    fill(148, 163, 184);
    textSize(12);
    text("Gymnasiale Oberstufe | LIFO-Prinzip & Speicherorganisation", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge rechts oben
    color badgeBorder = color(51, 65, 85);
    color badgeFill = color(30, 41, 59);
    String typName = "ARRAYSTACK";
    if (aktiverTyp == 0) {
        badgeBorder = color(16, 185, 129);
        badgeFill = color(16, 185, 129, 40);
        typName = "ARRAYSTACK (DYN. ARRAY)";
    } else if (aktiverTyp == 1) {
        badgeBorder = color(59, 130, 246);
        badgeFill = color(59, 130, 246, 40);
        typName = "LINKEDSTACK (VERKETTUNG)";
    } else if (aktiverTyp == 2) {
        badgeBorder = color(139, 92, 246); // Violett
        badgeFill = color(139, 92, 246, 40);
        typName = "CANTORSTACK (MATHE-ZAHL)";
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
    btnCantor.col = (aktiverTyp == 2) ? color(139, 92, 246) : color(51, 65, 85);
    
    btnArray.zeichnen();
    btnLinked.zeichnen();
    btnCantor.zeichnen();
    btnPush.zeichnen();
    btnPop.zeichnen();
    btnTop.zeichnen();
    btnLeeren.zeichnen();
    
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Zoom-Texte zeichnen (Zeigt den Zoom der Grafik an)
    fill(148, 163, 184);
    textSize(13);
    textAlign(LEFT, CENTER);
    text("Zoom:", 755, 110);
    fill(255);
    textAlign(CENTER, CENTER);
    text(round(zoomFaktor * 100) + "%", 865, 110);
    
    // 3. Visualisierungsbereich zeichnen (mit Zoom)
    pushMatrix();
    // Die Position des Stapels wird verschoben
    translate(scrollX, scrollY);
    scale(zoomFaktor); // ZoomFaktor steuert NUR noch den Stapel!
    
    // Den Stapel grafisch zeichnen
    // x = 0, y = 0 ist nun der relative Ursprung für das Zeichnen
    // Für ArrayStack & CantorStack: y=0 ist der Boden. Für LinkedStack: y=0 ist der Boden, gezeichnet wird nach oben
    float visualisierungsBreite = 180;
    float visualisierungsHoehe = 250;
    
    aktiverStack.grafischZeichnen(0, 0, visualisierungsBreite, visualisierungsHoehe);
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
        ArrayStack<Integer> neuerStack = new ArrayStack<Integer>();
        stackUebertragen(aktiverStack, neuerStack);
        arrayStack = neuerStack;
        aktiverStack = arrayStack;
        aktiverTyp = 0;
        logHinzufuegen("Auf ArrayStack gewechselt (Daten übertragen).");
    }
    
    // Klick auf Linked umschalten
    if (btnLinked.mouseOver() && aktiverTyp != 1)
    {
        LinkedStack<Integer> neuerStack = new LinkedStack<Integer>();
        stackUebertragen(aktiverStack, neuerStack);
        linkedStack = neuerStack;
        aktiverStack = linkedStack;
        aktiverTyp = 1;
        logHinzufuegen("Auf LinkedStack gewechselt (Daten übertragen).");
    }
    
    // Klick auf Cantor umschalten
    if (btnCantor.mouseOver() && aktiverTyp != 2)
    {
        CantorStack neuerStack = new CantorStack();
        stackUebertragen(aktiverStack, neuerStack);
        cantorStack = neuerStack;
        aktiverStack = cantorStack;
        aktiverTyp = 2;
        logHinzufuegen("Auf CantorStack gewechselt (Daten übertragen).");
    }
    
    // Klick auf Push (Wert auflegen)
    if (btnPush.mouseOver())
    {
        int wert = int(random(10, 100));
        aktiverStack.push(wert);
        logHinzufuegen("Wert " + wert + " auf den Stapel gelegt (push).");
    }
    
    // Klick auf Pop (Wert herunternehmen)
    if (btnPop.mouseOver())
    {
        if (aktiverStack.isEmpty())
        {
            logHinzufuegen("FEHLER: Stapel ist leer (isEmpty() == true). pop() nicht möglich!");
        }
        else
        {
            Integer wert = aktiverStack.pop();
            if (wert == null)
            {
                logHinzufuegen("Hinweis: pop() lieferte null (Stapel ist leer oder Methode noch nicht implementiert).");
            }
            else
            {
                logHinzufuegen("Wert " + wert + " vom Stapel entfernt (pop).");
            }
        }
    }
    
    // Klick auf Top (Oberstes Element prüfen)
    if (btnTop.mouseOver())
    {
        if (aktiverStack.isEmpty())
        {
            logHinzufuegen("Top-Element: (Stapel ist leer / isEmpty() == true)");
        }
        else
        {
            Integer wert = aktiverStack.top();
            if (wert == null)
            {
                logHinzufuegen("Top-Element: null (Stapel leer oder top() noch nicht implementiert).");
            }
            else
            {
                logHinzufuegen("Oberstes Element (top) ist: " + wert);
            }
        }
    }
    
    // Klick auf Leeren
    if (btnLeeren.mouseOver())
    {
        if (aktiverTyp == 0)
        {
            arrayStack = new ArrayStack<Integer>();
            aktiverStack = arrayStack;
        }
        else if (aktiverTyp == 1)
        {
            linkedStack = new LinkedStack<Integer>();
            aktiverStack = linkedStack;
        }
        else if (aktiverTyp == 2)
        {
            cantorStack = new CantorStack();
            aktiverStack = cantorStack;
        }
        logHinzufuegen("Der Stapel wurde geleert.");
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
        
        // Grenzen eingrenzen, damit die Zeichnung nicht völlig verschwindet
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
void stackUebertragen(Stack<Integer> quelle, Stack<Integer> ziel)
{
    ArrayList<Integer> temp = new ArrayList<Integer>();
    
    // 1. Alle Elemente entnehmen (mit Schutz gegen Endlosschleifen bei noch unvollständigen Schülervorlagen)
    int safetyLimit = 100;
    while (!quelle.isEmpty() && safetyLimit-- > 0)
    {
        Integer wert = quelle.pop();
        if (wert == null) break;
        temp.add(wert);
    }
    
    // 2. In umgekehrter LIFO-Reihenfolge (unten nach oben) wieder auf beide Stacks schieben
    for (int i = temp.size() - 1; i >= 0; i--)
    {
        Integer wert = temp.get(i);
        quelle.push(wert);
        ziel.push(wert);
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