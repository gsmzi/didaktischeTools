import java.util.Random;

/**
 * Erzeugt Bäume unterschiedlicher Formate (tief/entartet oder balanciert).
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public static class TieferBaum
{
    /**
     * Erzeugt einen "tiefen" Baum, bei dem nach rechts stets nur ein Knoten abgeht,
     * der links aber eine lange Kette bildet (entarteter Linearbaum)
     * @param tiefe Die gewünschte Tiefe
     * @return Die Wurzel des erzeugten Binärbaums
     */
    public static Binaerbaum<Integer> erzeugeTiefenBaum(int tiefe)
    {
        Random r = new Random();
        Binaerbaum<Integer> wurzel = new Binaerbaum<Integer>(r.nextInt(1000));
        Binaerbaum<Integer> k = wurzel;
        for (int i = 1; i < tiefe; i++)
        {
            k.links = new Binaerbaum<Integer>(r.nextInt(1000));
            k.rechts = new Binaerbaum<Integer>(r.nextInt(1000));
            k = k.links;
        }
        return wurzel;
    }
    
    /**
     * Erzeugt einen vollständig balancierten Baum der Tiefe 't'.
     * @param t Gewünschte Tiefe
     * @return Wurzel des Baums
     */
    public static Binaerbaum<Integer> erzeugeBalanciertenBaum(int t)
    {
        if (t <= 0) return null;
        Random r = new Random();
        return erzeugeBalanciertenBaum(t, r);
    }
    
    private static Binaerbaum<Integer> erzeugeBalanciertenBaum(int t, Random r)
    {
        if (t == 0) return null;
        Binaerbaum<Integer> k = new Binaerbaum<Integer>(r.nextInt(1000));
        k.links = erzeugeBalanciertenBaum(t - 1, r);
        k.rechts = erzeugeBalanciertenBaum(t - 1, r);
        return k;
    }
}
