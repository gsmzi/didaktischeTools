/**
 * Eine einfach verkettete Liste (mit Benchmark-Zählern)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeIterativ<T> extends ListeMitVerkettung<T>
{
    /**
     * Erzeugt eine neue Liste
     */
    ListeIterativ()
    {
        super();
    }

    Liste<T> neueInstanz()
    {
        return new ListeIterativ<T>();
    }

    /**
     * Gibt die Anzahl der Elemente der Liste zurück
     */
    int laenge()
    {
        //# TODO
        // Bestimme iterativ die Länge der Liste (durchlaufe alle Knoten).
        // Jeder Traversierungsschritt (k = k.nachfolger) ist ein Lesezugriff (leseZugriffe++).
        return 0;
    }

    /**
     * Gibt den n-ten Wert (0-basierte Zählweise) der Liste zurück.
     */
    T getNtenWert(int n)
    {
        //# TODO
        // Traversiere bis zum n-ten Element und gib dessen Datenwert zurück.
        // Erhöhe leseZugriffe bei jedem Schritt und beim Lesen des Datenwerts.
        return null; 
    }

    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     */
    void anhaengen(T val)
    {
        //# TODO
        // Erstelle einen neuen Listenknoten und hänge ihn ans Ende der Liste an.
        // Berücksichtige den Sonderfall, wenn die Liste noch leer ist (anfang == null).
        // Inkrementiere schreibZugriffe und leseZugriffe entsprechend.
    }

    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     */
    void einfuegenBei(int index, T val)
    {
        //# TODO
        // Füge einen neuen Wert am gegebenen Index ein.
        // index = 0 fügt am Anfang ein.
        // Erhöhe leseZugriffe und schreibZugriffe entsprechend.
    }

    /**
     * Gibt die Listenelemente hintereinander auf der Konsole aus.
     */
    void ausgeben()
    {
        Listenknoten<T> k = anfang;
        while (k != null) { 
            print(k.daten + " ");
            k = k.nachfolger;
        } 
        println();
    }

    /**
     * Gibt zurück, ob ein Wert sich in der Liste befindet
     */
    boolean enthaelt(T val)
    {
        Listenknoten<T> k = anfang;
        while (k != null) { 
            leseZugriffe++; // Knoten lesen
            if (k.daten != null && k.daten.equals(val)) {
                return true;
            } 
            k = k.nachfolger;
        } 
        return false;
    }

    /**
     * Entfernt das Element, das am gegebenen Index steht, aus der Liste.
     */
    void entferneBei(int index)
    {
        //# TODO
        // Entferne das Element am gegebenen Index.
        // Beachte Sonderfälle (Index 0, leere Liste, Index außerhalb).
        // Erhöhe leseZugriffe und schreibZugriffe entsprechend.
    }
}
