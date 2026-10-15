/**
 * Hauptprogramm: p12_tiefer_baum (Vorlage)
 * 
 * Demonstriert das Rekursionstiefen-Limit (StackOverflowError) und dessen Lösung durch Heap-Iteration.
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / LERNZIELE & RELEVANTE KLASSEN:
 * - Baumalgorithmen.pde (Analyse Rekursion vs. Iteration):
 *   Untersuchung des Call-Stack-Limits der JVM:
 *   1. tiefe() / anzahl(): Reine Rekursion nutzt den JVM-Call-Stack.
 *      Bei entarteten Bäumen mit großer Tiefe (z.B. > 2000) führt dies zum StackOverflowError.
 *   2. tiefeIterativ() / anzahlIterativ(): Iterative Traversierung mit einem
 *      eigenen Stack auf dem Heap (ArrayList). Vermeidet StackOverflowError und
 *      skaliert sicher auf Tiefen von 5000+ Knoten.
 * - TieferBaum.pde:
 *   Erzeugung von Testbäumen: erzeugeTiefenBaum() (linear entartet) vs.
 *   erzeugeBalanciertenBaum() (vollständig balanciert).
 * - (Vorgegeben: Binaerbaum.pde, p12_tiefer_baum.pde [Experimentier-GUI])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

import java.util.ArrayList;

Binaerbaum<Integer> startBaum;
Baumalgorithmen dasSpiel;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnBalanced;
Button btnDegenerate;
Button btnRecDepth;
Button btnRecCount;
Button btnIterDepth;
Button btnIterCount;
Button btnReset;

// Zustand
boolean useBalanced = false; // true = balanced, false = degenerate/deep
int currentDepthVal = 2000;  // depth of the tree
String resultDepth = "---";
String resultCount = "---";
String runTime = "---";
String calcStatus = "Bereit";
color statusColor = color(148, 163, 184); // Grau

void setup()
{
    size(1250, 750);
    surface.setResizable(true);
    
    // Knöpfe
    color colStandard = color(51, 65, 85);    // Slate 700
    color colAktion = color(59, 130, 246);    // Blau
    color colGefahr = color(239, 68, 68);     // Rot
    color colAktiv = color(16, 185, 129);     // Grün
    
    btnBalanced = new Button(50, 160, 125, 30, "Balancierter Baum", colStandard);
    btnDegenerate = new Button(185, 160, 125, 30, "Entarteter Baum", colAktion);
    
    btnRecDepth = new Button(50, 310, 125, 26, "Rekursive Tiefe", colStandard);
    btnRecCount = new Button(185, 310, 125, 26, "Rekursive Anzahl", colStandard);
    btnIterDepth = new Button(50, 345, 125, 26, "Iterative Tiefe", colAktion);
    btnIterCount = new Button(185, 345, 125, 26, "Iterative Anzahl", colAktion);
    
    btnReset = new Button(50, 480, 260, 25, "Baum neu generieren", colGefahr);
    
    logHinzufuegen("Playground geladen. Wählen Sie die Baumstruktur und die Tiefe.");
    regeneriereBaum();
}

void regeneriereBaum()
{
    if (useBalanced)
    {
        // Für balancierten Baum begrenzen wir die Tiefe im Slider auf log2(5000) ~ 12, da ein balancierter
        // Baum der Tiefe 12 bereits 4095 Knoten hat und mehr Speicher benötigt.
        int balancedDepth = constrain(currentDepthVal, 1, 12);
        startBaum = TieferBaum.erzeugeBalanciertenBaum(balancedDepth);
        dasSpiel = new Baumalgorithmen(startBaum);
        logHinzufuegen("Balancierter Baum der Tiefe " + balancedDepth + " generiert.");
    }
    else
    {
        startBaum = TieferBaum.erzeugeTiefenBaum(currentDepthVal);
        dasSpiel = new Baumalgorithmen(startBaum);
        logHinzufuegen("Entarteter tiefer Baum der Tiefe " + currentDepthVal + " generiert.");
    }
    resultDepth = "---";
    resultCount = "---";
    runTime = "---";
    calcStatus = "Bereit";
    statusColor = color(148, 163, 184);
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
    text("Gefahr von Rekursionstiefen (Deep Tree)", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Demonstriert den System-StackOverflow bei rekursiven Baum-Algorithmen und zeigt die iterative Lösung.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // 2. Layout
    float areaW = w - 380;
    float areaH = h - 210;
    
    // A. Linke Seite: Baum zeichnen
    pushMatrix();
    translate(30, 90);
    drawBaumStruktur(areaW, areaH);
    popMatrix();
    
    // Trennlinie vertikal
    stroke(51, 65, 85);
    strokeWeight(1.5);
    line(w - 320, 80, w - 320, h - 140);
    
    // B. Rechte Seite: Panel
    drawSteuerungsPanel(w - 300, 90, 270, h - 210);
    
    // 3. Log-Konsole (unten)
    drawLogger(w, h);
    
    popMatrix();
}

void drawBaumStruktur(float w, float h)
{
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Strukturelle Baumdarstellung", w / 2, 0);
    
    if (startBaum == null) return;
    
    if (useBalanced)
    {
        // Balancierten Baum zeichnen (vollständig)
        int maxDrawDepth = dasSpiel.tiefe();
        drawKnotenBalanced(startBaum, w / 2, 60, w / 4, 60, 1, maxDrawDepth);
    }
    else
    {
        // Entarteten linearen Baum stilisiert zeichnen
        float cx = w / 2;
        float cy = 60;
        float spacingX = 40;
        float spacingY = 55;
        
        int drawNodes = min(currentDepthVal, 5);
        
        // Erste Knoten zeichnen
        for (int i = 0; i < drawNodes; i++)
        {
            float nx = cx - i * spacingX;
            float ny = cy + i * spacingY;
            
            // Verbindungslinien
            stroke(51, 65, 85);
            strokeWeight(1.5);
            if (i > 0)
            {
                line(nx + spacingX, ny - spacingY, nx, ny);
            }
            // Rechtes Blatt zeichnen (das abgeht)
            line(nx, ny, nx + spacingX * 0.6, ny + spacingY * 0.8);
            fill(30, 41, 59);
            stroke(71, 85, 105);
            ellipse(nx + spacingX * 0.6, ny + spacingY * 0.8, 16, 16);
            
            // Hauptknoten
            fill(59, 130, 246); // Blau für Knoten in der Hauptkette
            ellipse(nx, ny, 24, 24);
            fill(255);
            textSize(9);
            textAlign(CENTER, CENTER);
            text("K" + (i+1), nx, ny - 1);
        }
        
        // Gestrichelte Linie nach unten bei großen Tiefen
        if (currentDepthVal > 5)
        {
            float bottomX = cx - 4 * spacingX;
            float bottomY = cy + 4 * spacingY;
            
            stroke(71, 85, 105);
            strokeWeight(1.5);
            // Dotted zig-zag
            for (int k = 0; k < 4; k++)
            {
                float dy = bottomY + k * 12 + 10;
                point(bottomX - k * 8, dy);
            }
            
            fill(148, 163, 184);
            textSize(10.5);
            textAlign(LEFT, CENTER);
            text("... (" + (currentDepthVal - 6) + " weitere Knoten linksseitig) ...", bottomX - 60, bottomY + 70);
            
            // Letzten Knoten (Blatt) ganz unten links zeichnen
            float endX = bottomX - 45;
            float endY = bottomY + 100;
            
            stroke(51, 65, 85);
            line(bottomX - 35, endY - 20, endX, endY);
            
            fill(16, 185, 129); // Grün für das letzte Blatt
            stroke(16, 185, 129);
            ellipse(endX, endY, 24, 24);
            fill(255);
            textSize(8);
            textAlign(CENTER, CENTER);
            text("Ende", endX, endY - 1);
        }
    }
}

void drawKnotenBalanced(Binaerbaum<Integer> k, float x, float y, float dx, float dy, int currentDepth, int maxDepth)
{
    if (k == null || currentDepth > 5) return; // Nicht tiefer als 5 zeichnen um Platz zu sparen
    
    // Kinder zeichnen
    if (k.links != null)
    {
        stroke(51, 65, 85);
        line(x, y, x - dx, y + dy);
        drawKnotenBalanced(k.links, x - dx, y + dy, dx * 0.5, dy, currentDepth + 1, maxDepth);
    }
    if (k.rechts != null)
    {
        stroke(51, 65, 85);
        line(x, y, x + dx, y + dy);
        drawKnotenBalanced(k.rechts, x + dx, y + dy, dx * 0.5, dy, currentDepth + 1, maxDepth);
    }
    
    fill(59, 130, 246);
    stroke(71, 85, 105);
    ellipse(x, y, 22, 22);
    
    fill(255);
    textSize(8.5);
    textAlign(CENTER, CENTER);
    text(String.valueOf(k.daten != null ? k.daten : 0), x, y - 1);
}

void drawSteuerungsPanel(float x, float y, float w, float h)
{
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    fill(241, 245, 249);
    textSize(12);
    textAlign(LEFT, TOP);
    text("1. Baumtyp wählen:", x + 20, y + 15);
    
    btnBalanced.x = x + 20; btnBalanced.y = y + 35; btnBalanced.w = (w - 50) / 2; btnBalanced.zeichnen();
    btnDegenerate.x = x + 30 + btnBalanced.w; btnDegenerate.y = y + 35; btnDegenerate.w = btnBalanced.w; btnDegenerate.zeichnen();
    
    // 2. Slider für Tiefe
    fill(241, 245, 249);
    int maxSliderVal = useBalanced ? 12 : 5000;
    text("2. Zieltiefe: " + currentDepthVal, x + 20, y + 80);
    
    stroke(71, 85, 105);
    strokeWeight(2);
    line(x + 20, y + 110, x + w - 20, y + 110);
    
    float sliderX = map(currentDepthVal, 5, maxSliderVal, x + 20, x + w - 20);
    fill(59, 130, 246);
    noStroke();
    ellipse(sliderX, y + 110, 12, 12);
    
    // Slider Interaktion
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    if (lmX >= x + 10 && lmX <= x + w - 10 && lmY >= y + 100 && lmY <= y + 120 && mousePressed)
    {
        currentDepthVal = (int)map(lmX, x + 20, x + w - 20, 5, maxSliderVal);
        currentDepthVal = constrain(currentDepthVal, 5, maxSliderVal);
        regeneriereBaum();
    }
    
    stroke(51, 65, 85);
    strokeWeight(1);
    line(x + 20, y + 130, x + w - 20, y + 130);
    
    // 3. Berechnungen
    fill(241, 245, 249);
    text("3. Algorithmen ausführen:", x + 20, y + 145);
    
    btnRecDepth.x = x + 20; btnRecDepth.y = y + 165; btnRecDepth.w = (w - 50) / 2; btnRecDepth.zeichnen();
    btnRecCount.x = x + 30 + btnRecDepth.w; btnRecCount.y = y + 165; btnRecCount.w = btnRecDepth.w; btnRecCount.zeichnen();
    
    btnIterDepth.x = x + 20; btnIterDepth.y = y + 200; btnIterDepth.w = btnRecDepth.w; btnIterDepth.zeichnen();
    btnIterCount.x = x + 30 + btnRecDepth.w; btnIterCount.y = y + 200; btnIterCount.w = btnRecDepth.w; btnIterCount.zeichnen();
    
    btnReset.x = x + 20; btnReset.y = y + 240; btnReset.w = w - 40; btnReset.zeichnen();
    
    line(x + 20, y + 280, x + w - 20, y + 280);
    
    // 4. Rechenergebnisse
    fill(241, 245, 249);
    text("Ergebnisse:", x + 20, y + 295);
    
    fill(148, 163, 184);
    textSize(10.5);
    text("Errechnete Tiefe: " + resultDepth, x + 30, y + 320);
    text("Errechnete Anzahl: " + resultCount, x + 30, y + 338);
    text("Rechenzeit: " + runTime, x + 30, y + 356);
    
    // Berechnungsstatus Badge
    fill(statusColor, 40);
    stroke(statusColor);
    rect(x + 20, y + 375, w - 40, 24, 4);
    fill(255);
    textSize(9.5);
    textAlign(CENTER, CENTER);
    text("STATUS: " + calcStatus, x + w/2, y + 387);
}

void drawLogger(float w, float h)
{
    float logW = w - 60;
    float logH = 95;
    float logY = h - 115;
    
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, logY, logW, logH, 8);
    
    fill(51, 65, 85);
    rect(30, logY, logW, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(9.5);
    textAlign(LEFT, CENTER);
    text("SPIEL PROTOKOLL & INTERNER STACK-ZUSTAND", 45, logY + 11);
    
    textSize(10.5);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 45, logY + 30 + i * 15);
    }
}

void mousePressed()
{
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    
    if (btnBalanced.mouseOver())
    {
        useBalanced = true;
        btnBalanced.col = color(59, 130, 246);
        btnDegenerate.col = color(51, 65, 85);
        currentDepthVal = min(12, currentDepthVal); // Limit depth for balanced tree
        regeneriereBaum();
    }
    
    if (btnDegenerate.mouseOver())
    {
        useBalanced = false;
        btnBalanced.col = color(51, 65, 85);
        btnDegenerate.col = color(59, 130, 246);
        regeneriereBaum();
    }
    
    if (btnReset.mouseOver())
    {
        regeneriereBaum();
    }
    
    // Algorithmen Aufrufe mit StackOverflowError-Schutz!
    if (btnRecDepth.mouseOver())
    {
        logHinzufuegen("Starte rekursive Tiefenberechnung (tiefe())...");
        long start = System.nanoTime();
        try
        {
            int d = dasSpiel.tiefe();
            long end = System.nanoTime();
            resultDepth = String.valueOf(d);
            runTime = String.format("%.2f ms", (end - start) / 1000000.0);
            calcStatus = "Erfolgreich";
            statusColor = color(16, 185, 129); // Grün
            logHinzufuegen("Rekursive Tiefe erfolgreich berechnet: " + d);
        }
        catch (StackOverflowError e)
        {
            resultDepth = "[CRASH]";
            runTime = "---";
            calcStatus = "StackOverflowError!";
            statusColor = color(239, 68, 68); // Rot
            logHinzufuegen("CRASH: StackOverflowError! Systemaufrufstapel übergelaufen!");
        }
    }
    
    if (btnRecCount.mouseOver())
    {
        logHinzufuegen("Starte rekursive Knotenzählung (anzahl())...");
        long start = System.nanoTime();
        try
        {
            int c = dasSpiel.anzahl();
            long end = System.nanoTime();
            resultCount = String.valueOf(c);
            runTime = String.format("%.2f ms", (end - start) / 1000000.0);
            calcStatus = "Erfolgreich";
            statusColor = color(16, 185, 129); // Grün
            logHinzufuegen("Rekursive Anzahl erfolgreich berechnet: " + c);
        }
        catch (StackOverflowError e)
        {
            resultCount = "[CRASH]";
            runTime = "---";
            calcStatus = "StackOverflowError!";
            statusColor = color(239, 68, 68); // Rot
            logHinzufuegen("CRASH: StackOverflowError! Systemaufrufstapel übergelaufen!");
        }
    }
    
    if (btnIterDepth.mouseOver())
    {
        logHinzufuegen("Starte iterative Tiefenberechnung (iterativ)...");
        long start = System.nanoTime();
        int d = dasSpiel.tiefeIterativ();
        long end = System.nanoTime();
        resultDepth = String.valueOf(d);
        runTime = String.format("%.2f ms", (end - start) / 1000000.0);
        calcStatus = "Erfolgreich (Iterativ)";
        statusColor = color(16, 185, 129); // Grün
        logHinzufuegen("Iterative Tiefe berechnet (Heap-Stack genutzt): " + d);
    }
    
    if (btnIterCount.mouseOver())
    {
        logHinzufuegen("Starte iterative Knotenzählung (iterativ)...");
        long start = System.nanoTime();
        int c = dasSpiel.anzahlIterativ();
        long end = System.nanoTime();
        resultCount = String.valueOf(c);
        runTime = String.format("%.2f ms", (end - start) / 1000000.0);
        calcStatus = "Erfolgreich (Iterativ)";
        statusColor = color(16, 185, 129); // Grün
        logHinzufuegen("Iterative Anzahl berechnet (Heap-Stack genutzt): " + c);
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