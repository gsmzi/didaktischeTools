/**
 * Klasse ListeIterativ (Schülervorlage)
 * 
 * Implementiert die einfach verkettete Liste mithilfe von iterativen Algorithmen (Schleifen).
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. int laenge()
 *    - Liste mit Zeiger durchlaufen und Knoten zählen.
 * 2. T getNtenWert(int n)
 *    - n Schritte vorwärts wandern und den Wert zurückgeben.
 * 3. void anhaengen(T val)
 *    - Neuen Knoten am Listenende anhängen (Sonderfall: leere Liste beachten).
 * 4. void einfuegenBei(int index, T val)
 *    - Knoten bei 'index' einfügen (Sonderfall Index 0 vs. Zeigerumbiegen bei Index > 0).
 * 5. boolean enthaelt(T val)
 *    - Liste nach 'val' durchsuchen.
 * 6. void entferneBei(int index)
 *    - Knoten an Position 'index' löschen (Sonderfall Index 0 vs. Überbrücken bei Index > 0).
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeIterativ<T> extends Liste<T>
{
    /**
     * Konstruktor der iterativen Liste.
     * Initialisiert eine leere Liste. Der Anfang zeigt auf 'null'.
     */
    ListeIterativ()
    {
        //# TODO: Setzen Sie den Anfangszustand der Liste (anfang-Zeiger)
        anfang = null;
    }

    /**
     * Ermittelt die Länge der Liste durch iteratives Durchlaufen aller Knoten.
     * 
     * @return Die Anzahl der Elemente in der Liste.
     */
    int laenge()
    {
        //# TODO: Durchlaufen Sie die Liste iterativ mit einem Hilfszeiger und zählen Sie die Knoten.
        
        return 0; // Platzhalter (0 statt -1 für Stabilität des GUI-Gittergerüsts)
    }

    /**
     * Gibt den Wert an einer bestimmten Position zurück.
     * 
     * @param n Der Index des gesuchten Elements (0-basiert)
     * @return Den Wert des n-ten Knotens oder null, falls der Index ungültig ist.
     */
    T getNtenWert(int n)
    {
        //# TODO: Wandern Sie iterativ n Schritte vorwärts und geben Sie den Wert zurück.
        
        return null; // Platzhalter
    }

    /**
     * Hängt einen neuen Wert an das Ende der Liste an.
     * 
     * @param val Der anzuhängende Wert
     */
    void anhaengen(T val)
    {
        //# TODO: Erstellen Sie einen neuen Knoten. Unterscheiden Sie, ob die Liste leer ist 
        //  oder ob das Ende erst durch eine Schleife gesucht werden muss.
        
    }

    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     * 
     * @param index Die Stelle, an der der neue Wert stehen soll (0 <= index <= laenge())
     * @param val Der einzufügende Wert
     */
    void einfuegenBei(int index, T val)
    {
        //# TODO: Fügen Sie einen neuen Knoten an der gewünschten Position ein.
        //  Beachten Sie den Sonderfall des Einfügens bei Index 0 und die korrekte 
        //  Reihenfolge des Zeigerbiegens bei Index > 0.
        
    }

    /**
     * Prüft, ob ein gesuchter Wert in der Liste enthalten ist.
     * 
     * @param val Der zu suchende Wert
     * @return true, wenn der Wert gefunden wurde; false sonst.
     */
    boolean enthaelt(T val)
    {
        //# TODO: Durchsuchen Sie die Liste iterativ nach dem übergebenen Wert.
        
        return false; // Platzhalter
    }

    /**
     * Entfernt den Knoten an der gegebenen Position aus der Liste.
     * 
     * @param index Die Position des zu löschenden Knotens.
     */
    void entferneBei(int index)
    {
        //# TODO: Entfernen Sie das Element am angegebenen Index.
        //  Beachten Sie das Löschen des Anfangselements (Index 0) sowie die 
        //  Überbrückung des Knotens bei Index > 0.
        
    }
    
    /**
     * Erzeugt eine String-Repräsentation der Liste für die Konsole.
     * 
     * @return String im Format [wert1, wert2, wert3]
     */
    @Override
    String toString()
    {
        StringBuilder b = new StringBuilder();
        Listenknoten<T> k = anfang;
        while (k != null)
        {
            if (b.length() > 0)
            {
                b.append(", ");
            }
            b.append(k.daten);
            k = k.nachfolger;
        }
        return "[ " + b.toString() + " ]";
    }
}
