/**
 * Abstrakte Basisklasse Stack
 * 
 * Definiert die Kernoperationen eines Stapelspeichers (LIFO - Last In, First Out)
 * sowie die Schnittstelle für die grafische Visualisierung in Processing.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Stack<T>
{
    /**
     * Gibt zurück, ob der Stack leer ist.
     * 
     * @return true, wenn der Stack keine Elemente enthält; false sonst.
     */
    abstract boolean isEmpty();
    
    /**
     * Legt ein neues Element auf den Stack.
     * 
     * @param wert Das neue Element
     */
    abstract void push(T wert);
    
    /**
     * Entfernt das oberste Element vom Stack und gibt es zurück.
     * 
     * @return Das bisherige oberste Element oder null, falls der Stack leer ist.
     */
    abstract T pop();
    
    /**
     * Gibt das oberste Element des Stacks zurück (ohne es zu entfernen).
     * 
     * @return Das oberste Element oder null, falls der Stack leer ist.
     */
    abstract T top();
    
    /**
     * Zeichnet die Stapelstruktur grafisch auf die Processing-Leinwand.
     * Jede Implementierung visualisiert ihre Datenstruktur entsprechend ihrer internen
     * Speicherorganisation (Array, verkettete Liste oder Cantor-Paarung).
     * 
     * @param x X-Koordinate des Mittelpunkts bzw. Startpunkts
     * @param y Y-Koordinate des Stapel-Bodens
     * @param breite Die gewünschte Breite der Visualisierung
     * @param hoehe Die gewünschte Höhe der Visualisierung
     */
    abstract void grafischZeichnen(float x, float y, float breite, float hoehe);
}
