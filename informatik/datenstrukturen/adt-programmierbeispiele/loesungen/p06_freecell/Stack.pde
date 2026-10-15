/**
 * Abstrakte Basisklasse für Stacks (Musterlösung)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Stack<T>
{
    /**
     * Gibt zurück, ob der Stack leer ist
     * @return true, wenn der Stack leer ist; false sonst
     */
    abstract boolean isEmpty();
    
    /**
     * Legt ein neues Element auf den Stack
     * @param x Das neue Element
     */
    abstract void push(T x);
    
    /**
     * Entfernt das oberste Element vom Stack (falls der Stack nicht leer ist) und gibt es zurück
     * @return Das bisherige oberste Element
     */
    abstract T pop();
    
    /**
     * Gibt das oberste Element des Stacks zurück (falls der Stack nicht leer ist)
     * @return Das oberste Element
     */
    abstract T top();
}
