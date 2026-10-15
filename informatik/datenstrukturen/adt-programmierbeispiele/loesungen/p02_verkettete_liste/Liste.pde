/**
 * Abstrakte Klasse Liste
 * 
 * Definiert die grundlegenden Operationen einer verketteten Liste 
 * und verwaltet den Einstiegszeiger 'anfang'.
 * Enthält zusätzlich die grafische Visualisierungslogik für Processing.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Liste<T>
{
    /**
     * Der Zeiger auf den ersten Knoten der Liste. 
     * Ist 'null', wenn die Liste leer ist.
     */
    Listenknoten<T> anfang;
    
    /**
     * Gibt zurück, ob die Liste leer ist.
     * 
     * @return true, wenn die Liste keine Elemente enthält; false sonst.
     */
    boolean istLeer()
    {
        return anfang == null;
    }

    /**
     * Gibt die Anzahl der Elemente der Liste zurück.
     */
    abstract int laenge();

    /**
     * Gibt den n-ten Wert (0-basierte Zählweise) der Liste zurück.
     * 
     * @param n Der Index des gewünschten Elements
     * @return Den n-ten Wert oder null, falls der Index ungültig ist
     */
    abstract T getNtenWert(int n);

    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     * 
     * @param val Der anzuhängende Wert
     */
    abstract void anhaengen(T val);

    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     * 
     * @param index Die Stelle, an der der neue Wert stehen soll (0 <= index <= laenge())
     * @param val Der einzufügende Wert
     */
    abstract void einfuegenBei(int index, T val);

    /**
     * Gibt die Listenelemente hintereinander auf der Konsole aus.
     */
    void ausgeben()
    {
        println(this.toString());
    }
    
    /**
     * Gibt zurück, ob ein Wert sich in der Liste befindet.
     * 
     * @param val Der zu suchende Wert
     * @return true, wenn der Wert enthalten ist; false sonst.
     */
    abstract boolean enthaelt(T val);

    /**
     * Entfernt das Element, das am gegebenen Index steht, aus der Liste.
     * 
     * @param index Die Stelle, von der der Wert entfernt werden soll.
     */
    abstract void entferneBei(int index);
    
    /**
     * Zeichnet die Liste grafisch auf der Processing-Leinwand.
     * Visualisiert Knoten als Rechtecke, Zeiger als Pfeile und das Listenende als Erdungssymbol.
     * 
     * @param startX Die X-Startkoordinate auf der Leinwand
     * @param startY Die Y-Startkoordinate auf der Leinwand
     * @param suchWert Ein Wert, der farblich hervorgehoben werden soll (kann null sein)
     */
    void grafischZeichnen(float startX, float startY, T suchWert)
    {
        float x = startX;
        float y = startY;
        
        float knotenBreite = 70;
        float zeigerBreite = 25;
        float gesamtBreite = knotenBreite + zeigerBreite;
        float hoehe = 45;
        float abstand = 40;
        
        // 1. Visualisierung des Anfangs-Zeigers
        fill(45, 55, 72); // Dunkelgrau-Blau für den Anfang-Zeiger
        stroke(148, 163, 184);
        strokeWeight(2);
        rect(x, y, 70, hoehe, 8);
        fill(241, 245, 249);
        textSize(12);
        textAlign(CENTER, CENTER);
        text("anfang", x + 35, y + hoehe / 2 - 2);
        
        float zeigerStartX = x + 70;
        float zeigerStartY = y + hoehe / 2;
        
        // Falls die Liste leer ist
        if (anfang == null)
        {
            // Zeichne Zeiger zu null
            stroke(239, 68, 68); // Roter Zeiger für null
            line(zeigerStartX, zeigerStartY, zeigerStartX + abstand, zeigerStartY);
            drawNullSymbol(zeigerStartX + abstand, zeigerStartY);
            return;
        }
        
        // Zeichne Pfeil vom anfang-Zeiger zum ersten Knoten
        stroke(148, 163, 184);
        drawArrow(zeigerStartX, zeigerStartY, zeigerStartX + abstand, zeigerStartY);
        
        x += 70 + abstand;
        
        // Traversierung der Knoten zur grafischen Darstellung
        Listenknoten<T> aktueller = anfang;
        int index = 0;
        
        while (aktueller != null)
        {
            // Bestimme Farbe des Datenfeldes
            color datenFarbe = color(30, 41, 59); // Standard: Dunkelblau-Grau
            color textFarbe = color(241, 245, 249);
            
            if (suchWert != null && aktueller.daten != null && aktueller.daten.equals(suchWert))
            {
                // Treffer beim Suchen leuchtet grün/türkis auf (Premium-Ausschmückung)
                datenFarbe = color(16, 185, 129); // Smaragdgrün
                textFarbe = color(255);
            }
            
            // 2. Knoten-Box zeichnen (Daten-Teil)
            fill(datenFarbe);
            stroke(100, 116, 139);
            rect(x, y, knotenBreite, hoehe, 6, 0, 0, 6);
            
            // Indexnummer über dem Knoten
            fill(148, 163, 184);
            textSize(10);
            textAlign(CENTER, BOTTOM);
            text("[" + index + "]", x + knotenBreite / 2, y - 5);
            
            // Datenwert im Knoten anzeigen
            fill(textFarbe);
            textSize(14);
            textAlign(CENTER, CENTER);
            String datenText = aktueller.daten != null ? aktueller.daten.toString() : "null";
            text(datenText, x + knotenBreite / 2, y + hoehe / 2 - 2);
            
            // 3. Knoten-Box zeichnen (Zeiger-Teil)
            fill(51, 65, 85);
            rect(x + knotenBreite, y, zeigerBreite, hoehe, 0, 6, 6, 0);
            
            // Zeiger-Knotenpunkt (Dot)
            fill(226, 232, 240);
            noStroke();
            ellipse(x + knotenBreite + zeigerBreite / 2, y + hoehe / 2, 6, 6);
            
            // 4. Zeiger-Linie zeichnen
            float aktuellerZeigerStartX = x + gesamtBreite;
            float aktuellerZeigerStartY = y + hoehe / 2;
            
            stroke(148, 163, 184);
            strokeWeight(2);
            
            if (aktueller.nachfolger != null)
            {
                // Pfeil zum nächsten Knoten
                drawArrow(aktuellerZeigerStartX, aktuellerZeigerStartY, aktuellerZeigerStartX + abstand, aktuellerZeigerStartY);
            }
            else
            {
                // Zeiger auf null
                stroke(239, 68, 68); // Rot für das Ende (null)
                line(aktuellerZeigerStartX, aktuellerZeigerStartY, aktuellerZeigerStartX + abstand, aktuellerZeigerStartY);
                drawNullSymbol(aktuellerZeigerStartX + abstand, aktuellerZeigerStartY);
            }
            
            // Weiterschalten
            x += gesamtBreite + abstand;
            aktueller = aktueller.nachfolger;
            index++;
        }
    }
    
    /**
     * Hilfsmethode zum Zeichnen einer Pfeilspitze.
     */
    private void drawArrow(float x1, float y1, float x2, float y2)
    {
        line(x1, y1, x2, y2);
        
        pushMatrix();
        translate(x2, y2);
        float winkel = atan2(y2 - y1, x2 - x1);
        rotate(winkel);
        
        // Pfeilspitze als kleines gefülltes Dreieck
        fill(148, 163, 184);
        noStroke();
        triangle(0, 0, -8, -4, -8, 4);
        popMatrix();
    }
    
    /**
     * Hilfsmethode zum Zeichnen eines Erdungs-Symbols (steht für 'null').
     */
    private void drawNullSymbol(float x, float y)
    {
        strokeWeight(2);
        // Senkrechter Strich
        line(x, y - 10, x, y + 10);
        
        // Drei waagerechte Striche
        line(x, y - 8, x + 6, y - 8);
        line(x, y - 3, x + 4, y - 3);
        line(x, y + 2, x + 2, y + 2);
        
        // Beschriftung "null"
        fill(239, 68, 68);
        noStroke();
        textSize(11);
        textAlign(LEFT, CENTER);
        text("null", x + 10, y - 2);
    }
}
