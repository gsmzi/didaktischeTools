/**
 * Eine einfach verkettete Liste, rekursiv implementiert (mit Benchmark-Zählern)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeRekursiv<T> extends ListeMitVerkettung<T>
{
    ListeRekursiv()
    {
        super();
    }

    Liste<T> neueInstanz()
    {
        return new ListeRekursiv<T>();
    }

    /**
     * Gibt die Anzahl der Elemente der Liste zurück
     */
    int laenge()
    {
        return laenge(anfang);
    }

    private int laenge(Listenknoten<T> k)
    {
        //# TODO
        // Bestimme rekursiv die Länge der Liste.
        // Falls k == null, ist die Restlänge 0.
        // Erhöhe leseZugriffe bei jedem Knoten-Besuch (leseZugriffe++).
        return 0;
    }

    /**
     * Gibt den n-ten Wert (0-basierte Zählweise) der Liste zurück.
     */
    T getNtenWert(int n)
    {
        return getNtenWert(anfang, n);
    }

    private T getNtenWert(Listenknoten<T> k, int n)
    {
        //# TODO
        // Suche rekursiv das n-te Element und gib dessen daten zurück.
        // Erhöhe leseZugriffe bei jedem Schritt.
        return null;
    }

    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     */
    void anhaengen(T val)
    {
        schreibZugriffe++; // Knotenerzeugung
        if (anfang == null)
        {
            anfang = new Listenknoten<T>(val, null);
            schreibZugriffe++;
        }
        else
        {
            anhaengen(anfang, val);
        }
    }

    private void anhaengen(Listenknoten<T> k, T val)
    {
        //# TODO
        // Hänge rekursiv an das Ende der Teilliste k an.
        // Erhöhe leseZugriffe und schreibZugriffe entsprechend.
    }

    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     */
    void einfuegenBei(int index, T val)
    {
        if (index == 0) 
        {
            anfang = new Listenknoten<T>(val, anfang);
            schreibZugriffe += 2;
        } 
        else
        {
            einfuegenBei(anfang, index, val);
        }
    }

    private void einfuegenBei(Listenknoten<T> k, int index, T val)
    {
        //# TODO
        // Füge rekursiv bei index ein.
        // Erhöhe leseZugriffe und schreibZugriffe entsprechend.
    }

    /**
     * Gibt die Listenelemente hintereinander auf der Konsole aus.
     */
    void ausgeben()
    { 
        ausgeben(anfang);
    }

    private void ausgeben(Listenknoten<T> k)
    {
        if (k == null) {
            println();
        } 
        else
        {
            print(k.daten + " ");
            ausgeben(k.nachfolger);
        }
    }

    /**
     * Gibt zurück, ob ein Wert sich in der Liste befindet
     */
    boolean enthaelt(T val)
    {
        return enthaelt(anfang, val);
    }

    private boolean enthaelt(Listenknoten<T> k, T val)
    {
        if (k == null) {
            return false;
        } 
        leseZugriffe++; // Knoten lesen
        if (k.daten != null && k.daten.equals(val)) {
            return true;
        } 
        return enthaelt(k.nachfolger, val);
    }

    /**
     * Entfernt das Element, das am gegebenen Index steht, aus der Liste.
     */
    void entferneBei(int index)
    {
        if (anfang == null) {
            return;
        } 
        if (index == 0) {
            anfang = anfang.nachfolger;
            leseZugriffe++;
            schreibZugriffe++;
        } 
        else
        {
            entferneBei(anfang, index);
        }
    }

    private void entferneBei(Listenknoten<T> k, int index)
    {
        //# TODO
        // Entferne rekursiv das Element bei index.
        // Erhöhe leseZugriffe und schreibZugriffe entsprechend.
    }
}
