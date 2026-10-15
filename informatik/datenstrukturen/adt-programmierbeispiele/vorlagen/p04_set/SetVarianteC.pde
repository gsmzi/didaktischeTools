import java.util.ArrayList;

/**
 * Set-Variante C (Schülervorlage): Bitset-Mengen-Implementation.
 * 
 * Jedes Element in der ArrayList speichert 32 Elemente (Wortlänge eines Java-Integers).
 * Bietet extrem schnelle Mengenoperationen über bitweise Arithmetik (AND, OR, NOT).
 * Unterstützt nur nicht-negative Werte (>= 0).
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * - Set differenz(Set s):
 *   Bitweise Differenz: wordA & ~wordB
 * - boolean untermenge(Set s):
 *   Bitweise Teilmengenprüfung: (wordThis & ~wordS) == 0
 * - Set vereinigungsmenge(Set s):
 *   Bitweise Vereinigung: wordA | wordB
 * - Set schnittmenge(Set s):
 *   Bitweise Schnittmenge: wordA & wordB
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class SetVarianteC extends Set
{
    private ArrayList<Integer> daten;

    /**
     * Erzeugt ein neues leeres Set.
     */
    SetVarianteC()
    {
        daten = new ArrayList<Integer>();
    }
    
    public int[] alsArray()
    {
        int[] ergebnis = new int[anzahl()];
        int index = 0;
        for (int i = 0; i < 32 * daten.size(); i++)
        {
            if (enthaelt(i))
            {
                ergebnis[index] = i;
                index++;
            }
        }
        return ergebnis;
    }

    /**
     * Gibt zurück, ob die Menge kein Element enthält.
     */
    boolean istLeer()
    {
        for (int v : daten)
        {
            if (v != 0)
            {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Gibt zurück, ob ein bestimmter Wert in der Menge enthalten ist.
     */
    boolean enthaelt(int x)
    {
        if (x >= 32 * daten.size() || x < 0)
        {
            return false;
        }
        int i = x / 32;
        int j = x % 32;
        int mask = 1 << j;
        return (daten.get(i) & mask) != 0;
    }
    
    /**
     * Gibt die Mächtigkeit der Menge zurück.
     */
    int anzahl()
    {
        int laenge = 0;
        for (int i : daten)
        {
            laenge += Integer.bitCount(i);
        }
        return laenge;
    }
    
    /**
     * Bestimmt die Differenzmenge der Menge selbst und der Menge s.
     */
    Set differenz(Set s)
    {
        SetVarianteC ergebnis = new SetVarianteC();
        if (s instanceof SetVarianteC)
        {
            SetVarianteC bs = (SetVarianteC)s;
            //# TODO
            // Führe die Differenzmenge (this \ s) bitweise durch.
            // Verwende das bitweise UND und das bitweise NICHT (& und ~) für die Indizes 
            // im gemeinsamen Längenbereich. Vergiss nicht, eventuell überstehende Elemente 
            // dieser Menge (falls diese länger ist) ebenfalls zu übernehmen.
            
        }
        else
        {
            //# TODO
            // Fallback für andere Set-Typen:
            // Überprüfe alle potenziellen Werte (0 bis 32*daten.size()-1) einzeln.
            
        }
        return ergebnis;
    }
    
    /**
     * Fügt einen neuen Wert in die Menge ein, falls er nicht bereits enthalten ist.
     */
    void einfuegen(int x)
    {
        if (x >= 0)
        {
            int i = x / 32;
            daten.ensureCapacity(i + 1);
            while(i >= daten.size())
            {
                daten.add(0);
            }
            int j = x % 32;
            int mask = 1 << j;
            daten.set(i, daten.get(i) | mask);
        }
    }
    
    /**
     * Gibt zurück, ob diese Menge eine Untermenge der Menge s ist.
     */
    boolean untermenge(Set s)
    {
        if (s instanceof SetVarianteC)
        {
            SetVarianteC bs = (SetVarianteC)s;
            //# TODO
            // Prüfe bitweise, ob diese Menge eine Untermenge von s ist.
            // Wenn (a & ~b) != 0 für irgendein Wort, dann ist a keine Untermenge von b.
            // Überprüfe auch, ob eventuelle überstehende Wörter dieser Menge ungleich 0 sind.
            
            return false;
        }
        else
        {
            //# TODO
            // Fallback für andere Set-Typen:
            // Überprüfe alle Werte einzeln.
            
            return false;
        }
    }
    
    /**
     * Bestimmt die Vereinigungsmenge der Menge selbst und der Menge s.
     */
    Set vereinigungsmenge(Set s)
    {
        SetVarianteC ergebnis = new SetVarianteC();
        if (s instanceof SetVarianteC)
        {
            SetVarianteC bs = (SetVarianteC)s;
            //# TODO
            // Führe die Vereinigung bitweise durch.
            // Verwende das bitweise ODER (|) für den gemeinsamen Längenbereich.
            // Übernehme anschließend alle überstehenden Teile von 'daten' oder 'bs.daten'.
            
        }
        else
        {
            //# TODO
            // Fallback für andere Set-Typen:
            // Kopiere alle Elemente dieser Menge in 'ergebnis' und füge alle Elemente aus s ein.
            
        }
        return ergebnis;
    }
    
    /**
     * Bestimmt die Schnittmenge der Menge selbst und der Menge s.
     */
    Set schnittmenge(Set s)
    {
        SetVarianteC ergebnis = new SetVarianteC();
        if (s instanceof SetVarianteC)
        {
            SetVarianteC bs = (SetVarianteC)s;
            //# TODO
            // Führe die Schnittmenge bitweise durch.
            // Verwende das bitweise UND (&) für den gemeinsamen Längenbereich.
            
        }
        else
        {
            //# TODO
            // Fallback für andere Set-Typen:
            // Prüfe für alle Indizes, ob sie in beiden Sets enthalten sind.
            
        }
        return ergebnis;
    }
    
    /**
     * Entfernt einen Wert aus der Menge, falls er enthalten ist.
     */
    void entfernen(int x)
    {
        if (x < 32 * daten.size() && x >= 0)
        {
            int i = x / 32;
            int j = x % 32;
            int mask = ~(1 << j);
            daten.set(i, daten.get(i) & mask);
        }
    }
    
    /**
     * Gibt zurück, ob diese Menge und s die gleichen Elemente enthalten.
     */
    boolean gleich(Set s)
    {
        if (s instanceof SetVarianteC)
        {
            SetVarianteC bs = (SetVarianteC)s;
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                if (daten.get(i) != bs.daten.get(i))
                {
                    return false;
                }
            }
            for (int i = daten.size(); i < bs.daten.size(); i++)
            {
                if (bs.daten.get(i) != 0)
                {
                    return false;
                }
            }
            for (int i = bs.daten.size(); i < daten.size(); i++)
            {
                if (daten.get(i) != 0)
                {
                    return false;
                }
            }
            return true;
        }
        else
        {
            return super.gleich(s);
        }
    }
    
    /**
     * Didaktischer Getter für den Internals-Viewer im GUI
     */
    public ArrayList<Integer> getBitWords()
    {
        return daten;
    }
}
