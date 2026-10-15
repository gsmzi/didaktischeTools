/**
 * Klasse HanoiGame (Schülervorlage)
 * 
 * Spiellogik und automatische rekursive Lösung der Türme von Hanoi.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean bewegeScheibe(int von, int nach)
 *    - Spielregeln prüfen (von nicht leer; Ziel leer oder Ziel-Scheibe > Quell-Scheibe).
 *    - Scheibe umsetzen (pop / push) und true zurückgeben; sonst false.
 * 2. void loeseRekursiv(int anzahl, int von, int nach, int ueber)
 *    - Rekursives Hanoi-Schema:
 *      1. Wenn anzahl > 1: loeseRekursiv(anzahl - 1, von, ueber, nach)
 *      2. Größte Scheibe bewegen: zuege.add(new Zug(von, nach))
 *      3. Wenn anzahl > 1: loeseRekursiv(anzahl - 1, ueber, nach, von)
 * ============================================================================
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
     * Liste der vorberechneten Züge für die schrittweise Ausführung (Ansatz 1: Command Queue)
     */
    private ArrayList<Zug> zuege = new ArrayList<Zug>();
    private int zugIndex = 0;

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
     * Berechnet die vollständige Zugfolge für das Hanoi-Problem vor
     */
    void berechneLoesung()
    {
        zuege.clear();
        zugIndex = 0;
        int n = getTurmHoehe(0);
        if (getTurmHoehe(1) != 0 || getTurmHoehe(2) != 0)
        {
            logHinzufuegen("Fehler: Nicht im Ausgangszustand!");
            return;
        }
        loeseRekursiv(n, 0, 2, 1);
        logHinzufuegen("Lösung berechnet: " + zuege.size() + " Züge erforderlich (2^" + n + " - 1).");
    }
    
    /**
     * Löst das Hanoi-Problem rekursiv
     * @param anzahl Die Anzahl der zu verschiebenden Scheiben
     * @param von Die Nummer des Ausgangsstapels
     * @param nach Die Nummer des Zielstapels
     * @param ueber Die Nummer des Hilfsstapels
     */
    private void loeseRekursiv(int anzahl, int von, int nach, int ueber)
    {
        //# TODO
        // Implementiere den rekursiven Algorithmus für die Türme von Hanoi:
        // 
        // 1. Wenn anzahl > 1: Verschiebe anzahl-1 Scheiben rekursiv von 'von' nach 'ueber' (über 'nach').
        // 2. Füge den aktuellen Zug zur Liste hinzu: zuege.add(new Zug(von, nach));
        // 3. Wenn anzahl > 1: Verschiebe anzahl-1 Scheiben rekursiv von 'ueber' nach 'nach' (über 'von').
    }
    
    /**
     * Führt den nächsten vorberechneten Zug aus
     * @return true, wenn ein Zug ausgeführt wurde; false sonst
     */
    boolean naechstenSchrittAusfuehren()
    {
        if (zugIndex < zuege.size())
        {
            Zug z = zuege.get(zugIndex);
            zugIndex++;
            boolean erfolg = bewegeScheibe(z.von, z.nach);
            if (erfolg)
            {
                logHinzufuegen("Schritt " + zugIndex + "/" + zuege.size() + ": Scheibe von Turm " + z.von + " nach " + z.nach + ".");
            }
            return erfolg;
        }
        return false;
    }
    
    int getZugIndex()
    {
        return zugIndex;
    }
    
    int getGesamtZuege()
    {
        return zuege.size();
    }
    
    boolean hatWeitereSchritte()
    {
        return zugIndex < zuege.size();
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
     */
    boolean istGeloest()
    {
        return stapel[0].isEmpty() && stapel[1].isEmpty();
    }
}
