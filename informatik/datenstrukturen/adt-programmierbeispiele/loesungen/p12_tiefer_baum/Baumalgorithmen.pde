import java.util.ArrayList;

/**
 * Führt verschiedene Algorithmen auf Binärbäumen aus.
 * Bietet sowohl rekursive (anfällige) als auch iterative (sichere) Implementierungen.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class Baumalgorithmen
{
    /**
     * Die Wurzel des Baums, mit dem der Algorithmus durchgeführt werden soll
     */
    protected Binaerbaum<Integer> wurzel;

    /**
     * Erzeugt ein neues Algorithmen-Objekt
     * @param wurzel Die Wurzel des Baums, der verarbeitet werden soll
     */
    public Baumalgorithmen(Binaerbaum<Integer> wurzel)
    {
        this.wurzel = wurzel;
    }

    // ==========================================
    // Rekursive Implementierungen (anfällig!)
    // ==========================================

    /**
     * Gibt die Tiefe des Baums zurück (rekursiv)
     * @return Die Tiefe des Baums, gezählt ab der Wurzel
     */
    public int tiefe()
    {
        return tiefe(wurzel);
    }

    private int tiefe(Binaerbaum<Integer> b)
    {
        if (b == null)
        {
            return 0;
        }
        return 1 + Math.max(tiefe(b.links), tiefe(b.rechts));
    }

    /**
     * Gibt die Anzahl der Knoten im Baums zurück (rekursiv)
     * @return Die Anzahl aller Knoten im Baum
     */
    public int anzahl()
    {
        return anzahl(wurzel);
    }

    private int anzahl(Binaerbaum<Integer> b)
    {
        if (b == null)
        {
            return 0;
        }
        return 1 + anzahl(b.links) + anzahl(b.rechts);
    }

    // ==========================================
    // Iterative Implementierungen (sicher!)
    // ==========================================

    /**
     * Zählt die Knoten im Baum iterativ unter Verwendung eines Heap-basierten Stacks.
     * Schützt vor StackOverflowError bei extrem tiefen Bäumen.
     */
    public int anzahlIterativ()
    {
        if (wurzel == null) return 0;
        int count = 0;
        
        // Lokaler Stack auf dem Heap (Größe dynamisch)
        ArrayList<Binaerbaum<Integer>> stack = new ArrayList<Binaerbaum<Integer>>();
        stack.add(wurzel);
        
        while (!stack.isEmpty())
        {
            Binaerbaum<Integer> current = stack.remove(stack.size() - 1);
            count++;
            
            if (current.rechts != null)
            {
                stack.add(current.rechts);
            }
            if (current.links != null)
            {
                stack.add(current.links);
            }
        }
        return count;
    }


    /**
     * Berechnet die Tiefe des Baums iterativ (sicher vor StackOverflowError).
     */
    public int tiefeIterativ()
    {
        if (wurzel == null) return 0;
        int maxDepth = 0;
        
        // Stack von Knoten-Tiefe Paaren
        ArrayList<DepthPair> stack = new ArrayList<DepthPair>();
        stack.add(new DepthPair(wurzel, 1));
        
        while (!stack.isEmpty())
        {
            DepthPair current = stack.remove(stack.size() - 1);
            maxDepth = Math.max(maxDepth, current.depth);
            
            if (current.node.rechts != null)
            {
                stack.add(new DepthPair(current.node.rechts, current.depth + 1));
            }
            if (current.node.links != null)
            {
                stack.add(new DepthPair(current.node.links, current.depth + 1));
            }
        }
        return maxDepth;
    }
}
