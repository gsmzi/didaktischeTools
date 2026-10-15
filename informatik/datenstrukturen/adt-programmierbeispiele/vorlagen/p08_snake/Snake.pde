/**
 * Repräsentiert die Schlange im Spiel Snake (Schülervorlage)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Snake
{
    private Queue<SnakeElement> koerper;
    
    // Aktuelle Kopfposition
    private int kopfX;
    private int kopfY;
    
    // Bewegungsrichtung
    private int richtungX;
    private int richtungY;

    /**
     * Erzeugt eine neue Schlange mit einer Startlänge von 3 Segmenten.
     * @param startX X-Koordinate des Kopfes
     * @param startY Y-Koordinate des Kopfes
     */
    Snake(int startX, int startY)
    {
        koerper = new ArrayQueue<SnakeElement>();
        
        // Initialen Schlangenkörper aufbauen (von links nach rechts wachsen)
        koerper.enqueue(new SnakeElement(startX - 2, startY));
        koerper.enqueue(new SnakeElement(startX - 1, startY));
        koerper.enqueue(new SnakeElement(startX, startY));
        
        kopfX = startX;
        kopfY = startY;
        
        // Standardmäßig bewegt sich die Schlange nach rechts
        richtungX = 1;
        richtungY = 0;
    }

    /**
     * Setzt die neue Bewegungsrichtung der Schlange.
     * Verhindert eine direkte Bewegungsumkehr (180 Grad).
     */
    void setRichtung(int dx, int dy)
    {
        // Wenn dx oder dy der Gegenrichtung entspricht, abbrechen
        if (dx != 0 && dx == -richtungX) return;
        if (dy != 0 && dy == -richtungY) return;
        
        richtungX = dx;
        richtungY = dy;
    }

    /**
     * Bewegt die Schlange um einen Schritt in die aktuelle Richtung.
     * Nutzt die Warteschlange: Ein neuer Kopf wird hinzugefügt (enqueue).
     * Wenn kein Apfel gefressen wurde, wird das hinterste Element entfernt (dequeue).
     * @param apfelGefressen Gibt an, ob die Schlange wachsen soll
     */
    void bewege(boolean apfelGefressen)
    {
        //# TODO
        // 1. Aktualisiere die Kopfkoordinaten kopfX und kopfY durch Aufaddieren von richtungX und richtungY.
        // 2. Erzeuge ein neues SnakeElement mit den neuen Kopfkoordinaten.
        // 3. Füge dieses Element mit enqueue() in die Warteschlange 'koerper' ein.
        // 4. Wenn 'apfelGefressen' false ist, entferne das hinterste Element der Schlange mittels dequeue() aus der Warteschlange.
        
    }

    /**
     * Überprüft, ob die Schlange mit sich selbst oder den Wänden kollidiert ist.
     * @param breite Breite des Spielfelds (Rasterzellen)
     * @param hoehe Höhe des Spielfelds (Rasterzellen)
     * @return true, wenn eine Kollision vorliegt; false sonst.
     */
    boolean pruefeKollision(int breite, int hoehe)
    {
        // 1. Wandkollision
        if (kopfX < 0 || kopfX >= breite || kopfY < 0 || kopfY >= hoehe)
        {
            return true;
        }
        
        // 2. Selbstkollision (Kopf rammt Körper)
        ArrayQueue<SnakeElement> aq = (ArrayQueue<SnakeElement>)koerper;
        Object[] segs = aq.alsArray();
        
        // Vergleiche den Kopf (letztes Element im Array) mit allen vorherigen Elementen
        for (int i = 0; i < segs.length - 1; i++)
        {
            SnakeElement el = (SnakeElement)segs[i];
            if (el != null && el.getX() == kopfX && el.getY() == kopfY)
            {
                return true;
            }
        }
        
        return false;
    }

    /**
     * Gibt den Kopf-X-Wert zurück.
     */
    int getKopfX()
    {
        return kopfX;
    }

    /**
     * Gibt den Kopf-Y-Wert zurück.
     */
    int getKopfY()
    {
        return kopfY;
    }

    /**
     * Gibt die X-Bewegungsrichtung zurück.
     */
    int getRichtungX()
    {
        return richtungX;
    }

    /**
     * Gibt die Y-Bewegungsrichtung zurück.
     */
    int getRichtungY()
    {
        return richtungY;
    }

    /**
     * Gibt die Warteschlange zurück, die den Schlangenkörper repräsentiert.
     */
    Queue<SnakeElement> getKoerper()
    {
        return koerper;
    }
}
