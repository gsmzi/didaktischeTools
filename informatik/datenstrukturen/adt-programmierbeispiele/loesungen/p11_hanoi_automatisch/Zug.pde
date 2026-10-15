/**
 * Datenklasse für einen einzelnen Hanoi-Zug (von Turm -> nach Turm).
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Zug
{
    int von;
    int nach;
    
    Zug(int von, int nach)
    {
        this.von = von;
        this.nach = nach;
    }
}