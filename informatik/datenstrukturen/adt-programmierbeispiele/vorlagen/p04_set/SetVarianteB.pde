import java.util.ArrayList;

/**
 * Set-Variante B (Schülervorlage): Speicherung in einer unskalierten, unsortierten ArrayList.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * - Set differenz(Set s):
 *   Fügt alle Elemente dieser Menge ein, die NICHT in s enthalten sind.
 * - boolean untermenge(Set s):
 *   Prüft, ob jedes Element dieser Menge auch in s enthalten ist.
 * - Set vereinigungsmenge(Set s):
 *   Fügt alle Elemente dieser Menge und alle Elemente aus s ein.
 * - Set schnittmenge(Set s):
 *   Fügt alle Elemente ein, die in BEIDEN Mengen enthalten sind.
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class SetVarianteB extends Set
{
    private ArrayList<Integer> daten;

    /**
     * Erzeugt ein neues leeres Set.
     */
    SetVarianteB()
    {
        daten = new ArrayList<Integer>();
    }

    /**
     * Gibt zurück, ob die Menge kein Element enthält.
     */
    boolean istLeer()
    {
        return daten.isEmpty();
    }

    /**
     * Gibt die Mächtigkeit der Menge zurück.
     */
    int anzahl()
    {
        return daten.size();
    }

    /**
     * Bestimmt die Differenzmenge der Menge selbst und der Menge s.
     */
    Set differenz(Set s)
    {
        Set ergebnis = new SetVarianteB();
        //# TODO
        // Bestimme die Differenzmenge (this \ s).
        // Füge alle Elemente aus dieser Menge in 'ergebnis' ein, die nicht in s enthalten sind.
        
        return ergebnis;
    }

    /**
     * Gibt zurück, ob diese Menge eine Untermenge der Menge s ist.
     */
    boolean untermenge(Set s)
    {
        //# TODO
        // Prüfe, ob diese Menge eine Untermenge von s ist.
        // Das ist der Fall, wenn jedes Element dieser Menge auch in s enthalten ist.
        
        return false;
    }

    /**
     * Bestimmt die Vereinigungsmenge der Menge selbst und der Menge s.
     */
    Set vereinigungsmenge(Set s)
    {
        Set ergebnis = new SetVarianteB();
        //# TODO
        // Bestimme die Vereinigungsmenge von dieser Menge und s.
        // Füge alle Elemente aus dieser Menge und alle Elemente aus s in 'ergebnis' ein.
        
        return ergebnis;
    }

    public int[] alsArray()
    {
        int[] ergebnis = new int[anzahl()];
        for (int i = 0; i < anzahl(); i++)
        {
            ergebnis[i] = daten.get(i);
        }
        return ergebnis;
    }

    /**
     * Bestimmt die Schnittmenge der Menge selbst und der Menge s.
     */
    Set schnittmenge(Set s)
    {
        Set ergebnis = new SetVarianteB();
        //# TODO
        // Bestimme die Schnittmenge von dieser Menge und s.
        // Ein Element ist in der Schnittmenge, wenn es in beiden Mengen enthalten ist.
        
        return ergebnis;
    }

    /**
     * Gibt zurück, ob ein bestimmter Wert in der Menge enthalten ist.
     */
    boolean enthaelt(int x)
    {
        return daten.contains(x);
    }

    /**
     * Entfernt einen Wert aus der Menge, falls er enthalten ist.
     */
    void entfernen(int wert)
    {
        daten.remove(new Integer(wert));
    }

    /**
     * Fügt einen neuen Wert in die Menge ein, falls er nicht bereits enthalten ist.
     */
    void einfuegen(int wert)
    {
        if (!daten.contains(wert))
        {
            daten.add(wert);
        }
    }
    
    /**
     * Didaktischer Getter für den Internals-Viewer im GUI
     */
    public ArrayList<Integer> getElements()
    {
        return daten;
    }
}
