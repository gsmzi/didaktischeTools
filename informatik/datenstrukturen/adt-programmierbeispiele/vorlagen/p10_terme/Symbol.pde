/**
 * Stellt ein Symbol eines Rechenterms dar (Schülervorlage).
 * Als statische Klasse deklariert zur Kompatibilität mit dem statischen Parser.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
static class Symbol
{
    /**
     * Der Operator bzw. der Wert des Symbols
     */
    private String wert;
    
    /**
     * Erzeugt ein neues Symbol.
     * @param s Der Wert des Symbols
     */
    Symbol(String s)
    {
        wert = s;
    }
    
    /**
     * Gibt zurück, ob es sich bei dem Symbol um einen Operator handelt.
     * @return true, wenn es ein Operator ist; false sonst
     */
    boolean istOperator()
    {
        return "+-*/".contains(wert);
    }
    
    /**
     * Gibt den Integer-Wert des Symbols zurück
     * @return Den Integer-Wert des Symbols, wenn es sich um eine Zahl handelt; 0 sonst
     */
    int getInt()
    {
        if (!istOperator())
        {
            return Integer.parseInt(wert);
        }
        return 0;
    }
    
    /**
     * Gibt zurück, ob es sich um einen Plus-Operator handelt
     * @return true, wenn das Symbol "+" ist; false sonst
     */
    boolean istPlus()
    {
        return wert.equals("+");
    }
       
    /**
     * Gibt zurück, ob es sich um einen Mal-Operator handelt
     * @return true, wenn das Symbol "*" ist; false sonst
     */
    boolean istMal()
    {
        return wert.equals("*");
    }
    
    /**
     * Gibt zurück, ob es sich um einen Minus-Operator handelt
     * @return true, wenn das Symbol "-" ist; false sonst
     */
    boolean istMinus()
    {
        return wert.equals("-");
    }

    /**
     * Gibt zurück, ob es sich um einen Geteilt-Operator handelt
     * @return true, wenn das Symbol "/" ist; false sonst
     */
    boolean istGeteilt()
    {
        return wert.equals("/");
    }
    
    /**
     * Gibt zurück, ob es sich um eine Punktrechnung handelt
     * @return true, wenn das Symbol "*" oder "/" ist; false sonst
     */
    boolean istPunktRechnung()
    {
        return istMal() || istGeteilt();
    }
    
    /**
     * Gibt zurück, ob es sich um eine Strichrechnung handelt
     * @return true, wenn das Symbol "+" oder "-" ist; false sonst
     */
    boolean istStrichRechnung()
    {
        return istPlus() || istMinus();
    }
    
    /**
     * Wandelt das Symbol in seine String-Darstellung um
     * @return Die String-Darstellung des Symbols
     */
    @Override
    public String toString()
    {
        return wert;
    }
}
