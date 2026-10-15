/**
 * Abstrakte Basisklasse für eine Warteschlange (Queue) (Schülervorlage)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class Queue<T>
{
    /**
     * Gibt zurück, ob die Warteschlange leer ist.
     * @return true, wenn leer; false sonst
     */
    abstract boolean isEmpty();
    
    /**
     * Reiht ein neues Element am Ende der Warteschlange ein.
     * @param x Das neue Element
     */
    abstract void enqueue(T x);
    
    /**
     * Entfernt das vorderste Element der Warteschlange (sofern nicht leer) und gibt es zurück.
     * @return Das bisherige vorderste Element
     */
    abstract T dequeue();
    
    /**
     * Gibt das vorderste Element der Warteschlange zurück (sofern nicht leer), ohne es zu entfernen.
     * @return Das vorderste Element
     */
    abstract T front();
}
