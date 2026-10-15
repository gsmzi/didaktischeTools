/**
 * Klasse TermAuswerter (Schülervorlage)
 * 
 * Wertet arithmetische Rechenbäume rekursiv aus und wandelt sie in Text um.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. int auswerten(Binaerbaum<Symbol> b)
 *    - Wenn b ein Blatt ist: b.daten.getInt() zurückgeben.
 *    - Sonst rekursiv links und rechts auswerten und mit dem Operator verknüpfen (+, -, *, /).
 * 2. String alsString(Binaerbaum<Symbol> b)
 *    - Rekursive Inorder-Traversierung mit Klammern um jede Operation erzeugen,
 *      z.B. "(" + alsString(b.links) + " " + op + " " + alsString(b.rechts) + ")".
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class TermAuswerter
{
    /**
     * Wertet den Term, der durch den Binärbaum b gegeben ist, arithmetisch aus.
     * @param b Der auszuwertende Baum
     * @return Das Zahlergebnis des Terms
     */
    public int auswerten(Binaerbaum<Symbol> b)
    {
        //# TODO: Implementieren Sie die Auswertung des Rechenbaums b.
        // 1. Wenn b ein Blatt ist, geben Sie seinen Zahlenwert zurück (b.daten.getInt()).
        // 2. Werten Sie rekursiv den linken und rechten Teilbaum aus.
        // 3. Verknüpfen Sie die beiden Ergebnisse mit dem Operator aus b.daten (+, -, *, /) und geben Sie das Ergebnis zurück.
        
        return 0;
    }
    
    /**
     * Wandelt den Term, der durch den Binärbaum b gegeben ist, in eine lineare Termdarstellung um.
     * @param b Der umzuwandelnde Term
     * @return Der Term als lineare Zeichenkette
     */
    public String alsString(Binaerbaum<Symbol> b)
    {
        //# TODO: Implementieren Sie die Umwandlung des Rechenbaums b in eine lineare Textdarstellung.
        // Ein einfacher Ansatz ist die Inorder-Traversierung mit Klammern um jede Operation, z. B.:
        // (linkes_Ergebnis + rechtes_Ergebnis)
        
        return "";
    }
}
