/**
 * Klasse ArrayQueue (Schülervorlage)
 * 
 * Eine Warteschlange (Queue) basierend auf einem zirkulären Array (Ringpuffer).
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean isEmpty()
 *    - Prüfen, ob die Queue leer ist (anzahl == 0).
 * 2. void enqueue(T x)
 *    - Element hinten einreihen.
 *    - Wenn anzahl == daten.length: verdoppleKapazitaet() aufrufen.
 *    - In daten[schwanz] eintragen, schwanz = (schwanz + 1) % daten.length, anzahl++.
 * 3. T dequeue()
 *    - Vorderstes Element entnehmen und zurückgeben.
 *    - Wenn leer: null zurückgeben.
 *    - daten[kopf] merken und nullen, kopf = (kopf + 1) % daten.length, anzahl--, Wert zurückgeben.
 * 4. T front()
 *    - Vorderstes Element ansehen, ohne es zu entfernen.
 *    - Wenn leer: null zurückgeben, sonst daten[kopf] zurückgeben.
 * 5. void verdoppleKapazitaet()
 *    - Neues Array doppelter Größe anlegen und Elemente linear umkopieren.
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ArrayQueue<T> extends Queue<T>
{
    private Object[] daten;
    private int kopf;
    private int schwanz;
    private int anzahl;

    /**
     * Erzeugt eine neue leere Warteschlange mit einer Anfangskapazität von 10.
     */
    ArrayQueue()
    {
        daten = new Object[10];
        kopf = 0;
        schwanz = 0;
        anzahl = 0;
    }

    /**
     * Gibt zurück, ob die Warteschlange leer ist.
     */
    boolean isEmpty()
    {
        //# TODO
        // Prüfe, ob die Anzahl der Elemente in der Warteschlange 0 ist.
        
        return false;
    }

    /**
     * Reiht ein neues Element am Ende der Warteschlange ein.
     * Wenn das Array voll ist, wird es verdoppelt.
     */
    void enqueue(T x)
    {
        //# TODO
        // 1. Wenn die Warteschlange voll ist (anzahl == daten.length), rufe verdoppleKapazitaet() auf.
        // 2. Trage das Element an der Position 'schwanz' ein.
        // 3. Setze 'schwanz' zyklisch auf die nächste Position: (schwanz + 1) % daten.length.
        // 4. Inkrementiere 'anzahl'.
        
    }

    /**
     * Entfernt das vorderste Element der Warteschlange und gibt es zurück.
     */
    T dequeue()
    {
        //# TODO
        // 1. Wenn die Warteschlange leer ist, gib null zurück.
        // 2. Hole das Element an der Position 'kopf'.
        // 3. Setze die Zelle daten[kopf] auf null (Speicherfreigabe).
        // 4. Setze 'kopf' zyklisch auf die nächste Position: (kopf + 1) % daten.length.
        // 5. Dekrementiere 'anzahl'.
        // 6. Gib das geholte Element zurück.
        
        return null;
    }

    /**
     * Gibt das vorderste Element zurück, ohne es zu entfernen.
     */
    T front()
    {
        //# TODO
        // Gib das Element an der Position 'kopf' zurück, sofern die Warteschlange nicht leer ist.
        
        return null;
    }

    /**
     * Verdoppelt das interne Array und ordnet die Elemente neu an (Entzerrung des Ringpuffers).
     */
    private void verdoppleKapazitaet()
    {
        //# TODO
        // 1. Erstelle ein neues Object-Array der doppelten Länge.
        // 2. Kopiere die Elemente der Reihe nach (von kopf bis schwanz) in das neue Array.
        //    Der physikalische Index im alten Array für das i-te logische Element ist (kopf + i) % daten.length.
        // 3. Setze 'daten' auf das neue Array.
        // 4. Setze 'kopf' auf 0 und 'schwanz' auf 'anzahl'.
        
    }

    /**
     * Didaktischer Getter: Gibt die Rohdaten des Arrays zurück.
     */
    Object[] getDaten()
    {
        return daten;
    }

    /**
     * Didaktischer Getter: Gibt den Kopf-Index (Lese-Index) zurück.
     */
    int getKopf()
    {
        return kopf;
    }

    /**
     * Didaktischer Getter: Gibt den Schwanz-Index (Schreib-Index) zurück.
     */
    int getSchwanz()
    {
        return schwanz;
    }

    /**
     * Didaktischer Getter: Gibt die aktuelle Elementanzahl zurück.
     */
    int getAnzahl()
    {
        return anzahl;
    }

    /**
     * Konvertiert den Inhalt der Queue in ein lineares Array in korrekter Reihenfolge (vom Kopf zum Schwanz).
     * @return Ein Array mit den Elementen der Queue
     */
    public Object[] alsArray()
    {
        Object[] linear = new Object[anzahl];
        for (int i = 0; i < anzahl; i++)
        {
            linear[i] = daten[(kopf + i) % daten.length];
        }
        return linear;
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append("[ ");
        for (int i = 0; i < anzahl; i++)
        {
            if (i > 0) sb.append(", ");
            sb.append(daten[(kopf + i) % daten.length]);
        }
        sb.append(" ]");
        return sb.toString();
    }
}
