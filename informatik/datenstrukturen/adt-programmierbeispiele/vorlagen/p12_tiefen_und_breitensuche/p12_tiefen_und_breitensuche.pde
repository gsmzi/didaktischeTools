/**
 * Hauptprogramm: p12_tiefen_und_breitensuche (Vorlage)
 * 
 * Vergleicht Breitensuche (Queue/FIFO) und Tiefensuche (Stack/LIFO) auf Binärbäumen.
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - Baumalgorithmen2.pde:
 *   Erweitert Baumalgorithmen um die beiden generischen Suchstrategien:
 *   1. breitensuche(Predicate<Integer> p):
 *      Verwendet eine Queue (FIFO-Prinzip) als Arbeitsbehälter:
 *      Rückgabe: suche(p, new ArrayQueue<Binaerbaum<Integer>>()).
 *   2. tiefensuche(Predicate<Integer> p):
 *      Verwendet einen Stack (LIFO-Prinzip) als Arbeitsbehälter:
 *      Rückgabe: suche(p, new ArrayStack<Binaerbaum<Integer>>()).
 * - (Vorgegeben: Container.pde, ArrayQueue.pde, ArrayStack.pde,
 *    Baumalgorithmen.pde, Binaerbaum.pde, p12_tiefen_und_breitensuche.pde [GUI])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

import java.util.ArrayList;
import java.util.function.Predicate;

Binaerbaum<Integer> startBaum;
Baumalgorithmen2 dasSpiel;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// GUI Steuerungsbuttons
Button btnBFS;
Button btnDFS;
Button btnPlayPause;
Button btnStep;
Button btnReset;

// Prädikatswahl (Radio-Button Style)
int selectedPredicateIdx = 0;
String[] predicateNames = {
  "Wert > 50",
  "Gerade Zahl",
  "Ungerade Zahl",
  "Zahl ist prim",
  "Genau Wert: "
};
int exactSearchVal = 45;
Button btnDecExact;
Button btnIncExact;

// Suchmodus & Zustand
boolean useBFS = true; // true = BFS (Queue), false = DFS (Stack)
boolean sucheAktiv = false;
boolean sucheFertig = false;
boolean sackgasse = false;

// State Machine für Schritt-für-Schritt-Suche
Container<Binaerbaum<Integer>> container = null;
Binaerbaum<Integer> aktuellerKnoten = null;
ArrayList<Binaerbaum<Integer>> besuchteKnoten = new ArrayList<Binaerbaum<Integer>>();
Binaerbaum<Integer> gefundenKnoten = null;

// Animation
int lastStepTime = 0;
int stepDelay = 800; // delay in ms

void setup()
{
    size(1280, 850);
    surface.setResizable(true);
    
    // Baum initialisieren
    baumInitialisieren();
    dasSpiel = new Baumalgorithmen2(startBaum);
    
    // Knöpfe initialisieren
    color colStandard = color(51, 65, 85);    // Slate 700
    color colAktion = color(59, 130, 246);    // Blau
    color colGefahr = color(239, 68, 68);     // Rot
    color colAktiv = color(16, 185, 129);     // Grün
    
    btnBFS = new Button(50, 160, 125, 30, "Breitensuche (Queue)", colAktion);
    btnDFS = new Button(185, 160, 125, 30, "Tiefensuche (Stack)", colStandard);
    
    btnPlayPause = new Button(50, 480, 125, 30, "Autoplay", colAktiv);
    btnStep = new Button(185, 480, 125, 30, "Einzelschritt", colStandard);
    btnReset = new Button(50, 520, 260, 25, "Suche zurücksetzen / Neu", colGefahr);
    
    btnDecExact = new Button(180, 360, 25, 25, "-", colStandard);
    btnIncExact = new Button(270, 360, 25, 25, "+", colStandard);
    
    logHinzufuegen("Playground geladen. Wählen Sie ein Prädikat und starten Sie die Suche.");
    resetSuche();
}

void baumInitialisieren()
{
    // Ein schöner strukturierter Testbaum
    startBaum = new Binaerbaum<Integer>(40);
    
    startBaum.links = new Binaerbaum<Integer>(25);
    startBaum.links.links = new Binaerbaum<Integer>(15);
    startBaum.links.links.links = new Binaerbaum<Integer>(9);
    startBaum.links.links.rechts = new Binaerbaum<Integer>(18);
    startBaum.links.rechts = new Binaerbaum<Integer>(30);
    startBaum.links.rechts.links = new Binaerbaum<Integer>(28);
    
    startBaum.rechts = new Binaerbaum<Integer>(60);
    startBaum.rechts.links = new Binaerbaum<Integer>(50);
    startBaum.rechts.links.rechts = new Binaerbaum<Integer>(55);
    startBaum.rechts.rechts = new Binaerbaum<Integer>(75);
    startBaum.rechts.rechts.links = new Binaerbaum<Integer>(70);
    startBaum.rechts.rechts.rechts = new Binaerbaum<Integer>(88);
}

void resetSuche()
{
    sucheAktiv = false;
    sucheFertig = false;
    sackgasse = false;
    aktuellerKnoten = null;
    gefundenKnoten = null;
    besuchteKnoten.clear();
    btnPlayPause.label = "Autoplay";
    btnPlayPause.col = color(16, 185, 129); // Grün
    
    // Behälter neu aufsetzen
    if (useBFS)
    {
        container = new ArrayQueue<Binaerbaum<Integer>>();
        logHinzufuegen("Breitensuche ausgewählt (ADT Queue bereit).");
    }
    else
    {
        container = new ArrayStack<Binaerbaum<Integer>>();
        logHinzufuegen("Tiefensuche ausgewählt (ADT Stack bereit).");
    }
    
    // Wurzel hinzufügen
    container.insert(startBaum);
}

// Prüft ob eine Zahl prim ist
boolean istPrim(int n)
{
    if (n <= 1) return false;
    for (int i = 2; i <= sqrt(n); i++)
    {
        if (n % i == 0) return false;
    }
    return true;
}

// Gibt das ausgewählte Prädikat zurück
Predicate<Integer> getSelectedPredicate()
{
    switch(selectedPredicateIdx)
    {
        case 0: return n -> n > 50;
        case 1: return n -> n % 2 == 0;
        case 2: return n -> n % 2 != 0;
        case 3: return n -> istPrim(n);
        case 4: return n -> n == exactSearchVal;
        default: return n -> false;
    }
}

String getPredicateDescription()
{
    switch(selectedPredicateIdx)
    {
        case 0: return "Wert > 50";
        case 1: return "Gerade Zahl";
        case 2: return "Ungerade Zahl";
        case 3: return "Wert ist Primzahl";
        case 4: return "Wert == " + exactSearchVal;
        default: return "Keins";
    }
}

// Führt einen Suchschritt aus
void searchStep()
{
    if (sucheFertig) return;
    
    if (container.isEmpty())
    {
        sucheAktiv = false;
        sucheFertig = true;
        sackgasse = true;
        logHinzufuegen("Suche erfolglos beendet. Behälter ist leer.");
        return;
    }
    
    // Nächsten Knoten holen
    Binaerbaum<Integer> node = container.removeNext();
    aktuellerKnoten = node;
    besuchteKnoten.add(node);
    
    Predicate<Integer> p = getSelectedPredicate();
    
    if (node.daten != null && p.test(node.daten))
    {
        gefundenKnoten = node;
        sucheAktiv = false;
        sucheFertig = true;
        logHinzufuegen("Treffer gefunden! Wert: " + node.daten);
    }
    else
    {
        logHinzufuegen("Prüfe Knoten " + node.daten + " -> kein Treffer.");
        
        // Nachfolger einfügen.
        // Didaktisch wichtig: rechts zuerst, dann links.
        // Bei Stack (DFS) führt das dazu, dass links zuerst entnommen wird.
        if (node.rechts != null)
        {
            container.insert(node.rechts);
            logHinzufuegen("  -> " + node.rechts.daten + " (rechts) in Behälter gelegt.");
        }
        if (node.links != null)
        {
            container.insert(node.links);
            logHinzufuegen("  -> " + node.links.daten + " (links) in Behälter gelegt.");
        }
    }
}

void draw()
{
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate
    
    // Autoplay Timer
    if (sucheAktiv && !sucheFertig)
    {
        int now = millis();
        if (now - lastStepTime > stepDelay)
        {
            searchStep();
            lastStepTime = now;
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
    text("Tiefen- und Breitensuche im Vergleich", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Vergleicht die Funktionsweise von Stack (LIFO) und Queue (FIFO) anhand einer schrittweisen Baumsuche.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    fill(sucheAktiv ? color(245, 158, 11, 40) : (sucheFertig ? (sackgasse ? color(239, 68, 68, 40) : color(16, 185, 129, 40)) : color(100, 116, 139, 40)));
    stroke(sucheAktiv ? color(245, 158, 11) : (sucheFertig ? (sackgasse ? color(239, 68, 68) : color(16, 185, 129)) : color(100, 116, 139)));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    String statusStr = "STATUS: BEREIT";
    if (sucheAktiv) statusStr = "SUCHE LÄUFT...";
    else if (sucheFertig) statusStr = sackgasse ? "NICHT GEFUNDEN" : "ERFOLGREICH!";
    text(statusStr, w - 130, 34);
    
    // 2. Layout-Aufteilung
    float areaW = w - 420;
    float areaH = h - 250;
    
    // A. Linke Seite: Baum zeichnen
    pushMatrix();
    translate(30, 90);
    drawBaumGrafik(areaW, areaH);
    popMatrix();
    
    // Trennlinie vertikal
    stroke(51, 65, 85);
    strokeWeight(1.5);
    line(w - 360, 80, w - 360, h - 180);
    
    // B. Rechte Seite: Panel
    drawSteuerungsPanel(w - 340, 90, 310, h - 270);
    
    // C. Unterer Bereich: Logger (Links) & Behälter-Visualisierer (Rechts)
    drawUntererBereich(w, h);
    
    popMatrix();
}

void drawBaumGrafik(float w, float h)
{
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Suchbaum-Visualisierung", w / 2, 0);
    
    // Verbindungen und Knoten rekursiv zeichnen
    // Spacing berechnen
    drawKnoten(startBaum, w / 2, 50, 140, 75, -1, -1);
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
    drawKnoten(k.links, x - dx, y + dy, dx * 0.52, dy, x, y);
    drawKnoten(k.rechts, x + dx, y + dy, dx * 0.52, dy, x, y);
    
    // Highlights bestimmen
    boolean istAktiver = (aktuellerKnoten == k);
    boolean istGefundener = (gefundenKnoten == k);
    boolean istBesuchter = besuchteKnoten.contains(k);
    boolean istImContainer = false;
    
    // Prüfen, ob der Knoten im Container liegt
    if (container != null)
    {
        ArrayList<Binaerbaum<Integer>> el = container.getElements();
        for (Binaerbaum<Integer> node : el)
        {
            if (node == k)
            {
                istImContainer = true;
                break;
            }
        }
    }
    
    strokeWeight(1.5);
    if (istGefundener)
    {
        stroke(16, 185, 129); // Grün für Treffer
        strokeWeight(3.5);
        fill(16, 185, 129);
    }
    else if (istAktiver)
    {
        stroke(245, 158, 11); // Gelb für aktuellen Suchkopf
        strokeWeight(3.5);
        fill(245, 158, 11);
    }
    else if (istImContainer)
    {
        stroke(99, 102, 241); // Indigo für Knoten im Container (Warte-Schlange/-Stapel)
        strokeWeight(2);
        fill(30, 41, 59);
    }
    else if (istBesuchter)
    {
        stroke(59, 130, 246); // Blau für bereits geprüfte Knoten
        fill(15, 23, 42);
    }
    else
    {
        stroke(71, 85, 105);
        fill(15, 23, 42);
    }
    
    ellipse(x, y, 32, 32);
    
    // Wert einzeichnen
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(String.valueOf(k.daten), x, y - 1);
}

void drawSteuerungsPanel(float x, float y, float w, float h)
{
    // Panel Rahmen
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    fill(241, 245, 249);
    textSize(12);
    textAlign(LEFT, TOP);
    text("1. Algorithmus wählen:", x + 20, y + 15);
    
    btnBFS.x = x + 20;
    btnBFS.y = y + 35;
    btnBFS.w = (w - 50) / 2;
    btnBFS.zeichnen();
    
    btnDFS.x = x + 30 + btnBFS.w;
    btnDFS.y = y + 35;
    btnDFS.w = btnBFS.w;
    btnDFS.zeichnen();
    
    // 2. Prädikatswahl
    fill(241, 245, 249);
    text("2. Gesuchtes Prädikat:", x + 20, y + 85);
    
    for (int i = 0; i < predicateNames.length; i++)
    {
        float py = y + 110 + i * 28;
        
        // Radio Button Kreis
        stroke(71, 85, 105);
        fill(15, 23, 42);
        ellipse(x + 30, py + 7, 14, 14);
        if (selectedPredicateIdx == i)
        {
            fill(59, 130, 246);
            noStroke();
            ellipse(x + 30, py + 7, 8, 8);
        }
        
        fill(226, 232, 240);
        textSize(10.5);
        textAlign(LEFT, CENTER);
        
        String pLabel = predicateNames[i];
        if (i == 4) pLabel += exactSearchVal;
        text(pLabel, x + 50, py + 7);
        
        // Hover Detection
        float lmX = mouseX / GUI_SCALE;
        float lmY = mouseY / GUI_SCALE;
        if (lmX >= x + 20 && lmX <= x + w - 20 && lmY >= py && lmY <= py + 20 && !sucheAktiv && !sucheFertig)
        {
            cursor(HAND);
            if (mousePressed && mouseButton == LEFT)
            {
                selectedPredicateIdx = i;
                logHinzufuegen("Prädikat geändert zu: " + getPredicateDescription());
                mousePressed = false; // Debounce
            }
        }
    }
    
    // +/- buttons for Exact search
    if (selectedPredicateIdx == 4 && !sucheAktiv && !sucheFertig)
    {
        btnDecExact.x = x + 185;
        btnDecExact.y = y + 215;
        btnDecExact.zeichnen();
        
        btnIncExact.x = x + 215;
        btnIncExact.y = y + 215;
        btnIncExact.zeichnen();
    }
    
    // 3. Geschwindigkeit
    fill(241, 245, 249);
    text("3. Intervall: " + stepDelay + " ms", x + 20, y + 265);
    
    // Slider
    stroke(71, 85, 105);
    strokeWeight(2);
    line(x + 20, y + 295, x + w - 20, y + 295);
    
    float sliderX = map(stepDelay, 50, 2000, x + 20, x + w - 20);
    fill(59, 130, 246);
    noStroke();
    ellipse(sliderX, y + 295, 14, 14);
    
    // Slider Interaktion
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    if (lmX >= x + 10 && lmX <= x + w - 10 && lmY >= y + 285 && lmY <= y + 305 && mousePressed)
    {
        stepDelay = (int)map(lmX, x + 20, x + w - 20, 50, 2000);
        stepDelay = constrain(stepDelay, 50, 2000);
    }
    
    // 4. Steuerung Buttons
    stroke(51, 65, 85);
    strokeWeight(1);
    line(x + 20, y + 320, x + w - 20, y + 320);
    
    fill(241, 245, 249);
    text("4. Steuerung:", x + 20, y + 335);
    
    btnPlayPause.x = x + 20;
    btnPlayPause.y = y + 355;
    btnPlayPause.w = (w - 50) / 2;
    btnPlayPause.zeichnen();
    
    btnStep.x = x + 30 + btnPlayPause.w;
    btnStep.y = y + 355;
    btnStep.w = btnPlayPause.w;
    btnStep.zeichnen();
    
    btnReset.x = x + 20;
    btnReset.y = y + 395;
    btnReset.w = w - 40;
    btnReset.zeichnen();
}

void drawUntererBereich(float w, float h)
{
    float logW = w - 540;
    float logH = 120;
    float logY = h - 150;
    
    // 1. Logger (links)
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, logY, logW, logH, 8);
    
    fill(51, 65, 85);
    rect(30, logY, logW, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(9.5);
    textAlign(LEFT, CENTER);
    text("SPIELPROTOKOLL / LOGGER", 45, logY + 11);
    
    textSize(10.5);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 45, logY + 30 + i * 16);
    }
    
    // 2. Behälter-Visualisierer (rechts)
    float containerW = 450;
    float containerX = w - 480;
    
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    rect(containerX, logY, containerW, logH, 8);
    
    fill(51, 65, 85);
    rect(containerX, logY, containerW, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(9.5);
    textAlign(LEFT, CENTER);
    text(useBFS ? "WARTESCHLANGE (QUEUE - FIFO)" : "STAPELSPEICHER (STACK - LIFO)", containerX + 15, logY + 11);
    
    // Behälterinhalt zeichnen
    if (container != null)
    {
        ArrayList<Binaerbaum<Integer>> el = container.getElements();
        
        if (useBFS)
        {
            // Queue zeichnen: Ein horizontaler Kanal von rechts (last) nach links (first)
            // Eingang (rechts) -> [Node] -> [Node] -> Ausgang (links)
            float cy = logY + 55;
            float boxW = 32;
            float boxH = 26;
            
            // Kanal-Linien
            stroke(71, 85, 105);
            strokeWeight(1.5);
            line(containerX + 60, cy - 2, containerX + containerW - 60, cy - 2);
            line(containerX + 60, cy + boxH + 2, containerX + containerW - 60, cy + boxH + 2);
            
            // Beschriftungen
            fill(148, 163, 184);
            textSize(9);
            textAlign(CENTER, CENTER);
            text("AUSGANG\n(FIRST / DEQUEUE)", containerX + 35, cy + boxH / 2);
            text("EINGANG\n(LAST / ENQUEUE)", containerX + containerW - 35, cy + boxH / 2);
            
            // Elemente (von links nach rechts: index 0 (first) am weitesten links)
            int maxDraw = 8;
            for (int i = 0; i < min(el.size(), maxDraw); i++)
            {
                float bx = containerX + 80 + i * 40;
                
                fill(99, 102, 241);
                stroke(255, 30);
                rect(bx, cy, boxW, boxH, 4);
                
                fill(255);
                textSize(10);
                text(String.valueOf(el.get(i).daten), bx + boxW / 2, cy + boxH / 2 - 1);
                
                // Pfeil nach links zeigen
                if (i > 0)
                {
                    stroke(148, 163, 184);
                    line(bx - 2, cy + boxH/2, bx - 6, cy + boxH/2);
                    line(bx - 6, cy + boxH/2, bx - 4, cy + boxH/2 - 2);
                    line(bx - 6, cy + boxH/2, bx - 4, cy + boxH/2 + 2);
                }
            }
            
            if (el.size() > maxDraw)
            {
                fill(148, 163, 184);
                textSize(12);
                text("...", containerX + 80 + maxDraw * 40, cy + boxH / 2);
            }
            else if (el.isEmpty())
            {
                fill(239, 68, 68);
                textSize(10);
                text("Schlange ist leer.", containerX + containerW / 2, cy + boxH / 2);
            }
        }
        else
        {
            // Stack zeichnen: Horizontaler Becher, links geschlossen (Boden), rechts offen (TOP / PUSH & POP)
            float cy = logY + 55;
            float boxW = 32;
            float boxH = 26;
            
            // Becher-Linien
            stroke(71, 85, 105);
            strokeWeight(1.5);
            // Boden (links)
            line(containerX + 60, cy - 2, containerX + 60, cy + boxH + 2);
            // Seiten
            line(containerX + 60, cy - 2, containerX + containerW - 80, cy - 2);
            line(containerX + 60, cy + boxH + 2, containerX + containerW - 80, cy + boxH + 2);
            
            // Beschriftung
            fill(148, 163, 184);
            textSize(9);
            textAlign(CENTER, CENTER);
            text("BODEN", containerX + 35, cy + boxH / 2);
            text("ÖFFNUNG\n(TOP / PUSH & POP)", containerX + containerW - 45, cy + boxH / 2);
            
            // Stack-Elemente (in getElements ist Index 0 das Top-Element.
            // Wir zeichnen sie so, dass das älteste Element (Index size-1) am Boden (links) liegt und das Top-Element am weitesten rechts.
            int maxDraw = 8;
            int size = el.size();
            for (int i = 0; i < min(size, maxDraw); i++)
            {
                // Umkehrung für die Zeichnung von links nach rechts
                int listIdx = size - 1 - i;
                float bx = containerX + 70 + i * 40;
                
                // Top-Element hervorheben (ist das am weitesten rechts gezeichnete)
                if (listIdx == 0)
                {
                    fill(245, 158, 11); // Orange für Top
                }
                else
                {
                    fill(99, 102, 241); // Indigo
                }
                
                stroke(255, 30);
                rect(bx, cy, boxW, boxH, 4);
                
                fill(255);
                textSize(10);
                text(String.valueOf(el.get(listIdx).daten), bx + boxW / 2, cy + boxH / 2 - 1);
                
                // Label für TOP über der Box zeichnen
                if (listIdx == 0)
                {
                    fill(245, 158, 11);
                    textSize(8);
                    text("TOP", bx + boxW/2, cy - 8);
                }
            }
            
            if (size > maxDraw)
            {
                // Wenn es mehr Elemente gibt, deuten wir das links an
                fill(148, 163, 184);
                textSize(12);
                text("...", containerX + 75, cy + boxH / 2);
            }
            else if (el.isEmpty())
            {
                fill(239, 68, 68);
                textSize(10);
                text("Stapel ist leer.", containerX + containerW / 2, cy + boxH / 2);
            }
        }
    }
}

void mousePressed()
{
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    
    // 1. Algorithmus Wechsel
    if (btnBFS.mouseOver() && !sucheAktiv)
    {
        useBFS = true;
        btnBFS.col = color(59, 130, 246);  // Aktiv (Blau)
        btnDFS.col = color(51, 65, 85);    // Inaktiv (Slate)
        resetSuche();
    }
    if (btnDFS.mouseOver() && !sucheAktiv)
    {
        useBFS = false;
        btnBFS.col = color(51, 65, 85);    // Inaktiv (Slate)
        btnDFS.col = color(59, 130, 246);  // Aktiv (Blau)
        resetSuche();
    }
    
    // 2. Steuerung
    if (btnPlayPause.mouseOver())
    {
        if (sucheFertig)
        {
            resetSuche();
        }
        sucheAktiv = !sucheAktiv;
        if (sucheAktiv)
        {
            btnPlayPause.label = "Pause";
            btnPlayPause.col = color(245, 158, 11); // Orange
            lastStepTime = millis();
            logHinzufuegen("Autoplay gestartet.");
        }
        else
        {
            btnPlayPause.label = "Autoplay";
            btnPlayPause.col = color(16, 185, 129); // Grün
            logHinzufuegen("Autoplay pausiert.");
        }
    }
    
    if (btnStep.mouseOver())
    {
        if (sucheFertig)
        {
            resetSuche();
        }
        sucheAktiv = false;
        btnPlayPause.label = "Autoplay";
        btnPlayPause.col = color(16, 185, 129);
        searchStep();
    }
    
    if (btnReset.mouseOver())
    {
        resetSuche();
        logHinzufuegen("Suche zurückgesetzt.");
    }
    
    // 3. Exact value adjusters
    if (selectedPredicateIdx == 4 && !sucheAktiv && !sucheFertig)
    {
        if (btnDecExact.mouseOver())
        {
            exactSearchVal = max(1, exactSearchVal - 1);
            logHinzufuegen("Suchwert verringert auf: " + exactSearchVal);
        }
        if (btnIncExact.mouseOver())
        {
            exactSearchVal = min(999, exactSearchVal + 1);
            logHinzufuegen("Suchwert erhöht auf: " + exactSearchVal);
        }
    }
}

void logHinzufuegen(String msg)
{
    String zeit = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    aktionsLogs.add("[" + zeit + "] " + msg);
    if (aktionsLogs.size() > 5)
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