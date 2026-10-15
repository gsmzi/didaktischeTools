import java.util.ArrayList;

/**
 * Abstrakte Oberklasse für Queue und Stack
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public abstract class Container<T>
{
    /**
     * Gibt zurück, ob der Container leer ist
     * @return true, wenn der Container leer ist; false sonst
     */
    public abstract boolean isEmpty();
    
    /**
     * Fügt ein neues Element in den Container ein
     * @param x Das neue Element
     */
    public abstract void insert(T x);
    
    /**
     * Entfernt das nächste Element aus dem Container (falls er nicht leer ist) und gibt es zurück
     * @return Das bisherige "nächste" Element
     */
    public abstract T removeNext();
    
    /**
     * Gibt das nächste Element des Containers zurück (falls er nicht leer ist)
     * @return Das "nächste" Element
     */
    public abstract T getNext();
    
    /**
     * Hilfsmethode, um alle Elemente im Container in ihrer Entnahme-Reihenfolge abzurufen.
     * Nützlich für die visuelle Darstellung.
     */
    public abstract ArrayList<T> getElements();
}
