/**
 * Der ADT Liste (mit Benchmark-Erweiterung)
 * 
 * Bietet die standardmäßigen Listenoperationen sowie Zähler
 * für Lese- und Schreibzugriffe zur Performanceanalyse.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Liste<T>
{
    /**
     * Performance-Zähler für Benchmark-Vergleiche
     */
    int leseZugriffe = 0;
    int schreibZugriffe = 0;
    
    /**
     * Setzt die Benchmark-Zähler zurück.
     */
    void resetCounters()
    {
        leseZugriffe = 0;
        schreibZugriffe = 0;
    }
    
    /**
     * Erstellt eine neue, leere Instanz derselben Listenimplementierung.
     */
    abstract Liste<T> neueInstanz();

    /**
     * Gibt die Anzahl der Elemente der Liste zurück.
     */
    abstract int laenge();

    /**
     * Gibt den n-ten Wert (0-basierte Zählweise) der Liste zurück.
     * @param n Der Index des gewünschten Elements
     * @return Den n-ten Wert oder null, falls der Index ungültig ist.
     */
    abstract T getNtenWert(int n);

    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     * @param val Der anzuhängende Wert
     */
    abstract void anhaengen(T val);

    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     * @param index Die Stelle, an der der neue Wert stehen soll (0 <= index <= laenge())
     * @param val Der einzufügende Wert
     */
    abstract void einfuegenBei(int index, T val);

    /**
     * Gibt die Listenelemente hintereinander auf der Konsole aus.
     */
    abstract void ausgeben();

    /**
     * Gibt zurück, ob ein Wert sich in der Liste befindet.
     * @param val Der zu suchende Wert
     * @return true, wenn der Wert enthalten ist; false sonst
     */
    abstract boolean enthaelt(T val);

    /**
     * Entfernt das Element, das am gegebenen Index steht, aus der Liste.
     * @param index Die Stelle, von der der Wert entfernt werden soll.
     */
    abstract void entferneBei(int index);

    /**
     * Gibt zurück, ob die Liste leer ist.
     * @return true, wenn die Liste keine Elemente enthält; false sonst
     */
    abstract boolean istLeer();
}
