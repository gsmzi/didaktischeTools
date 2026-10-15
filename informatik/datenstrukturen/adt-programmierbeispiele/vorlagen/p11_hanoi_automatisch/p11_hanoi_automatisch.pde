/**
 * Hauptprogramm: p11_hanoi_automatisch (Schülervorlage)
 * 
 * Vollautomatischer rekursiver Lösungsalgorithmus für die Türme von Hanoi mit Schritt-Queue.
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - HanoiGame.pde:
 *   Rekursive automatische Lösungsfindung der Türme von Hanoi:
 *   Zu programmieren: loeseRekursiv(int anzahl, int von, int nach, int ueber):
 *   1. Rekursiver Aufruf: (anzahl - 1) Scheiben von 'von' nach 'ueber' (Hilfsturm: 'nach').
 *   2. Größte Scheibe bewegen: Zug als Datensatz speichern: zuege.add(new Zug(von, nach)).
 *   3. Rekursiver Aufruf: (anzahl - 1) Scheiben von 'ueber' nach 'nach' (Hilfsturm: 'von').
 * - (Vorgegeben: Zug-Klassenframework, ArrayStack.pde, Scheibe.pde,
 *    p11_hanoi_automatisch.pde [Queue-Autopilot, Interna-Viewer & GUI])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

HanoiGame dasSpiel;
int scheibenAnzahl = 5; // Standard für Automatik (nicht zu viele Schritte)

// Autopilot-Zustand (Ansatz 1: Zeitgesteuerte Queue-Wiedergabe)
boolean autopilotAktiv = false;
int lastStepTime = 0;
int stepDelay = 300; // in ms

// Zoom und Scrollen
float zoomFaktor = 1.0;
float scrollX = 0;
float scrollY = 0;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnStart, btnPause, btnStep, btnStop, btnReset;
Button btnScheibenDec, btnScheibenInc;
Button btnZoomDec, btnZoomInc;

// Slider für die Geschwindigkeit (Delay)
float sliderVal = 0.28; // Standard 300ms entspricht ca. 0.28 auf dem Bereich 50..1000
boolean sliderDragged = false;

void setup()
{
    size(1350, 700);
    surface.setResizable(true);
    
    // Spiel initialisieren
    dasSpiel = new HanoiGame(scheibenAnzahl);
    
    // Zoom zentrieren
    scrollX = 40;
    scrollY = 155;
    
    // Buttons initialisieren
    color colAktiv = color(16, 185, 129);      // Smaragdgrün
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    color colOrange = color(245, 158, 11);     // Orange
    
    btnStart = new Button(50, 95, 60, 25, "Start", colAktiv);
    btnPause = new Button(115, 95, 60, 25, "Pause", colOrange);
    btnStep = new Button(180, 95, 60, 25, "Schritt", colAktion);
    btnStop = new Button(245, 95, 60, 25, "Stop", colGefahr);
    btnReset = new Button(310, 95, 60, 25, "Reset", colStandard);
    
    btnScheibenDec = new Button(460, 95, 25, 25, "-", colStandard);
    btnScheibenInc = new Button(520, 95, 25, 25, "+", colStandard);
    
    btnZoomDec = new Button(950, 95, 25, 25, "-", colStandard);
    btnZoomInc = new Button(1010, 95, 25, 25, "+", colStandard);
    
    logHinzufuegen("Hanoi-Automatisch geladen. Klicke auf 'Start', um den rekursiven Solver zu starten.");
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
    text("Die Türme von Hanoi (Automatischer Rekursionslöser)", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Verfolgen Sie die Visualisierung des rekursiven Algorithmus. Nutzen Sie Pause, Einzelschritt oder die Geschwindigkeitsregelung.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    boolean geloest = dasSpiel.istGeloest();
    color badgeFill = color(51, 65, 85, 40);
    color badgeStroke = color(51, 65, 85);
    String stat = "STATUS: BEREIT";
    
    if (autopilotAktiv)
    {
        badgeFill = color(16, 185, 129, 40);
        badgeStroke = color(16, 185, 129);
        stat = "STATUS: LÄUFT (" + dasSpiel.getZugIndex() + "/" + dasSpiel.getGesamtZuege() + ")";
    }
    else if (dasSpiel.getZugIndex() > 0 && !geloest)
    {
        badgeFill = color(245, 158, 11, 40);
        badgeStroke = color(245, 158, 11);
        stat = "STATUS: PAUSIERT (" + dasSpiel.getZugIndex() + "/" + dasSpiel.getGesamtZuege() + ")";
    }
    else if (geloest)
    {
        badgeFill = color(59, 130, 246, 40);
        badgeStroke = color(59, 130, 246);
        stat = "STATUS: GELÖST!";
    }
    
    fill(badgeFill);
    stroke(badgeStroke);
    rect(w - 240, 20, 210, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(stat, w - 135, 34);
    
    // 2. Control Panel
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, 50, 8);
    
    btnStart.zeichnen();
    btnPause.zeichnen();
    btnStep.zeichnen();
    btnStop.zeichnen();
    btnReset.zeichnen();
    btnScheibenDec.zeichnen();
    btnScheibenInc.zeichnen();
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Texte und Slider
    fill(255);
    textSize(11);
    textAlign(LEFT, CENTER);
    text("Scheiben: " + scheibenAnzahl, 385, 107);
    
    // Slider zeichnen
    float sliderX = 640;
    float sliderY = 107;
    float sliderW = 120;
    stroke(51, 65, 85);
    strokeWeight(4);
    line(sliderX, sliderY, sliderX + sliderW, sliderY);
    
    // Regler-Knopf
    float handleX = sliderX + sliderVal * sliderW;
    fill(59, 130, 246);
    stroke(255);
    strokeWeight(1.5);
    ellipse(handleX, sliderY, 12, 12);
    
    // Slider-Wert aktualisieren
    stepDelay = round(map(sliderVal, 0, 1, 50, 1000));
    
    fill(255);
    textSize(10);
    textAlign(LEFT, CENTER);
    text("Verzögerung: " + stepDelay + " ms", sliderX + sliderW + 15, sliderY - 1);
    text("Zoom: " + round(zoomFaktor * 100) + "%", 870, 107);
    
    // 3. Visualisierungsbereich
    pushMatrix();
    translate(scrollX, scrollY);
    scale(zoomFaktor);
    
    float visWidth = w - 80;
    float visHeight = max(215, h - 280);
    
    // Links: Die 3 Hanoi-Türme
    hanoiTuermeZeichnen(0, 0, visWidth * 0.55, visHeight);
    
    // Trennlinie
    stroke(51, 65, 85);
    strokeWeight(1);
    line(visWidth * 0.57, -15, visWidth * 0.57, visHeight + 15);
    
    // Rechts: Die Stack-Memory-Internals
    stackMemoryZeichnen(visWidth * 0.60, 0, visWidth * 0.40, visHeight);
    
    popMatrix();
    
    // Autopilot-Taktung (zeitgesteuerte Ausführung des nächsten vorberechneten Zuges)
    if (autopilotAktiv)
    {
        if (dasSpiel.hatWeitereSchritte())
        {
            if (millis() - lastStepTime >= stepDelay)
            {
                dasSpiel.naechstenSchrittAusfuehren();
                lastStepTime = millis();
            }
        }
        else
        {
            autopilotAktiv = false;
            logHinzufuegen("Fertig! Alle " + dasSpiel.getGesamtZuege() + " Züge erfolgreich ausgeführt.");
        }
    }
    
    // Scroll-Hinweis
    fill(148, 163, 184, 150);
    textSize(10.5);
    textAlign(RIGHT, BOTTOM);
    text("Ziehe mit der Maus im Zeichenbereich zum Verschieben", w - 30, h - 126);
    
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
    text("REC-SOLVER PROTOKOLL & AKTIONSLOG", 45, h - 110);
    
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
 * Zeichnet die drei Hanoi-Pfähle und deren Scheiben.
 */
void hanoiTuermeZeichnen(float x, float y, float w, float h)
{
    // Titel
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Animations-Spielfeld", x + w / 2, y - 18);
    
    // Bodenplatte
    fill(30, 41, 59);
    stroke(71, 85, 105);
    strokeWeight(2);
    rect(x + 20, y + h - 40, w - 40, 15, 4);
    
    // Die drei Pfähle zeichnen
    float abstand = (w - 40) / 3;
    
    for (int i = 0; i < 3; i++)
    {
        float px = x + 20 + i * abstand + abstand / 2;
        float pTop = y + 30;
        float pBottom = y + h - 40;
        
        // Der eigentliche Holzstab
        stroke(30, 41, 59);
        strokeWeight(8);
        line(px, pTop, px, pBottom);
        
        // Beschriftung der Pfähle
        fill(148, 163, 184);
        textSize(10);
        textAlign(CENTER, TOP);
        String label = (i == 0) ? "Start (Turm 0)" : ((i == 1) ? "Hilfe (Turm 1)" : "Ziel (Turm 2)");
        text(label, px, pBottom + 20);
        
        // Scheiben zeichnen
        int hoehe = dasSpiel.getTurmHoehe(i);
        float baseY = pBottom - 2; // knapp über der Platte
        
        // Wir zeichnen von unten nach oben (n-1 bis 0 im Stack-Index)
        for (int j = hoehe - 1; j >= 0; j--)
        {
            Scheibe s = dasSpiel.getNteScheibe(i, j);
            int stapelEbene = hoehe - 1 - j;
            float sy = baseY - stapelEbene * 20 - 20;
            s.zeichne(px, sy);
        }
    }
}

/**
 * Visualisiert didaktisch den genauen Inhalt der drei Stacks (Internals).
 */
void stackMemoryZeichnen(float x, float y, float w, float h)
{
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Stack-Datenstrukturen (Interna)", x + w / 2, y - 18);
    
    float containerH = max(h, 214);
    
    // Hintergrund-Container
    fill(30, 41, 59, 100);
    stroke(51, 65, 85);
    rect(x, y, w, containerH, 8);
    
    float startY = y + 10;
    float startX = x + 15;
    float spaltenW = (w - 30) / 3;
    float slotH = 17;
    
    for (int i = 0; i < 3; i++)
    {
        float sX = startX + i * spaltenW;
        ArrayStack<Scheibe> st = (ArrayStack<Scheibe>)dasSpiel.getStapel(i);
        Object[] daten = st.getDaten();
        int anzahl = st.getAnzahl();
        
        // Spaltentitel
        fill(255);
        textSize(11);
        textAlign(CENTER, TOP);
        text("Turm " + i, sX + spaltenW/2, startY);
        
        // Zeiger-Status unter dem Turm-Titel
        fill(anzahl > 0 ? color(96, 165, 250) : color(100, 116, 139));
        textSize(8);
        textAlign(CENTER, TOP);
        text(anzahl > 0 ? "top: Index " + (anzahl - 1) : "top: (leer)", sX + spaltenW/2, startY + 12);
        
        // Zeichne die 10 Array-Slots (Index 9 oben, Index 0 unten)
        for (int slot = 0; slot < 10; slot++)
        {
            float slotY = startY + 25 + (9 - slot) * slotH; // Slot 0 ist unten
            
            boolean isData = slot < anzahl;
            boolean isTop = (anzahl > 0 && slot == anzahl - 1);
            
            // Slot-Farbe und Rahmen
            if (isTop)
            {
                // Top-Slot prominent in Blau hervorheben
                fill(30, 58, 138, 160);
                stroke(59, 130, 246);
                strokeWeight(1.5);
            }
            else if (isData)
            {
                fill(51, 65, 85);
                stroke(71, 85, 105);
                strokeWeight(1);
            }
            else
            {
                fill(15, 23, 42, 100);
                stroke(51, 65, 85);
                strokeWeight(1);
            }
            
            rect(sX + 4, slotY, spaltenW - 8, slotH - 2, 3);
            
            // Slot-Index links anzeigen [slot]
            fill(isTop ? color(147, 197, 253) : color(100, 116, 139));
            textSize(7.5);
            textAlign(LEFT, CENTER);
            text("[" + slot + "]", sX + 7, slotY + slotH/2 - 1);
            
            if (isData)
            {
                Scheibe s = (Scheibe)daten[slot];
                if (s != null)
                {
                    // Wert einzeichnen
                    fill(255);
                    textSize(8.5);
                    textAlign(LEFT, CENTER);
                    text("Scheibe " + s.getGroesse(), sX + 24, slotY + slotH/2 - 1);
                }
            }
            
            // Zeiger-Markierung im Top-Slot
            if (isTop)
            {
                fill(96, 165, 250);
                textSize(8);
                textAlign(RIGHT, CENTER);
                text("← top", sX + spaltenW - 7, slotY + slotH/2 - 1);
            }
        }
    }
}

void mousePressed()
{
    // GUI-Klicks abfangen
    if (btnStart.mouseOver())
    {
        if (dasSpiel.istGeloest())
        {
            dasSpiel = new HanoiGame(scheibenAnzahl);
            dasSpiel.berechneLoesung();
            autopilotAktiv = true;
            lastStepTime = millis();
            logHinzufuegen("Autopilot neu gestartet.");
        }
        else
        {
            if (dasSpiel.getGesamtZuege() == 0)
            {
                dasSpiel.berechneLoesung();
            }
            autopilotAktiv = true;
            lastStepTime = millis();
            logHinzufuegen("Autopilot gestartet.");
        }
    }
    
    if (btnPause.mouseOver() && autopilotAktiv)
    {
        autopilotAktiv = false;
        logHinzufuegen("Autopilot pausiert.");
    }
    
    if (btnStep.mouseOver())
    {
        autopilotAktiv = false;
        if (dasSpiel.getGesamtZuege() == 0)
        {
            dasSpiel.berechneLoesung();
        }
        if (dasSpiel.hatWeitereSchritte())
        {
            dasSpiel.naechstenSchrittAusfuehren();
        }
        else if (dasSpiel.istGeloest())
        {
            logHinzufuegen("Das Spiel ist bereits gelöst.");
        }
    }
    
    if (btnStop.mouseOver() && autopilotAktiv)
    {
        autopilotAktiv = false;
        logHinzufuegen("Autopilot angehalten.");
    }
    
    if (btnReset.mouseOver())
    {
        autopilotAktiv = false;
        dasSpiel = new HanoiGame(scheibenAnzahl);
        logHinzufuegen("Spiel zurückgesetzt.");
    }
    
    if (btnScheibenDec.mouseOver() && scheibenAnzahl > 3 && !autopilotAktiv)
    {
        scheibenAnzahl--;
        dasSpiel = new HanoiGame(scheibenAnzahl);
        logHinzufuegen("Anzahl Scheiben auf " + scheibenAnzahl + " geändert.");
    }
    
    if (btnScheibenInc.mouseOver() && scheibenAnzahl < 10 && !autopilotAktiv)
    {
        scheibenAnzahl++;
        dasSpiel = new HanoiGame(scheibenAnzahl);
        logHinzufuegen("Anzahl Scheiben auf " + scheibenAnzahl + " geändert.");
    }
    
    if (btnZoomDec.mouseOver() && zoomFaktor > 0.5)
    {
        zoomFaktor -= 0.1;
    }
    if (btnZoomInc.mouseOver() && zoomFaktor < 2.0)
    {
        zoomFaktor += 0.1;
    }
    
    // Klick auf den Slider-Bereich
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    if (lmX >= 640 && lmX <= 760 && lmY >= 100 && lmY <= 114)
    {
        sliderDragged = true;
        sliderVal = constrain((lmX - 640) / 120.0, 0, 1);
    }
}

void mouseReleased()
{
    sliderDragged = false;
}

void mouseDragged()
{
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    if (sliderDragged)
    {
        sliderVal = constrain((lmX - 640) / 120.0, 0, 1);
    }
    else if (lmY > 150 && lmY < (h - 130))
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