/**
 * Ein Stack basierend auf einem Array (Musterlösung)
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
        if (!isEmpty())
        {
            return (T)daten[anzahl-1];
        }
        return null;
    }
    
    /**
     * Entfernt das oberste Element vom Stack (falls der Stack nicht leer ist) und gibt es zurück
     * @return Das bisherige oberste Element
     */
    T pop()
    {
        if (!isEmpty())
        {
            anzahl--;
            T val = (T)daten[anzahl];
            daten[anzahl] = null; // Speicher freigeben
            return val;
        }
        return null;
    }
    
    /**
     * Legt ein neues Element auf den Stack
     * @param wert Das neue Element
     */
    void push(T wert)
    {
        if (anzahl == daten.length)
        {
            Object[] tmp = new Object[2*daten.length];
            System.arraycopy(daten, 0, tmp, 0, daten.length);
            daten = tmp;
        }
        daten[anzahl] = wert;
        anzahl++;
    }
    
    /**
     * Gibt zurück, ob der Stack leer ist
     * @return true, wenn der Stack leer ist; false sonst
     */
    boolean isEmpty()
    {
        return anzahl == 0;
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
