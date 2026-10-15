import java.util.ArrayList;
import java.util.function.Predicate; 
import java.awt.Point;

/**
 * ReprÃ¤sentiert ein 9x9-Sudoku-Gitter
 * 
 * @author Rainer Helfrich
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
     * Sucht die kleinste Kandidatenmenge im Gitter und gibt ihre Koordinaten als Point zurÃ¼ck
     * @return Die Koordinaten der kleinsten Kandidatenmenge; null, wenn keine Kandidatenmenge im Gitter steht
     */
    public Point getPositionVonKleinsterKandidatenmenge()
    {
        int min = 10;
        Point p = null;
        for (int y = 0; y < 9; y++)
        {
            for (int x = 0; x < 9; x++)
            {
                if (felder[x][y] instanceof Kandidatenmenge)
                {
                    Kandidatenmenge km = (Kandidatenmenge)felder[x][y];
                    if (km.anzahl() == 2) // besser kann es nicht werden
                    {
                        return new Point(x,y);
                    }
                    if (km.anzahl() < min)
                    {
                        min = km.anzahl();
                        p = new Point(x,y);
                    }
                }
            }
        }
        return p;
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
     * TrÃ¤gt eine Zahl nach der "Nackter Einer"-Technik ins Gitter ein.
     * @return true, wenn eine solche Eintragung mÃ¶glich war; false sonst
     */
    private boolean nackterEinerEintragen()
    {
        for (int i = 0; i < 9; i++)
        {
            for (int j = 0; j < 9; j++)
            {
                if (felder[i][j] instanceof Kandidatenmenge)
                {
                    Kandidatenmenge kl = (Kandidatenmenge)felder[i][j];
                    if (kl.anzahl() == 1)
                    {
                        int wert = kl.alsArray()[0];
                        felder[i][j] = new BekannteZahl(wert);
                        System.out.println("Schreibe " + wert + " an Stelle (" + i + "," + j + "), nackter Einer");
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private BekannteZahl versteckterEinerEintragen(Kandidatenmenge km, Eintrag[] andereZellen)
    {
        Set ohneAlleAnderen = km;
        for (Eintrag e : andereZellen)
        {
            ohneAlleAnderen = ohneAlleAnderen.differenz((Kandidatenmenge)e);
        }
        if (ohneAlleAnderen.anzahl() == 1)
        {
            return new BekannteZahl(ohneAlleAnderen.alsArray()[0]);
        }
        else if (ohneAlleAnderen.anzahl() > 1)
        {
            System.out.println("das dÃ¼rfte nicht sein");
        }
        return null;
    }

    /**
     * TrÃ¤gt eine Zahl nach der "Versteckter Einer"-Technik ins Gitter ein.
     * @return true, wenn eine solche Eintragung mÃ¶glich war; false sonst
     */
    private boolean versteckterEinerEintragen()
    {
        // Suche Zahl, die nur einmal in Gruppe auftritt
        for (int i = 0; i < 9; i++)
        {
            for (int j = 0; j < 9; j++)
            {
                if (felder[i][j] instanceof Kandidatenmenge)
                {
                    Kandidatenmenge km = (Kandidatenmenge)felder[i][j];
                    BekannteZahl bz = versteckterEinerEintragen(km, getZeile(j, x -> x instanceof Kandidatenmenge && x != km ));
                    if (bz != null)
                    {
                        felder[i][j] = bz;
                        System.out.println("Schreibe " + bz.getZahl() + " an Stelle (" + i + "," + j + "), versteckter Einer in Zeile");
                        return true;
                    }
                    bz = versteckterEinerEintragen(km, getSpalte(i, x -> x instanceof Kandidatenmenge && x != km ));
                    if (bz != null)
                    {
                        felder[i][j] = bz;
                        System.out.println("Schreibe " + bz.getZahl() + " an Stelle (" + i + "," + j + "), versteckter Einer in Spalte");
                        return true;
                    }
                    bz = versteckterEinerEintragen(km, getBlockVon(i, j, x -> x instanceof Kandidatenmenge && x != km));
                    if (bz != null)
                    {
                        felder[i][j] = bz;
                        System.out.println("Schreibe " + bz.getZahl() + " an Stelle (" + i + "," + j + "), versteckter Einer in Block");
                        return true;
                    }
                }
            }
        }
        return false;
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
     * TrÃ¤gt in allen Zellen des Gitters, an denen bisher null steht, die Kandidatenmenge ein
     * @return true, wenn alle Kandidatenmengen nichtleer sind; false sonst
     */
    public boolean kandidatenMengenErstellen()
    {
        boolean bLeereMenge = false;
        for (int i = 0; i < 9; i++)
        {
            Eintrag[] spalte = getSpalte(i, x -> x instanceof BekannteZahl);
            for (int j = 0; j < 9; j++)
            {
                if (felder[i][j] == null)
                {
                    Kandidatenmenge kl = new Kandidatenmenge();
                    Eintrag[] zeile = this.getZeile(j, x -> x instanceof BekannteZahl);
                    for (Eintrag e : zeile)
                    {
                        BekannteZahl bz = (BekannteZahl)e;
                        kl.entfernen(bz.getZahl());
                    }
                    for (Eintrag e : spalte)
                    {
                        BekannteZahl bz = (BekannteZahl)e;
                        kl.entfernen(bz.getZahl());
                    }
                    Eintrag[] feld = getBlockVon(i, j, x -> x instanceof BekannteZahl);
                    for (Eintrag e : feld)
                    {
                        BekannteZahl bz = (BekannteZahl)e;
                        kl.entfernen(bz.getZahl());
                    }
                    if (kl.istLeer())
                    {
                        bLeereMenge = true;
                    }
                    felder[i][j] = kl;
                }
            }
        }
        if (bLeereMenge)
        {
            return false;
        }
        boolean bAenderung = true;
        while(bAenderung)
        {
            bAenderung = false;
            for (int i = 0; i < 9; i++)
            {
                Eintrag[] bereich = getZeile(i, x -> x instanceof Kandidatenmenge);
                if (nackteZweierEliminieren(bereich))
                {
                    bAenderung = true;
                    System.out.println("... in Zeile " + i);
                    if (getZeile(i, x -> x instanceof Kandidatenmenge && ((Kandidatenmenge)x).anzahl() == 0).length > 0)
                    {
                        return false;
                    }
                }
                bereich = getSpalte(i, x -> x instanceof Kandidatenmenge);
                if (nackteZweierEliminieren(bereich))
                {
                    bAenderung = true;
                    System.out.println("... in Spalte " + i);
                    if (getSpalte(i, x -> x instanceof Kandidatenmenge && ((Kandidatenmenge)x).anzahl() == 0).length > 0)
                    {
                        return false;
                    }
                }
                int row = (i / 3)*3;
                int col = (i % 3)*3;
                bereich = getBlockVon(col, row, x -> x instanceof Kandidatenmenge);
                if (nackteZweierEliminieren(bereich))
                {
                    bAenderung = true;
                    System.out.println("... in Block (" + col + "," + row + ")");
                    if (getBlockVon(col, row, x -> x instanceof Kandidatenmenge && ((Kandidatenmenge)x).anzahl() == 0).length > 0)
                    {
                        return false;
                    }
                }
            }
        }
        return !bLeereMenge;
    }

    private boolean nackteZweierEliminieren(Eintrag[] bereich)
    {
        for (int i = 0; i < bereich.length; i++)
        {
            Kandidatenmenge a = (Kandidatenmenge)bereich[i];
            if (a.anzahl() != 2)
            {
                continue;
            }
            for (int j = i+1; j < bereich.length; j++)
            {
                Kandidatenmenge b = (Kandidatenmenge)bereich[j];
                if (b.gleich(a))
                {
                    int[] zweier = a.alsArray();
                    for (Eintrag mm : bereich)
                    {
                        Kandidatenmenge m = (Kandidatenmenge)mm;
                        if (a != m && b != m)
                        {
                            int vorher = m.anzahl();
                            m.entfernen(zweier[0]);
                            m.entfernen(zweier[1]);
                            if (m.anzahl() != vorher)
                            {
                                System.out.println("Nackter Zweier " + zweier[0] + "" + zweier[1]);
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }
}




