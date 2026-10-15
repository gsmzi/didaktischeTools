/**
 * Klasse ArrayStack (Schülervorlage)
 * 
 * Ein Stack basierend auf einem dynamischen Array.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean isEmpty()
 *    - Prüfen, ob der Stack leer ist (anzahl == 0).
 * 2. void push(T wert)
 *    - Element auf den Stack legen.
 *    - Bei Bedarf (anzahl == daten.length) das Array verdoppeln (resize).
 *    - wert an Index 'anzahl' einfügen und 'anzahl' um 1 erhöhen.
 * 3. T pop()
 *    - Oberstes Element entfernen und zurückgeben.
 *    - Wenn leer: null zurückgeben.
 *    - 'anzahl' verringern, Wert merken, Zelle nullen und Wert zurückgeben.
 * 4. T top()
 *    - Oberstes Element (an Index anzahl - 1) ansehen, ohne es zu entfernen.
 *    - Wenn leer: null zurückgeben.
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ArrayStack<T> extends Stack<T>
{
    /**
     * Enthält die Nutzdaten
     */
    private Object[] daten;
    
    /**
     * Die Zahl gibt an, wie viele Elemente auf dem Stack liegen und damit auch,
     * wie viele Werte im Datenarray gültig sind.
     */
    private int anzahl;

    /**
     * Erzeugt einen neuen leeren Stack
     */
    ArrayStack()
    {
        daten = new Object[10];
        anzahl = 0;
    }
    
    /**
     * Gibt das oberste Element des Stacks zurück (falls der Stack nicht leer ist)
     * @return Das oberste Element
     */
    T top()
    {
        //# TODO
        // Gib das oberste Element des Stacks zurück (Index: anzahl-1),
        // sofern der Stack nicht leer ist. Andernfalls gib null zurück.
        
        return null;
    }
    
    /**
     * Entfernt das oberste Element vom Stack (falls der Stack nicht leer ist) und gibt es zurück
     * @return Das bisherige oberste Element
     */
    T pop()
    {
        //# TODO
        // Entferne das oberste Element vom Stack (sofern der Stack nicht leer ist),
        // dekrementiere die Anzahl, setze die Zelle im Array auf null und gib das Element zurück.
        
        return null;
    }
    
    /**
     * Legt ein neues Element auf den Stack
     * @param wert Das neue Element
     */
    void push(T wert)
    {
        //# TODO
        // Legt das neue Element auf den Stack.
        // Bei Bedarf (anzahl == daten.length) muss das Array verdoppelt werden.
        
    }
    
    /**
     * Gibt zurück, ob der Stack leer ist
     * @return true, wenn der Stack leer ist; false sonst
     */
    boolean isEmpty()
    {
        //# TODO
        // Prüfe, ob die Anzahl der Elemente 0 ist.
        
        return false;
    }
    
    /**
     * Didaktischer Getter für den Internals-Viewer im GUI
     */
    Object[] getDaten()
    {
        return daten;
    }
    
    /**
     * Didaktischer Getter für die Anzahl der Elemente
     */
    int getAnzahl()
    {
        return anzahl;
    }
    
    /**
     * Gibt den Stack in String-Form aus.
     * @return Die String-Repräsentation des Stacks
     */
    @Override
    public String toString()
    {
        StringBuilder b = new StringBuilder();
        b.append("[ ");
        for (int i = 0; i < anzahl; i++)
        {
            if (i > 0)
            {
                b.append(", ");
            }
            b.append(daten[i]);
        }
        b.append(" <");
        return b.toString();
    }
}
