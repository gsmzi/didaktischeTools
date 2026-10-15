/**
 * Abstrakte Basisklasse Queue
 * 
 * Definiert die Kernoperationen einer Warteschlange (FIFO - First In, First Out)
 * sowie die Schnittstelle für die grafische Visualisierung in Processing.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Queue<T>
{
    /**
     * Gibt zurück, ob die Queue leer ist.
     * 
     * @return true, wenn die Queue keine Elemente enthält; false sonst.
     */
    abstract boolean isEmpty();
    
    /**
     * Fügt ein neues Element hinten in der Schlange ein.
     * 
     * @param x Das einzufügende Element
     */
    abstract void enqueue(T x);
    
    /**
     * Entfernt das vorderste Element aus der Queue und gibt es zurück.
     * 
     * @return Das bisherige vorderste Element oder null, falls die Queue leer ist.
     */
    abstract T dequeue();
    
    /**
     * Gibt das vorderste Element der Queue zurück (ohne es zu entfernen).
     * 
     * @return Das vorderste Element oder null, falls die Queue leer ist.
     */
    abstract T front();
    
    /**
     * Zeichnet die Schlangenstruktur grafisch auf die Processing-Leinwand.
     * Jede Implementierung visualisiert ihre Datenstruktur entsprechend ihrer internen
     * Speicherorganisation (Array-Ringpuffer oder verkettete Liste).
     * 
     * @param x X-Koordinate des Mittelpunkts der Visualisierung
     * @param y Y-Koordinate des Mittelpunkts bzw. der Basis
     * @param breite Die gewünschte Breite der Visualisierung
     * @param hoehe Die gewünschte Höhe der Visualisierung
     */
    abstract void grafischZeichnen(float x, float y, float breite, float hoehe);
}
