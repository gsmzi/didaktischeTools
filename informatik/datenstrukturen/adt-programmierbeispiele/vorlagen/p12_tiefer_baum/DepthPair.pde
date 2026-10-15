/**
 * Hilfsklasse für iterative Tiefenberechnung (Knoten-Tiefe-Paar).
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class DepthPair
{
    Binaerbaum<Integer> node;
    int depth;
    
    DepthPair(Binaerbaum<Integer> n, int d)
    {
        this.node = n;
        this.depth = d;
    }
}