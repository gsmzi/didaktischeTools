/**
 * Repräsentiert eine Kandidatenmenge für eine Sudoku-Zelle
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class Kandidatenmenge extends BitSet implements Eintrag
{
    /**
     * Erzeugt eine neue Kandidatenmenge bestehend aus den Zahlen von 1 bis 9
     */
    public Kandidatenmenge()
    {
        for (int i = 1; i <= 9; i++)
        {
            this.einfuegen(i);
        }
    }

    /**
     * Zeichnet die Kandidatenmenge
     */
    public void zeichneDich(float x, float y, float w, float h)
    {
        if (istLeer())
        {
            // Ein rotes Kreuz zeichnen bei Widerspruch (Sackgasse)
            stroke(239, 68, 68); // Rot
            strokeWeight(2);
            line(x + 5, y + 5, x + w - 5, y + h - 5);
            line(x + 5, y + h - 5, x + w - 5, y + 5);
        }
        else
        {
            fill(96, 165, 250); // Helles Blau für Lesbarkeit auf dunklem Hintergrund
            textSize(10);
            textAlign(CENTER, CENTER);
            for (int i = 0; i < 3; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    int n = 3*j+i+1;
                    if (enthaelt(n))
                    {
                        float cx = x + i * w / 3.0;
                        float cy = y + j * h / 3.0;
                        float cw = w / 3.0;
                        float ch = h / 3.0;
                        text(String.valueOf(n), cx + cw / 2.0, cy + ch / 2.0 - 1);
                    }
                }
            }
        }
    }
}
