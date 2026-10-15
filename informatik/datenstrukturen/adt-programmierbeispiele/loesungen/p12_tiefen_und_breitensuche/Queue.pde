/**
 * Abstrakte Basisklasse für Queues
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public abstract class Queue<T> extends Container<T>
{
    /**
     * Fügt ein neues Element hinten in der Schlange ein
     * @param x Das neue Element
     */
    public abstract void enqueue(T x);
    
    /**
     * Entfernt das vorderste Element aus der Queue (falls sie nicht leer ist) und gibt es zurück
     * @return Das bisherige vorderste Element
     */
    public abstract T dequeue();
    
    /**
     * Gibt das vorderste Element der Queue zurück (falls sie nicht leer ist)
     * @return Das vorderste Element
     */
    public abstract T front();
    
    /**
     * Fügt ein neues Element in den Container ein
     * Entspricht hier dem enqueue
     * @param x Das neue Element
     */
    @Override
    public void insert(T x)
    {
        enqueue(x);
    }
    
    /**
     * Entfernt das nächste Element aus dem Container (falls er nicht leer ist) und gibt es zurück
     * Entspricht hier dem dequeue
     * @return Das bisherige "nächste" Element
     */
    @Override
    public T removeNext()
    {
        return dequeue();
    }
    
    /**
     * Gibt das nächste Element des Containers zurück (falls er nicht leer ist)
     * Entspricht hier dem front
     * @return Das "nächste" Element
     */
    @Override
    public T getNext()
    {
        return front();
    }
}
