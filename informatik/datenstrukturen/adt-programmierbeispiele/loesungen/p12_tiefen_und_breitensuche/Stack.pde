/**
 * Abstrakte Basisklasse für Stacks
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public abstract class Stack<T> extends Container<T>
{
    /**
     * Legt ein neues Element auf den Stack
     * @param x Das neue Element
     */
    public abstract void push(T x);
    
    /**
     * Entfernt das oberste Element vom Stack (falls der Stack nicht leer ist) und gibt es zurück
     * @return Das bisherige oberste Element
     */
    public abstract T pop();
    
    /**
     * Gibt das oberste Element des Stacks zurück (falls der Stack nicht leer ist)
     * @return Das oberste Element
     */
    public abstract T top();
    
    /**
     * Fügt ein neues Element in den Container ein
     * Entspricht hier dem push
     * @param x Das neue Element
     */
    @Override
    public void insert(T x)
    {
        push(x);
    }
    
    /**
     * Entfernt das nächste Element aus dem Container (falls er nicht leer ist) und gibt es zurück
     * Entspricht hier dem pop
     * @return Das bisherige "nächste" Element
     */
    @Override
    public T removeNext()
    {
        return pop();
    }
    
    /**
     * Gibt das nächste Element des Containers zurück (falls er nicht leer ist)
     * Entspricht hier dem top
     * @return Das "nächste" Element
     */
    @Override
    public T getNext()
    {
        return top();
    }
}
