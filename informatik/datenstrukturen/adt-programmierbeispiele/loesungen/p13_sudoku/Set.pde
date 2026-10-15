/**
 * Schnittstelle des ADTs Set
 * 
 * @author Rainer Helfrich
 * @version September 2026
 */

public abstract class Set
{
    /**
     * FÃ¼gt einen neuen Wert in die Menge ein, falls er nicht bereits enthalten ist.
     * @param wert Der einzufÃ¼gende Wert
     */
    public abstract void einfuegen(int wert);
    
    /**
     * Entfernt einen Wert aus der Menge, falls er enthalten ist.
     * @param wert Der zu entfernende Wert
     */
    public abstract void entfernen(int wert);
    
    /**
     * Gibt zurÃ¼ck, ob ein bestimmter Wert in der Menge enthalten ist.
     * @param wert Der zu suchende Wert
     */
    public abstract boolean enthaelt(int wert);
    
    /**
     * Bestimmt die Schnittmenge der Menge selbst und der Menge s.
     * @param s Die Menge, mit der die Schnittmenge bestimmt werden soll
     * @return Ein neues Set, das die Schnittmenge der beiden Mengen reprÃ¤sentiert.
     */
    public abstract Set schnittmenge(Set s);
    
    /**
     * Bestimmt die Vereinigungsmenge der Menge selbst und der Menge s.
     * @param s Die Menge, mit der die Vereinigungsmenge bestimmt werden soll
     * @return Ein neues Set, das die Vereinigungsmenge der beiden Mengen reprÃ¤sentiert.
     */
    public abstract Set vereinigungsmenge(Set s);
    
    /**
     * Gibt zurÃ¼ck, ob diese Menge eine Untermenge der Menge s ist.
     * @param s Die Menge, die geprÃ¼ft werden soll.
     * @return true, wenn jedes Element dieser Menge in s enthalten ist; false sonst
     */
    public abstract boolean untermenge(Set s);
    
    /**
     * Bestimmt die Differenzmenge der Menge selbst und der Menge s.
     * @param s Die Menge, die von dieser Menge abgezogen werden soll.
     * @return Ein neues Set, das alle Elemente dieser Menge enthÃ¤lt, die nicht in s enthalten sind.
     */
    public abstract Set differenz(Set s);
    
    /**
     * Gibt die MÃ¤chtigkeit der Menge zurÃ¼ck
     * @return Die Anzahl der Elemente in der Menge
     */
    public abstract int anzahl();
    
    /**
     * Gibt zurÃ¼ck, ob die Menge kein Element enthÃ¤lt
     * @return true, wenn die Menge leer ist; false sonst
     */
    public abstract boolean istLeer();
    
    protected abstract int[] alsArray();

    /**
     * Gibt zurÃ¼ck, ob diese Menge und s die gleichen Elemente enthalten
     * @param s Die zu Ã¼berprÃ¼fende Menge
     * @return true, wenn beide Mengen die gleichen Elemente enthalten; false sonst
     */
    public boolean gleich(Set s)
    {
        return untermenge(s) && s.untermenge(this);
    }
    
    /**
     * Gibt die String-Darstellung der Menge (aufzÃ¤hlende Darstellung) zurÃ¼ck
     * @return Ein String, der alle Elemente der Menge aufzÃ¤hlt.
     */
    @Override
    public String toString()
    {
        if (istLeer())
        {
            return "{ }";
        }
        StringBuilder sb = new StringBuilder();
        for(int v : alsArray())
        {
            if (sb.length() == 0)
            {
                sb.append("{ ");
            }
            else
            {
                sb.append(", ");
            }
            sb.append(v);
        }
        sb.append(" }");
        return sb.toString();
    }
}




