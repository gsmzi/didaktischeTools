import java.util.ArrayList;
import java.util.Random;

/**
 * Das Spielfeld selbst (Schülervorlage)
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
        
        //# TODO: Stapel instanziieren
        // 1. Erzeuge die vier Stacks für die Ablagestapel (ablagestapel[i] = new ArrayStack<Karte>();)
        // 2. Erzeuge die acht Stacks für die Kaskaden (kaskaden[i] = new ArrayStack<Karte>();)
        
        
        // Karten zufällig auf Kaskaden verteilen
        for (int i = 0; i < kaskaden.length; i++) 
        {
            int limit = (i < 4) ? 7 : 6;
            for (int j = 0; j < limit; j++) {
                int rnd = r.nextInt(zahlen.size());
                Karte k = new Karte(zahlen.get(rnd));
                zahlen.remove(rnd);
                
                // Falls die Stacks oben korrekt instanziiert wurden,
                // können hier die Karten aufgelegt werden:
                if (kaskaden[i] != null)
                {
                    kaskaden[i].push(k);
                }
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
        //# TODO
        // Gib die oberste Karte aus dem angegebenen Bereich zurück.
        // 1. Wenn Bereich ZELLEN: Gib zellen[index] zurück.
        // 2. Wenn Bereich KASKADEN: Falls kaskaden[index] nicht leer ist, gib kaskaden[index].top() zurück.
        // 3. Wenn Bereich ABLAGESTAPEL: Falls ablagestapel[index] nicht leer ist, gib ablagestapel[index].top() zurück.
        
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
        if (s == null) return 0;
        
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
        if (s == null) return null;
        
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
            if (s != null && !s.isEmpty())
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
        //# TODO
        // Implementiere die Verschiebe-Regeln von Freecell:
        // 1. Hole die Quell-Karte (aus ZELLEN oder KASKADEN).
        // 2. Prüfe, ob das Ablegen im Zielbereich erlaubt ist:
        //    - ZELLEN: Erlaubt, wenn die Zielzelle leer ist (null).
        //    - KASKADEN: Erlaubt, wenn die Kaskade leer ist, ODER die oberste Karte im Zielstack 
        //      einen um 1 größeren Wert hat als unsere Karte UND eine andere Farbe (rot vs. schwarz/istRot() alternierend).
        //    - ABLAGESTAPEL: Erlaubt, wenn der Zielstack leer ist UND unsere Karte ein As (Wert 1) ist, 
        //      ODER der Zielstack nicht leer ist UND die oberste Karte dort dieselbe Farbe (getFarbe()) hat 
        //      UND einen um 1 kleineren Wert als unsere Karte.
        // 3. Wenn die Bewegung erlaubt ist:
        //    - Lege die Karte auf das Ziel (im Array eintragen bzw. push() auf den Stack).
        //    - Entferne die Karte von der Quelle (im Array löschen bzw. pop() vom Stack).
        //    - Gib true zurück.
        // 4. Andernfalls gib false zurück.
        
        return false;
    }

    /**
     * Führt einen automatischen Zug auf die Ablagestapel aus, wenn möglich.
     * @return true, wenn ein Zug ausgeführt wurde; false sonst.
     */
    boolean automatischerZug()
    {
        //# TODO (Optional für Schüler)
        // Versuche, Karten automatisch auf die Ablagestapel zu verschieben.
        // Eine Karte kann automatisch "nach Hause" gelegt werden, wenn sie ein As/eine 2 ist,
        // oder wenn ihr Wert maximal um 2 größer ist als die kleinste Karte auf allen Ablagen.
        // Nutze verschiebe() bzw. eine Hilfsmethode.
        
        return false;
    }

    /**
     * Führt einen Doppelklick-Schnellzug aus:
     * - Von Zelle auf passenden Ablagestapel
     * - Von Kaskade auf eine freie Zelle / passenden Ablagestapel
     */
    boolean schnellerZug(int bereich, int index)
    {
        //# TODO (Optional für Schüler)
        // Implementiere Schnellzüge für Doppelklicks:
        // - Wenn ZELLEN: Versuche Karte nach Hause zu legen.
        // - Wenn KASKADEN: Versuche Karte nach Hause zu legen, andernfalls auf eine leere Zelle.
        
        return false;
    }
}
