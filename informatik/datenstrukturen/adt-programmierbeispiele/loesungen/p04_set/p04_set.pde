/**
 * Hauptprogramm: p04_set (Musterlösung)
 * 
 * Bietet eine interaktive Visualisierung von mathematischen Mengen (Sets):
 * - Drei Implementierungsvarianten:
 *   1. SetVarianteA: Hash-Tabelle mit Chaining (Kollisionslisten)
 *   2. SetVarianteB: Unsortiertes Array (ArrayList)
 *   3. SetVarianteC: Bitset (Speicherung in 32-Bit-Wörtern per Bitmasken)
 * 
 * Features:
 * - Bearbeitung von Menge A und Menge B per Zahlen-Grid (Werte 0-30).
 * - Mengenoperationen: Schnittmenge (A ∩ B), Vereinigungsmenge (A ∪ B),
 *   Differenzmenge (A \ B), Untermengen- und Gleichheitsprüfung.
 * - Venn-Diagramm: Grafische Mengenkreise mit automatischer Platzierung
 *   der Elemente im linken Kreis, im Overlap oder im rechten Kreis.
 * - Speicher-Viewer: Visualisiert die genaue interne Struktur der aktiven Menge
 *   (Hash-Buckets mit Ketten, ArrayList oder Bitset-Binärdarstellung).
 * - Große GUI-Elemente (140% Skalierung), Zoom und Log-Konsole.
 * 
 * @author Antigravity
 * @version September 2026
 */

Set mengeA;
Set mengeB;
Set mengeErgebnis = null;

int aktiverTyp = 0; // 0 = Hash-Table (A), 1 = ArrayList (B), 2 = Bitset (C)
int bearbeitungsMenge = 0; // 0 = Menge A bearbeiten, 1 = Menge B bearbeiten
String ergebnisText = "";

// Zoom und Scrollen
float zoomFaktor = 1.0;
float scrollX = 0;
float scrollY = 0;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnSetA, btnSetB;
Button btnMengeA_Edit, btnMengeB_Edit;
Button btnSchnitt, btnVereinigung, btnDifferenz, btnUntermenge, btnGleichheit;
Button btnLeerenA, btnLeerenB, btnLeerenErg;
Button btnShowHash, btnShowList, btnShowBit;
Button btnZoomDec, btnZoomInc;

// Grid von Zahlen (0 bis 30)
NumberGridButton[] gridButtons = new NumberGridButton[31];

void setup()
{
    size(1350, 820);
    surface.setResizable(true);
    
    // System-Schriftart laden, die mathematische Unicode-Zeichen unterstützt
    PFont font = createFont("Segoe UI", 11);
    textFont(font);
    
    // Initialisiere die Mengen als Hash-Table (Standard)
    mengeA = new SetVarianteA();
    mengeB = new SetVarianteA();
    
    // Standardwerte einfügen
    mengeA.einfuegen(2);
    mengeA.einfuegen(5);
    mengeA.einfuegen(8);
    mengeA.einfuegen(12);
    mengeA.einfuegen(15);
    
    mengeB.einfuegen(5);
    mengeB.einfuegen(12);
    mengeB.einfuegen(18);
    mengeB.einfuegen(22);
    mengeB.einfuegen(27);
    
    // Zoom zentrieren
    scrollX = 40;
    scrollY = 235;
    
    // Buttons initialisieren
    color colAktiv = color(16, 185, 129);      // Smaragdgrün
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    color colViolett = color(139, 92, 246);    // Violett
    
    // Implementierungs-Umschalter
    btnShowHash = new Button(50, 95, 110, 25, "SetVarianteA (Hash)", colAktiv);
    btnShowList = new Button(165, 95, 110, 25, "SetVarianteB (List)", colStandard);
    btnShowBit = new Button(280, 95, 110, 25, "SetVarianteC (Bit)", colStandard);
    
    // Editier-Auswahl
    btnMengeA_Edit = new Button(410, 95, 115, 25, "Menge A bearbeiten", colAktiv);
    btnMengeB_Edit = new Button(530, 95, 115, 25, "Menge B bearbeiten", colStandard);
    
    // Mengenoperationen
    btnSchnitt = new Button(660, 95, 42, 25, "A \u2229 B", colAktion);
    btnVereinigung = new Button(707, 95, 42, 25, "A \u222a B", colAktion);
    btnDifferenz = new Button(754, 95, 42, 25, "A \\ B", colAktion);
    btnUntermenge = new Button(801, 95, 42, 25, "A \u2286 B", colAktion);
    btnGleichheit = new Button(848, 95, 42, 25, "A == B", colAktion);
    
    // Leeren
    btnLeerenA = new Button(50, 130, 110, 20, "Menge A leeren", colGefahr);
    btnLeerenB = new Button(165, 130, 110, 20, "Menge B leeren", colGefahr);
    btnLeerenErg = new Button(280, 130, 110, 20, "Ergebnis leeren", colStandard);
    
    // Zoom
    btnZoomDec = new Button(895, 95, 17, 25, "-", colStandard);
    btnZoomInc = new Button(916, 95, 17, 25, "+", colStandard);
    
    // Zahlen-Grid (0 bis 30) initialisieren
    // Wir zeichnen das Grid rechts oben im Control Panel (x = 410, y = 125)
    // 3 Zeilen, je 11 Spalten
    int cols = 11;
    float startX = 410;
    float startY = 130;
    float btnW = 20;
    float btnH = 20;
    float gap = 3;
    
    for (int i = 0; i <= 30; i++)
    {
        int row = i / cols;
        int col = i % cols;
        float bx = startX + col * (btnW + gap);
        float by = startY + row * (btnH + gap);
        gridButtons[i] = new NumberGridButton(bx, by, btnW, btnH, i);
    }
    
    logHinzufuegen("Mengen-Visualisierung geladen. Editiere A oder B über das Zahlenraster.");
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
    text("Didaktische Visualisierung: Mengenalgebra (ADT Set)", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Speicherstrukturen (Hash, Array, Bitset) und Mengenoperationen interaktiv erforschen", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.1 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // 2. Control Panel
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, 120, 8);
    
    // Button-Zustände anpassen
    btnShowHash.col = (aktiverTyp == 0) ? color(16, 185, 129) : color(51, 65, 85);
    btnShowList.col = (aktiverTyp == 1) ? color(59, 130, 246) : color(51, 65, 85);
    btnShowBit.col = (aktiverTyp == 2) ? color(139, 92, 246) : color(51, 65, 85);
    
    btnMengeA_Edit.col = (bearbeitungsMenge == 0) ? color(16, 185, 129) : color(51, 65, 85);
    btnMengeB_Edit.col = (bearbeitungsMenge == 1) ? color(59, 130, 246) : color(51, 65, 85);
    
    // Buttons zeichnen
    btnShowHash.zeichnen();
    btnShowList.zeichnen();
    btnShowBit.zeichnen();
    
    btnMengeA_Edit.zeichnen();
    btnMengeB_Edit.zeichnen();
    
    btnSchnitt.zeichnen();
    btnVereinigung.zeichnen();
    btnDifferenz.zeichnen();
    btnUntermenge.zeichnen();
    btnGleichheit.zeichnen();
    
    btnLeerenA.zeichnen();
    btnLeerenB.zeichnen();
    btnLeerenErg.zeichnen();
    
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Zoom-Faktor
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(round(zoomFaktor * 100) + "%", 914, 132);
    
    // Zahlenraster zeichnen
    for (int i = 0; i <= 30; i++)
    {
        gridButtons[i].zeichnen();
    }
    
    // Infotext rechts neben dem Grid
    fill(148, 163, 184);
    textSize(10);
    textAlign(LEFT, TOP);
    text("Raster-Klick fügt hinzu/entfernt\naus der ausgewählten Menge.", 665, 130);
    
    // 3. Visualisierungsbereich
    pushMatrix();
    translate(scrollX, scrollY);
    scale(zoomFaktor);
    
    float visWidth = w - 80;
    float visHeight = h - 355;
    
    // Links: Venn-Diagramm
    vennDiagrammZeichnen(0, 0, visWidth * 0.45, visHeight);
    
    // Trennlinie
    stroke(51, 65, 85);
    strokeWeight(1);
    line(visWidth * 0.47, -20, visWidth * 0.47, visHeight + 20);
    
    // Rechts: Speicher-Viewer
    speicherViewerZeichnen(visWidth * 0.50, 0, visWidth * 0.50, visHeight);
    
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
    text("MENGEN PROTOKOLL & AKTIONSLOG", 45, h - 110);
    
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
 * Zeichnet das Venn-Diagramm für Menge A und Menge B.
 */
void vennDiagrammZeichnen(float x, float y, float w, float h)
{
    float cxA = x + w * 0.35;
    float cxB = x + w * 0.65;
    float cy = y + h * 0.45;
    float radius = 100;
    
    // Diagrammtitel
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Venn-Diagramm (Mengen-Diagramm)", x + w / 2, y - 20);
    
    // Venn-Kreise füllen (transparent)
    noStroke();
    fill(16, 185, 129, 45); // A: Grün
    ellipse(cxA, cy, radius * 2, radius * 2);
    
    fill(59, 130, 246, 45); // B: Blau
    ellipse(cxB, cy, radius * 2, radius * 2);
    
    // Venn-Kreise Umrandungen
    strokeWeight(2);
    stroke(16, 185, 129);
    noFill();
    ellipse(cxA, cy, radius * 2, radius * 2);
    
    stroke(59, 130, 246);
    ellipse(cxB, cy, radius * 2, radius * 2);
    
    // Kreis-Labels
    fill(16, 185, 129);
    textSize(14);
    textAlign(RIGHT, BOTTOM);
    text("Menge A", cxA - radius + 15, cy - radius + 15);
    
    fill(59, 130, 246);
    textAlign(LEFT, BOTTOM);
    text("Menge B", cxB + radius - 15, cy - radius + 15);
    
    // Elemente in 3 Listen einteilen: Nur in A, in beiden (A und B), Nur in B
    ArrayList<Integer> nurInA = new ArrayList<Integer>();
    ArrayList<Integer> inBeiden = new ArrayList<Integer>();
    ArrayList<Integer> nurInB = new ArrayList<Integer>();
    
    for (int i = 0; i <= 30; i++)
    {
        boolean inA = mengeA.enthaelt(i);
        boolean inB = mengeB.enthaelt(i);
        
        if (inA && inB) inBeiden.add(i);
        else if (inA) nurInA.add(i);
        else if (inB) nurInB.add(i);
    }
    
    // Elemente im Diagramm zeichnen
    // Nur in A
    float rxA = cxA - 35;
    elementeInVennZeichnen(nurInA, rxA, cy, 35, color(16, 185, 129));
    
    // Nur in B
    float rxB = cxB + 35;
    elementeInVennZeichnen(nurInB, rxB, cy, 35, color(59, 130, 246));
    
    // In Beiden (Schnittmenge)
    float rxAB = (cxA + cxB) / 2;
    elementeInVennZeichnen(inBeiden, rxAB, cy, 22, color(245, 158, 11)); // Orange für Schnitt
    
    // Zeige das Operations-Ergebnis unten an, falls vorhanden
    if (mengeErgebnis != null)
    {
        fill(241, 245, 249);
        textSize(11);
        textAlign(CENTER, TOP);
        text(ergebnisText, x + w / 2, y + h - 35);
        textSize(12);
        fill(245, 158, 11);
        text("Ergebnis-Set: " + mengeErgebnis.toString(), x + w / 2, y + h - 20);
    }
}

/**
 * Hilfsmethode, um Elemente strukturiert in einem Venn-Kreissektor anzuordnen.
 */
void elementeInVennZeichnen(ArrayList<Integer> elemente, float cx, float cy, float maxR, color col)
{
    if (elemente.isEmpty()) return;
    
    int count = elemente.size();
    
    for (int i = 0; i < count; i++)
    {
        float x, y;
        if (count == 1)
        {
            x = cx;
            y = cy;
        }
        else
        {
            // Verteile auf einem Kreis
            float angle = i * TWO_PI / count;
            // Radius wächst leicht mit Elementzahl, bleibt aber gekapselt
            float dist = min(maxR, 12 + i * 2.5); 
            x = cx + dist * cos(angle);
            y = cy + dist * sin(angle);
        }
        
        // Element Kreis
        fill(30, 41, 59);
        stroke(col);
        strokeWeight(1);
        ellipse(x, y, 16, 16);
        
        // Wert
        fill(255);
        textSize(9);
        textAlign(CENTER, CENTER);
        text(elemente.get(i), x, y - 1);
    }
}

/**
 * Zeichnet den Speicher-Viewer für die ausgewählte Menge.
 */
/**
 * Zeichnet den Speicher-Viewer für beide Mengen nebeneinander.
 */
void speicherViewerZeichnen(float x, float y, float w, float h)
{
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    String implName = (aktiverTyp == 0) ? "SetVarianteA (Hash-Table)" : ((aktiverTyp == 1) ? "SetVarianteB (ArrayList)" : "SetVarianteC (Bitset)");
    text("Speicher-Interna (" + implName + ")", x + w / 2, y - 20);
    
    float gap = 15;
    float colW = (w - gap) / 2;
    
    // Links: Menge A zeichnen (Themenfarbe: Emerald-Grün)
    einzelneMengeZeichnen(x, y, colW, h, mengeA, "Menge A", color(16, 185, 129), bearbeitungsMenge == 0);
    
    // Rechts: Menge B zeichnen (Themenfarbe: Blau)
    einzelneMengeZeichnen(x + colW + gap, y, colW, h, mengeB, "Menge B", color(59, 130, 246), bearbeitungsMenge == 1);
}

/**
 * Hilfsmethode, um die Speicher-Interna einer einzelnen Menge anzuzeigen.
 */
void einzelneMengeZeichnen(float px, float py, float pw, float ph, Set aktiveMenge, String name, color themeColor, boolean istAktiv)
{
    // Panel-Hintergrund
    fill(30, 41, 59, 100);
    if (istAktiv)
    {
        stroke(themeColor);
        strokeWeight(2);
    }
    else
    {
        stroke(51, 65, 85);
        strokeWeight(1);
    }
    rect(px, py, pw, ph, 8);
    strokeWeight(1); // Zurücksetzen
    
    // Titel des Teil-Panels
    fill(istAktiv ? themeColor : color(148, 163, 184));
    textSize(11);
    textAlign(LEFT, TOP);
    text(name + (istAktiv ? " (Bearbeitung)" : ""), px + 10, py + 8);
    
    float pad = 10;
    float startX = px + pad;
    float startY = py + 28;
    float innerH = ph - 38;
    
    if (aktiverTyp == 0)
    {
        // --- Visualisiere Hash-Buckets (SetVarianteA) ---
        ArrayList<Integer>[] buckets = ((SetVarianteA)aktiveMenge).getBuckets();
        float zellenH = min(18, innerH / buckets.length);
        
        textSize(8);
        textAlign(LEFT, CENTER);
        
        for (int i = 0; i < buckets.length; i++)
        {
            float bY = startY + i * zellenH;
            
            // Bucket-Index Box
            fill(51, 65, 85);
            stroke(71, 85, 105);
            strokeWeight(1);
            rect(startX, bY - zellenH / 2, 24, zellenH - 2, 3);
            
            fill(226, 232, 240);
            textAlign(CENTER, CENTER);
            text("[" + i + "]", startX + 12, bY - 1);
            
            // Kollisionsliste (Verkettete Kette) zeichnen
            ArrayList<Integer> bucketList = buckets[i];
            if (bucketList != null && !bucketList.isEmpty())
            {
                float listX = startX + 32;
                
                // Verbindungslinie
                stroke(themeColor);
                line(startX + 24, bY - 1, listX, bY - 1);
                
                for (int j = 0; j < bucketList.size(); j++)
                {
                    // Knoten
                    fill(themeColor);
                    stroke(100, 116, 139);
                    rect(listX, bY - zellenH / 2, 20, zellenH - 2, 3);
                    
                    fill(255);
                    text(bucketList.get(j), listX + 10, bY - 1);
                    
                    // Zeiger zum nächsten Knoten
                    if (j < bucketList.size() - 1)
                    {
                        stroke(148, 163, 184);
                        line(listX + 20, bY - 1, listX + 28, bY - 1);
                        listX += 28;
                    }
                }
            }
            else
            {
                // Zeiger auf null
                stroke(239, 68, 68);
                line(startX + 24, bY - 1, startX + 32, bY - 1);
                line(startX + 32, bY - 3, startX + 32, bY + 1); // Querstrich null
            }
        }
    }
    else if (aktiverTyp == 1)
    {
        // --- Visualisiere unstrukturiertes Array (SetVarianteB) ---
        ArrayList<Integer> elements = ((SetVarianteB)aktiveMenge).getElements();
        float boxW = 25;
        float boxH = 20;
        float gap = 4;
        int maxCols = floor((pw - pad * 2) / (boxW + gap));
        
        if (elements.isEmpty())
        {
            fill(100, 116, 139);
            textSize(11);
            textAlign(CENTER, CENTER);
            text("Menge ist leer.", px + pw / 2, py + ph / 2);
            return;
        }
        
        for (int i = 0; i < elements.size(); i++)
        {
            int r = i / maxCols;
            int c = i % maxCols;
            float bx = startX + c * (boxW + gap);
            float by = startY + r * (boxH + gap + 10);
            
            // Box
            fill(themeColor);
            stroke(100, 116, 139);
            rect(bx, by, boxW, boxH, 4);
            
            // Wert
            fill(255);
            textSize(10);
            textAlign(CENTER, CENTER);
            text(elements.get(i), bx + boxW / 2, by + boxH / 2 - 2);
            
            // Index
            fill(148, 163, 184);
            textSize(7);
            text("[" + i + "]", bx + boxW / 2, by + boxH + 5);
        }
    }
    else if (aktiverTyp == 2)
    {
        // --- Visualisiere Bitset-Wörter (SetVarianteC) ---
        ArrayList<Integer> words = ((SetVarianteC)aktiveMenge).getBitWords();
        int wordCount = max(1, words.size());
        
        float cellW = (pw - pad * 2) / 16.0;
        float cellH = 15;
        
        for (int wIdx = 0; wIdx < wordCount; wIdx++)
        {
            float wY = startY + wIdx * 80;
            int wordVal = (wIdx < words.size()) ? words.get(wIdx) : 0;
            
            // Zeilenbeschriftung über der Bit-Reihe
            fill(148, 163, 184);
            textAlign(LEFT, TOP);
            textSize(9);
            text("Wort " + wIdx + " (Bits " + (wIdx * 32) + ".." + (wIdx * 32 + 31) + "):", startX, wY);
            
            float r1Y = wY + 15;
            float r2Y = r1Y + cellH + 5;
            
            // Reihe 1 (Bits 0..15)
            for (int bit = 0; bit < 16; bit++)
            {
                float bx = startX + bit * cellW;
                int mask = 1 << bit;
                boolean isSet = (wordVal & mask) != 0;
                
                fill(isSet ? themeColor : color(51, 65, 85));
                stroke(30, 41, 59);
                rect(bx, r1Y, cellW - 1, cellH, 2);
                
                fill(isSet ? color(255) : color(100, 116, 139));
                textSize(8);
                textAlign(CENTER, CENTER);
                text(isSet ? "1" : "0", bx + cellW / 2, r1Y + cellH / 2 - 1);
            }
            
            // Reihe 2 (Bits 16..31)
            for (int bit = 0; bit < 16; bit++)
            {
                float bx = startX + bit * cellW;
                int mask = 1 << (bit + 16);
                boolean isSet = (wordVal & mask) != 0;
                
                fill(isSet ? themeColor : color(51, 65, 85));
                stroke(30, 41, 59);
                rect(bx, r2Y, cellW - 1, cellH, 2);
                
                fill(isSet ? color(255) : color(100, 116, 139));
                textSize(8);
                textAlign(CENTER, CENTER);
                text(isSet ? "1" : "0", bx + cellW / 2, r2Y + cellH / 2 - 1);
            }
            
            // Labels für Bit-Indizes
            fill(100, 116, 139);
            textSize(7);
            textAlign(LEFT, TOP);
            text(String.valueOf(wIdx * 32), startX, r1Y + cellH + 1);
            textAlign(RIGHT, TOP);
            text(String.valueOf(wIdx * 32 + 15), startX + 16 * cellW, r1Y + cellH + 1);
            
            textAlign(LEFT, TOP);
            text(String.valueOf(wIdx * 32 + 16), startX, r2Y + cellH + 1);
            textAlign(RIGHT, TOP);
            text(String.valueOf(wIdx * 32 + 31), startX + 16 * cellW, r2Y + cellH + 1);
        }
    }
}

void mousePressed()
{
    // Implementierungs-Umschalter
    if (btnShowHash.mouseOver() && aktiverTyp != 0)
    {
        Set neueA = new SetVarianteA();
        Set neueB = new SetVarianteA();
        setUebertragen(mengeA, neueA);
        setUebertragen(mengeB, neueB);
        mengeA = neueA;
        mengeB = neueB;
        mengeErgebnis = null;
        aktiverTyp = 0;
        logHinzufuegen("Implementierung gewechselt zu SetVarianteA (Hash-Table).");
    }
    
    if (btnShowList.mouseOver() && aktiverTyp != 1)
    {
        Set neueA = new SetVarianteB();
        Set neueB = new SetVarianteB();
        setUebertragen(mengeA, neueA);
        setUebertragen(mengeB, neueB);
        mengeA = neueA;
        mengeB = neueB;
        mengeErgebnis = null;
        aktiverTyp = 1;
        logHinzufuegen("Implementierung gewechselt zu SetVarianteB (ArrayList).");
    }
    
    if (btnShowBit.mouseOver() && aktiverTyp != 2)
    {
        Set neueA = new SetVarianteC();
        Set neueB = new SetVarianteC();
        setUebertragen(mengeA, neueA);
        setUebertragen(mengeB, neueB);
        mengeA = neueA;
        mengeB = neueB;
        mengeErgebnis = null;
        aktiverTyp = 2;
        logHinzufuegen("Implementierung gewechselt zu SetVarianteC (Bitset).");
    }
    
    // Editier-Set-Wahl
    if (btnMengeA_Edit.mouseOver()) bearbeitungsMenge = 0;
    if (btnMengeB_Edit.mouseOver()) bearbeitungsMenge = 1;
    
    // Leeren
    if (btnLeerenA.mouseOver())
    {
        mengeA = instanziiereMenge();
        mengeErgebnis = null;
        logHinzufuegen("Menge A wurde geleert.");
    }
    if (btnLeerenB.mouseOver())
    {
        mengeB = instanziiereMenge();
        mengeErgebnis = null;
        logHinzufuegen("Menge B wurde geleert.");
    }
    if (btnLeerenErg.mouseOver())
    {
        mengeErgebnis = null;
        logHinzufuegen("Ergebnis-Menge wurde zurückgesetzt.");
    }
    
    // Mengenoperationen
    if (btnSchnitt.mouseOver())
    {
        mengeErgebnis = mengeA.schnittmenge(mengeB);
        ergebnisText = "Schnittmenge: A \u2229 B";
        logHinzufuegen("Schnittmenge berechnet: " + mengeErgebnis.toString());
    }
    if (btnVereinigung.mouseOver())
    {
        mengeErgebnis = mengeA.vereinigungsmenge(mengeB);
        ergebnisText = "Vereinigungsmenge: A \u222a B";
        logHinzufuegen("Vereinigungsmenge berechnet: " + mengeErgebnis.toString());
    }
    if (btnDifferenz.mouseOver())
    {
        mengeErgebnis = mengeA.differenz(mengeB);
        ergebnisText = "Differenzmenge: A \\ B";
        logHinzufuegen("Differenzmenge A ohne B berechnet: " + mengeErgebnis.toString());
    }
    if (btnUntermenge.mouseOver())
    {
        boolean res = mengeA.untermenge(mengeB);
        mengeErgebnis = null;
        logHinzufuegen("Pr\u00fcfung Untermenge: Ist A \u2286 B? " + (res ? "JA (Wahr)" : "NEIN (Falsch)"));
    }
    if (btnGleichheit.mouseOver())
    {
        boolean res = mengeA.gleich(mengeB);
        mengeErgebnis = null;
        logHinzufuegen("Prüfung Gleichheit: Ist A == B? " + (res ? "JA (Wahr)" : "NEIN (Falsch)"));
    }
    
    // Grid Klicks abfangen
    Set zielMenge = (bearbeitungsMenge == 0) ? mengeA : mengeB;
    for (int i = 0; i <= 30; i++)
    {
        if (gridButtons[i].mouseOver())
        {
            if (zielMenge.enthaelt(i))
            {
                zielMenge.entfernen(i);
                logHinzufuegen("Wert " + i + " aus Menge " + ((bearbeitungsMenge == 0) ? "A" : "B") + " entfernt.");
            }
            else
            {
                // Bitset unterstützt nur positive Werte, das Grid ist ohnehin >= 0
                zielMenge.einfuegen(i);
                logHinzufuegen("Wert " + i + " in Menge " + ((bearbeitungsMenge == 0) ? "A" : "B") + " eingefügt.");
            }
            mengeErgebnis = null; // Ergebnis zurücksetzen bei Änderung
        }
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
 * Instanziiert eine leere Menge des aktuell ausgewählten Typs.
 */
Set instanziiereMenge()
{
    if (aktiverTyp == 0) return new SetVarianteA();
    if (aktiverTyp == 1) return new SetVarianteB();
    return new SetVarianteC();
}

/**
 * Überträgt Elemente von einer Menge in eine andere.
 */
void setUebertragen(Set quelle, Set ziel)
{
    int[] werte = quelle.alsArray();
    for (int w : werte)
    {
        // Bitset unterstützt nur >= 0, was im Grid immer wahr ist
        ziel.einfuegen(w);
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

/**
 * Spezialbutton für das Zahlen-Eingabe-Grid.
 */
class NumberGridButton
{
    float x, y, w, h;
    int value;
    
    NumberGridButton(float x, float y, float w, float h, int val)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.value = val;
    }
    
    void zeichnen()
    {
        boolean hover = mouseOver();
        
        // Bestimme, ob dieser Wert in A oder B enthalten ist
        boolean inA = mengeA.enthaelt(value);
        boolean inB = mengeB.enthaelt(value);
        
        // Farbcode
        color cellCol = color(51, 65, 85); // Grau (Standard leer)
        
        if (inA && inB)
        {
            cellCol = color(245, 158, 11); // Orange (in beiden)
        }
        else if (inA)
        {
            cellCol = color(16, 185, 129); // Grün (nur A)
        }
        else if (inB)
        {
            cellCol = color(59, 130, 246); // Blau (nur B)
        }
        
        if (hover)
        {
            cellCol = lerpColor(cellCol, color(255), 0.25);
        }
        
        fill(cellCol);
        stroke(15, 23, 42);
        strokeWeight(1);
        rect(x, y, w, h, 3);
        
        fill(255);
        textSize(8);
        textAlign(CENTER, CENTER);
        text(value, x + w / 2, y + h / 2 - 1);
    }
    
    boolean mouseOver()
    {
        float lmX = mouseX / GUI_SCALE;
        float lmY = mouseY / GUI_SCALE;
        return lmX >= x && lmX <= x + w && lmY >= y && lmY <= y + h;
    }
}