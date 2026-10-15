import java.util.function.Predicate;

/**
 * Tiefen- und Breitensuche
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
        return suche(p, new ArrayQueue<Binaerbaum<Integer>>());
    }
    
    public Integer tiefensuche(Predicate<Integer> p)
    {
        return suche(p, new ArrayStack<Binaerbaum<Integer>>());
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
