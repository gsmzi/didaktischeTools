/**
 * Hauptprogramm: p10_baumalgorithmen (Schülervorlage)
 * 
 * Behandelt fundamentale rekursive Algorithmen (Tiefe, Knotenzahl, Suche) auf Binärbäumen.
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - Baumalgorithmen.pde:
 *   Rekursive fundamentale Algorithmen auf der Baumstruktur:
 *   1. tiefe(Binaerbaum<T> b):
 *      Rekursive Bestimmung der Baumtiefe: Anker (b == null -> 0),
 *      Schritt: 1 + Math.max(tiefe(b.links), tiefe(b.rechts)).
 *   2. anzahlKnoten(Binaerbaum<T> b):
 *      Rekursive Zählung aller Knoten: Anker (b == null -> 0),
 *      Schritt: 1 + anzahlKnoten(b.links) + anzahlKnoten(b.rechts).
 *   3. enthaelt(Binaerbaum<T> b, T wert):
 *      Rekursive Elementprüfung: Prüfen von b.daten, rekursiver Abstieg in
 *      b.links oder b.rechts.
 * - (Vorgegeben: Binaerbaum.pde [Traversierungen], p10_baumalgorithmen.pde [Visualisierung & GUI])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

Binaerbaum<Integer> startBaum;
Baumalgorithmen dasSpiel;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnPreorder;
Button btnInorder;
Button btnPostorder;
Button btnStop;
Button btnSearch;
Button btnClearSearch;

// Suchvariablen
String searchInput = "";
boolean inputActive = false;
boolean searchExecuted = false;
boolean searchResult = false;
Binaerbaum<Integer> foundNode = null;

// Traversierungs-Animation
ArrayList<Binaerbaum> traversalList = null;
int traversalIndex = -1;
int lastTraversalStepTime = 0;
int traversalDelay = 800; // Millisekunden pro Schritt
String traversalName = "";

void setup()
{
    size(1250, 750);
    surface.setResizable(true);
    
    // Baum aufbauen
    baumInitialisieren();
    dasSpiel = new Baumalgorithmen(startBaum);
    
    // Buttons
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    color colAktiv = color(16, 185, 129);      // Grün
    
    btnPreorder = new Button(50, 260, 95, 30, "Preorder", colStandard);
    btnInorder = new Button(150, 260, 95, 30, "Inorder", colStandard);
    btnPostorder = new Button(250, 260, 95, 30, "Postorder", colStandard);
    btnStop = new Button(50, 300, 295, 25, "Animation Stoppen", colGefahr);
    
    btnSearch = new Button(230, 140, 60, 25, "Suchen", colAktion);
    btnClearSearch = new Button(295, 140, 50, 25, "Clear", colStandard);
    
    logHinzufuegen("Baumalgorithmen geladen. Klicke auf die Traversierungsknöpfe oder nutze die Suche.");
}

void baumInitialisieren()
{
    // Ein schöner Suchbaum mit Werten
    startBaum = new Binaerbaum<Integer>(40);
    
    startBaum.links = new Binaerbaum<Integer>(25);
    startBaum.links.links = new Binaerbaum<Integer>(15);
    startBaum.links.links.links = new Binaerbaum<Integer>(10);
    startBaum.links.rechts = new Binaerbaum<Integer>(30);
    startBaum.links.rechts.rechts = new Binaerbaum<Integer>(35);
    
    startBaum.rechts = new Binaerbaum<Integer>(60);
    startBaum.rechts.links = new Binaerbaum<Integer>(50);
    startBaum.rechts.links.links = new Binaerbaum<Integer>(45);
    startBaum.rechts.rechts = new Binaerbaum<Integer>(75);
    startBaum.rechts.rechts.rechts = new Binaerbaum<Integer>(80);
}

void draw()
{
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate
    
    // Traversierungs-Animationsschritt ausführen
    if (traversalList != null && traversalIndex != -1)
    {
        int now = millis();
        if (now - lastTraversalStepTime > traversalDelay)
        {
            if (traversalIndex < traversalList.size() - 1)
            {
                traversalIndex++;
                Binaerbaum aktNode = traversalList.get(traversalIndex);
                logHinzufuegen("Besuche Knoten: " + aktNode.daten);
            }
            else
            {
                logHinzufuegen("Traversierung " + traversalName + " abgeschlossen.");
                traversalList = null;
                traversalIndex = -1;
            }
            lastTraversalStepTime = now;
        }
    }
    
    pushMatrix();
    scale(GUI_SCALE);
    
    // 1. Header
    fill(30, 41, 59);
    noStroke();
    rect(0, 0, w, 70);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text("Binärbaum-Algorithmen & Traversierung", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Visualisiert Tiefe, Knotenzahl und die Traversierungsarten Preorder (Haupt), Inorder (Symmetrisch) und Postorder (Neben).", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    boolean animiert = (traversalIndex != -1);
    fill(animiert ? color(245, 158, 11, 40) : color(16, 185, 129, 40));
    stroke(animiert ? color(245, 158, 11) : color(16, 185, 129));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(animiert ? "ANIMATION LÄUFT" : "STATUS: BEREIT", w - 130, 34);
    
    // 2. Visualisierungsbereich
    float treeAreaW = w - 420;
    float treeAreaH = h - 210;
    
    // A. Linke Seite: Baum zeichnen
    pushMatrix();
    translate(30, 90);
    drawBaumGrafik(treeAreaW, treeAreaH);
    popMatrix();
    
    // Trennlinie
    stroke(51, 65, 85);
    strokeWeight(1.5);
    line(w - 380, 80, w - 380, h - 140);
    
    // B. Rechte Seite: Panel
    drawAlgorithmenPanel(w - 360, 90, 330, h - 210);
    
    // 3. Log-Konsole (unten)
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, h - 120, w - 60, 95, 8);
    
    fill(51, 65, 85);
    rect(30, h - 120, w - 60, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(10);
    textAlign(LEFT, CENTER);
    text("SPIEL PROTOKOLL & BERECHNUNGEN", 45, h - 110);
    
    textSize(11);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 50, h - 90 + i * 16);
    }
    
    popMatrix();
}

/**
 * Zeichnet den Baum.
 */
void drawBaumGrafik(float w, float h)
{
    // Titel
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Mathematische Binärbaum-Darstellung", w / 2, 0);
    
    // Zeichne Verbindungen und Knoten
    drawKnoten(startBaum, w / 2, 60, 160, 85, -1, -1);
    
    // Zeige bisherige Traversierungsschritte ganz unten an
    if (traversalIndex != -1)
    {
        StringBuilder sb = new StringBuilder();
        sb.append(traversalName + "-Pfad: ");
        for (int i = 0; i <= traversalIndex; i++)
        {
            if (i > 0) sb.append(" -> ");
            sb.append(traversalList.get(i).daten);
        }
        fill(245, 158, 11);
        textSize(11);
        textAlign(CENTER, BOTTOM);
        text(sb.toString(), w / 2, h - 10);
    }
}

void drawKnoten(Binaerbaum<Integer> k, float x, float y, float dx, float dy, float px, float py)
{
    if (k == null) return;
    
    // Verbindungslinie
    if (px != -1)
    {
        stroke(51, 65, 85);
        strokeWeight(1.5);
        line(px, py, x, y);
    }
    
    // Kinder zeichnen
    drawKnoten(k.links, x - dx, y + dy, dx * 0.5, dy, x, y);
    drawKnoten(k.rechts, x + dx, y + dy, dx * 0.5, dy, x, y);
    
    // Highlights bestimmen:
    // Ist dieser Knoten der aktuell animierte Knoten?
    boolean istAktiverTravers = (traversalList != null && traversalIndex != -1 && traversalList.get(traversalIndex) == k);
    // Wurde dieser Knoten bereits im aktuellen Pfad besucht?
    boolean istBesuchterTravers = false;
    if (traversalList != null && traversalIndex != -1)
    {
        for (int i = 0; i <= traversalIndex; i++)
        {
            if (traversalList.get(i) == k)
            {
                istBesuchterTravers = true;
                break;
            }
        }
    }
    // Ist dies der gesuchte und gefundene Knoten?
    boolean istGefunden = (foundNode == k);
    
    strokeWeight(1.5);
    if (istAktiverTravers)
    {
        stroke(245, 158, 11);
        strokeWeight(3);
        fill(245, 158, 11); // Orange für den aktuellen Suchcursor
    }
    else if (istGefunden)
    {
        stroke(16, 185, 129);
        strokeWeight(3);
        fill(16, 185, 129); // Leuchtend grün für Suchergebnis
    }
    else if (istBesuchterTravers)
    {
        stroke(59, 130, 246);
        fill(30, 41, 59); // Blau umrandet für besuchte Knoten
    }
    else
    {
        stroke(71, 85, 105);
        fill(15, 23, 42); // Normaler Zustand
    }
    
    ellipse(x, y, 32, 32);
    
    // Wert einzeichnen
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(String.valueOf(k.daten), x, y - 1);
}

/**
 * Zeichnet das rechte Kontroll-Panel.
 */
void drawAlgorithmenPanel(float x, float y, float w, float h)
{
    // Container
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    // 1. Titel und Metriken
    fill(241, 245, 249);
    textSize(13);
    textAlign(LEFT, TOP);
    text("Knoten-Berechnungen:", x + 20, y + 20);
    
    fill(148, 163, 184);
    textSize(11);
    text("Gesamte Knoten (anzahl()): " + dasSpiel.anzahl(), x + 30, y + 45);
    text("Max. Tiefe (tiefe()): " + dasSpiel.tiefe(), x + 30, y + 65);
    
    // 2. Element-Suche
    fill(241, 245, 249);
    textSize(13);
    text("Wert suchen (enthaelt()):", x + 20, y + 100);
    
    // Such-Eingabefeld
    fill(15, 23, 42);
    stroke(inputActive ? color(59, 130, 246) : color(71, 85, 105));
    rect(x + 20, y + 125, 150, 25, 4);
    
    fill(255);
    textSize(11);
    textAlign(LEFT, CENTER);
    text(searchInput + (inputActive && (frameCount / 20) % 2 == 0 ? "|" : ""), x + 30, y + 137);
    
    btnSearch.x = x + 180;
    btnSearch.y = y + 125;
    btnSearch.zeichnen();
    
    btnClearSearch.x = x + 245;
    btnClearSearch.y = y + 125;
    btnClearSearch.zeichnen();
    
    // Suchergebnis-Label
    if (searchExecuted)
    {
        fill(searchResult ? color(16, 185, 129) : color(239, 68, 68));
        textSize(10);
        textAlign(LEFT, TOP);
        text(searchResult ? "GEFUNDEN! Knoten markiert." : "NICHT GEFUNDEN!", x + 20, y + 158);
    }
    
    // 3. Traversierungen
    fill(241, 245, 249);
    textSize(13);
    textAlign(LEFT, TOP);
    text("Traversierungen simulieren:", x + 20, y + 200);
    
    btnPreorder.x = x + 20;
    btnPreorder.y = y + 225;
    btnPreorder.w = (w - 60) / 3;
    btnPreorder.zeichnen();
    
    btnInorder.x = x + 30 + btnPreorder.w;
    btnInorder.y = y + 225;
    btnInorder.w = btnPreorder.w;
    btnInorder.zeichnen();
    
    btnPostorder.x = x + 40 + (btnPreorder.w * 2);
    btnPostorder.y = y + 225;
    btnPostorder.w = btnPreorder.w;
    btnPostorder.zeichnen();
    
    btnStop.x = x + 20;
    btnStop.y = y + 265;
    btnStop.w = w - 40;
    btnStop.zeichnen();
    
    // Info-Box unten
    fill(15, 23, 42, 180);
    stroke(51, 65, 85);
    rect(x + 20, y + 305, w - 40, 70, 6);
    
    fill(148, 163, 184);
    textSize(9.5);
    textAlign(LEFT, TOP);
    String infoText = "Traversierungsregeln:\n" +
                      "- Preorder: Wurzel -> Links -> Rechts\n" +
                      "- Inorder: Links -> Wurzel -> Rechts\n" +
                      "- Postorder: Links -> Rechts -> Wurzel";
    text(infoText, x + 30, y + 312, w - 60, 60);
}

void mousePressed()
{
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    
    // Prüfen, ob das Sucheingabefeld angeklickt wurde
    float inX = width / GUI_SCALE - 360 + 20;
    float inY = 90 + 125;
    if (lmX >= inX && lmX <= inX + 150 && lmY >= inY && lmY <= inY + 25)
    {
        inputActive = true;
    }
    else
    {
        inputActive = false;
    }
    
    // Buttons prüfen
    if (btnSearch.mouseOver())
    {
        suchenAusfuehren();
    }
    if (btnClearSearch.mouseOver())
    {
        searchInput = "";
        searchExecuted = false;
        foundNode = null;
        logHinzufuegen("Suche gelöscht.");
    }
    if (btnPreorder.mouseOver())
    {
        startTraversierung("Preorder", dasSpiel.getPreorder());
    }
    if (btnInorder.mouseOver())
    {
        startTraversierung("Inorder", dasSpiel.getInorder());
    }
    if (btnPostorder.mouseOver())
    {
        startTraversierung("Postorder", dasSpiel.getPostorder());
    }
    if (btnStop.mouseOver())
    {
        traversalList = null;
        traversalIndex = -1;
        logHinzufuegen("Animation abgebrochen.");
    }
}

void startTraversierung(String name, ArrayList<Binaerbaum> liste)
{
    traversalList = liste;
    traversalIndex = 0;
    traversalName = name;
    lastTraversalStepTime = millis();
    foundNode = null; // Suche bei Traversierung löschen
    logHinzufuegen("Starte " + name + "-Traversierung...");
    logHinzufuegen("Besuche Knoten: " + traversalList.get(0).daten);
}

void suchenAusfuehren()
{
    if (searchInput.length() == 0) return;
    try
    {
        int val = Integer.parseInt(searchInput.trim());
        searchResult = dasSpiel.enthaelt(val);
        searchExecuted = true;
        
        if (searchResult)
        {
            foundNode = findNode(startBaum, val);
            logHinzufuegen("Suche: " + val + " wurde im Baum gefunden!");
        }
        else
        {
            foundNode = null;
            logHinzufuegen("Suche: " + val + " ist nicht im Baum enthalten.");
        }
    }
    catch (Exception x)
    {
        logHinzufuegen("Fehler: Nur Ganzzahlen suchen.");
    }
}

Binaerbaum<Integer> findNode(Binaerbaum<Integer> b, int val)
{
    if (b == null) return null;
    if (b.daten.equals(val)) return b;
    
    Binaerbaum<Integer> l = findNode(b.links, val);
    if (l != null) return l;
    return findNode(b.rechts, val);
}

void keyPressed()
{
    if (inputActive)
    {
        if (key >= '0' && key <= '9')
        {
            if (searchInput.length() < 5)
            {
                searchInput += key;
            }
        }
        else if (key == BACKSPACE && searchInput.length() > 0)
        {
            searchInput = searchInput.substring(0, searchInput.length() - 1);
        }
        else if (key == ENTER || key == RETURN)
        {
            suchenAusfuehren();
            inputActive = false;
        }
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