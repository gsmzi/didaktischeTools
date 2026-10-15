/**
 * Das Spielfeld selbst (Schülervorlage)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class HanoiGame
{
    /**
     * Das Array hat drei Elemente und stellt die drei Scheibenstapel dar.
     */
    private Stack<Scheibe>[] stapel;

    /**
     * Erzeugt ein neues Spiel mit 7 Scheiben
     */
    HanoiGame()
    {
        this(7);
    }
    
    /**
     * Erzeugt ein neues Spiel, die Anzahl der Scheiben kann zwischen 3 und 10 liegen.
     * @param groesse Die Höhe des Stapels
     */
    HanoiGame(int groesse)
    {
        if (groesse > 10)
        {
            groesse = 10;
        }
        if (groesse < 3)
        {
            groesse = 3;
        }
        stapel = new Stack[3];
        for (int i = 0; i < 3; i++)
        {
            stapel[i] = new ArrayStack<Scheibe>();
        }
        while(groesse > 0)
        {
            stapel[0].push(new Scheibe(groesse));
            groesse--;
        }
    }
    
    /**
     * Gibt die Höhe des Turms zurück
     * @param index Welcher Turm wird abgefragt? 0 = links, 1 = mitte, 2 = rechts
     * @return Höhe des gefragten Turmes
     */
    int getTurmHoehe(int index)
    {
        Stack<Scheibe> tmp = new ArrayStack<Scheibe>();
        int size = 0;
        while(!stapel[index].isEmpty())
        {
            tmp.push(stapel[index].pop());
            size++;
        }
        while(!tmp.isEmpty())
        {
            stapel[index].push(tmp.pop());
        }
        return size;
    }
    
    /**
     * Gibt die n-te Scheibe auf Turm t zurück. n wird von oben gezählt, d.h. n = 0 ist die oberste Scheibe.
     * @param turm Die Nummer des Turmes (0 = links, 1 = mitte, 2 = rechts)
     * @param index Die Nummer der Scheibe (0 <= index < getTurmHoehe(t))
     * @return Die gewünschte Scheibe
     */    
    Scheibe getNteScheibe(int turm, int index)
    {
        Stack<Scheibe> tmp = new ArrayStack<Scheibe>();
        for (int i = 0; i < index; i++)
        {
            tmp.push(stapel[turm].pop());
        }
        Scheibe s = stapel[turm].top();
        while(!tmp.isEmpty())
        {
            stapel[turm].push(tmp.pop());
        }
        return s;
    }
    
    /**
     * Verschiebt eine Scheibe von einem Turm auf den anderen, falls der Zug erlaubt ist
     * @param von Die Nummer des Turms (0 = links, 1 = mitte, 2 = rechts), von dem weggezogen wird
     * @param nach Die Nummer des Turms (0 = links, 1 = mitte, 2 = rechts), auf den hingezogen wird
     * @return true, wenn der Zug erlaubt war; false sonst
     */
    boolean bewegeScheibe(int von, int nach)
    {
        //# TODO
        // Implementiere die Spielregeln von Hanoi:
        // 1. Wenn der Ausgangsstapel 'von' leer ist, gibt es nichts zu verschieben -> return false.
        // 2. Finde die oberste Scheibe auf Stapel 'von' heraus (top()).
        // 3. Prüfe, ob das Ablegen auf Stapel 'nach' erlaubt ist:
        //    Das ist der Fall, wenn Stapel 'nach' leer ist ODER die oberste Scheibe auf Stapel 'nach' 
        //    größer ist als die zu verschiebende Scheibe.
        // 4. Wenn der Zug erlaubt ist, verschiebe die Scheibe (pop() von 'von' und push() auf 'nach') 
        //    und gib true zurück. Andernfalls gib false zurück.
        
        return false;
    }
    
    /**
     * Gibt den rohen Stapel-Datenbehälter zurück (für didaktische Visualisierung)
     */
    Stack<Scheibe> getStapel(int idx)
    {
        return stapel[idx];
    }
    
    /**
     * Überprüft, ob das Spiel erfolgreich gelöst wurde.
     * Das Spiel ist gelöst, wenn alle Scheiben auf dem rechten Turm (Pfahl 2) liegen.
     */
    boolean istGeloest()
    {
        return stapel[0].isEmpty() && stapel[1].isEmpty();
    }
}
