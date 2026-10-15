/**
 * Eine Warteschlange (Queue) basierend auf einem zirkulären Array (Ringpuffer) (Musterlösung)
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
        return anzahl == 0;
    }

    /**
     * Reiht ein neues Element am Ende der Warteschlange ein.
     * Wenn das Array voll ist, wird es verdoppelt.
     */
    void enqueue(T x)
    {
        if (anzahl == daten.length)
        {
            verdoppleKapazitaet();
        }
        daten[schwanz] = x;
        schwanz = (schwanz + 1) % daten.length;
        anzahl++;
    }

    /**
     * Entfernt das vorderste Element der Warteschlange und gibt es zurück.
     */
    T dequeue()
    {
        if (isEmpty())
        {
            return null;
        }
        T element = (T)daten[kopf];
        daten[kopf] = null; // Speicher freigeben
        kopf = (kopf + 1) % daten.length;
        anzahl--;
        return element;
    }

    /**
     * Gibt das vorderste Element zurück, ohne es zu entfernen.
     */
    T front()
    {
        if (isEmpty())
        {
            return null;
        }
        return (T)daten[kopf];
    }

    /**
     * Verdoppelt das interne Array und ordnet die Elemente neu an (Entzerrung des Ringpuffers).
     */
    private void verdoppleKapazitaet()
    {
        Object[] neu = new Object[daten.length * 2];
        for (int i = 0; i < anzahl; i++)
        {
            neu[i] = daten[(kopf + i) % daten.length];
        }
        daten = neu;
        kopf = 0;
        schwanz = anzahl;
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
