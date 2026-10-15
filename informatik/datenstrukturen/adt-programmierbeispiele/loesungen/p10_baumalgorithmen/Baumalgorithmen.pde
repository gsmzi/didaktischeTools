import java.util.ArrayList;

/**
 * Führt verschiedene Algorithmen auf Binärbäumen aus (Musterlösung)
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
        if (b == null)
        {
            return 0;
        }
        return 1 + Math.max(tiefe(b.links), tiefe(b.rechts));
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
        if (b == null)
        {
            return 0;
        }
        return 1 + anzahl(b.links) + anzahl(b.rechts);
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
        if (b == null)
        {
            return false;
        }
        if (b.daten != null && b.daten.equals(wert))
        {
            return true;
        }
        return enthaelt(b.links, wert) || enthaelt(b.rechts, wert);
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
