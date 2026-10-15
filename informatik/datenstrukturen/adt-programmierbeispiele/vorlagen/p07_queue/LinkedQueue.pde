/**
 * Klasse LinkedQueue (Schülervorlage)
 * 
 * Implementiert eine Warteschlange (Queue) basierend auf einer einfach verketteten Liste.
 * Um ein Einfügen am Ende (enqueue) und ein Entnehmen am Anfang (dequeue) in O(1) zu ermöglichen,
 * besitzt diese Queue sowohl einen Zeiger auf den ersten Knoten (first) als auch auf den letzten Knoten (last).
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean isEmpty()
 *    - Prüfen, ob die Queue leer ist (first == null).
 * 2. void enqueue(T x)
 *    - Neues Element am Ende der Warteschlange einreihen.
 *    - Neuen Knoten mit Inhalt 'x' erzeugen.
 *    - Falls die Queue leer ist: first und last auf den neuen Knoten setzen.
 *    - Andernfalls: last.nachfolger = neuerKnoten, last = neuerKnoten.
 * 3. T dequeue()
 *    - Vorderstes Element entnehmen und zurückgeben.
 *    - Wenn leer: null zurückgeben.
 *    - Wert von 'first' merken und 'first' auf 'first.nachfolger' umbiegen.
 *    - Falls 'first' danach null ist, auch 'last' auf null setzen.
 *    - Den gemerkten Wert zurückgeben.
 * 4. T front()
 *    - Vorderstes Element ansehen, ohne es zu entfernen.
 *    - Wenn leer: null zurückgeben, sonst first.daten zurückgeben.
 * ============================================================================
 * 
 * Visualisierung:
 * Zeichnet die dynamische verkettete Knotenstruktur horizontal von links (first / Kopf der Schlange)
 * nach rechts (last / Ende der Schlange).
 * Zeigerbeschriftungen markieren die Knoten 'first' und 'last'.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class LinkedQueue<T> extends Queue<T>
{
    /**
     * Der vorderste Knoten der Schlange (Einstieg zum Entnehmen).
     */
    private Listenknoten<T> first;
    
    /**
     * Der hinterste Knoten der Schlange (Einstieg zum Anfügen).
     */
    private Listenknoten<T> last;
    
    /**
     * Erzeugt eine neue, leere Queue.
     */
    LinkedQueue()
    {
        first = null;
        last = null;
    }
    
    /**
     * Gibt das vorderste Element der Queue zurück (ohne es zu entfernen).
     */
    T front()
    {
        //# TODO: Das vorderste Element zurückgeben, ohne es zu entfernen.
        // 1. Prüfen, ob die Schlange leer ist (first == null). Falls ja, null zurückgeben.
        // 2. Ansonsten die Daten von 'first' zurückgeben.
        return null;
    }
    
    /**
     * Entfernt das vorderste Element aus der Queue und gibt es zurück.
     * Setzt last auf null, wenn die Queue dadurch leer wird.
     * 
     * @return Das bisherige vorderste Element oder null, falls die Queue leer ist.
     */
    T dequeue()
    {
        //# TODO: Element vorne entnehmen und zurückgeben.
        // 1. Prüfen, ob die Schlange leer ist. Falls ja, null zurückgeben.
        // 2. Die Daten von 'first' in einer Variable zwischenspeichern.
        // 3. ZEIGER BIEGEN: 'first' auf den Nachfolger von 'first' setzen.
        // 4. Sonderfall prüfen: Ist 'first' jetzt null? Falls ja, muss auch 'last' auf null gesetzt werden.
        // 5. Den zwischengespeicherten Wert zurückgeben.
        return null;
    }
    
    /**
     * Fügt ein neues Element hinten in der Schlange ein.
     * 
     * @param x Das einzufügende Element
     */
    void enqueue(T x)
    {
        //# TODO: Element hinten anfügen.
        // 1. Prüfen, ob die Schlange leer ist (first == null).
        //    - Falls ja: Neuen Knoten erzeugen (mit Wert x) und diesen sowohl als 'first' als auch als 'last' festlegen.
        //    - Falls nein: 
        //      - Neuen Knoten als Nachfolger des bisherigen 'last' anfügen (last.nachfolger = ...).
        //      - ZEIGER BIEGEN: Den 'last'-Zeiger auf diesen neu erstellten Nachfolger setzen.
    }
    
    /**
     * Gibt zurück, ob die Queue leer ist.
     */
    boolean isEmpty()
    {
        //# TODO: Prüfen, ob die Schlange leer ist (z.B. ob 'first' null ist)
        return false;
    }
    
    /**
     * Zählt die Elemente in der Schlange (didaktischer Helfer für Skalierung/Verschiebung).
     */
    private int count()
    {
        int c = 0;
        Listenknoten<T> aktueller = first;
        while (aktueller != null)
        {
            c++;
            aktueller = aktueller.nachfolger;
        }
        return c;
    }
    
    /**
     * Zeichnet die verkettete Queue grafisch auf die Processing-Leinwand.
     */
    void grafischZeichnen(float x, float y, float breite, float hoehe)
    {
        float knotenBreite = 70;
        float datenBreite = 45;
        float zeigerBreite = 25;
        float zellenHoehe = 30;
        float abstandX = 35;
        
        int anzahlKnoten = count();
        
        // Startkoordinate links ausrichten
        float startX = x - 220;
        float aktuellesY = y - 10;
        
        // Titel und Info zeichnen
        fill(241, 245, 249);
        textSize(12);
        textAlign(CENTER, BOTTOM);
        text("Verkettete Knoten (LinkedQueue)", x, y - 75);
        
        fill(148, 163, 184);
        textSize(10);
        text("Dynamische Struktur (first verweist auf Kopf, last verweist auf Ende)", x, y - 60);
        
        // Falls die Queue leer ist
        if (first == null)
        {
            // first und last zeigen beide auf null
            drawNullLabel(startX, aktuellesY - 20, "first");
            drawNullLabel(startX, aktuellesY + 20, "last");
            return;
        }
        
        // Einstiegszeiger first (Zeichnung)
        float firstLabelX = startX - 70;
        fill(45, 55, 72);
        stroke(16, 185, 129); // Grün für first
        strokeWeight(1.5);
        rect(firstLabelX - 25, aktuellesY - 25, 50, 20, 4);
        fill(241, 245, 249);
        textSize(10);
        textAlign(CENTER, CENTER);
        text("first", firstLabelX, aktuellesY - 17);
        drawArrow(firstLabelX + 25, aktuellesY - 15, startX, aktuellesY - 5);
        
        // Traversiere und zeichne die Knoten
        Listenknoten<T> aktueller = first;
        float aktuellesX = startX;
        int index = 0;
        
        while (aktueller != null)
        {
            // Farbgebung: Kopf der Schlange leuchtet smaragdgrün, das Ende blau
            color datenFarbe = color(30, 41, 59);
            if (aktueller == first)
            {
                datenFarbe = color(16, 185, 129); // Smaragdgrün
            }
            else if (aktueller == last)
            {
                datenFarbe = color(59, 130, 246); // Blau
            }
            
            // Daten-Box
            fill(datenFarbe);
            stroke(100, 116, 139);
            strokeWeight(1);
            rect(aktuellesX, aktuellesY - zellenHoehe / 2, datenBreite, zellenHoehe, 6, 0, 0, 6);
            
            // Dateninhalt
            fill(255);
            textSize(12);
            textAlign(CENTER, CENTER);
            String datenText = aktueller.daten != null ? aktueller.daten.toString() : "null";
            text(datenText, aktuellesX + datenBreite / 2, aktuellesY - 2);
            
            // Zeiger-Box
            fill(51, 65, 85);
            rect(aktuellesX + datenBreite, aktuellesY - zellenHoehe / 2, zeigerBreite, zellenHoehe, 0, 6, 6, 0);
            
            // Zeigerpunkt (Dot)
            fill(226, 232, 240);
            noStroke();
            ellipse(aktuellesX + datenBreite + zeigerBreite / 2, aktuellesY, 5, 5);
            
            // Beschriftung des last-Zeigers (von unten)
            if (aktueller == last)
            {
                float lastLabelX = aktuellesX + knotenBreite / 2;
                float lastLabelY = aktuellesY + 35;
                fill(45, 55, 72);
                stroke(59, 130, 246); // Blau für last
                strokeWeight(1.5);
                rect(lastLabelX - 25, lastLabelY - 10, 50, 20, 4);
                fill(241, 245, 249);
                textSize(10);
                textAlign(CENTER, CENTER);
                text("last", lastLabelX, lastLabelY - 2);
                drawArrow(lastLabelX, lastLabelY - 10, lastLabelX, aktuellesY + zellenHoehe / 2);
            }
            
            // Zeiger-Linie zeichnen
            stroke(148, 163, 184);
            strokeWeight(1.5);
            float zeigerStartX = aktuellesX + datenBreite + zeigerBreite / 2;
            
            if (aktueller.nachfolger != null)
            {
                // Zeiger auf Nachfolger (nach rechts)
                float zielX = aktuellesX + knotenBreite + abstandX;
                drawArrow(zeigerStartX, aktuellesY, zielX, aktuellesY);
                aktuellesX = zielX;
            }
            else
            {
                // Zeiger auf null
                float nullX = aktuellesX + knotenBreite + abstandX - 10;
                line(zeigerStartX, aktuellesY, nullX, aktuellesY);
                drawNullSymbol(nullX, aktuellesY);
            }
            
            aktueller = aktueller.nachfolger;
            index++;
        }
    }
    
    /**
     * Hilfsmethode zum Zeichnen von Richtungs-Pfeilen.
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
     * Zeichnet ein Label für einen auf null zeigenden Einstiegszeiger.
     */
    private void drawNullLabel(float x, float y, String labelName)
    {
        fill(45, 55, 72);
        stroke(239, 68, 68);
        strokeWeight(1.5);
        rect(x - 60, y - 10, 50, 20, 4);
        
        fill(241, 245, 249);
        textSize(10);
        textAlign(CENTER, CENTER);
        text(labelName, x - 35, y - 2);
        
        stroke(239, 68, 68);
        line(x - 10, y, x + 15, y);
        drawNullSymbol(x + 15, y);
    }
    
    /**
     * Hilfsmethode zum Zeichnen des null-Erdungssymbols.
     */
    private void drawNullSymbol(float x, float y)
    {
        strokeWeight(1.5);
        stroke(239, 68, 68); // Rot für null
        line(x, y - 8, x, y + 8);
        line(x + 3, y - 5, x + 3, y + 5);
        line(x + 6, y - 2, x + 6, y + 2);
        
        fill(239, 68, 68);
        noStroke();
        textSize(9);
        textAlign(LEFT, CENTER);
        text("null", x + 10, y - 1);
    }
    
    @Override
    public String toString()
    {
        StringBuilder b = new StringBuilder();
        b.append("Queue: [");
        Listenknoten<T> k = first;
        while (k != null)
        {
            b.append(k.daten);
            if (k.nachfolger != null)
            {
                b.append(", ");
            }
            k = k.nachfolger;
        }
        b.append("]");
        return b.toString();
    }
}
