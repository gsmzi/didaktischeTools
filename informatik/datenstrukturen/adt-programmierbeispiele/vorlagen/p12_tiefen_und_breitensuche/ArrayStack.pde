import java.util.ArrayList;

/**
 * Ein Stack basierend auf einem Array
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class ArrayStack<T> extends Stack<T>
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
    public ArrayStack()
    {
        daten = new Object[10];
        anzahl = 0;
    }
    
    /**
     * Gibt das oberste Element des Stacks zurück (falls der Stack nicht leer ist)
     * @return Das oberste Element
     */
    public T top()
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
    public T pop()
    {
        if (!isEmpty())
        {
            anzahl--;
            return (T)daten[anzahl];
        }
        return null;
    }
    
    /**
     * Legt ein neues Element auf den Stack
     * @param x Das neue Element
     */
    public void push(T wert)
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
    public boolean isEmpty()
    {
        return anzahl == 0;
    }
    
    /**
     * Liefert alle Elemente in ihrer Entnahme-Reihenfolge (LIFO: von oben nach unten).
     */
    @Override
    public ArrayList<T> getElements()
    {
        ArrayList<T> elements = new ArrayList<T>();
        // Top-Element (Index anzahl - 1) kommt zuerst
        for (int i = anzahl - 1; i >= 0; i--)
        {
            elements.add((T)daten[i]);
        }
        return elements;
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
