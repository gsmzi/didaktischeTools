/**
 * Hauptprogramm: p10_terme (Musterlösung)
 * 
 * Bietet einen interaktiven Playground zur Auswertung von Rechenbäumen:
 * - Basiert auf dem ADT Binaerbaum (Binärbaum).
 * - Parst beliebige mathematische Ausdrücke live in einen Rechenbaum.
 * - Rendert den Rechenbaum mit didaktischen Teilergebnissen an den Operatorknoten.
 * - Ermöglicht Tastatureingabe und Schnelllade-Termbeispiele.
 * - Protokolliert alle Auswertungen live im Logger.
 * 
 * @author Antigravity
 * @version September 2026
 */

Binaerbaum<Symbol> aktuellerBaum = null;
TermAuswerter auswerter = new TermAuswerter();

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Eingabevariablen
String termEingabe = "(3 + 4) * (8 - 2)";
boolean inputActive = false;
String errorMessage = null;

// Buttons
Button btnParse;
Button btnPreset1, btnPreset2, btnPreset3, btnPreset4;

void setup()
{
    size(1250, 750);
    surface.setResizable(true);
    
    // Buttons
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    
    btnParse = new Button(230, 125, 65, 25, "Parsen", colAktion);
    
    btnPreset1 = new Button(50, 250, 140, 25, "(12 + 4) * (8 - 2)", colStandard);
    btnPreset2 = new Button(200, 250, 140, 25, "3 * 5 + 4 * 2", colStandard);
    btnPreset3 = new Button(50, 285, 140, 25, "100 / (4 * 5) - 2", colStandard);
    btnPreset4 = new Button(200, 285, 140, 25, "(3 + 5) * (10 / 2) + 7", colStandard);
    
    termParsen();
    
    logHinzufuegen("Term-Evaluator geladen. Tippe einen Term ein oder lade ein Beispiel.");
}

void termParsen()
{
    errorMessage = null;
    try
    {
        aktuellerBaum = TermParser.parse(termEingabe);
        logHinzufuegen("Term erfolgreich geparst: \"" + termEingabe + "\"");
    }
    catch (Exception x)
    {
        aktuellerBaum = null;
        errorMessage = x.getMessage();
        logHinzufuegen("Fehler beim Parsen: " + errorMessage);
    }
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
    text("Arithmetischer Rechenbaum-Auswerter", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Parst algebraische Terme in einen Binärbaum, berechnet Teilergebnisse bottom-up und minimiert Klammern.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    boolean okay = (aktuellerBaum != null);
    fill(okay ? color(16, 185, 129, 40) : color(239, 68, 68, 40));
    stroke(okay ? color(16, 185, 129) : color(239, 68, 68));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(okay ? "TERM GÜLTIG" : "SYNTAXFEHLER", w - 130, 34);
    
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
    drawAnalysePanel(w - 360, 90, 330, h - 210);
    
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
    text("SPIEL PROTOKOLL & TERMAUSWERTER", 45, h - 110);
    
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
 * Zeichnet den Rechenbaum.
 */
void drawBaumGrafik(float w, float h)
{
    // Titel
    fill(241, 245, 249);
    textSize(13);
    textAlign(CENTER, TOP);
    text("Syntax-Rechenbaum (Evaluationsschritte)", w / 2, 0);
    
    if (aktuellerBaum == null)
    {
        fill(148, 163, 184);
        textSize(12);
        textAlign(CENTER, CENTER);
        text("(Kein gültiger Baum - Syntaxfehler beheben)", w / 2, h / 2);
        return;
    }
    
    // Baum zeichnen
    drawKnoten(aktuellerBaum, w / 2, 50, 160, 75, -1, -1);
}

void drawKnoten(Binaerbaum<Symbol> k, float x, float y, float dx, float dy, float px, float py)
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
    
    // Knotenfarbe: Operatoren sind orange-blau, Zahlen sind smaragdgrün
    boolean istOp = k.daten.istOperator();
    color strokeCol = istOp ? color(245, 158, 11) : color(16, 185, 129);
    color fillCol = istOp ? color(45, 30, 20) : color(15, 40, 25);
    
    stroke(strokeCol);
    strokeWeight(1.5);
    fill(fillCol);
    ellipse(x, y, 28, 28);
    
    fill(255);
    textSize(11);
    textAlign(CENTER, CENTER);
    text(k.daten.toString(), x, y - 1);
    
    // Didaktisches Highlight: Schreibe Teilergebnisse neben jeden Operator!
    if (istOp)
    {
        try
        {
            int teilErgebnis = auswerter.auswerten(k);
            fill(100, 116, 139);
            textSize(9.5);
            textAlign(LEFT, CENTER);
            text("=" + teilErgebnis, x + 18, y);
        }
        catch (Exception e)
        {
            fill(239, 68, 68);
            textSize(8);
            textAlign(LEFT, CENTER);
            text("=Err", x + 18, y);
        }
    }
}

/**
 * Zeichnet das rechte Kontroll-Panel.
 */
void drawAnalysePanel(float x, float y, float w, float h)
{
    // Container
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    // 1. Term-Eingabe
    fill(241, 245, 249);
    textSize(13);
    textAlign(LEFT, TOP);
    text("Term eintippen:", x + 20, y + 20);
    
    // Eingabefeld
    fill(15, 23, 42);
    stroke(inputActive ? color(59, 130, 246) : color(71, 85, 105));
    rect(x + 20, y + 45, 290, 25, 4);
    
    fill(255);
    textSize(11);
    textAlign(LEFT, CENTER);
    text(termEingabe + (inputActive && (frameCount / 20) % 2 == 0 ? "|" : ""), x + 30, y + 57);
    
    // Parsen-Button (neu platziert)
    btnParse.x = x + 20;
    btnParse.y = y + 80;
    btnParse.w = w - 40;
    btnParse.zeichnen();
    
    // 2. Schnelllade-Beispiele
    fill(241, 245, 249);
    textSize(13);
    textAlign(LEFT, TOP);
    text("Schnelllade-Termbeispiele:", x + 20, y + 130);
    
    btnPreset1.x = x + 20;
    btnPreset1.y = y + 155;
    btnPreset1.w = (w - 50) / 2;
    btnPreset1.zeichnen();
    
    btnPreset2.x = x + 30 + btnPreset1.w;
    btnPreset2.y = y + 155;
    btnPreset2.w = btnPreset1.w;
    btnPreset2.zeichnen();
    
    btnPreset3.x = x + 20;
    btnPreset3.y = y + 190;
    btnPreset3.w = btnPreset1.w;
    btnPreset3.zeichnen();
    
    btnPreset4.x = x + 30 + btnPreset1.w;
    btnPreset4.y = y + 190;
    btnPreset4.w = btnPreset1.w;
    btnPreset4.zeichnen();
    
    // 3. Auswertung
    fill(241, 245, 249);
    textSize(13);
    text("Baum-Auswertung:", x + 20, y + 245);
    
    if (aktuellerBaum != null)
    {
        fill(148, 163, 184);
        textSize(11);
        
        // Term auswerten
        try
        {
            int ergebnis = auswerter.auswerten(aktuellerBaum);
            String infixNormiert = auswerter.alsString(aktuellerBaum);
            
            text("Ergebnis (auswerten()): " + ergebnis, x + 30, y + 270);
            text("Normierter Term (alsString()):", x + 30, y + 290);
            
            fill(255);
            textSize(12);
            text(infixNormiert, x + 35, y + 310);
        }
        catch (Exception e)
        {
            fill(239, 68, 68);
            text("Berechnungsfehler: " + e.getMessage(), x + 30, y + 270);
        }
    }
    else
    {
        fill(239, 68, 68);
        textSize(10.5);
        String err = (errorMessage != null) ? errorMessage : "Ungültiger Term";
        text("Syntaxfehler:\n" + err, x + 30, y + 270, w - 60, 100);
    }
}

void mousePressed()
{
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    
    // Klick auf Eingabefeld prüfen
    float inX = width / GUI_SCALE - 360 + 20;
    float inY = 90 + 45;
    if (lmX >= inX && lmX <= inX + 290 && lmY >= inY && lmY <= inY + 25)
    {
        inputActive = true;
    }
    else
    {
        inputActive = false;
    }
    
    // Buttons
    if (btnParse.mouseOver())
    {
        termParsen();
    }
    if (btnPreset1.mouseOver())
    {
        termEingabe = "(12 + 4) * (8 - 2)";
        termParsen();
    }
    if (btnPreset2.mouseOver())
    {
        termEingabe = "3 * 5 + 4 * 2";
        termParsen();
    }
    if (btnPreset3.mouseOver())
    {
        termEingabe = "100 / (4 * 5) - 2";
        termParsen();
    }
    if (btnPreset4.mouseOver())
    {
        termEingabe = "(3 + 5) * (10 / 2) + 7";
        termParsen();
    }
}

void keyPressed()
{
    if (inputActive)
    {
        if ((key >= '0' && key <= '9') || "+-*/() ".contains(String.valueOf(key)))
        {
            if (termEingabe.length() < 35)
            {
                termEingabe += key;
            }
        }
        else if (key == BACKSPACE && termEingabe.length() > 0)
        {
            termEingabe = termEingabe.substring(0, termEingabe.length() - 1);
        }
        else if (key == ENTER || key == RETURN)
        {
            termParsen();
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