/**
 * Hauptprogramm: p06_hanoi (Schülervorlage)
 * 
 * Interaktives Spiel "Türme von Hanoi" auf Basis des ADT Stack (Stapelspeicher).
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - ArrayStack.pde:
 *   Generischer Stapelspeicher zur Verwaltung der Scheiben auf einem Turm.
 *   Zu programmieren: push(T x), pop(), top(), isEmpty().
 * - HanoiGame.pde:
 *   Spiellogik für das Umstapeln nach den Regeln der Türme von Hanoi.
 *   Zu programmieren: bewegeScheibe(int von, int nach):
 *   Prüfen, ob der Quellturm nicht leer ist und ob die Scheibe kleiner ist
 *   als die oberste Scheibe des Zielturms. Wenn gültig: pop() von Quelle,
 *   push() auf Ziel, zuegeAnzahl hochzählen und true zurückgeben.
 * - (Vorgegeben: Scheibe.pde [Scheibenmodell & Farben], Stack.pde [Interface],
 *    p06_hanoi.pde [Spielfeld, Interna-Memory-Viewer, Interaktion])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

HanoiGame dasSpiel;
int scheibenAnzahl = 7;

// Interaktions-Variablen
Scheibe markierteScheibe = null;
int quellTurm = -1;

// Zoom und Scrollen
float zoomFaktor = 1.0;
float scrollX = 0;
float scrollY = 0;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnReset;
Button btnScheibenDec, btnScheibenInc;
Button btnZoomDec, btnZoomInc;

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
    
    btnReset = new Button(50, 95, 140, 25, "Spiel zurücksetzen", colGefahr);
    btnScheibenDec = new Button(340, 95, 25, 25, "-", colStandard);
    btnScheibenInc = new Button(400, 95, 25, 25, "+", colStandard);
    
    btnZoomDec = new Button(500, 95, 25, 25, "-", colStandard);
    btnZoomInc = new Button(560, 95, 25, 25, "+", colStandard);
    
    logHinzufuegen("Hanoi geladen. Klicke auf einen Turm, um die oberste Scheibe abzuheben.");
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
    text("Die Türme von Hanoi (Schülervorlage)", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Verschiebe alle Scheiben von links nach rechts. Größere Scheiben dürfen nie auf kleinere gelegt werden.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    boolean geloest = dasSpiel.istGeloest();
    fill(geloest ? color(16, 185, 129, 40) : color(59, 130, 246, 40));
    stroke(geloest ? color(16, 185, 129) : color(59, 130, 246));
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(geloest ? "STATUS: ERFOLGREICH GELÖST!" : "STATUS: IN ARBEIT", w - 130, 34);
    
    // 2. Control Panel
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, 50, 8);
    
    btnReset.zeichnen();
    btnScheibenDec.zeichnen();
    btnScheibenInc.zeichnen();
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Texte für Parameter
    fill(255);
    textSize(11);
    textAlign(LEFT, CENTER);
    text("Scheiben: " + scheibenAnzahl, 260, 107);
    text("Spielfeld-Zoom: " + round(zoomFaktor * 100) + "%", 605, 107);
    
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
    text("SPIEL PROTOKOLL & LOGGER", 45, h - 110);
    
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
    text("Interaktives Spielfeld", x + w / 2, y - 18);
    
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
        
        // Hover-Effekt für Pfahl (Bereich um den Pfahl herum sensitiv)
        boolean isHovered = (quellTurm == -1 && markierteScheibe == null && mousePegOver(i, x, w, h)) 
                         || (markierteScheibe != null && mousePegOver(i, x, w, h));
        
        if (isHovered)
        {
            stroke(59, 130, 246, 120);
            strokeWeight(8);
            line(px, pTop - 10, px, pBottom);
        }
        
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
            
            // Wenn diese Scheibe markiert ist und vom aktuellen Turm stammt, zeichnen wir sie schwebend
            if (markierteScheibe == s && quellTurm == i)
            {
                // Schwebend über dem Turm
                s.zeichne(px, pTop - 30);
            }
            else
            {
                // Normal aufgestapelt. Der Index j = 0 ist oben.
                int stapelEbene = hoehe - 1 - j;
                float sy = baseY - stapelEbene * 20 - 20;
                s.zeichne(px, sy);
            }
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

/**
 * Prüft, ob sich die Maus im Toleranzbereich über einem Peg (i) befindet.
 */
boolean mousePegOver(int i, float x, float w, float h)
{
    float abstand = (w - 40) / 3;
    float px = x + 20 + i * abstand + abstand / 2;
    
    // Maus-Koordinaten unter Berücksichtigung des GUI-Zooms
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    
    // Visualisierungs-Koordinaten zurückrechnen
    float localX = (lmX - scrollX) / zoomFaktor;
    float localY = (lmY - scrollY) / zoomFaktor;
    
    return localX >= (px - abstand / 2) && localX <= (px + abstand / 2) && localY >= 20 && localY <= h;
}

void mousePressed()
{
    // GUI-Klicks abfangen
    if (btnReset.mouseOver())
    {
        dasSpiel = new HanoiGame(scheibenAnzahl);
        markierteScheibe = null;
        quellTurm = -1;
        logHinzufuegen("Spiel mit " + scheibenAnzahl + " Scheiben zurückgesetzt.");
    }
    
    if (btnScheibenDec.mouseOver() && scheibenAnzahl > 3)
    {
        scheibenAnzahl--;
        dasSpiel = new HanoiGame(scheibenAnzahl);
        markierteScheibe = null;
        quellTurm = -1;
        logHinzufuegen("Anzahl Scheiben auf " + scheibenAnzahl + " geändert.");
    }
    
    if (btnScheibenInc.mouseOver() && scheibenAnzahl < 10)
    {
        scheibenAnzahl++;
        dasSpiel = new HanoiGame(scheibenAnzahl);
        markierteScheibe = null;
        quellTurm = -1;
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
    
    // Klicks auf die Hanoi-Türme
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    float visWidth = w - 80;
    float visHeight = h - 350;
    
    for (int i = 0; i < 3; i++)
    {
        if (mousePegOver(i, 0, visWidth * 0.55, visHeight))
        {
            if (markierteScheibe == null)
            {
                // Versuche Scheibe abzuheben
                if (dasSpiel.getTurmHoehe(i) > 0)
                {
                    markierteScheibe = dasSpiel.getNteScheibe(i, 0);
                    quellTurm = i;
                    logHinzufuegen("Scheibe " + markierteScheibe.getGroesse() + " von Turm " + i + " abgehoben.");
                }
            }
            else
            {
                // Versuche abzulegen
                if (quellTurm == i)
                {
                    // Gleicher Turm: wieder ablegen
                    markierteScheibe = null;
                    quellTurm = -1;
                    logHinzufuegen("Scheibe wieder abgelegt.");
                }
                else
                {
                    // Anderer Turm: Zug ausführen
                    if (dasSpiel.bewegeScheibe(quellTurm, i))
                    {
                        logHinzufuegen("Verschiebe Scheibe " + markierteScheibe.getGroesse() + " von Turm " + quellTurm + " nach Turm " + i + ".");
                        markierteScheibe = null;
                        quellTurm = -1;
                        
                        if (dasSpiel.istGeloest())
                        {
                            logHinzufuegen("Glückwunsch! Du hast das Rätsel gelöst!");
                        }
                    }
                    else
                    {
                        logHinzufuegen("FEHLER: Ungültiger Zug! Größere Scheibe darf nicht auf kleinere gelegt werden.");
                    }
                }
            }
        }
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