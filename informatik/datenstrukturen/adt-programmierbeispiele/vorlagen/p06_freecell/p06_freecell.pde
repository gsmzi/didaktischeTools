/**
 * Hauptprogramm: p06_freecell (Schülervorlage)
 * 
 * Implementiert das Kartenspiel Freecell auf Basis des ADT Stack (Stapelspeicher).
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - ArrayStack.pde:
 *   Generischer Stapelspeicher für Spielkarten.
 *   Zu programmieren: push(T x), pop(), top(), isEmpty().
 * - FreecellGame.pde:
 *   Spiellogik und Kartenschiebe-Regelwerk von Freecell.
 *   Zu programmieren:
 *   1. Konstruktor: Stacks für ablagestapel[4] und kaskaden[8] instanziieren.
 *   2. getKarte(bereich, index): Oberste Karte eines Bereichs abfragen.
 *   3. verschiebe(vonBereich, vonIndex, nachBereich, nachIndex):
 *      Regeln validieren (Zellen: leer; Kaskaden: absteigender Wert + alternierende Farbe;
 *      Ablagen: aufsteigend + gleiche Farbe ab As), Karte umstapeln und Rückgabe true/false.
 *   4. (Optional für Fortgeschrittene: automatischerZug() und schnellerZug()).
 * - (Vorgegeben: Karte.pde [Kartenmodell & Vektorgrafik], Stack.pde [Interface],
 *    p06_freecell.pde [Spielfeld, Drag&Drop, GUI])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

FreecellGame dasSpiel;
int spielNummer = 1;

// Interaktions-Variablen
int selectedBereich = FreecellGame.KEINER;
int selectedIndex = -1;

// Zeitsteuerung für Doppelklick-Erkennung
int lastClickTime = 0;
int lastClickBereich = FreecellGame.KEINER;
int lastClickIndex = -1;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnRandom;
Button btnAuto;
Button btnSpielDec;
Button btnSpielInc;
Button btnStartNummer;

// Cache für den Hintergrund
PGraphics bgCache;

void setup()
{
    size(1500, 950);
    surface.setResizable(true);
    
    // Spiel initialisieren
    dasSpiel = new FreecellGame(spielNummer);
    
    // Buttons initialisieren
    color colStandard = color(51, 65, 85);     // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    
    btnRandom = new Button(50, 95, 120, 25, "Zufälliges Spiel", colGefahr);
    btnAuto = new Button(185, 95, 120, 25, "Auto-Home", colAktion);
    btnSpielDec = new Button(320, 95, 25, 25, "-", colStandard);
    btnSpielInc = new Button(415, 95, 25, 25, "+", colStandard);
    btnStartNummer = new Button(455, 95, 140, 25, "Mit Nummer starten", colStandard);
    
    logHinzufuegen("Freecell geladen. Klicke auf eine Karte, um sie zu markieren, und auf das Ziel, um sie zu bewegen.");
}

void draw()
{
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    // Hintergrund-Cache generieren, falls Fenstergröße sich ändert oder noch nicht geladen
    if (bgCache == null || bgCache.width != width || bgCache.height != height) {
        bgCache = createGraphics(width, height);
        bgCache.beginDraw();
        for (int i = 0; i < height; i++) {
            float inter = map(i, 0, height, 0, 1);
            color c = lerpColor(color(16, 75, 39), color(10, 48, 25), inter);
            bgCache.stroke(c);
            bgCache.line(0, i, width, i);
        }
        bgCache.endDraw();
    }
    
    // Hintergrund zeichnen
    image(bgCache, 0, 0);
    
    pushMatrix();
    scale(GUI_SCALE);
    
    // 1. Header
    fill(15, 23, 42, 180);
    noStroke();
    rect(0, 0, w, 70);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text("Freecell Solitär", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Sortiere alle Karten auf die vier Ablagestapel von As bis König. Nutze die freien Zellen als Zwischenspeicher.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    boolean gewonnen = dasSpiel.istGewonnen();
    fill(gewonnen ? color(16, 185, 129, 40) : color(59, 130, 246, 40));
    stroke(gewonnen ? color(16, 185, 129) : color(59, 130, 246));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(gewonnen ? "STATUS: SPIEL GEWONNEN!" : "STATUS: IN ARBEIT", w - 130, 34);
    
    // 2. Control Panel
    fill(15, 23, 42, 100);
    stroke(16, 185, 129, 50);
    strokeWeight(1);
    rect(30, 80, w - 60, 50, 8);
    
    btnRandom.zeichnen();
    btnAuto.zeichnen();
    btnSpielDec.zeichnen();
    btnSpielInc.zeichnen();
    btnStartNummer.zeichnen();
    
    // Texte für Parameter
    fill(255);
    textSize(11);
    textAlign(LEFT, CENTER);
    text("Spiel-Nr: " + spielNummer, 355, 107);
    
    // 3. Spielfeld Visualisierung
    drawSpielfeld(w, h);
    
    // 4. Log-Konsole (unten)
    fill(15, 23, 42, 220);
    stroke(16, 185, 129, 80);
    strokeWeight(1);
    rect(30, h - 125, w - 60, 95, 8);
    
    fill(15, 40, 25);
    rect(30, h - 125, w - 60, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(10);
    textAlign(LEFT, CENTER);
    text("SPIEL PROTOKOLL & LOGGER", 45, h - 115);
    
    textSize(11);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 50, h - 95 + i * 16);
    }
    
    popMatrix();
}

/**
 * Zeichnet das Spielfeld mit allen Slots und Karten.
 */
void drawSpielfeld(float w, float h)
{
    // A. Freie Zellen (Freecells) - Spalten 0 bis 3
    for (int i = 0; i < 4; i++)
    {
        float x = 30 + i * 125;
        float y = 150;
        
        // Slot zeichnen
        fill(10, 48, 25, 150);
        stroke(16, 185, 129, 60);
        strokeWeight(2);
        rect(x, y, Karte.CARD_WIDTH, Karte.CARD_HEIGHT, 8);
        
        // Faint 'F' inside empty cells
        if (dasSpiel.getKarte(FreecellGame.ZELLEN, i) == null)
        {
            fill(16, 185, 129, 30);
            textSize(32);
            textAlign(CENTER, CENTER);
            text("F", x + Karte.CARD_WIDTH/2, y + Karte.CARD_HEIGHT/2);
        }
        else
        {
            Karte k = dasSpiel.getKarte(FreecellGame.ZELLEN, i);
            k.zeichne(x, y);
        }
    }
    
    // B. Ablagestapel (Foundations) - Spalten 4 bis 7
    for (int i = 0; i < 4; i++)
    {
        float x = 530 + i * 125;
        float y = 150;
        
        // Slot zeichnen
        fill(10, 48, 25, 150);
        stroke(16, 185, 129, 60);
        strokeWeight(2);
        rect(x, y, Karte.CARD_WIDTH, Karte.CARD_HEIGHT, 8);
        
        // Faint 'A' inside empty foundations
        if (dasSpiel.getKarte(FreecellGame.ABLAGESTAPEL, i) == null)
        {
            fill(16, 185, 129, 30);
            textSize(32);
            textAlign(CENTER, CENTER);
            text("A", x + Karte.CARD_WIDTH/2, y + Karte.CARD_HEIGHT/2);
        }
        else
        {
            Karte k = dasSpiel.getKarte(FreecellGame.ABLAGESTAPEL, i);
            k.zeichne(x, y);
        }
    }
    
    // C. Kaskaden (Arbeitsstapel)
    for (int i = 0; i < 8; i++)
    {
        float x = 30 + i * 125;
        float y = 320;
        
        int hoehe = dasSpiel.getStapelHoehe(i);
        float spacing = dynamicSpacing(i);
        
        // Wenn leer, zeichne einen Platzhalter-Rahmen
        if (hoehe == 0)
        {
            fill(10, 48, 25, 100);
            stroke(16, 185, 129, 30);
            strokeWeight(2);
            rect(x, y, Karte.CARD_WIDTH, Karte.CARD_HEIGHT, 8);
        }
        else
        {
            // Karten von unten nach oben zeichnen
            for (int j = 0; j < hoehe; j++)
            {
                Karte k = dasSpiel.getKarteInStapel(i, hoehe - 1 - j);
                k.zeichne(x, y + j * spacing);
            }
        }
    }
}

/**
 * Berechnet den optimalen Kartenabstand für eine Kaskade, damit sie nicht aus dem Bildschirm ragt.
 */
float dynamicSpacing(int index)
{
    int hoehe = dasSpiel.getStapelHoehe(index);
    if (hoehe <= 1) return 25;
    
    float h = height / GUI_SCALE;
    float availableH = h - 320 - Karte.CARD_HEIGHT - 140; // 140px Platz für Log/Konsole unten
    float spacing = availableH / (hoehe - 1);
    
    return constrain(spacing, 14, 28);
}

/**
 * Logik bei Klicks
 */
void mousePressed()
{
    // Klicks auf Buttons prüfen
    if (btnRandom.mouseOver())
    {
        java.util.Random rnd = new java.util.Random();
        spielNummer = rnd.nextInt(99999) + 1;
        dasSpiel = new FreecellGame(spielNummer);
        selectedBereich = FreecellGame.KEINER;
        selectedIndex = -1;
        logHinzufuegen("Zufälliges Spiel #" + spielNummer + " gestartet.");
        return;
    }
    
    if (btnAuto.mouseOver())
    {
        boolean zugGemacht = false;
        int zuegeCount = 0;
        // Führe automatische Heimbringungszüge aus, solange es geht
        while (dasSpiel.automatischerZug())
        {
            zugGemacht = true;
            zuegeCount++;
        }
        
        if (zugGemacht)
        {
            logHinzufuegen(zuegeCount + " Karte(n) automatisch auf Ablagestapel verschoben (Auto-Home).");
            if (dasSpiel.istGewonnen())
            {
                logHinzufuegen("HERZLICHEN GLÜCKWUNSCH! Du hast das Spiel gewonnen!");
            }
        }
        else
        {
            logHinzufuegen("Keine automatischen Züge möglich.");
        }
        return;
    }
    
    if (btnSpielDec.mouseOver() && spielNummer > 1)
    {
        spielNummer--;
        return;
    }
    
    if (btnSpielInc.mouseOver())
    {
        spielNummer++;
        return;
    }
    
    if (btnStartNummer.mouseOver())
    {
        dasSpiel = new FreecellGame(spielNummer);
        selectedBereich = FreecellGame.KEINER;
        selectedIndex = -1;
        logHinzufuegen("Spiel #" + spielNummer + " gestartet.");
        return;
    }
    
    // Spielfeldbereich anklicken
    float lmX = mouseX / GUI_SCALE;
    float lmY = mouseY / GUI_SCALE;
    
    int clickBereich = FreecellGame.KEINER;
    int clickIndex = -1;
    
    // 1. Klick auf freie Zellen?
    if (lmY >= 150 && lmY <= 150 + Karte.CARD_HEIGHT)
    {
        for (int i = 0; i < 4; i++)
        {
            float x = 30 + i * 125;
            if (lmX >= x && lmX <= x + Karte.CARD_WIDTH)
            {
                clickBereich = FreecellGame.ZELLEN;
                clickIndex = i;
                break;
            }
        }
    }
    
    // 2. Klick auf Ablagestapel?
    if (lmY >= 150 && lmY <= 150 + Karte.CARD_HEIGHT && clickBereich == FreecellGame.KEINER)
    {
        for (int i = 0; i < 4; i++)
        {
            float x = 530 + i * 125;
            if (lmX >= x && lmX <= x + Karte.CARD_WIDTH)
            {
                clickBereich = FreecellGame.ABLAGESTAPEL;
                clickIndex = i;
                break;
            }
        }
    }
    
    // 3. Klick auf Kaskaden?
    if (lmY >= 320 && clickBereich == FreecellGame.KEINER)
    {
        for (int i = 0; i < 8; i++)
        {
            float x = 30 + i * 125;
            if (lmX >= x && lmX <= x + Karte.CARD_WIDTH)
            {
                int hoehe = dasSpiel.getStapelHoehe(i);
                float spacing = dynamicSpacing(i);
                float maxY = max(320 + Karte.CARD_HEIGHT, 320 + Karte.CARD_HEIGHT + (hoehe - 1) * spacing);
                
                if (lmY <= maxY)
                {
                    clickBereich = FreecellGame.KASKADEN;
                    clickIndex = i;
                    break;
                }
            }
        }
    }
    
    // Wenn kein gültiger Bereich angeklickt wurde, hebe Auswahl auf
    if (clickBereich == FreecellGame.KEINER)
    {
        entferneAuswahl();
        return;
    }
    
    // Doppelklick / Schnellzug-Erkennung
    int now = millis();
    boolean istDoppelklick = (clickBereich == lastClickBereich && clickIndex == lastClickIndex && (now - lastClickTime) < 300);
    lastClickTime = now;
    lastClickBereich = clickBereich;
    lastClickIndex = clickIndex;
    
    if (istDoppelklick)
    {
        entferneAuswahl();
        Karte k = dasSpiel.getKarte(clickBereich, clickIndex);
        if (k != null)
        {
            String name = getKartenName(k);
            if (dasSpiel.schnellerZug(clickBereich, clickIndex))
            {
                logHinzufuegen("Schnellzug: " + name + " verschoben.");
                checkSpielEnde();
            }
            else
            {
                logHinzufuegen("Schnellzug für " + name + " nicht möglich.");
            }
        }
        return;
    }
    
    // Normaler Spielzug (Click-to-Select / Click-to-Move)
    if (selectedBereich == FreecellGame.KEINER)
    {
        // 1. Schritt: Karte auswählen
        Karte k = dasSpiel.getKarte(clickBereich, clickIndex);
        if (k != null)
        {
            if (clickBereich == FreecellGame.ABLAGESTAPEL)
            {
                logHinzufuegen("Karten auf Ablagestapeln können nicht bewegt werden.");
                return;
            }
            selectedBereich = clickBereich;
            selectedIndex = clickIndex;
            k.setMarkiert(true);
            logHinzufuegen(getKartenName(k) + " ausgewählt. Wähle ein Ziel.");
        }
    }
    else
    {
        // 2. Schritt: Karte verschieben
        Karte selectedKarte = dasSpiel.getKarte(selectedBereich, selectedIndex);
        
        if (selectedBereich == clickBereich && selectedIndex == clickIndex)
        {
            // Erneuter Klick auf dieselbe Karte -> Deselektieren
            entferneAuswahl();
            logHinzufuegen("Auswahl aufgehoben.");
        }
        else
        {
            String name = getKartenName(selectedKarte);
            String zielTyp = (clickBereich == FreecellGame.ZELLEN) ? "freie Zelle " + clickIndex : 
                             ((clickBereich == FreecellGame.ABLAGESTAPEL) ? "Ablagestapel " + clickIndex : "Kaskade " + clickIndex);
            
            // Bewegung ausführen
            if (dasSpiel.verschiebe(selectedBereich, selectedIndex, clickBereich, clickIndex))
            {
                logHinzufuegen(name + " verschoben auf " + zielTyp + ".");
                entferneAuswahl();
                checkSpielEnde();
            }
            else
            {
                logHinzufuegen("FEHLER: Ungültiger Zug für " + name + "!");
                entferneAuswahl();
            }
        }
    }
}

/**
 * Hebt die aktuelle Kartenauswahl auf.
 */
void entferneAuswahl()
{
    if (selectedBereich != FreecellGame.KEINER && selectedIndex != -1)
    {
        Karte k = dasSpiel.getKarte(selectedBereich, selectedIndex);
        if (k != null)
        {
            k.setMarkiert(false);
        }
    }
    selectedBereich = FreecellGame.KEINER;
    selectedIndex = -1;
}

/**
 * Gibt einen sprechenden Namen für die Karte zurück (z.B. "Herz-As" oder "Pik-10")
 */
String getKartenName(Karte k)
{
    if (k == null) return "";
    String farbeStr = "";
    if (k.getFarbe() == Karte.PIK) farbeStr = "Pik";
    else if (k.getFarbe() == Karte.KREUZ) farbeStr = "Kreuz";
    else if (k.getFarbe() == Karte.HERZ) farbeStr = "Herz";
    else if (k.getFarbe() == Karte.KARO) farbeStr = "Karo";
    
    String wertStr = "";
    if (k.getWert() == 1) wertStr = "As";
    else if (k.getWert() == 11) wertStr = "Bube";
    else if (k.getWert() == 12) wertStr = "Dame";
    else if (k.getWert() == 13) wertStr = "König";
    else wertStr = String.valueOf(k.getWert());
    
    return farbeStr + "-" + wertStr;
}

void checkSpielEnde()
{
    if (dasSpiel.istGewonnen())
    {
        logHinzufuegen("GLÜCKWUNSCH! Du hast das Spiel gewonnen!");
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