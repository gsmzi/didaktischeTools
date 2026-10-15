import java.awt.Color;

/**
 * Repräsentiert eine "sicher" eingetragene Zahl in einer Sudoku-Zelle
 * Kann eine Vorgabe sein oder eine durch Schlussfolgerungen gesetzte Zahl sein.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class BekannteZahl implements Eintrag
{
    /**
     * Der Wert der bekannten Zahl
     */
    private int wert;
    
    /**
     * Die Farbe, in der die Zahl gezeichnet werden soll (für Backtracking-Situationen)
     */
    private Color farbe;
    
    /**
     * Erzeugt eine neue bekannte Zahl
     * @param w Der Wert der Zahl
     */
    public BekannteZahl(int w)
    {
        wert = w;
        farbe = Color.BLACK;
    }
    
    /**
     * Markiert die Zahl, dies bedeutet, dass sie beim Backtracking "geraten" wurde
     */
    public void setMarkiert()
    {
        farbe = new Color(140, 70, 120); // Dunkelviolett / Magenta
    }
    
    /**
     * Zeichnet die Zahl auf das Canvas
     */
    public void zeichneDich(float x, float y, float w, float h)
    {
        if (farbe.equals(Color.BLACK))
        {
            fill(255);
        }
        else
        {
            fill(232, 121, 249); // Neon Pink/Purple for guessed numbers
        }
        
        textSize(26);
        textAlign(CENTER, CENTER);
        text(String.valueOf(wert), x + w/2, y + h/2 - 2);
    }

    /**
     * Gibt den Zahlwert der bekannten Zahl zurück
     * @return Der Wert der Zahl
     */
    public int getZahl()
    {
        return wert;
    }
    
    public Color getFarbe()
    {
        return farbe;
    }
}
