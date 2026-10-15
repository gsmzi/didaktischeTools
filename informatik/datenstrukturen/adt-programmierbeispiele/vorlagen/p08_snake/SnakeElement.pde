/**
 * Repräsentiert ein einzelnes Segment des Schlangenkörpers (Schülervorlage)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class SnakeElement
{
    private int x;
    private int y;

    /**
     * Erzeugt ein neues Schlangensegment an den Koordinaten (x, y)
     */
    SnakeElement(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    /**
     * Gibt die X-Koordinate zurück.
     */
    int getX()
    {
        return x;
    }

    /**
     * Gibt die Y-Koordinate zurück.
     */
    int getY()
    {
        return y;
    }

    @Override
    public String toString()
    {
        return "(" + x + "," + y + ")";
    }
}
