/**
 * Schnittstelle und Basisklasse des ADTs Set (Menge).
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Set
{
    /**
     * Fügt einen neuen Wert in die Menge ein, falls er nicht bereits enthalten ist.
     * @param wert Der einzufügende Wert
     */
    abstract void einfuegen(int wert);
    
    /**
     * Entfernt einen Wert aus der Menge, falls er enthalten ist.
     * @param wert Der zu entfernende Wert
     */
    abstract void entfernen(int wert);
    
    /**
     * Gibt zurück, ob ein bestimmter Wert in der Menge enthalten ist.
     * @param wert Der zu suchende Wert
     */
    abstract boolean enthaelt(int wert);
    
    /**
     * Bestimmt die Schnittmenge der Menge selbst und der Menge s.
     * @param s Die Menge, mit der die Schnittmenge bestimmt werden soll
     * @return Ein neues Set, das die Schnittmenge der beiden Mengen repräsentiert.
     */
    abstract Set schnittmenge(Set s);
    
    /**
     * Bestimmt die Vereinigungsmenge der Menge selbst und der Menge s.
     * @param s Die Menge, mit der die Vereinigungsmenge bestimmt werden soll
     * @return Ein neues Set, das die Vereinigungsmenge der beiden Mengen repräsentiert.
     */
    abstract Set vereinigungsmenge(Set s);
    
    /**
     * Gibt zurück, ob diese Menge eine Untermenge der Menge s ist.
     * @param s Die Menge, die geprüft werden soll.
     * @return true, wenn jedes Element dieser Menge in s enthalten ist; false sonst
     */
    abstract boolean untermenge(Set s);
    
    /**
     * Bestimmt die Differenzmenge der Menge selbst und der Menge s.
     * @param s Die Menge, die von dieser Menge abgezogen werden soll.
     * @return Ein neues Set, das alle Elemente dieser Menge enthält, die nicht in s enthalten sind.
     */
    abstract Set differenz(Set s);
    
    /**
     * Gibt die Mächtigkeit der Menge zurück.
     * @return Die Anzahl der Elemente in der Menge
     */
    abstract int anzahl();
    
    /**
     * Gibt zurück, ob die Menge kein Element enthält.
     * @return true, wenn die Menge leer ist; false sonst
     */
    abstract boolean istLeer();
    
    /**
     * Liefert die Elemente der Menge als flaches Integer-Array.
     */
    public abstract int[] alsArray();

    /**
     * Gibt zurück, ob diese Menge und s die gleichen Elemente enthalten.
     * @param s Die zu überprüfende Menge
     * @return true, wenn beide Mengen die gleichen Elemente enthalten; false sonst
     */
    public boolean gleich(Set s)
    {
        return untermenge(s) && s.untermenge(this);
    }
    
    /**
     * Gibt die String-Darstellung der Menge zurück.
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
