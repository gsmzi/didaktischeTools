/**
 * Klasse LinkedStack (Schülervorlage)
 * 
 * Implementiert einen Stack basierend auf einer einfach verketteten Liste.
 * Die Einfüge- und Löschoperationen (push/pop) finden am Kopf der Liste statt, 
 * da dies eine Laufzeit von O(1) ermöglicht.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean isEmpty()
 *    - Prüfen, ob der Stapel leer ist (topNode == null).
 * 2. void push(T wert)
 *    - Neues Element oben auf den Stapel legen.
 *    - Neuen Listenknoten erzeugen (Inhalt: wert, Nachfolger: topNode).
 *    - Zeiger umbiegen: Der neue Knoten wird zum neuen topNode.
 * 3. T pop()
 *    - Oberstes Element entfernen und zurückgeben.
 *    - Wenn leer: null zurückgeben.
 *    - Wert von topNode merken, Zeiger umbiegen (topNode = topNode.nachfolger)
 *      und gemerkten Wert zurückgeben.
 * 4. T top()
 *    - Oberstes Element ansehen, ohne es zu entfernen.
 *    - Wenn leer: null zurückgeben, sonst topNode.daten zurückgeben.
 * ============================================================================
 * 
 * Visualisierung:
 * Zeichnet die dynamische verkettete Knotenstruktur vertikal von oben (topNode) 
 * nach unten (Listenende / null). Jeder Knoten ist zweigeteilt (daten und nachfolger).
 * Ein Pfeil zeigt auf den darunter liegenden Knoten. Das Ende verweist auf 'null'.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class LinkedStack<T> extends Stack<T>
{
    /**
     * Der Zeiger auf den obersten Knoten des Stacks.
     * Ist 'null', wenn der Stack leer ist.
     */
    private Listenknoten<T> topNode;

    /**
     * Erzeugt einen neuen leeren Stack.
     */
    LinkedStack()
    {
        topNode = null;
    }

    /**
     * Gibt das oberste Element zurück, ohne es zu entfernen.
     */
    T top()
    {
        //# TODO: top() implementieren: Das oberste Element zurückgeben, ohne es vom Stapel zu entfernen.
        // 1. Prüfen, ob der Stack leer ist. Falls ja, null zurückgeben.
        // 2. Ansonsten die Daten des topNode zurückgeben.
        return null;
    }

    /**
     * Entfernt das oberste Element und gibt es zurück.
     * Dazu wird der topNode-Zeiger auf den Nachfolger des aktuellen topNode verbogen.
     * 
     * @return Das bisherige oberste Element oder null, falls der Stack leer ist.
     */
    T pop()
    {
        //# TODO: pop() implementieren: Das oberste Element entfernen und zurückgeben.
        // 1. Prüfen, ob der Stack leer ist. Falls ja, null zurückgeben.
        // 2. Den Wert von topNode in einer Variable zwischenspeichern.
        // 3. ZEIGER BIEGEN: Den topNode-Zeiger auf den Nachfolger des aktuellen topNode setzen.
        // 4. Den zwischengespeicherten Wert zurückgeben.
        return null;
    }

    /**
     * Legt ein neues Element auf den Stack.
     * Ein neuer Knoten wird erzeugt, dessen Nachfolger auf den bisherigen topNode zeigt.
     * Dieser neue Knoten wird dann zum neuen topNode.
     * 
     * @param wert Das aufzulegende Element
     */
    void push(T wert)
    {
        //# TODO: push(T wert) implementieren: Neues Element oben auf den Stapel legen.
        // 1. Einen neuen Listenknoten erzeugen. Dieser erhält als Inhalt 'wert' und
        //    als Nachfolger den bisherigen 'topNode'.
        // 2. ZEIGER BIEGEN: Der neue Knoten wird zum neuen 'topNode' ernannt.
    }

    /**
     * Gibt zurück, ob der Stack leer ist.
     */
    boolean isEmpty()
    {
        //# TODO: isEmpty() implementieren: Prüfen, ob der Stack leer ist (ob topNode null ist).
        return false;
    }
    
    /**
     * Zeichnet den verketteten Stack grafisch auf die Processing-Leinwand.
     * Didaktischer Aufbau:
     * - Der Stapel steht auf dem Boden (Null-Symbol bei y - 20) und wächst nach oben.
     * - Der unterste Knoten zeigt auf das Null-Symbol (Erdung).
     * - Jeder Knoten ist zweigeteilt: links Daten (Wert), rechts Zeigerfach (mit Zeigerpunkt).
     * - Ein Zeiger verlässt das Zeigerfach nach rechts und führt sauber senkrecht in den darunterliegenden Nachfolger.
     * - Der Zeiger 'topNode' befindet sich direkt über dem obersten Element (Spitze) und zeigt nach unten.
     * - Der oberste Knoten ist durch smaragdgrüne Färbung hervorgehoben (LIFO: nächstes pop-Element).
     */
    void grafischZeichnen(float x, float y, float breite, float hoehe)
    {
        // Knoten sammeln von topNode nach unten
        ArrayList<Listenknoten<T>> knotenListe = new ArrayList<Listenknoten<T>>();
        Listenknoten<T> curr = topNode;
        while (curr != null)
        {
            knotenListe.add(curr);
            curr = curr.nachfolger;
        }
        int anzahlKnoten = knotenListe.size();
        
        float knotenBreite = 150;
        float datenBreite = 105;
        float zeigerBreite = 45;
        float zellenHoehe = 36;
        float schrittY = 60; // 36px Knotenhöhe + 24px Abstand
        
        float startX = x - knotenBreite / 2; // Zentriert um x
        float dotX = startX + datenBreite + zeigerBreite / 2; // Zeigerpunkt-Mitte
        
        // 1. Fall: Stack ist leer
        if (anzahlKnoten == 0)
        {
            float topBadgeY = y - 70;
            float nullY = y - 20;
            
            // Titel und Info
            fill(241, 245, 249);
            textSize(13);
            textAlign(CENTER, BOTTOM);
            text("Verkettete Knoten (LinkedStack)", x, topBadgeY - 35);
            
            fill(239, 68, 68);
            textSize(10);
            text("Stapel ist leer (0 Elemente) | topNode == null", x, topBadgeY - 20);
            
            // topNode Badge
            fill(30, 41, 59);
            stroke(239, 68, 68);
            strokeWeight(1.5);
            rect(x - 40, topBadgeY - 12, 80, 24, 6);
            
            fill(241, 245, 249);
            textSize(11);
            textAlign(CENTER, CENTER);
            text("topNode", x, topBadgeY - 1);
            
            // Roter Zeiger direkt auf null
            drawVerticalArrow(x, topBadgeY + 12, x, nullY - 8, color(239, 68, 68));
            drawNullSymbol(x, nullY);
            return;
        }
        
        // 2. Fall: Stack enthält Elemente
        // Wir verankern den untersten Knoten (Index anzahlKnoten - 1) bei bodenY
        float bodenY = y - 55;
        float nullY = y - 15;
        
        // Y-Koordinate des obersten Knotens (Index 0)
        float topNodeY = bodenY - (anzahlKnoten - 1) * schrittY;
        float topBadgeY = topNodeY - zellenHoehe / 2 - 32;
        float titleY = topBadgeY - 25;
        
        // Titel und Info zeichnen (mindestens 25px über dem topNode-Badge)
        fill(241, 245, 249);
        textSize(13);
        textAlign(CENTER, BOTTOM);
        text("Verkettete Knoten (LinkedStack)", x, titleY - 14);
        
        fill(148, 163, 184);
        textSize(10);
        text("Dynamischer Speicherbedarf | " + anzahlKnoten + (anzahlKnoten == 1 ? " Element" : " Elemente"), x, titleY);
        
        // topNode Badge über dem obersten Element
        fill(30, 41, 59);
        stroke(16, 185, 129); // Grün für topNode
        strokeWeight(1.5);
        rect(x - 40, topBadgeY - 12, 80, 24, 6);
        
        fill(16, 185, 129);
        textSize(11);
        textAlign(CENTER, CENTER);
        text("topNode", x, topBadgeY - 1);
        
        // Pfeil vom topNode-Badge in die Oberkante des obersten Knotens
        drawVerticalArrow(x, topBadgeY + 12, x, topNodeY - zellenHoehe / 2, color(16, 185, 129));
        
        // Knoten von oben nach unten zeichnen
        for (int i = 0; i < anzahlKnoten; i++)
        {
            Listenknoten<T> k = knotenListe.get(i);
            float nodeY = bodenY - (anzahlKnoten - 1 - i) * schrittY;
            boolean istTop = (i == 0);
            
            // Farbgebung: Oberster Knoten smaragdgrün, darunter liegende Slate
            color datenFarbe = istTop ? color(16, 185, 129) : color(30, 41, 59);
            color datenRand = istTop ? color(52, 211, 153) : color(71, 85, 105);
            
            // Daten-Box zeichnen
            fill(datenFarbe);
            stroke(datenRand);
            strokeWeight(istTop ? 1.5 : 1);
            rect(startX, nodeY - zellenHoehe / 2, datenBreite, zellenHoehe, 6, 0, 0, 6);
            
            // Datenwert
            fill(255);
            textSize(13);
            textAlign(CENTER, CENTER);
            String datenText = k.daten != null ? k.daten.toString() : "null";
            text(datenText, startX + datenBreite / 2, nodeY - 1);
            
            // Zeiger-Box (nachfolger) zeichnen
            fill(51, 65, 85);
            stroke(datenRand);
            strokeWeight(1);
            rect(startX + datenBreite, nodeY - zellenHoehe / 2, zeigerBreite, zellenHoehe, 0, 6, 6, 0);
            
            // Zeigerpunkt (Dot)
            fill(226, 232, 240);
            noStroke();
            ellipse(dotX, nodeY, 6, 6);
            
            // Kleine didaktische Beschriftung links neben dem Knoten
            if (istTop)
            {
                fill(16, 185, 129);
                textSize(9);
                textAlign(RIGHT, CENTER);
                text("Spitze (top)", startX - 10, nodeY - 1);
            }
            else if (i == anzahlKnoten - 1 && anzahlKnoten > 1)
            {
                fill(100, 116, 139);
                textSize(9);
                textAlign(RIGHT, CENTER);
                text("Boden", startX - 10, nodeY - 1);
            }
            
            // Zeiger-Verbindung zum nächsten Knoten oder null
            if (k.nachfolger != null)
            {
                float nextNodeY = nodeY + schrittY;
                float midY = nodeY + zellenHoehe / 2 + 12; // Genau in der Mitte der 24px-Lücke
                
                stroke(148, 163, 184);
                strokeWeight(1.5);
                line(dotX, nodeY, dotX + 22, nodeY);
                line(dotX + 22, nodeY, dotX + 22, midY);
                line(dotX + 22, midY, x, midY);
                drawVerticalArrow(x, midY, x, nextNodeY - zellenHoehe / 2);
            }
            else
            {
                // Unterster Knoten verweist auf null
                float midY = nodeY + zellenHoehe / 2 + 12;
                
                stroke(148, 163, 184);
                strokeWeight(1.5);
                line(dotX, nodeY, dotX + 22, nodeY);
                line(dotX + 22, nodeY, dotX + 22, midY);
                line(dotX + 22, midY, x, midY);
                
                // Zeigerlinie hinab zum Erdungssymbol
                stroke(239, 68, 68);
                line(x, midY, x, nullY - 8);
                drawNullSymbol(x, nullY);
            }
        }
    }
    
    /**
     * Hilfsmethode zum Zeichnen eines Zeigerpfeils.
     */
    private void drawArrow(float x1, float y1, float x2, float y2)
    {
        line(x1, y1, x2, y2);
        pushMatrix();
        translate(x2, y2);
        float winkel = atan2(y2 - y1, x2 - x1);
        rotate(winkel);
        fill(148, 163, 184);
        noStroke();
        triangle(0, 0, -6, -3, -6, 3);
        popMatrix();
    }
    
    /**
     * Hilfsmethode zum Zeichnen eines vertikalen Zeigerpfeils mit Farbwahl (nach unten).
     */
    private void drawVerticalArrow(float x1, float y1, float x2, float y2, color pfeilFarbe)
    {
        stroke(pfeilFarbe);
        strokeWeight(1.5);
        line(x1, y1, x2, y2);
        fill(pfeilFarbe);
        noStroke();
        triangle(x2, y2, x2 - 4, y2 - 7, x2 + 4, y2 - 7);
    }
    
    /**
     * Hilfsmethode zum Zeichnen eines vertikalen Zeigerpfeils in Standardfarbe (nach unten).
     */
    private void drawVerticalArrow(float x1, float y1, float x2, float y2)
    {
        drawVerticalArrow(x1, y1, x2, y2, color(148, 163, 184));
    }
    
    /**
     * Hilfsmethode zum Zeichnen eines Erdungs-Symbols (null).
     */
    private void drawNullSymbol(float x, float y)
    {
        strokeWeight(1.5);
        stroke(239, 68, 68); // Rot für null
        line(x - 8, y, x + 8, y);
        line(x - 5, y + 3, x + 5, y + 3);
        line(x - 2, y + 6, x + 2, y + 6);
        
        fill(239, 68, 68);
        noStroke();
        textSize(9);
        textAlign(CENTER, TOP);
        text("null", x, y + 9);
    }
    
    @Override
    public String toString()
    {
        String ergebnis = " <";
        Listenknoten<T> k = this.topNode;
        while (k != null)
        {
            ergebnis = k.daten + ergebnis;
            if (k.nachfolger != null)
            {
                ergebnis = ", " + ergebnis;
            }
            k = k.nachfolger;
        }
        return "[ " + ergebnis;
    }
}
