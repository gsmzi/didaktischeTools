/**
 * Klasse ArrayQueue
 * 
 * Implementiert eine Warteschlange (Queue) basierend auf einem dynamischen Array
 * als Ringpuffer (Circular Buffer). Bei Kapazitätsüberschreitung verdoppelt sich das Array.
 * 
 * Visualisierung:
 * Stellt die Struktur zweifach dar:
 * 1. Kreis-Ansicht (Ringpuffer): Veranschaulicht, wie die Zeiger 'first' und 'last'
 *    im Kreis wandern und bei Überschreitung des Array-Endes wieder auf 0 springen.
 * 2. Index-Ansicht (Linear): Zeigt die physische Anordnung der Elemente im internen Speicher-Array.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ArrayQueue<T> extends Queue<T>
{
    /**
     * Das interne Speicher-Array.
     */
    private Object[] daten;
    
    /**
     * Der Index des vordersten Elements (front / Kopf der Schlange).
     */
    private int first;
    
    /**
     * Der Index, an dem das nächste Element eingefügt wird (Ende der Schlange).
     */
    private int last;
    
    /**
     * Erzeugt eine neue, leere Queue mit einer Standardkapazität von 10.
     */
    ArrayQueue()
    {
        daten = new Object[10];
        first = 0;
        last = 0;
    }
    
    /**
     * Gibt zurück, ob die Queue leer ist.
     * Dies ist der Fall, wenn first und last auf denselben Index zeigen.
     */
    boolean isEmpty()
    {
        return first == last;
    }
    
    /**
     * Fügt ein neues Element hinten in der Schlange ein.
     * Nutzt das Ringpuffer-Prinzip (Modulo-Arithmetik).
     * Falls das Array voll ist, wird es verdoppelt und die Elemente werden linearisiert.
     */
    void enqueue(T x)
    {
        daten[last] = x;
        last++;
        
        // Ringpuffer-Sprung am Ende des Arrays
        if (last == daten.length)
        {
            last = 0;
        }
        
        // Kollisionsprüfung: Ist das Array voll? (last hat first eingeholt)
        if (last == first)
        {
            // Kapazität verdoppeln
            Object[] tmp = new Object[daten.length * 2];
            
            // Kopiere von 'first' bis zum Array-Ende an den Anfang des neuen Arrays
            System.arraycopy(daten, first, tmp, 0, daten.length - first);
            
            // Kopiere den umgelaufenen Teil (von 0 bis 'first') dahinter
            System.arraycopy(daten, 0, tmp, daten.length - first, first);
            
            // Zeiger zurücksetzen: Daten liegen nun wieder linear im neuen Speicher
            first = 0;
            last = daten.length;
            daten = tmp;
        }
    }
    
    /**
     * Entfernt das vorderste Element aus der Queue und gibt es zurück.
     * Setzt den freien Platz auf null, um Speicherlecks zu verhindern.
     */
    T dequeue()
    {
        T x = null;
        if (!isEmpty())
        {
            x = (T)daten[first];
            daten[first] = null; // Speicher freigeben
            first++;
            
            // Ringpuffer-Sprung am Ende des Arrays
            if (first == daten.length)
            {
                first = 0;
            }
        }
        return x;
    }
    
    /**
     * Gibt das vorderste Element zurück (ohne Entfernen).
     */
    T front()
    {
        if (isEmpty())
        {
            return null;
        }
        return (T)daten[first];
    }
    
    /**
     * Prüft, ob ein gegebener Array-Index im Ringpuffer derzeit belegt ist.
     */
    private boolean istBelegt(int index)
    {
        if (isEmpty())
        {
            return false;
        }
        if (first < last)
        {
            return index >= first && index < last;
        }
        else
        {
            return index >= first || index < last;
        }
    }
    
    /**
     * Zeichnet die Queue-Struktur grafisch (Ringpuffer und Index-Ansicht).
     */
    void grafischZeichnen(float x, float y, float breite, float hoehe)
    {
        // Wir etablieren zwei Visualisierungsbereiche nebeneinander.
        float cx = x - 180; // Kreis-Mittelpunkt links
        float cy = y - 20;
        float rx = x + 40;  // Startkoordinate linear rechts
        float ry = y - 20;
        
        // --- 1. KREIS-ANSICHT (RINGPUFFER) ---
        float radius = 75;
        float zellenRadius = 16;
        
        fill(241, 245, 249);
        textSize(12);
        textAlign(CENTER, BOTTOM);
        text("Ringpuffer (Kreis-Ansicht)", cx, cy - radius - 35);
        
        fill(148, 163, 184);
        textSize(10);
        text("Größe: " + count() + " / Kapazität: " + daten.length, cx, cy - radius - 20);
        
        // Zeichne Ring-Führungslinie im Hintergrund
        noFill();
        stroke(51, 65, 85);
        strokeWeight(1);
        ellipse(cx, cy, radius * 2, radius * 2);
        
        // Einzelne Zellen im Kreis zeichnen
        for (int i = 0; i < daten.length; i++)
        {
            float winkel = i * TWO_PI / daten.length - HALF_PI;
            float cellX = cx + radius * cos(winkel);
            float cellY = cy + radius * sin(winkel);
            
            boolean belegt = istBelegt(i);
            
            // Farbgebung
            if (belegt)
            {
                if (i == first)
                {
                    fill(16, 185, 129); // Emerald-Grün (Kopf der Schlange)
                }
                else
                {
                    fill(30, 41, 59); // Standard Slate Dunkel
                }
                stroke(100, 116, 139);
                strokeWeight(1);
                ellipse(cellX, cellY, zellenRadius * 2, zellenRadius * 2);
                
                // Inhalt zeichnen
                fill(255);
                textSize(11);
                textAlign(CENTER, CENTER);
                String txt = daten[i] != null ? daten[i].toString() : "";
                text(txt, cellX, cellY - 1);
            }
            else
            {
                // Unbelegt (gestrichelt)
                noFill();
                stroke(71, 85, 105);
                strokeWeight(1);
                drawDashedCircle(cellX, cellY, zellenRadius);
            }
            
            // Indexbeschriftung außen am Kreis
            float labelX = cx + (radius + 24) * cos(winkel);
            float labelY = cy + (radius + 24) * sin(winkel);
            fill(148, 163, 184);
            textSize(9);
            textAlign(CENTER, CENTER);
            text("[" + i + "]", labelX, labelY);
        }
        
        // Zeiger im Kreis als Pfeile von der Mitte aus zeichnen
        // first-Zeiger (Kopf)
        float winkelFirst = first * TWO_PI / daten.length - HALF_PI;
        stroke(16, 185, 129); // Grün
        strokeWeight(2);
        fill(16, 185, 129);
        drawArrow(cx, cy, cx + (radius - zellenRadius - 5) * cos(winkelFirst), cy + (radius - zellenRadius - 5) * sin(winkelFirst));
        
        // last-Zeiger (Einfügepunkt)
        float winkelLast = last * TWO_PI / daten.length - HALF_PI;
        stroke(59, 130, 246); // Blau
        strokeWeight(2);
        fill(59, 130, 246);
        // Etwas kürzerer Pfeil, falls first == last (damit man beide sieht)
        float lastArrowLen = (first == last) ? (radius - zellenRadius - 22) : (radius - zellenRadius - 5);
        drawArrow(cx, cy, cx + lastArrowLen * cos(winkelLast), cy + lastArrowLen * sin(winkelLast));
        
        // Beschriftung der Zeiger im Kreiszentrum
        fill(15, 23, 42);
        stroke(51, 65, 85);
        strokeWeight(1);
        ellipse(cx, cy, 32, 32);
        fill(255);
        textSize(8);
        textAlign(CENTER, CENTER);
        text("F: gr\nL: bl", cx, cy - 1);
        
        
        // --- 2. INDEX-ANSICHT (LINEAR) ---
        float boxBreite = 35;
        float boxHoehe = 30;
        float abstand = 5;
        float linearGesamtBreite = daten.length * (boxBreite + abstand) - abstand;
        float startX = rx - linearGesamtBreite / 2 + 100; // Ausgerichtet zur rechten Seite
        
        fill(241, 245, 249);
        textSize(12);
        textAlign(CENTER, BOTTOM);
        text("Speicher-Array (Index-Ansicht)", startX + linearGesamtBreite / 2, ry - 40);
        
        for (int i = 0; i < daten.length; i++)
        {
            float zelleX = startX + i * (boxBreite + abstand);
            boolean belegt = istBelegt(i);
            
            if (belegt)
            {
                if (i == first)
                {
                    fill(16, 185, 129);
                }
                else
                {
                    fill(30, 41, 59);
                }
                stroke(100, 116, 139);
                strokeWeight(1);
                rect(zelleX, ry - boxHoehe / 2, boxBreite, boxHoehe, 4);
                
                fill(255);
                textSize(11);
                textAlign(CENTER, CENTER);
                String txt = daten[i] != null ? daten[i].toString() : "";
                text(txt, zelleX + boxBreite / 2, ry - 2);
            }
            else
            {
                noFill();
                stroke(71, 85, 105);
                strokeWeight(1);
                drawDashedRect(zelleX, ry - boxHoehe / 2, boxBreite, boxHoehe);
            }
            
            // Index
            fill(148, 163, 184);
            textSize(9);
            textAlign(CENTER, TOP);
            text("[" + i + "]", zelleX + boxBreite / 2, ry + boxHoehe / 2 + 5);
            
            // first-Zeiger (unten drunter)
            if (i == first)
            {
                stroke(16, 185, 129);
                strokeWeight(1.5);
                fill(16, 185, 129);
                line(zelleX + boxBreite / 2, ry + boxHoehe / 2 + 25, zelleX + boxBreite / 2, ry + boxHoehe / 2 + 15);
                triangle(zelleX + boxBreite / 2, ry + boxHoehe / 2 + 15, zelleX + boxBreite / 2 - 3, ry + boxHoehe / 2 + 19, zelleX + boxBreite / 2 + 3, ry + boxHoehe / 2 + 19);
                textSize(8);
                textAlign(CENTER, TOP);
                text("first", zelleX + boxBreite / 2, ry + boxHoehe / 2 + 27);
            }
            
            // last-Zeiger (oben drüber)
            if (i == last)
            {
                stroke(59, 130, 246);
                strokeWeight(1.5);
                fill(59, 130, 246);
                line(zelleX + boxBreite / 2, ry - boxHoehe / 2 - 25, zelleX + boxBreite / 2, ry - boxHoehe / 2 - 15);
                triangle(zelleX + boxBreite / 2, ry - boxHoehe / 2 - 15, zelleX + boxBreite / 2 - 3, ry - boxHoehe / 2 - 19, zelleX + boxBreite / 2 + 3, ry - boxHoehe / 2 - 19);
                textSize(8);
                textAlign(CENTER, BOTTOM);
                text("last", zelleX + boxBreite / 2, ry - boxHoehe / 2 - 27);
            }
        }
    }
    
    /**
     * Gibt die Anzahl der tatsächlich in der Queue befindlichen Elemente zurück.
     */
    private int count()
    {
        if (first <= last)
        {
            return last - first;
        }
        else
        {
            return (daten.length - first) + last;
        }
    }
    
    /**
     * Zeichnet gestrichelte Rechtecke.
     */
    private void drawDashedRect(float x, float y, float w, float h)
    {
        float dl = 3;
        float gl = 2;
        for (float xi = x; xi < x + w; xi += dl + gl) {
            line(xi, y, min(xi + dl, x + w), y);
            line(xi, y + h, min(xi + dl, x + w), y + h);
        }
        for (float yi = y; yi < y + h; yi += dl + gl) {
            line(x, yi, x, min(yi + dl, y + h));
            line(x + w, yi, x + w, min(yi + dl, y + h));
        }
    }
    
    /**
     * Zeichnet gestrichelte Kreise.
     */
    private void drawDashedCircle(float cx, float cy, float r)
    {
        int steps = 16;
        float angleStep = TWO_PI / steps;
        for (int i = 0; i < steps; i += 2)
        {
            float a1 = i * angleStep;
            float a2 = (i + 1) * angleStep;
            arc(cx, cy, r * 2, r * 2, a1, a2);
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
        noStroke();
        triangle(0, 0, -6, -3, -6, 3);
        popMatrix();
    }
    
    @Override
    public String toString()
    {
        StringBuilder b = new StringBuilder();
        b.append("Queue: [");
        int count = count();
        for (int i = 0; i < count; i++)
        {
            if (i > 0)
            {
                b.append(", ");
            }
            b.append(daten[(first + i) % daten.length]);
        }
        b.append("]");
        return b.toString();
    }
}
