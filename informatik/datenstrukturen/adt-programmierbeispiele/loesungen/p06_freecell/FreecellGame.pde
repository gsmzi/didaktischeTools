import java.util.ArrayList;
import java.util.Random;

/**
 * Das Spielfeld selbst (Musterlösung)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class FreecellGame
{
    /**
     * Die vier Zellen oben links
     */
    private Karte[] zellen;

    /**
     * Die vier Stapel oben rechts (Ablagestapel)
     */
    private Stack<Karte>[] ablagestapel;

    /**
     * Die acht Stapel unten, auf denen die Karten zu Beginn liegen (Kaskaden)
     */
    private Stack<Karte>[] kaskaden; 

    /**
     * Konstanten, die für die verschiedenen Ablegebereiche stehen.
     */
    public static final int ZELLEN = 0;
    public static final int ABLAGESTAPEL = 1;
    public static final int KASKADEN = 2;
    public static final int KEINER = -1;

    /**
     * Erzeugt ein neues Spiel mit einer zufälligen Ausgangssituation.
     */
    FreecellGame()
    {
        this(new Random());
    }

    /**
     * Erzeugt ein neues Spiel mit einer vorgegebenen Nummer.
     * Ein Spiel mit einer bestimmten Nummer beginnt immer in der gleichen Ausgangssituation.
     * @param nummer Legt fest, welche Ausgangssituation verwendet wird.
     */
    FreecellGame(int nummer)
    {
        this(new Random(nummer));
    }

    /**
     * Erzeugt ein neues Spiel.
     * @param r Der Zufallsgenerator
     */
    private FreecellGame(Random r)
    {
        zellen = new Karte[4];
        ablagestapel = new Stack[4];
        kaskaden = new Stack[8];
        
        ArrayList<Integer> zahlen = new ArrayList<Integer>(52);
        for (int i = 0; i < 52; i++) {
            zahlen.add(i);
        } 
        
        // Stapel instanziieren
        for (int i = 0; i < ablagestapel.length; i++) {
            ablagestapel[i] = new ArrayStack<Karte>();
        } 
        for (int i = 0; i < kaskaden.length; i++) {
            kaskaden[i] = new ArrayStack<Karte>();
        }
        
        // Karten zufällig auf Kaskaden verteilen
        for (int i = 0; i < kaskaden.length; i++) 
        {
            int limit = (i < 4) ? 7 : 6;
            for (int j = 0; j < limit; j++) {
                int rnd = r.nextInt(zahlen.size());
                Karte k = new Karte(zahlen.get(rnd));
                zahlen.remove(rnd);
                kaskaden[i].push(k);
            } 
        } 
    }

    /**
     * Gibt die oberste Karte aus dem angegebenen Bereich zurück.
     * @param bereich Kann ZELLEN, ABLAGESTAPEL oder KASKADEN sein.
     * @param index Kann 0 bis 7 (für Kaskaden) bzw. 0 bis 3 (andere Bereiche) sein.
     * @return Die oberste Karte, sofern eine dort liegt; null sonst.
     */
    Karte getKarte(int bereich, int index)
    {
        if (bereich == ZELLEN)
        {
            return zellen[index];
        }
        if (bereich == KASKADEN && !kaskaden[index].isEmpty())
        {
            return kaskaden[index].top();
        }
        if (bereich == ABLAGESTAPEL && !ablagestapel[index].isEmpty())
        {
            return ablagestapel[index].top();
        }
        return null;
    }

    /**
     * Gibt die Höhe der Kaskade mit der gegebenen Nummer zurück.
     * @param index Kann 0 bis 7 sein.
     * @return Die Höhe der Kaskade.
     */
    int getStapelHoehe(int index)
    {
        int size = 0;
        Stack<Karte> temp = new ArrayStack<Karte>();
        Stack<Karte> s = kaskaden[index];
        while(!s.isEmpty())
        {
            temp.push(s.pop());
            size++;
        }
        while(!temp.isEmpty())
        {
            s.push(temp.pop());
        }
        return size;
    }

    /**
     * Gibt die n-te Karte von oben in der Kaskade mit der Nummer index zurück.
     * @param index Kann 0 bis 7 sein.
     * @param n Kann 0 bis getStapelHoehe(index)-1 sein.
     * @return Die gewünschte Karte.
     */
    Karte getKarteInStapel(int index, int n)
    {
        Stack<Karte> temp = new ArrayStack<Karte>();
        Stack<Karte> s = kaskaden[index];
        for (int i = 0; i < n; i++)
        {
            temp.push(s.pop());
        }
        Karte k = s.top();
        while(!temp.isEmpty())
        {
            s.push(temp.pop());
        }
        return k;
    }

    /**
     * Gibt zurück, ob das Spiel gewonnen ist.
     * @return true, wenn gewonnen; false sonst.
     */
    boolean istGewonnen()
    {
        for (Karte k : zellen)
        {
            if (k != null)
            {
                return false;
            }
        }
        for (Stack<Karte> s : kaskaden)
        {
            if (!s.isEmpty())
            {
                return false;
            }
        }
        return true;
    }

    /**
     * Verschiebt eine Karte nach den Regeln von Freecell.
     * @param vonBereich ZELLEN oder KASKADEN
     * @param vonIndex Quellindex
     * @param nachBereich ZELLEN, KASKADEN oder ABLAGESTAPEL
     * @param nachIndex Zielindex
     * @return true, wenn Zug gültig und erfolgreich; false sonst.
     */
    boolean verschiebe(int vonBereich, int vonIndex, int nachBereich, int nachIndex)
    {
        Karte k = null;
        if (vonBereich == ZELLEN)
        {
            k = zellen[vonIndex];
        }
        else if (vonBereich == KASKADEN && !kaskaden[vonIndex].isEmpty())
        {
            k = kaskaden[vonIndex].top();
        }
        else
        {
            return false;
        }
        
        boolean erfolg = false;
        if (nachBereich == ZELLEN)
        {
            erfolg = (zellen[nachIndex] == null);
            if (erfolg)
            {
                zellen[nachIndex] = k;
            }
        }
        if (nachBereich == KASKADEN)
        {
            if (kaskaden[nachIndex].isEmpty())
            {
                erfolg = true;
            }
            else
            {
                Karte kk = kaskaden[nachIndex].top();
                // Karte muss alternierende Farbe haben und genau um 1 kleiner sein
                erfolg = (kk.getWert() == k.getWert() + 1 && kk.istRot() != k.istRot());
            }
            if (erfolg)
            {
                kaskaden[nachIndex].push(k);
            }
        }
        if (nachBereich == ABLAGESTAPEL)
        {
            if (ablagestapel[nachIndex].isEmpty())
            {
                // Asse auf leere Ablagestapel
                erfolg = (k.getWert() == 1);
            }
            else 
            {
                Karte kk = ablagestapel[nachIndex].top();
                // Gleiche Farbe, Wert um 1 höher
                erfolg = (kk.getFarbe() == k.getFarbe() && kk.getWert() == k.getWert() - 1);
            }
            if (erfolg)
            {
                ablagestapel[nachIndex].push(k);
            }
        }
        
        if (erfolg)
        {
            if (vonBereich == ZELLEN)
            {
                zellen[vonIndex] = null;
            }
            else
            {
                kaskaden[vonIndex].pop();
            }
        }
        return erfolg;
    }

    /**
     * Führt einen automatischen Zug auf die Ablagestapel aus, wenn möglich.
     * Eine Karte darf automatisch nach Hause wandern, wenn sie ein As/2 ist, 
     * oder wenn ihr Wert maximal um 2 größer ist als die kleinste Karte auf allen Ablagen.
     * @return true, wenn ein Zug ausgeführt wurde; false sonst.
     */
    boolean automatischerZug()
    {
        int min = 15;
        for (Stack<Karte> s : ablagestapel)
        {
            if (s.isEmpty())
            {
                min = 0;
                break;
            }
            if (s.top().getWert() < min)
            {
                min = s.top().getWert();
            }
        }
        
        // Prüfe freie Zellen
        for (int i = 0; i < zellen.length; i++)
        {
            if (zellen[i] != null && zellen[i].getWert() <= min + 2 && verschiebeAutomatisch(zellen[i]))
            {
                zellen[i] = null;
                return true;
            }
        }
        
        // Prüfe Kaskaden
        for (int i = 0; i < kaskaden.length; i++)
        {
            Stack<Karte> s = kaskaden[i];
            if (!s.isEmpty() && s.top().getWert() <= min + 2 && verschiebeAutomatisch(s.top()))
            {
                s.pop();
                return true;
            }
        }
        return false;        
    }

    /**
     * Hilfsmethode für das automatische Heimverschieben.
     */
    private boolean verschiebeAutomatisch(Karte k)
    {
        if (k.getWert() == 1)
        {
            for (Stack<Karte> s: ablagestapel)
            {
                if (s.isEmpty())
                {
                    s.push(k);
                    return true;
                }
            }
        }
        else
        {
            for (Stack<Karte> s: ablagestapel)
            {
                if (!s.isEmpty() && s.top().getFarbe() == k.getFarbe() && s.top().getWert() + 1 == k.getWert())
                {
                    s.push(k);
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Führt einen Doppelklick-Schnellzug aus:
     * - Von Zelle auf passenden Ablagestapel
     * - Von Kaskade auf eine freie Zelle
     */
    boolean schnellerZug(int bereich, int index)
    {
        if (bereich == ZELLEN && zellen[index] != null)
        {
            Karte k = zellen[index];
            if (verschiebeAutomatisch(k))
            {
                zellen[index] = null;
                return true;
            }
        }
        if (bereich == KASKADEN && !kaskaden[index].isEmpty())
        {
            // Versuche erst auf Ablagestapel zu verschieben
            Karte k = kaskaden[index].top();
            if (verschiebeAutomatisch(k))
            {
                kaskaden[index].pop();
                return true;
            }
            
            // Sonst auf freie Zelle verschieben
            for (int i = 0; i < zellen.length; i++)
            {
                if (zellen[i] == null)
                {
                    zellen[i] = kaskaden[index].pop();
                    return true;
                }
            }
        }
        return false;
    }
}
