import java.util.function.Predicate;

/**
 * Klasse Baumalgorithmen2 (Schülervorlage)
 * 
 * Erweitert Baumalgorithmen um Breitensuche (Queue) und Tiefensuche (Stack).
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. Integer breitensuche(Predicate<Integer> p)
 *    - Suche mit FIFO-Behälter (Queue) aufrufen:
 *      return suche(p, new ArrayQueue<Binaerbaum<Integer>>());
 * 2. Integer tiefensuche(Predicate<Integer> p)
 *    - Suche mit LIFO-Behälter (Stack) aufrufen:
 *      return suche(p, new ArrayStack<Binaerbaum<Integer>>());
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class Baumalgorithmen2 extends Baumalgorithmen
{
    public Baumalgorithmen2(Binaerbaum<Integer> wurzel)
    {
        super(wurzel);
    }
    
    public Integer breitensuche(Predicate<Integer> p)
    {
        //# TODO: Implementieren Sie die Breitensuche wie beschrieben
        //  Tipp: Rufen Sie die Methode suche(p, container) mit einer geeigneten Container-Instanz auf.
        return null;
    }
    
    public Integer tiefensuche(Predicate<Integer> p)
    {
        //# TODO: Implementieren Sie die Tiefensuche wie beschrieben
        //  Tipp: Rufen Sie die Methode suche(p, container) mit einer geeigneten Container-Instanz auf.
        return null;
    }
    
    public Integer suche(Predicate<Integer> p, Container<Binaerbaum<Integer>> todo)
    {
        todo.insert(wurzel);
        while(!todo.isEmpty())
        {
            Binaerbaum<Integer> tmp = todo.removeNext();
            if (tmp.daten != null && p.test(tmp.daten))
            {
                return tmp.daten;
            }
            if (tmp.rechts != null)
            {
                todo.insert(tmp.rechts);
            }
            if (tmp.links != null)
            {
                todo.insert(tmp.links);
            }
        }
        return null;
    }
}
