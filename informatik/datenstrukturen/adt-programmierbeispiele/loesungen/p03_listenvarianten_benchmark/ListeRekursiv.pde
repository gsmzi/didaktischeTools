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
        if (k == null) {
            return 0;
        } 
        leseZugriffe++; // Knoten lesen
        return 1 + laenge(k.nachfolger);
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
        if (k == null) {
            return null;
        }
        leseZugriffe++; // Knoten lesen
        if (n == 0) {
            leseZugriffe++; // Datenwert lesen
            return k.daten;
        } 
        return getNtenWert(k.nachfolger, n-1);
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
        if (k == null) 
        {
            return;
        } 
        leseZugriffe++; // Knoten lesen
        if (k.nachfolger == null) 
        {
            k.nachfolger = new Listenknoten<T>(val, null);
            schreibZugriffe++;
        } 
        else
        {
            anhaengen(k.nachfolger, val);
        }
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
        if (k == null) {
            return;
        }
        leseZugriffe++; // Knoten lesen
        if (index == 1) 
        {
            k.nachfolger = new Listenknoten<T>(val, k.nachfolger);
            schreibZugriffe += 2;
        } 
        else
        {
            einfuegenBei(k.nachfolger, index-1, val);
        }
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
        if (k != null && k.nachfolger != null) {
            leseZugriffe++; // Knoten lesen
            if (index == 1) 
            {
                k.nachfolger = k.nachfolger.nachfolger;
                leseZugriffe++;
                schreibZugriffe++;
            } 
            else 
            {
                entferneBei(k.nachfolger, index-1);  
            } 
        }
    }
}
