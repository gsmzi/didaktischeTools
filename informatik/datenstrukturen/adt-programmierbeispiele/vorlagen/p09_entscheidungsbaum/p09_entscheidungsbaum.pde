/**
 * Hauptprogramm: p09_entscheidungsbaum (Schülervorlage)
 * 
 * Implementiert einen interaktiven Entscheidungsbaum auf Basis des ADT Binaerbaum.
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - p09_entscheidungsbaum.pde:
 *   1. Methode entscheidungsbaumTesten():
 *      Aufbau eines eigenen hierarchischen Entscheidungsbaums aus Binaerbaum<String>-
 *      Objekten (Wurzel mit Ausgangsfrage, Verzweigungen für 'Ja' (links) und
 *      'Nein' (rechts), Lösungen/Diagnosen als Blattknoten).
 *   2. Klasse EntscheidungsFrame:
 *      Navigationslogik durch den Baum:
 *      - jaGeklickt(): aktuellen Zeiger auf baum.links setzen.
 *      - neinGeklickt(): aktuellen Zeiger auf baum.rechts setzen.
 *      - istLoesung(): prüfen, ob baum ein Blattknoten ist (baum.istBlatt()).
 *      - aktuellerText(): Text des aktuellen Knotens zurückgeben (baum.daten).
 * - (Vorgegeben: Binaerbaum.pde [Generischer Binärbaum], 2D-Baum-Rendering & GUI)
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

EntscheidungsFrame meinFrame;
Binaerbaum<String> startBaum; // Referenz auf die Wurzel zum Zurücksetzen

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnJa;
Button btnNein;
Button btnReset;

void setup()
{
    size(1200, 750);
    surface.setResizable(true);
    
    // Testbaum aufbauen und Frame instanziieren
    entscheidungsbaumTesten();
    
    // Buttons initialisieren
    color colAktiv = color(16, 185, 129);      // Smaragdgrün (Ja)
    color colGefahr = color(239, 68, 68);      // Rot (Nein)
    color colStandard = color(51, 65, 85);     // Slate 700 (Reset)
    
    btnJa = new Button(50, 260, 140, 40, "JA [J]", colAktiv);
    btnNein = new Button(210, 260, 140, 40, "NEIN [N]", colGefahr);
    btnReset = new Button(50, 320, 300, 35, "Neustart [R]", colStandard);
    
    logHinzufuegen("Entscheidungsbaum geladen. Verwende die Buttons oder Tasten J/N/R.");
}

/**
 * Erzeugt einen Entscheidungsbaum und übergibt ihn an das Frame
 */
void entscheidungsbaumTesten()
{
    //# TODO: Bauen Sie hier Ihren Entscheidungsbaum auf.
    // 1. Erzeugen Sie einen Wurzelknoten mit der ersten Frage.
    // 2. Erzeugen Sie die linken (Ja-Pfad) und rechten (Nein-Pfad) Unterbäume.
    // 
    // Beispiel:
    // Binaerbaum<String> meinBaum = new Binaerbaum<String>("Hast du versucht, das Gerät aus- und wieder einzuschalten?");
    // meinBaum.links = new Binaerbaum<String>("Bist du sicher, dass das Netzkabel eingesteckt ist?");
    // meinBaum.rechts = new Binaerbaum<String>("Dann versuche das zuerst!");
    // ...
    
    Binaerbaum<String> meinBaum = new Binaerbaum<String>("(Legen Sie hier Ihren Entscheidungsbaum an!)");
    
    // Der folgende Aufruf muss stehen bleiben
    startBaum = meinBaum;
    meinFrame = new EntscheidungsFrame(meinBaum);
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
    text("Interaktiver Entscheidungsbaum", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Visualisiert die Navigation durch einen Fehlerdiagnose-Binärbaum. Blätter stellen Lösungen dar.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    boolean geloest = meinFrame.istLoesung();
    fill(geloest ? color(16, 185, 129, 40) : color(59, 130, 246, 40));
    stroke(geloest ? color(16, 185, 129) : color(59, 130, 246));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(geloest ? "STATUS: LÖSUNG GEFUNDEN" : "STATUS: FRAGE OFFEN", w - 130, 34);
    
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
    
    // B. Rechte Seite: Interaktions-Panel
    drawInteraktionsPanel(w - 360, 90, 330, h - 210);
    
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
    text("SPIEL PROTOKOLL & AKTIONEN", 45, h - 110);
    
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
 * Zeichnet den kompletten Binärbaum mit Linien und farblichen Highlights.
 */
void drawBaumGrafik(float w, float h)
{
    // Titel
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Fehlersuche-Binärbaumstruktur", w / 2, 0);
    
    // Baum rekursiv zeichnen
    // Start x in der Mitte, y bei 60, horizontaler Abstand 170, vertikaler Abstand 90
    drawKnoten(startBaum, w / 2, 60, 160, 90, -1, -1);
}

void drawKnoten(Binaerbaum<String> k, float x, float y, float dx, float dy, float px, float py)
{
    if (k == null) return;
    
    // 1. Verbindungslinie zum Elternknoten zeichnen
    if (px != -1)
    {
        boolean pfadVerbindung = istAufPfad(k) && istAufPfad(getElternteil(startBaum, k));
        stroke(pfadVerbindung ? color(59, 130, 246) : color(51, 65, 85));
        strokeWeight(pfadVerbindung ? 3 : 1.5);
        line(px, py, x, y);
    }
    
    // Kinder rekursiv zeichnen (Abstand dx halbieren)
    drawKnoten(k.links, x - dx, y + dy, dx * 0.5, dy, x, y);
    drawKnoten(k.rechts, x + dx, y + dy, dx * 0.5, dy, x, y);
    
    // 2. Knoten selbst zeichnen
    boolean istAktiv = (k == meinFrame.baum);
    boolean pfadKnoten = istAufPfad(k);
    
    strokeWeight(istAktiv ? 3.5 : 1.5);
    if (istAktiv)
    {
        stroke(147, 197, 253); // Pulsierende Umrandung bei aktivem Knoten
        float pulse = sin(frameCount * 0.1) * 3;
        fill(59, 130, 246);
        if (k.istBlatt())
        {
            rect(x - 50 - pulse/2, y - 20 - pulse/2, 100 + pulse, 40 + pulse, 6);
        }
        else
        {
            ellipse(x, y, 46 + pulse, 46 + pulse);
        }
    }
    else
    {
        stroke(pfadKnoten ? color(59, 130, 246) : color(71, 85, 105));
        fill(pfadKnoten ? color(30, 41, 59) : color(15, 23, 42));
        if (k.istBlatt())
        {
            rect(x - 45, y - 18, 90, 36, 6);
        }
        else
        {
            ellipse(x, y, 40, 40);
        }
    }
    
    // Textbeschriftung des Knotens
    fill(255);
    textSize(8.5);
    textAlign(CENTER, CENTER);
    String labelText = k.daten;
    
    if (labelText == null) labelText = "(null)";
    
    // Kürzen für die Anzeige im Kreis/Box
    if (labelText.length() > 10)
    {
        labelText = labelText.substring(0, 8) + "..";
    }
    
    // Blätter erhalten ein spezielles Symbol
    if (k.istBlatt())
    {
        fill(16, 185, 129); // Grün für Lösungen
        text("Lösung", x, y - 5);
        fill(226, 232, 240);
        text(labelText, x, y + 6);
    }
    else
    {
        text(labelText, x, y);
    }
}

/**
 * Prüft rekursiv, ob der gegebene Knoten auf dem aktuellen Pfad liegt.
 * Ein Knoten ist auf dem Pfad, wenn der aktive Knoten (meinFrame.baum) ein Nachfahre von ihm ist.
 */
boolean istAufPfad(Binaerbaum<String> knoten)
{
    if (knoten == null) return false;
    if (meinFrame == null || meinFrame.baum == null) return false;
    if (knoten == meinFrame.baum) return true;
    return istUnterbaumVon(knoten.links, meinFrame.baum) || istUnterbaumVon(knoten.rechts, meinFrame.baum);
}

boolean istUnterbaumVon(Binaerbaum<String> wurzel, Binaerbaum<String> ziel)
{
    if (wurzel == null) return false;
    if (wurzel == ziel) return true;
    return istUnterbaumVon(wurzel.links, ziel) || istUnterbaumVon(wurzel.rechts, ziel);
}

Binaerbaum<String> getElternteil(Binaerbaum<String> aktueller, Binaerbaum<String> kind)
{
    if (aktueller == null || kind == null) return null;
    if (aktueller.links == kind || aktueller.rechts == kind) return aktueller;
    
    Binaerbaum<String> l = getElternteil(aktueller.links, kind);
    if (l != null) return l;
    return getElternteil(aktueller.rechts, kind);
}

/**
 * Zeichnet das rechte Interaktions-Panel.
 */
void drawInteraktionsPanel(float x, float y, float w, float h)
{
    // Container
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    // Titel
    fill(241, 245, 249);
    textSize(13);
    textAlign(LEFT, TOP);
    text(meinFrame.istLoesung() ? "Diagnoseergebnis:" : "Aktuelle Frage:", x + 20, y + 20);
    
    // Textbox
    fill(15, 23, 42, 180);
    stroke(51, 65, 85);
    rect(x + 20, y + 45, w - 40, 180, 6);
    
    fill(255);
    textSize(11.5);
    textAlign(LEFT, TOP);
    String text = meinFrame.aktuellerText();
    if (text == null) text = "(Kein Text)";
    text(text, x + 32, y + 60, w - 64, 150);
    
    // Knöpfe rendern
    if (!meinFrame.istLoesung())
    {
        btnJa.x = x + 20;
        btnJa.y = y + 240;
        btnJa.w = (w - 50) / 2;
        btnJa.zeichnen();
        
        btnNein.x = x + 30 + btnJa.w;
        btnNein.y = y + 240;
        btnNein.w = btnJa.w;
        btnNein.zeichnen();
    }
    
    btnReset.x = x + 20;
    btnReset.y = y + 300;
    btnReset.w = w - 40;
    btnReset.zeichnen();
}

void keyPressed()
{
    if (key == 'j' || key == 'J')
    {
        auswahlTreffen(true);
    }
    else if (key == 'n' || key == 'N')
    {
        auswahlTreffen(false);
    }
    else if (key == 'r' || key == 'R')
    {
        neustart();
    }
}

void mousePressed()
{
    if (!meinFrame.istLoesung())
    {
        if (btnJa.mouseOver())
        {
            auswahlTreffen(true);
        }
        if (btnNein.mouseOver())
        {
            auswahlTreffen(false);
        }
    }
    if (btnReset.mouseOver())
    {
        neustart();
    }
}

void auswahlTreffen(boolean ja)
{
    if (meinFrame.istLoesung()) return;
    
    String alteFrage = meinFrame.aktuellerText();
    if (ja)
    {
        meinFrame.jaGeklickt();
        logHinzufuegen("Ja geklickt zu: \"" + alteFrage + "\" -> " + meinFrame.aktuellerText());
    }
    else
    {
        meinFrame.neinGeklickt();
        logHinzufuegen("Nein geklickt zu: \"" + alteFrage + "\" -> " + meinFrame.aktuellerText());
    }
    
    if (meinFrame.istLoesung())
    {
        logHinzufuegen("Lösung erreicht! \"" + meinFrame.aktuellerText() + "\"");
    }
}

void neustart()
{
    meinFrame = new EntscheidungsFrame(startBaum);
    logHinzufuegen("Entscheidungsbaum zurückgesetzt auf Anfang.");
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