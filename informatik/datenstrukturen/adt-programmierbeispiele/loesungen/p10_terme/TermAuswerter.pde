/**
 * Wertet einen Term aus, der als Rechenbaum gegeben ist (Musterlösung).
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class TermAuswerter
{
    /**
     * Wertet den Term, der durch den Binärbaum b gegeben ist, arithmetisch aus
     * @param b Der auszuwertende Baum
     * @return Das Zahlergebnis des Terms
     */
    public int auswerten(Binaerbaum<Symbol> b)
    {
        if (b == null)
        {
            return 0;
        }
        if (b.istBlatt())
        {
            return b.daten.getInt();
        }
        else
        {
            int l = auswerten(b.links);
            int r = auswerten(b.rechts);
            if (b.daten.istPlus())
            {
                return l + r;
            }
            else if (b.daten.istMal())
            {
                return l * r;
            }
            else if (b.daten.istMinus())
            {
                return l - r;
            }
            else 
            {
                // Division durch Null absichern
                if (r == 0)
                {
                    throw new ArithmeticException("Division durch Null!");
                }
                return l / r;
            }
        }
    }
    
    /**
     * Wandelt den Term, der durch den Binärbaum b gegeben ist, in eine lineare Termdarstellung um
     * @param b Der umzuwandelnde Term
     * @return Der Term als lineare Zeichenkette
     */
    private boolean brauchtKlammer(Binaerbaum<Symbol> b, boolean links)
    {
        Binaerbaum<Symbol> kind = links ? b.links : b.rechts;
        if (kind == null || kind.istBlatt())
        {
            return false;
        }
        if (b.daten.istPunktRechnung())
        {
            if (kind.daten.istStrichRechnung())
                return true;
            if (!links && b.daten.istGeteilt())
                return true;
            return false;
        }
        if (!links && b.daten.istMinus() && b.rechts.daten.istStrichRechnung())
        {
            return true;
        }
        return false;
    }
    
    public String alsString(Binaerbaum<Symbol> b)
    {
        if (b == null)
        {
            return "";
        }
        if (b.istBlatt())
        {
            return b.daten.toString();
        }
        String ergebnis = "";
        
        if (brauchtKlammer(b, true))
        {
            ergebnis += "(";
        }
        ergebnis += alsString(b.links);
        if (brauchtKlammer(b, true))
        {
            ergebnis += ")";
        }
        
        ergebnis += " " + b.daten.toString() + " ";
        
        if (brauchtKlammer(b, false))
        {
            ergebnis += "(";
        }
        ergebnis += alsString(b.rechts);
        if (brauchtKlammer(b, false))
        {
            ergebnis += ")";
        }
        
        return ergebnis;
    }
}
