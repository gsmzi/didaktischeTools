/**
 * Hauptprogramm: p08_snake (Schülervorlage)
 * 
 * Implementiert das Spiel Snake auf Basis einer Ringpuffer-Warteschlange (ArrayQueue).
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - ArrayQueue.pde:
 *   Ringpuffer-Warteschlange zur Speicherung der Körpersegmente der Schlange.
 *   Zu programmieren: isEmpty(), enqueue(T x), dequeue(), front(), verdoppleKapazitaet().
 * - Snake.pde:
 *   Schlangenmodellierung mittels Warteschlange.
 *   Zu programmieren: bewege(boolean apfelGefressen):
 *   1. Kopfkoordinaten (kopfX, kopfY) um aktuelle Richtung (richtungX, richtungY) weitersetzen.
 *   2. Neues SnakeElement erzeugen und per enqueue() in 'koerper' einfügen.
 *   3. Falls apfelGefressen == false: Letztes Segment per dequeue() entfernen.
 * - (Vorgegeben: SnakeElement.pde [Körpersegment], Queue.pde [Interface],
 *    p08_snake.pde [Spielfeld, Tastensteuerung, Kollision, GUI])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

Snake dieSchlange;
int appleX, appleY;
int score = 0;
boolean gameOver = false;
boolean gamePaused = false;

// Zeitsteuerung
int lastUpdateTime = 0;
int baseInterval = 220; // Startgeschwindigkeit (ms)

// Grid-Konfiguration
final int GRID_W = 20;
final int GRID_H = 20;
final int CELL_SIZE = 20; // 20x20 Pixel pro Zelle -> 400x400 Pixel Spielfeld

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnReset;
Button btnPause;
Button btnSpeedDec;
Button btnSpeedInc;

void setup()
{
    size(1250, 750);
    surface.setResizable(true);
    
    // Spiel initialisieren
    neuesSpiel();
    
    // Buttons initialisieren
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    
    btnReset = new Button(50, 95, 120, 25, "Neues Spiel", colGefahr);
    btnPause = new Button(185, 95, 120, 25, "Pause / Weiter", colAktion);
    btnSpeedDec = new Button(320, 95, 25, 25, "-", colStandard);
    btnSpeedInc = new Button(380, 95, 25, 25, "+", colStandard);
    
    logHinzufuegen("Snake geladen. Verwende WASD oder Pfeiltasten zum Steuern.");
}

void neuesSpiel()
{
    dieSchlange = new Snake(5, 10);
    score = 0;
    gameOver = false;
    gamePaused = false;
    platziereApfel();
    lastUpdateTime = millis();
}

void platziereApfel()
{
    java.util.Random rnd = new java.util.Random();
    ArrayQueue<SnakeElement> aq = (ArrayQueue<SnakeElement>)dieSchlange.getKoerper();
    Object[] segs = aq.alsArray();
    
    boolean aufSchlange = true;
    while (aufSchlange)
    {
        appleX = rnd.nextInt(GRID_W);
        appleY = rnd.nextInt(GRID_H);
        
        // Prüfen, ob der Apfel auf der Schlange liegt
        aufSchlange = false;
        for (Object o : segs)
        {
            SnakeElement el = (SnakeElement)o;
            if (el != null && el.getX() == appleX && el.getY() == appleY)
            {
                aufSchlange = true;
                break;
            }
        }
    }
}

void draw()
{
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate
    
    // Spielschritt ausführen (Zeitgesteuert)
    int interval = max(80, baseInterval - score * 3); // Schlange wird schneller mit der Zeit
    if (!gameOver && !gamePaused)
    {
        int now = millis();
        if (now - lastUpdateTime > interval)
        {
            spielSchritt();
            lastUpdateTime = now;
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
    text("Snake & Queue-ADT", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Steuere die Schlange. Jedes Essen reiht ein neues Element am Kopf ein (enqueue) und vergrößert die Schlange.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    fill(gameOver ? color(239, 68, 68, 40) : (gamePaused ? color(245, 158, 11, 40) : color(16, 185, 129, 40)));
    stroke(gameOver ? color(239, 68, 68) : (gamePaused ? color(245, 158, 11) : color(16, 185, 129)));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    String statusStr = gameOver ? "GAME OVER!" : (gamePaused ? "PAUSE" : "IN BEWEGUNG");
    text("STATUS: " + statusStr, w - 130, 34);
    
    // 2. Control Panel
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, 50, 8);
    
    btnReset.zeichnen();
    btnPause.zeichnen();
    btnSpeedDec.zeichnen();
    btnSpeedInc.zeichnen();
    
    fill(255);
    textSize(11);
    textAlign(LEFT, CENTER);
    text("Intervall: " + interval + " ms", 425, 107);
    text("Punkte: " + score, 560, 107);
    
    // 3. Visualisierungsbereich
    float boardX = 30;
    float boardY = 150;
    float boardSize = GRID_W * CELL_SIZE; // 400x400
    
    // A. Spielfeld zeichnen
    drawSpielfeld(boardX, boardY);
    
    // B. Queue Internals Zeichnen (Rechts)
    float internalsX = boardX + boardSize + 40;
    float internalsY = boardY;
    float internalsW = w - internalsX - 30;
    float internalsH = boardSize;
    
    drawQueueInternals(internalsX, internalsY, internalsW, internalsH);
    
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
    text("SPIEL PROTOKOLL & QUEUE-AKTIONEN", 45, h - 110);
    
    textSize(11);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 50, h - 90 + i * 16);
    }
    
    popMatrix();
}

void spielSchritt()
{
    // Berechne nächste Kopf-Koordinate
    int naechsterX = dieSchlange.getKopfX() + dieSchlange.getRichtungX();
    int naechsterY = dieSchlange.getKopfY() + dieSchlange.getRichtungY();
    
    boolean apfelGefressen = (naechsterX == appleX && naechsterY == appleY);
    
    if (apfelGefressen)
    {
        dieSchlange.bewege(true);
        score += 10;
        logHinzufuegen("Apfel gefressen! enqueue(" + naechsterX + "," + naechsterY + ") ausgeführt. Länge wächst.");
        platziereApfel();
    }
    else
    {
        dieSchlange.bewege(false);
        // Didaktisches Logging: dequeue/enqueue zeigen
        logHinzufuegen("Bewegung: enqueue(" + naechsterX + "," + naechsterY + ") & dequeue() am Schwanz.");
    }
    
    // Kollision prüfen
    if (dieSchlange.pruefeKollision(GRID_W, GRID_H))
    {
        gameOver = true;
        logHinzufuegen("Kollision! Spiel beendet. Erreichte Punkte: " + score);
    }
}

/**
 * Zeichnet das Spielfeld mit Gitternetz, Apfel und Schlange.
 */
void drawSpielfeld(float x, float y)
{
    float size = GRID_W * CELL_SIZE;
    
    // Hintergrund-Container des Spielfelds
    fill(10, 15, 30);
    stroke(51, 65, 85);
    strokeWeight(2);
    rect(x, y, size, size, 4);
    
    // Subtiles Gitternetz
    stroke(30, 41, 59, 100);
    strokeWeight(1);
    for (int i = 1; i < GRID_W; i++) {
        line(x + i * CELL_SIZE, y, x + i * CELL_SIZE, y + size);
    }
    for (int j = 1; j < GRID_H; j++) {
        line(x, y + j * CELL_SIZE, x + size, y + j * CELL_SIZE);
    }
    
    // Apfel zeichnen (Pulsierendes Rot)
    float pulse = 2 + sin(frameCount * 0.15) * 2;
    fill(239, 68, 68);
    noStroke();
    ellipse(x + appleX * CELL_SIZE + CELL_SIZE/2, y + appleY * CELL_SIZE + CELL_SIZE/2, CELL_SIZE - 4 + pulse, CELL_SIZE - 4 + pulse);
    // Apfelstängel
    stroke(16, 185, 129);
    strokeWeight(1.5);
    line(x + appleX * CELL_SIZE + CELL_SIZE/2, y + appleY * CELL_SIZE + CELL_SIZE/2 - 2, x + appleX * CELL_SIZE + CELL_SIZE/2 + 2, y + appleY * CELL_SIZE + CELL_SIZE/2 - 7);
    
    // Schlange zeichnen
    ArrayQueue<SnakeElement> aq = (ArrayQueue<SnakeElement>)dieSchlange.getKoerper();
    Object[] segs = aq.alsArray();
    
    for (int i = 0; i < segs.length; i++)
    {
        SnakeElement el = (SnakeElement)segs[i];
        if (el == null) continue;
        
        // Farbverlauf von Kopf (helles Grün) bis Schwanz (dunkleres Blau-Grün)
        float inter = map(i, 0, segs.length - 1, 0, 1);
        color colSeg = lerpColor(color(16, 115, 80), color(52, 211, 153), inter);
        
        // Kopf kriegt ein anderes Design (z.B. Augen)
        boolean istKopf = (i == segs.length - 1);
        
        fill(colSeg);
        noStroke();
        rect(x + el.getX() * CELL_SIZE + 1, y + el.getY() * CELL_SIZE + 1, CELL_SIZE - 2, CELL_SIZE - 2, istKopf ? 6 : 4);
        
        if (istKopf)
        {
            // Augen zeichnen basierend auf Richtung
            fill(255);
            float eyeSize = 3;
            float cx = x + el.getX() * CELL_SIZE + CELL_SIZE/2;
            float cy = y + el.getY() * CELL_SIZE + CELL_SIZE/2;
            
            int rx = dieSchlange.getRichtungX();
            int ry = dieSchlange.getRichtungY();
            
            if (rx != 0) { // Horizontal
                ellipse(cx + rx*3, cy - 4, eyeSize, eyeSize);
                ellipse(cx + rx*3, cy + 4, eyeSize, eyeSize);
                fill(0);
                ellipse(cx + rx*3.5, cy - 4, 1.2, 1.2);
                ellipse(cx + rx*3.5, cy + 4, 1.2, 1.2);
            } else { // Vertikal
                ellipse(cx - 4, cy + ry*3, eyeSize, eyeSize);
                ellipse(cx + 4, cy + ry*3, eyeSize, eyeSize);
                fill(0);
                ellipse(cx - 4, cy + ry*3.5, 1.2, 1.2);
                ellipse(cx + 4, cy + ry*3.5, 1.2, 1.2);
            }
        }
    }
    
    // Game Over Overlay
    if (gameOver)
    {
        fill(15, 23, 42, 220);
        rect(x, y, size, size, 4);
        
        fill(239, 68, 68);
        textSize(24);
        textAlign(CENTER, CENTER);
        text("GAME OVER!", x + size/2, y + size/2 - 20);
        
        fill(255);
        textSize(12);
        text("Punkte: " + score, x + size/2, y + size/2 + 15);
        textSize(10);
        text("Drücke 'Neues Spiel' zum Neustarten", x + size/2, y + size/2 + 40);
    }
}

/**
 * Visualisiert didaktisch den genauen Zustand der Queue im Array (Internals-Viewer).
 */
void drawQueueInternals(float x, float y, float w, float h)
{
    // Container zeichnen
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    fill(241, 245, 249);
    textSize(12);
    textAlign(CENTER, TOP);
    text("Queue-Ringpuffer Backing Array (Interna)", x + w/2, y + 15);
    
    ArrayQueue<SnakeElement> aq = (ArrayQueue<SnakeElement>)dieSchlange.getKoerper();
    Object[] daten = aq.getDaten();
    int kopf = aq.getKopf();
    int schwanz = aq.getSchwanz();
    int anzahl = aq.getAnzahl();
    int arraySize = daten.length;
    
    // Spaltenanzahl für die Grid-Darstellung (Immer 5 Spalten)
    int cols = 5;
    int rows = ceil((float)arraySize / cols);
    
    // Abstände
    float gridMarginX = 20;
    float gridMarginY = 45;
    float slotW = (w - gridMarginX * 2) / cols;
    float slotH = slotW; // Quadratische Slots
    
    // Falls das Grid zu hoch für die Box wird, verkleinern wir die Slots dynamisch
    if (gridMarginY + rows * slotH > h - 40)
    {
        slotH = (h - 40 - gridMarginY) / rows;
        slotW = slotH;
        gridMarginX = (w - cols * slotW) / 2;
    }
    
    textSize(9);
    textAlign(CENTER, CENTER);
    
    for (int i = 0; i < arraySize; i++)
    {
        int col = i % cols;
        int row = i / cols;
        
        float sx = x + gridMarginX + col * slotW;
        float sy = y + gridMarginY + row * slotH;
        
        // Zelle zeichnen
        boolean isOccupied = (daten[i] != null);
        
        // Farbe bestimmen:
        // Kopf (Lesezeiger) = Blau, Schwanz (Schreibzeiger) = Orange, Sonst Slate
        color zellFarbe = color(15, 23, 42, 100);
        color randFarbe = color(51, 65, 85);
        float randDicke = 1;
        
        if (i == kopf && i == schwanz) {
            // Zirkuläre Überschneidung
            zellFarbe = color(59, 130, 246, 70);
            randFarbe = color(245, 158, 11);
            randDicke = 2.5;
        } else if (i == kopf) {
            zellFarbe = color(59, 130, 246, 60); // Blau
            randFarbe = color(59, 130, 246);
            randDicke = 2;
        } else if (i == schwanz) {
            zellFarbe = color(245, 158, 11, 40); // Orange (Schreibzeiger / Frei)
            randFarbe = color(245, 158, 11);
            randDicke = 2;
        } else if (isOccupied) {
            zellFarbe = color(16, 185, 129, 30); // Belegte Schlangenzelle
            randFarbe = color(16, 185, 129, 150);
        }
        
        fill(zellFarbe);
        stroke(randFarbe);
        strokeWeight(randDicke);
        rect(sx + 3, sy + 3, slotW - 6, slotH - 6, 6);
        
        // Indexnummer in der Ecke
        fill(100, 116, 139);
        textSize(8);
        textAlign(LEFT, TOP);
        text("[" + i + "]", sx + 8, sy + 8);
        
        // Zeiger-Beschriftung
        if (i == kopf || i == schwanz)
        {
            fill(255);
            textSize(7.5);
            textAlign(RIGHT, BOTTOM);
            String label = "";
            if (i == kopf && i == schwanz) label = "Kopf/Schw";
            else if (i == kopf) label = "Kopf (R)";
            else if (i == schwanz) label = "Schw (W)";
            
            text(label, sx + slotW - 8, sy + slotH - 8);
        }
        
        // Zelleninhalt zeichnen
        if (isOccupied)
        {
            SnakeElement el = (SnakeElement)daten[i];
            
            // Symbol
            fill(52, 211, 153);
            noStroke();
            ellipse(sx + slotW/2, sy + slotH/2 - 2, 8, 8);
            
            // Koordinate zeichnen
            fill(226, 232, 240);
            textSize(8);
            textAlign(CENTER, TOP);
            text("(" + el.getX() + "," + el.getY() + ")", sx + slotW/2, sy + slotH/2 + 5);
        }
        else
        {
            // Faint 'null'
            fill(100, 116, 139, 80);
            textSize(8);
            textAlign(CENTER, CENTER);
            text("null", sx + slotW/2, sy + slotH/2);
        }
    }
    
    // Legende unten drunter zeichnen
    float legY = y + h - 30;
    textAlign(LEFT, CENTER);
    textSize(9);
    
    fill(59, 130, 246);
    rect(x + 20, legY, 10, 10, 2);
    fill(255);
    text("Kopf (front/Lese-Index)", x + 35, legY + 5);
    
    fill(245, 158, 11);
    rect(x + 160, legY, 10, 10, 2);
    fill(255);
    text("Schwanz (next free/Schreib-Index)", x + 175, legY + 5);
    
    fill(16, 185, 129, 80);
    rect(x + 330, legY, 10, 10, 2);
    fill(255);
    text("Belegt", x + 345, legY + 5);
}

void keyPressed()
{
    // Tastatursteuerung (WASD & Pfeiltasten)
    if (key == 'w' || key == 'W' || keyCode == UP)
    {
        dieSchlange.setRichtung(0, -1);
    }
    else if (key == 's' || key == 'S' || keyCode == DOWN)
    {
        dieSchlange.setRichtung(0, 1);
    }
    else if (key == 'a' || key == 'A' || keyCode == LEFT)
    {
        dieSchlange.setRichtung(-1, 0);
    }
    else if (key == 'd' || key == 'D' || keyCode == RIGHT)
    {
        dieSchlange.setRichtung(1, 0);
    }
    else if (key == 'p' || key == 'P')
    {
        gamePaused = !gamePaused;
        logHinzufuegen(gamePaused ? "Spiel pausiert." : "Spiel fortgesetzt.");
    }
}

void mousePressed()
{
    if (btnReset.mouseOver())
    {
        neuesSpiel();
        logHinzufuegen("Neues Spiel gestartet.");
    }
    
    if (btnPause.mouseOver() && !gameOver)
    {
        gamePaused = !gamePaused;
        logHinzufuegen(gamePaused ? "Spiel pausiert." : "Spiel fortgesetzt.");
    }
    
    if (btnSpeedDec.mouseOver() && baseInterval < 400)
    {
        baseInterval += 20;
    }
    
    if (btnSpeedInc.mouseOver() && baseInterval > 100)
    {
        baseInterval -= 20;
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