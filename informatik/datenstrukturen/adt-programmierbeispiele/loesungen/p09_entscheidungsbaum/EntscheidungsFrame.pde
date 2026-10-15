/**
 * Logikklasse EntscheidungsFrame (Musterlösung)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class EntscheidungsFrame
{
    protected Binaerbaum<String> baum;
    
    EntscheidungsFrame(Binaerbaum<String> baum)
    {
        this.baum = baum;
    }
    
    protected void jaGeklickt()
    {
        baum = baum.links;
    }
    
    protected void neinGeklickt()
    {
        baum = baum.rechts;
    }
    
    protected boolean istLoesung()
    {
        return baum.istBlatt();
    }
    
    protected String aktuellerText()
    {
        return baum.daten;
    }
}