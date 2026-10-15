import java.util.ArrayList;

/**
 * Queue basierend auf einem Array
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class ArrayQueue<T> extends Queue<T>
{
    /**
     * Die Nutzdaten
     */
    private Object[] daten;
    
    /**
     * Der Index des ersten Wertes
     */
    private int first;
    
    /**
     * Der nächste freie Index
     */
    private int last;
    
    /**
     * Erzeugt eine neue, leere Queue
     */
    public ArrayQueue()
    {
        daten = new Object[10];
        first = 0;
        last = 0;
    }
    
    /**
     * Fügt ein neues Element hinten in der Schlange ein
     * @param x Das neue Element
     */
    public void enqueue(T x)
    {
        daten[last] = x;
        last++;
        if (last == daten.length)
        {
            last = 0;
        }
        if (last == first) // Vergrößerung nötig
        {
            Object[] tmp = new Object[daten.length*2];
            System.arraycopy(daten, first, tmp, 0, daten.length - first);
            System.arraycopy(daten, 0, tmp, daten.length - first, first);
            first = 0;
            last = daten.length;
            daten = tmp;
        }
    }
    
    /**
     * Gibt das vorderste Element der Queue zurück (falls sie nicht leer ist)
     * @return Das vorderste Element
     */
    public T front()
    {
        if (isEmpty())
        {
            return null;
        }
        return (T)daten[first];
    }
    
    /**
     * Entfernt das vorderste Element aus der Queue (falls sie nicht leer ist) und gibt es zurück
     * @return Das bisherige vorderste Element
     */
    public T dequeue()
    {
        T x = null;
        if (!isEmpty())
        {
            x = (T)daten[first];
            first++;
            if (first == daten.length)
            {
                first = 0;
            }
        }
        return x;
    }
    
    /**
     * Gibt zurück, ob die Queue leer ist
     * @return true, wenn die Queue leer ist; false sonst
     */
    public boolean isEmpty()
    {
        return first == last;
    }
    
    /**
     * Liefert alle Elemente in ihrer Entnahme-Reihenfolge (FIFO: vom Kopf bis zum Ende).
     */
    @Override
    public ArrayList<T> getElements()
    {
        ArrayList<T> elements = new ArrayList<T>();
        if (isEmpty()) return elements;
        
        int idx = first;
        while (idx != last)
        {
            elements.add((T)daten[idx]);
            idx++;
            if (idx == daten.length)
            {
                idx = 0;
            }
        }
        return elements;
    }
    
    /**
     * Gibt die Queue in String-Form aus.
     * @return Die String-Repräsentation der Queue
     */
    @Override
    public String toString()
    {
        StringBuilder b = new StringBuilder();
        for (int i = first; i < (last < first ? daten.length : last); i++)
        {
            if (i != first)
            {
                b.append(", ");
            }
            b.append(daten[i]);
        }
        if (last < first)
        {
            for (int i = 0; i < last; i++)
            {
                b.append(", " + daten[i]);
            }
        }
        return "< " + b.toString() + " <";
    }
}
