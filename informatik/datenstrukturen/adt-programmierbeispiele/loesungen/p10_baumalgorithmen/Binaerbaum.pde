/**
 * Ein Knoten eines Binärbaums (Musterlösung)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class Binaerbaum<T>
{
    /**
     * Der Datenwert des Knotens
     */
    public T daten;
    
    /**
     * Der linke Kindbaum
     */
    public Binaerbaum<T> links;
    
    /**
     * Der rechte Kindbaum
     */
    public Binaerbaum<T> rechts;
    
    /**
     * Erzeugt einen Blattknoten mit leerem Datenwert
     */
    public Binaerbaum()
    {
        this(null, null, null);
    }
    
    /**
     * Erzeugt einen Knoten mit Datenwert und Kindern
     * @param daten Der Datenwert
     * @param links Der linke Kindbaum
     * @param rechts Der rechte Kindbaum
     */
    public Binaerbaum(T daten, Binaerbaum<T> links, Binaerbaum<T> rechts)
    {
        this.daten = daten;
        this.links = links;
        this.rechts = rechts;
    }

    /**
     * Erzeugt einen Blattknoten mit Datenwert
     * @param daten Der Datenwert
     */
    public Binaerbaum(T daten)
    {
        this(daten, null, null);
    }
    
    /**
     * Gibt zurück, ob der Knoten ein Blatt ist
     * @return true, wenn der Knoten ein Blatt ist; false sonst
     */
    public boolean istBlatt()
    {
        return links == null && rechts == null;
    }
}
