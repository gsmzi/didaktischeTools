/**
 * Eine einfach verkettete Liste mit Verweis auf den letzten Knoten (mit Benchmark-Zählern)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeMitEnde<T> extends ListeIterativ<T>
{
    /**
     * Der letzte Knoten der Liste
     */
    private Listenknoten<T> ende;
    
    /**
     * Erzeugt eine neue Liste
     */
    ListeMitEnde()
    {
        super();
        ende = null;
    }

    Liste<T> neueInstanz()
    {
        return new ListeMitEnde<T>();
    }

    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     * O(1) Laufzeit durch Endezeiger.
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
            ende.nachfolger = neu;
            schreibZugriffe++;
        }
        ende = neu;
        schreibZugriffe++;
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
            if (ende == null)
            {
                ende = anfang;
                schreibZugriffe++;
            }
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
            Listenknoten<T> neu = new Listenknoten<T>(val, k.nachfolger);
            k.nachfolger = neu;
            schreibZugriffe += 2;
            
            if (k == ende)
            {
                ende = neu;
                schreibZugriffe++;
            }
        }
    }
    
    /**
     * Gibt zurück, ob die Liste leer ist.
     */
    boolean istLeer()
    {
        return anfang == null && ende == null;
    }

    /**
     * Entfernt das Element, das am gegebenen Index steht, aus der Liste.
     */
    void entferneBei(int index)
    {
        if (anfang == null) 
        {
            return;
        } 
        if (index == 0) 
        {
            anfang = anfang.nachfolger;
            leseZugriffe++;
            schreibZugriffe++;
            if (anfang == null)
            {
                ende = null;
                schreibZugriffe++;
            }
        } 
        else
        {
            Listenknoten<T> tmp = anfang;
            while (index > 1 && tmp != null) 
            {
                leseZugriffe++;
                tmp = tmp.nachfolger;
                index--;
            } 
            
            if (tmp != null && tmp.nachfolger != null) 
            {
                tmp.nachfolger = tmp.nachfolger.nachfolger;
                leseZugriffe++;
                schreibZugriffe++;
                if (tmp.nachfolger == null)
                {
                    ende = tmp;
                    schreibZugriffe++;
                }
            } 
        }
    }
}
