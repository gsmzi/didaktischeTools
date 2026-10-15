/**
 * Klasse ListeMitEnde (Schülervorlage)
 * 
 * Eine einfach verkettete Liste mit Verweis auf den letzten Knoten (ende-Zeiger)
 * für schnelles O(1)-Anhängen.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. void anhaengen(T val)
 *    - In O(1) mit Hilfe des 'ende'-Zeigers anhängen.
 *    - Sonderfall leere Liste beachten (anfang und ende setzen).
 * 2. void einfuegenBei(int index, T val)
 *    - Element bei 'index' einfügen; falls am Ende eingefügt wird, 'ende' anpassen.
 * 3. void entferneBei(int index)
 *    - Element entfernen; falls das letzte Element gelöscht wird, 'ende' anpassen.
 * ============================================================================
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
        //# TODO
        // Hänge das neue Element mithilfe des Endezeigers 'ende' in O(1) Zeit an.
        // Vergiss nicht, sowohl 'anfang' als auch 'ende' richtig zu setzen und schreibZugriffe zu dokumentieren.
    }

    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     */
    void einfuegenBei(int index, T val)
    {
        //# TODO
        // Füge das Element bei 'index' ein. Wenn das Element am Ende oder am Anfang eingefügt wird,
        // passe den Endezeiger 'ende' bzw. den Anfangszeiger entsprechend an.
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
        //# TODO
        // Entferne das Element am gegebenen Index und aktualisiere bei Bedarf den Endezeiger.
    }
}
