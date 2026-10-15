/**
 * Führt verschiedene Algorithmen auf Binärbäumen aus
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
    private int tiefe(Binaerbaum<Integer> b)
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
    private int anzahl(Binaerbaum<Integer> b)
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
    private <T> boolean enthaelt(Binaerbaum<Integer> b, T wert)
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
}
