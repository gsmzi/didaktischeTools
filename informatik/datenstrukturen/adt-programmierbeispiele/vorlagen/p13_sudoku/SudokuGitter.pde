import java.util.ArrayList;
import java.util.function.Predicate; 
import java.awt.Point;

/**
 * Klasse SudokuGitter (Schülervorlage)
 * 
 * Repräsentiert das 9x9-Sudoku-Gitter und steuert Deduktions- und Backtracking-Schritte.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean kandidatenMengenErstellen()
 *    - Für alle Zellen mit 'null' eine Kandidatenmenge (Werte 1..9 abzüglich
 *      gesetzter Zahlen in Zeile, Spalte und 3x3-Block) erstellen.
 *    - false zurückgeben, wenn eine leere Kandidatenmenge entsteht (Widerspruch).
 * 2. boolean nackterEinerEintragen()
 *    - Zelle mit genau 1 Kandidaten finden, in BekannteZahl umwandeln, true zurückgeben.
 * 3. boolean versteckterEinerEintragen()
 *    - Ziffer finden, die in einer Zeile/Spalte/Block nur in genau 1 Zelle vorkommt.
 * 4. Point getPositionVonKleinsterKandidatenmenge()
 *    - Zelle mit der kleinsten Kandidatenmenge als new Point(x, y) zurückgeben (oder null).
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public class SudokuGitter
{
    /**
     * Die einzelnen Felder des Gitters
     * Erster Index = x-Koordinate
     * Zweiter Index = y-Koordinate
     */
    private Eintrag[][] felder;

    /**
     * Verweist auf das Fenster, in dem das Gitter dargestellt wird 
     */
    private SudokuFrame theFrame;

    /**
     * Erzeugt ein neues Gitter mit dem RÃ¤tsel Nr. 100
     */
    public SudokuGitter()
    {
        this(100);
    }

    /**
     * Erzeugt ein neues Gitter mit dem RÃ¤tsel Nr. 100
     * @param nummer Die Nummer des Spiels
     */
    public SudokuGitter(int nummer)
    {
        this(SudokuRaetselDB.getRaetsel(nummer));
    }

    /**
     * Erzeugt ein neues Gitter mit durch den String beschriebenen Spiel
     * @param spiel Eine String-Codierung des Spiels
     */
    public SudokuGitter(String spiel)
    {
        this(spiel, null);
    }

    /**
     * Erzeugt ein neues Gitter als Kopie eines anderen Gitters
     * @param vorlage Die Vorlage fÃ¼r das neue Gitter
     */
    private SudokuGitter(SudokuGitter vorlage)
    {
        this(vorlage.toString(), vorlage.theFrame);
    }

    /**
     * Erzeugt ein neues Gitter mit durch den String beschriebenen Spiel
     * @param spiel Eine String-Codierung des Spiels
     * @param parent Das Ã¼bergeordnete Fenster des neu erzeugten Fensters (kann auch null sein)
     */
    private SudokuGitter(String spiel, SudokuFrame parent)
    {
        felder = new Eintrag[9][9];
        char[] cSpiel = spiel.toCharArray();
        for (int i = 0; i < 9; i++)
        {
            for (int j = 0; j < 9; j++)
            {
                if (cSpiel[9*j+i] != '.')
                {
                    felder[i][j] = new BekannteZahl(Integer.parseInt(""+cSpiel[9*j+i]));
                }
            }
        }
        theFrame = new SudokuFrame(this, parent);
    }

    /**
     * Erzeugt einen Klon des aktuellen Gitters und setzt eine Zelle auf einen bestimmten Wert
     * @param x Die x-Koordinate des zu setzenden Feldes
     * @param y Die y-Koordinate des zu setzenden Feldes
     * @param wert Der zu setzende Wert
     * @return Die Kopie des Gitters
     */
    public SudokuGitter klonErzeugen(int x, int y, int wert)
    {
        SudokuGitter sp = new SudokuGitter(this);
        BekannteZahl raten = new BekannteZahl(wert);
        raten.setMarkiert();
        sp.felder[x][y] = raten;
        sp.theFrame.setTitle("Sudokus lÃ¶sen: Versuch (" + x + "," + y + ") <- " + wert);
        return sp;
    }

    /**
     * Wandelt das Gitter in seine String-Darstellung um
     * @return Eine String-Darstellung des Gitters
     */
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        for (int y = 0; y < 9; y++)
        {
            for (int x = 0; x < 9; x++)
            {
                if (felder[x][y] instanceof BekannteZahl)
                {
                    sb.append(""+((BekannteZahl)felder[x][y]).getZahl());
                }
                else
                {
                    sb.append(".");
                }
            }
        }
        return sb.toString();
    }

    /**
     * PrÃ¼ft, ob das Spiel gelÃ¶st ist
     * @return true, wenn das Spiel gelÃ¶st ist; false sonst
     */
    public boolean istGeloest()
    {
        for (int i = 0; i < 9; i++)
        {
            for (int j = 0; j < 9; j++)
            {
                if (!(felder[i][j] instanceof BekannteZahl))
                {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * TrÃ¤gt eine Zahl ins Gitter ein, wenn es mÃ¶glich ist. Wenn ja, lÃ¶scht es alle Kandidatenmengen aus dem Gitter
     * @return true, wenn eine Eintragung mÃ¶glich war; false sonst
     */
    public boolean eintragen()
    {
        boolean ergebnis = nackterEinerEintragen();
        if (!ergebnis)
        {
            ergebnis = versteckterEinerEintragen();
        }
        if (ergebnis)
        {
            for (int i = 0; i < 9; i++)
            {
                for (int j = 0; j < 9; j++)
                {
                    if (felder[i][j] instanceof Kandidatenmenge)
                    {
                        felder[i][j] = null;
                    }
                }
            }            
        }
        return ergebnis;
    }

    /**
     * Gibt den Eintrag an der gewÃ¼nschten Koordinate zurÃ¼ck
     * @param x Die x-Koordinate des Eintrags (0 bis 8)
     * @param y Die y-Koordinate des Eintrags (0 bis 8)
     * @return Der Eintrag an der gewÃ¼nschten Koordinate
     */
    public Eintrag getEintrag(int x, int y)
    {
        return felder[x][y];
    }

    /**
     * Gibt alle EintrÃ¤ge der gewÃ¼nschten Zeile zurÃ¼ck
     * @param z Die Nummer der Zeile (0 bis 8)
     * @return Ein Array mit allen EintrÃ¤gen der Zeile
     */
    private Eintrag[] getZeile(int z)
    {
        return getZeile(z, null);
    }

    /**
     * Gibt alle EintrÃ¤ge der gewÃ¼nschten Zeile zurÃ¼ck, die einem PrÃ¤dikat entsprechen
     * @param z Die Nummer der Zeile (0 bis 8)
     * @param pred Das PrÃ¤dikat, mit dem die EintrÃ¤ge geprÃ¼ft werden sollen; null fÃ¼r alle EintrÃ¤ge
     * @return Ein Array mit allen EintrÃ¤gen der Zeile, die dem PrÃ¤dikat entsprechen
     */
    private Eintrag[] getZeile(int z, Predicate<Eintrag> pred)
    {
        ArrayList<Eintrag> a = new ArrayList<Eintrag>();
        for (int i = 0; i < 9; i++)
        {
            if (pred == null || pred.test(felder[i][z]))
                a.add(felder[i][z]);
        }
        return a.toArray(new Eintrag[0]);
    }

    /**
     * Gibt alle EintrÃ¤ge der gewÃ¼nschten Spalte zurÃ¼ck
     * @param s Die Nummer der Spalte (0 bis 8)
     * @return Ein Array mit allen EintrÃ¤gen der Spalte
     */
    private Eintrag[] getSpalte(int s)
    {
        return getSpalte(s, null);
    }

    /**
     * Gibt alle EintrÃ¤ge der gewÃ¼nschten Spalte zurÃ¼ck, die einem PrÃ¤dikat entsprechen
     * @param s Die Nummer der Spalte (0 bis 8)
     * @param pred Das PrÃ¤dikat, mit dem die EintrÃ¤ge geprÃ¼ft werden sollen; null fÃ¼r alle EintrÃ¤ge
     * @return Ein Array mit allen EintrÃ¤gen der Spalte, die dem PrÃ¤dikat entsprechen
     */
    private Eintrag[] getSpalte(int s, Predicate<Eintrag> pred)
    {
        ArrayList<Eintrag> a = new ArrayList<Eintrag>();
        for (int i = 0; i < 9; i++)
        {
            if (pred == null || pred.test(felder[s][i]))
                a.add(felder[s][i]);
        }
        return a.toArray(new Eintrag[0]);
    }

    /**
     * Gibt alle EintrÃ¤ge des Blocks zurÃ¼ck, in dem die Zelle (x,y) liegt
     * @param x Die x-Koordinate der Zelle (0 bis 8)
     * @param y Die y-Koordinate der Zelle (0 bis 8)
     * @return Ein Array mit allen EintrÃ¤gen des Blocks
     */
    private Eintrag[] getBlockVon(int x, int y)
    {
        return getBlockVon(x, y, null);
    }

    /**
     * Gibt alle EintrÃ¤ge des Blocks zurÃ¼ck, in dem die Zelle (x,y) liegt, sonfern diese einem PrÃ¤dikat entsprechen
     * @param x Die x-Koordinate der Zelle (0 bis 8)
     * @param y Die y-Koordinate der Zelle (0 bis 8)
     * @return Ein Array mit allen EintrÃ¤gen des Blocks, die dem PrÃ¤dikat entsprechen
     */
    private Eintrag[] getBlockVon(int x, int y, Predicate<Eintrag> pred)
    {
        ArrayList<Eintrag> a = new ArrayList<Eintrag>();
        int xs = (x/3)*3;
        int ys = (y/3)*3;
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                if (pred == null || pred.test(felder[xs+i][ys+j]))
                    a.add(felder[xs+i][ys+j]);
            }
        }
        return a.toArray(new Eintrag[0]);
    }

    /**
     * TrÃ¤gt in allen Zellen des Gitters, an denen bisher null steht, die Kandidatenmenge ein
     * @return true, wenn alle Kandidatenmengen nichtleer sind; false sonst
     */
    public boolean kandidatenMengenErstellen()
    {
        //# TODO: Vervollständigen Sie die Methode.
        //#       Sie soll an alle Stellen im zweidimensionalen Array felder, die derzeit null enthalten, eine Kandidatenmenge setzen.
        //#       Falls eine der Kandidatenmengen leer ist, soll false zurückgegeben werden, andernfalls true.
        return true;
    }

    /**
     * Trägt eine Zahl nach der "Nackter Einer"-Technik ins Gitter ein.
     * @return true, wenn eine solche Eintragung möglich war; false sonst
     */
    private boolean nackterEinerEintragen()
    {
        //# TODO: Vervollständigen Sie die Methode.
        //#       Sie soll einen (!) Eintragungsschritt nach der "Nackter Einer"-Technik machen 
        //#       und true zurückgeben, wenn das Eintragen möglich war. Andernfalls soll false zurückgeliefert werden.
        //#       Es ist wirklich wichtig, dass Sie immer nur einen Eintragungsschritt machen, da sonst falsche Ergebnisse entstehen können.
        //#       Zum Eintragen erzeugen Sie ein neues Objekt vom Typ BekannteZahl mit der entsprechenden Ziffer als Parameter und 
        //#       tragen Sie es in das zweidimensionale Array felder ein.
        
        return false;
    }
    
    /**
     * Trägt eine Zahl nach der "Versteckter Einer"-Technik ins Gitter ein.
     * @return true, wenn eine solche Eintragung möglich war; false sonst
     */
    private boolean versteckterEinerEintragen()
    {
        //# TODO: Vervollständigen Sie die Methode.
        //#       Sie soll einen (!) Eintragungsschritt nach der "Versteckter Einer"-Technik machen 
        //#       und true zurückgeben, wenn das Eintragen möglich war. Andernfalls soll false zurückgeliefert werden.
        //#       Es ist wirklich wichtig, dass Sie immer nur einen Eintragungsschritt machen, da sonst falsche Ergebnisse entstehen können.
        //#       Zum Eintragen erzeugen Sie ein neues Objekt vom Typ BekannteZahl mit der entsprechenden Ziffer als Parameter und 
        //#       tragen Sie es in das zweidimensionale Array felder ein.
        
        return false;
    }

    /**
     * Sucht die kleinste Kandidatenmenge im Gitter und gibt ihre Koordinaten als Point zurück
     * @return Die Koordinaten der kleinsten Kandidatenmenge; null, wenn keine Kandidatenmenge im Gitter steht
     */
    public Point getPositionVonKleinsterKandidatenmenge()
    {
        Point p = null;
        //# TODO: Vervollständigen Sie diese Methode. 
        //#       Sie gibt die Position der Kandidatenmenge zurück, die die wenigsten Werte enthält.
        //#       Der x-Wert des Point-Objekts ist die erste Koordinate im zweidimensionalen Array felder, der y-Wert die zweite.
        //#       Beispiel zum Erzeugen eines Point: p = new Point(spalte, zeile);
        //#       Falls kein Eintrag in felder eine Kandidatenmenge ist, soll null zurückgegeben werden.
        //#       Dies ist der Fall, wenn das Rätsel gelöst ist.

        return p;
    }
}




