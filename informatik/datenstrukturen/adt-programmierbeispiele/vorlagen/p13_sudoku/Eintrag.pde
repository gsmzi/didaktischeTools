/**
 * Ein Eintrag in einer Sudoku-Zelle, kann entweder eine feststehende Zahl sein oder eine Menge von Kandidaten
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public interface Eintrag
{
    /**
     * Zeichnet den Eintrag auf das Processing-Canvas
     */    
    void zeichneDich(float x, float y, float w, float h);
}
