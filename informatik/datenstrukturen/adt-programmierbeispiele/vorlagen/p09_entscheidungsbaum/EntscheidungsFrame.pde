/**
 * Logikklasse EntscheidungsFrame (Schülervorlage)
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. void jaGeklickt():
 *    - Zeiger 'baum' auf das linke Kind setzen (baum = baum.links).
 * 2. void neinGeklickt():
 *    - Zeiger 'baum' auf das rechte Kind setzen (baum = baum.rechts).
 * 3. boolean istLoesung():
 *    - Prüfen, ob der aktuelle Knoten ein Blattknoten ist (baum != null && baum.istBlatt()).
 * 4. String aktuellerText():
 *    - Datenwert des aktuellen Knotens zurückgeben (baum != null ? baum.daten : "").
 * ============================================================================
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
        //# TODO: Setzen Sie den Zeiger 'baum' auf das linke Kind (baum = baum.links).
        
    }
    
    protected void neinGeklickt()
    {
        //# TODO: Setzen Sie den Zeiger 'baum' auf das rechte Kind (baum = baum.rechts).
        
    }
    
    protected boolean istLoesung()
    {
        //# TODO: Prüfen Sie, ob der aktuelle Knoten 'baum' ein Blattknoten ist (baum.istBlatt()).
        
        return false;
    }
    
    protected String aktuellerText()
    {
        //# TODO: Geben Sie den Datenwert des aktuellen Knotens zurück (baum.daten).
        
        return null;
    }
}