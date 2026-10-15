/**
 * Klasse ArrayStack
 * 
 * Implementiert einen Stack basierend auf einem dynamischen Array.
 * Wenn das Array voll ist, wird seine Kapazität automatisch verdoppelt.
 * 
 * Visualisierung:
 * Zeigt das vollständige interne Array als vertikale Box-Struktur. 
 * Aktive Elemente werden farbig gefüllt, während freie Speicherplätze gestrichelt
 * und leer dargestellt werden. Ein Pfeil markiert das oberste Element (top) 
 * und den nächsten freien Einfügeplatz (anzahl).
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ArrayStack<T> extends Stack<T>
{
    /**
     * Das interne Array, das die Daten speichert.
     */
    private Object[] daten;
    
    /**
     * Die Anzahl der aktuell im Stack befindlichen Elemente.
     * Repräsentiert gleichzeitig den Index, an dem das nächste Element eingefügt wird.
     */
    private int anzahl;

    /**
     * Erzeugt einen neuen leeren Stack mit einer Standardkapazität von 10.
     */
    ArrayStack()
    {
        daten = new Object[10];
        anzahl = 0;
    }
    
    /**
     * Gibt zurück, ob der Stack leer ist.
     */
    boolean isEmpty()
    {
        return anzahl == 0;
    }
    
    /**
     * Legt ein neues Element auf den Stack.
     * Verdoppelt die Array-Größe, falls die Kapazität erschöpft ist.
     * 
     * @param wert Das aufzulegende Element
     */
    void push(T wert)
    {
        // Kapazitätsprüfung: Ist das Array voll?
        if (anzahl == daten.length)
        {
            // Kapazität verdoppeln (didaktisch wertvolle Speicherverwaltung)
            Object[] tmp = new Object[2 * daten.length];
            System.arraycopy(daten, 0, tmp, 0, daten.length);
            daten = tmp;
        }
        
        // Wert an die Position 'anzahl' schreiben und Zähler inkrementieren
        daten[anzahl] = wert;
        anzahl++;
    }
    
    /**
     * Entfernt das oberste Element und gibt es zurück.
     * 
     * @return Das oberste Element oder null, falls der Stack leer ist.
     */
    T pop()
    {
        if (!isEmpty())
        {
            // Zähler dekrementieren (das Element über dem neuen Index wird ungültig)
            anzahl--;
            T wert = (T)daten[anzahl];
            // Speicher freigeben (Vermeidung von Memory Leaks)
            daten[anzahl] = null; 
            return wert;
        }
        return null;
    }
    
    /**
     * Liefert das oberste Element, ohne es zu entfernen.
     */
    T top()
    {
        if (!isEmpty())
        {
            return (T)daten[anzahl - 1];
        }
        return null;
    }
    
    /**
     * Zeichnet den Array-Stack grafisch auf die Processing-Leinwand.
     */
    void grafischZeichnen(float x, float y, float breite, float hoehe)
    {
        // Wir zeichnen das Array von unten nach oben.
        // x ist der Mittelpunkt des Stacks.
        float startX = x - breite / 2;
        float zellenHoehe = min(30, hoehe / daten.length); // Skaliert mit der Array-Größe
        
        // Titel und Info zeichnen
        fill(241, 245, 249);
        textSize(12);
        textAlign(CENTER, BOTTOM);
        text("Speicher-Array (ArrayStack)", x, y - (daten.length * zellenHoehe) - 25);
        
        fill(148, 163, 184);
        textSize(10);
        text("Größe: " + anzahl + " / Kapazität: " + daten.length, x, y - (daten.length * zellenHoehe) - 10);
        
        // Zeichne die Stapel-Umrandung (Wände des Containers)
        stroke(100, 116, 139);
        strokeWeight(3);
        line(startX - 5, y + 2, startX + breite + 5, y + 2); // Boden
        line(startX - 5, y + 2, startX - 5, y - (daten.length * zellenHoehe)); // Linke Wand
        line(startX + breite + 5, y + 2, startX + breite + 5, y - (daten.length * zellenHoehe)); // Rechte Wand
        
        // Einzelne Speicherzellen zeichnen
        for (int i = 0; i < daten.length; i++)
        {
            float zelleY = y - i * zellenHoehe - zellenHoehe;
            
            if (i < anzahl)
            {
                // Belegte Zelle zeichnen
                // Das oberste aktive Element bekommt ein helleres Grün
                if (i == anzahl - 1)
                {
                    fill(16, 185, 129); // Emerald-Grün
                }
                else
                {
                    fill(30, 41, 59); // Standard Slate Dunkel
                }
                stroke(100, 116, 139);
                strokeWeight(1);
                rect(startX, zelleY, breite, zellenHoehe, 4);
                
                // Inhalt zeichnen
                fill(255);
                textSize(12);
                textAlign(CENTER, CENTER);
                text(daten[i].toString(), x, zelleY + zellenHoehe / 2 - 2);
            }
            else
            {
                // Freie (allokierte, aber unbenutzte) Zelle zeichnen
                noFill();
                stroke(71, 85, 105);
                strokeWeight(1);
                // Dotted-Effekt simulieren
                drawDashedRect(startX, zelleY, breite, zellenHoehe);
            }
            
            // Indexbeschriftung links neben dem Stapel
            fill(148, 163, 184);
            textSize(9);
            textAlign(RIGHT, CENTER);
            text("[" + i + "]", startX - 12, zelleY + zellenHoehe / 2);
        }
        
        // Pfeile für Zeiger zeichnen
        strokeWeight(1.5);
        
        // top-Zeiger (oberstes Element)
        if (anzahl > 0)
        {
            float topY = y - (anzahl - 1) * zellenHoehe - zellenHoehe / 2;
            stroke(16, 185, 129); // Grün
            fill(16, 185, 129);
            drawHorizontalArrow(startX + breite + 40, topY, startX + breite + 5, topY);
            textSize(10);
            textAlign(LEFT, CENTER);
            text("top (" + daten[anzahl - 1] + ")", startX + breite + 45, topY - 2);
        }
        
        // anzahl-Zeiger (nächster freier Platz)
        if (anzahl < daten.length)
        {
            float anzahlY = y - anzahl * zellenHoehe - zellenHoehe / 2;
            stroke(59, 130, 246); // Blau
            fill(59, 130, 246);
            drawHorizontalArrow(startX + breite + 40, anzahlY, startX + breite + 5, anzahlY);
            textSize(10);
            textAlign(LEFT, CENTER);
            text("nächster freier Platz (index=" + anzahl + ")", startX + breite + 45, anzahlY - 2);
        }
    }
    
    /**
     * Hilfsmethode zum Zeichnen gestrichelter Rechtecke (für leere Speicherplätze).
     */
    private void drawDashedRect(float x, float y, float w, float h)
    {
        float dashLength = 4;
        float gapLength = 3;
        
        // Waagerechte Linien gestrichelt
        for (float xi = x; xi < x + w; xi += dashLength + gapLength)
        {
            float w_dash = min(dashLength, x + w - xi);
            line(xi, y, xi + w_dash, y);
            line(xi, y + h, xi + w_dash, y + h);
        }
        // Senkrechte Linien gestrichelt
        for (float yi = y; yi < y + h; yi += dashLength + gapLength)
        {
            float h_dash = min(dashLength, y + h - yi);
            line(x, yi, x, yi + h_dash);
            line(x + w, yi, x + w, yi + h_dash);
        }
    }
    
    /**
     * Hilfsmethode zum Zeichnen horizontaler Zeigerpfeile.
     */
    private void drawHorizontalArrow(float x1, float y1, float x2, float y2)
    {
        line(x1, y1, x2, y2);
        float arrowSize = 5;
        // Da es immer nach links zeigt:
        triangle(x2, y2, x2 + arrowSize, y2 - arrowSize / 1.5, x2 + arrowSize, y2 + arrowSize / 1.5);
    }
    
    @Override
    public String toString()
    {
        StringBuilder b = new StringBuilder();
        b.append("[ ");
        for (int i = 0; i < anzahl; i++)
        {
            if (i > 0)
            {
                b.append(", ");
            }
            b.append(daten[i]);
        }
        b.append(" <");
        return b.toString();
    }
}
