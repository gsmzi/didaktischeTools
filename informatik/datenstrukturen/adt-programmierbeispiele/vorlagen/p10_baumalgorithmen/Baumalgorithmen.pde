import java.util.ArrayList;

/**
 * Klasse Baumalgorithmen (Schülervorlage)
 * 
 * Führt grundlegende rekursive Algorithmen auf Binärbäumen aus.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. int tiefe(Binaerbaum b)
 *    - Tiefe des Baumes rekursiv bestimmen.
 *    - b == null -> 0; sonst 1 + max(tiefe(b.links), tiefe(b.rechts)).
 * 2. int anzahl(Binaerbaum b)
 *    - Anzahl aller Knoten im Baum rekursiv zählen.
 *    - b == null -> 0; sonst 1 + anzahl(b.links) + anzahl(b.rechts).
 * 3. <T> boolean enthaelt(Binaerbaum b, T wert)
 *    - Prüfen, ob ein Wert im Baum vorkommt (mit equals vergleichen).
 *    - b == null -> false; Treffer -> true; sonst links oder rechts weitersuchen.
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class Baumalgorithmen
{
    /**
     * Die Wurzel des Baums, mit dem der Algorithmus durchgeführt werden soll
     */
    protected Binaerbaum wurzel;

    /**
     * Erzeugt ein neues Algorithmen-Objekt
     * @param wurzel Die Wurzel des Baums, der verarbeitet werden soll
     */
    public Baumalgorithmen(Binaerbaum wurzel)
    {
        this.wurzel = wurzel;
    }

    /**
     * Gibt die Tiefe des Baums zurück
     * @return Die Tiefe des Baums, gezählt ab der Wurzel
     */
    public int tiefe()
    {
        return tiefe(wurzel);
    }

    /**
     * Gibt die Tiefe eines Baums zurück
     * @param b Der Baum, dessen Tiefe bestimmt werden soll
     * @return Die Tiefe des Baums, gezählt ab b
     */
    private int tiefe(Binaerbaum b)
    {
        //# TODO: Bestimmen Sie die Tiefe des Binärbaums b. 
        //#       Ein leerer Baum (b == null) hat nach Definition die Tiefe 0.
        //#       Die Tiefe eines Knotens ist 1 plus das Maximum der Tiefen seiner beiden Kinder.
        
        return 0;
    }

    /**
     * Gibt die Anzahl der Knoten im Baums zurück
     * @return Die Anzahl aller Knoten im Baum
     */
    public int anzahl()
    {
        return anzahl(wurzel);
    }

    /**
     * Gibt die Anzahl der Knoten in einem Baums zurück
     * @param b Der Baum, in dem die Knoten gezählt werden sollen
     * @return Die Anzahl der Knoten, die sich von b an im Baum befinden (inklusive b)
     */
    private int anzahl(Binaerbaum b)
    {
        //# TODO: Bestimmen Sie die Anzahl der Knoten des Binärbaums b mit seinen Unterbäumen.
        //#       Ein leerer Baum (b == null) hat 0 Knoten.
        //#       Andernfalls hat der Baum 1 Knoten plus die Knotenanzahl im linken und rechten Teilbaum.
        
        return 0;
    }

    /**
     * Prüft, ob sich ein Wert im Baum befindet
     * @param wert Der zu suchende Wert
     * @return true, wenn ein Knoten den Wert enthält; false sonst
     */
    public <T> boolean enthaelt(T wert)
    {
        return enthaelt(wurzel, wert);
    }

    /**
     * Prüft, ob sich ein Wert in b oder darunter befindet
     * @param b Der Baum, in dem der Wert gesucht werden soll
     * @return true, wenn b oder einer seiner Kindknoten den Wert enthält; false sonst
     */
    private <T> boolean enthaelt(Binaerbaum b, T wert)
    {
        //# TODO: Bestimmen Sie, ob der Binärbaum b oder einer seiner Unterbäume den Wert wert enthält.
        //#       Achtung: Ein Vergleich muss mit equals durchgeführt werden.
        //#       Ein leerer Baum (b == null) enthält den Wert nicht.
        
        return false;
    }

    /**
     * Sammelt alle Knoten in Preorder-Reihenfolge (Hauptreihenfolge)
     */
    public ArrayList<Binaerbaum> getPreorder()
    {
        ArrayList<Binaerbaum> out = new ArrayList<Binaerbaum>();
        collectPreorder(wurzel, out);
        return out;
    }
    
    private void collectPreorder(Binaerbaum b, ArrayList<Binaerbaum> out)
    {
        if (b == null) return;
        out.add(b);
        collectPreorder(b.links, out);
        collectPreorder(b.rechts, out);
    }

    /**
     * Sammelt alle Knoten in Inorder-Reihenfolge (Symmetrische Reihenfolge)
     */
    public ArrayList<Binaerbaum> getInorder()
    {
        ArrayList<Binaerbaum> out = new ArrayList<Binaerbaum>();
        collectInorder(wurzel, out);
        return out;
    }
    
    private void collectInorder(Binaerbaum b, ArrayList<Binaerbaum> out)
    {
        if (b == null) return;
        collectInorder(b.links, out);
        out.add(b);
        collectInorder(b.rechts, out);
    }

    /**
     * Sammelt alle Knoten in Postorder-Reihenfolge (Nebenreihenfolge)
     */
    public ArrayList<Binaerbaum> getPostorder()
    {
        ArrayList<Binaerbaum> out = new ArrayList<Binaerbaum>();
        collectPostorder(wurzel, out);
        return out;
    }
    
    private void collectPostorder(Binaerbaum b, ArrayList<Binaerbaum> out)
    {
        if (b == null) return;
        collectPostorder(b.links, out);
        collectPostorder(b.rechts, out);
        out.add(b);
    }
}
