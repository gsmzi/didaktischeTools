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
        int len = 0;
        Listenknoten<T> k = anfang;
        while (k != null) { 
            leseZugriffe++; // Knoten lesen
            k = k.nachfolger;
            len++;
        } 
        return len;
    }

    /**
     * Gibt den n-ten Wert (0-basierte Zählweise) der Liste zurück.
     */
    T getNtenWert(int n)
    {
        Listenknoten<T> k = anfang;
        while (k != null) { 
            leseZugriffe++; // Knoten lesen
            if (n == 0) {
                leseZugriffe++; // Datenwert lesen
                return k.daten;
            } 
            k = k.nachfolger;
            n--;
        } 
        return null; 
    }

    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     */
    void anhaengen(T val)
    {
        Listenknoten<T> neu = new Listenknoten<T>(val, null);
        schreibZugriffe++; // Knotenerzeugung
        
        if (anfang == null) 
        {
            anfang = neu;
            schreibZugriffe++;
        } 
        else
        {
            Listenknoten<T> k = anfang;
            while (k.nachfolger != null) { 
                leseZugriffe++; // Zeigernachfolger lesen
                k = k.nachfolger;
            } 
            k.nachfolger = neu;
            schreibZugriffe++;
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
            schreibZugriffe += 2; // Knotenerzeugung + Kopf-Zuweisung
        } 
        else
        {
            Listenknoten<T> k = anfang;
            while (index > 1) {
                if (k == null) {
                    return; 
                } 
                leseZugriffe++;
                k = k.nachfolger;
                index--;
            } 
            if (k == null) {
                return; 
            }
            k.nachfolger = new Listenknoten<T>(val, k.nachfolger);
            schreibZugriffe += 2; // Knotenerzeugung + Nachfolger-Zuweisung
        }
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
            Listenknoten<T> tmp = anfang;
            while (index > 1 && tmp != null) {
                leseZugriffe++;
                tmp = tmp.nachfolger;
                index--;
            } 
            if (tmp != null && tmp.nachfolger != null) {
                tmp.nachfolger = tmp.nachfolger.nachfolger;
                leseZugriffe++;
                schreibZugriffe++;
            } 
        }
    }
}
