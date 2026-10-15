import java.util.ArrayList;

/**
 * Set-Variante A: Hash-Tabelle mit Chaining (Kollisionslisten).
 * 
 * Verwendet ein Array von ArrayLists als Buckets.
 * Führt bei einem Auslastungsgrad (load factor) > 0.5 ein Rehash durch.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class SetVarianteA extends Set
{
    private ArrayList<Integer>[] daten;
    private int anzahl;

    /**
     * Erzeugt ein neues leeres Set.
     */
    SetVarianteA()
    {
        this(10);
    }

    private SetVarianteA(int capacity)
    {
        if (capacity < 10)
        {
            capacity = 10;
        }
        daten = new ArrayList[capacity * 2];
        anzahl = 0;
    }

    public int[] alsArray()
    {
        int[] ergebnis = new int[anzahl];
        int index = 0;
        for (ArrayList<Integer> l : daten)
        {
            if (l != null)
            {
                for (int x : l)
                {
                    ergebnis[index] = x;
                    index++;
                }
            }
        }
        return ergebnis;
    }

    /**
     * Gibt zurück, ob die Menge kein Element enthält.
     */
    boolean istLeer()
    {
        return anzahl == 0;
    }

    /**
     * Gibt die Mächtigkeit der Menge zurück.
     */
    int anzahl()
    {
        return anzahl;
    }

    /**
     * Bestimmt die Differenzmenge der Menge selbst und der Menge s.
     */
    Set differenz(Set s)
    {
        Set ergebnis = new SetVarianteA(anzahl);
        for (ArrayList<Integer> l : daten)
        {
            if (l != null)
            {
                for (int n : l)
                {
                    if (!s.enthaelt(n))
                    {
                        ergebnis.einfuegen(n);
                    }
                }
            }
        }
        return ergebnis;
    }

    /**
     * Gibt zurück, ob diese Menge eine Untermenge der Menge s ist.
     */
    boolean untermenge(Set s)
    {
        for (ArrayList<Integer> l : daten)
        {
            if (l != null)
            {
                for (int n : l)
                {
                    if (!s.enthaelt(n))
                    {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    /**
     * Bestimmt die Vereinigungsmenge der Menge selbst und der Menge s.
     */
    Set vereinigungsmenge(Set s)
    {
        SetVarianteA ergebnis = new SetVarianteA(s.anzahl() + anzahl());
        for (ArrayList<Integer> l : daten)
        {
            if (l != null)
            {
                for (int n : l)
                {
                    ergebnis.einfuegen(n);
                }
            }
        }
        for (int n : s.alsArray())
        {
            ergebnis.einfuegen(n);
        }
        return ergebnis;
    }

    /**
     * Fügt einen neuen Wert in die Menge ein, falls er nicht bereits enthalten ist.
     */
    void einfuegen(int n)
    {
        // Rehash bei Auslastung > 50%
        if ((double)anzahl / daten.length > 0.5)
        {
            rehash();
        }
        
        int hash = abs(n) % daten.length;
        if (daten[hash] == null)
        {
            daten[hash] = new ArrayList<Integer>(2);
        }
        if (!daten[hash].contains(n))
        {
            anzahl++;
            daten[hash].add(n);
        }
    }

    private void rehash()
    {
        ArrayList<Integer>[] tmp = new ArrayList[2 * daten.length + 1];
        for (ArrayList<Integer> l : daten)
        {
            if (l != null)
            {
                for (int n : l)
                {
                    int hash = abs(n) % tmp.length;
                    if (tmp[hash] == null)
                    {
                        tmp[hash] = new ArrayList<Integer>(2);
                    }
                    tmp[hash].add(n);
                }
            }
        }
        daten = tmp;
    }

    /**
     * Bestimmt die Schnittmenge der Menge selbst und der Menge s.
     */
    Set schnittmenge(Set s)
    {
        SetVarianteA ergebnis = new SetVarianteA(anzahl);
        for (ArrayList<Integer> l : daten)
        {
            if (l != null)
            {
                for (int n : l)
                {
                    if (s.enthaelt(n))
                    {
                        ergebnis.einfuegen(n);
                    }
                }
            }
        }
        return ergebnis;
    }

    /**
     * Gibt zurück, ob ein bestimmter Wert in der Menge enthalten ist.
     */
    boolean enthaelt(int n)
    {
        int hash = abs(n) % daten.length;
        return daten[hash] != null && daten[hash].contains(n);
    }

    /**
     * Entfernt einen Wert aus der Menge, falls er enthalten ist.
     */
    void entfernen(int n)
    {
        int hash = abs(n) % daten.length;
        if (daten[hash] != null)
        {
            if (daten[hash].contains(n))
            {
                anzahl--;
                daten[hash].remove(new Integer(n));
            }
        }
    }
    
    /**
     * Didaktischer Getter für den Internals-Viewer im GUI
     */
    public ArrayList<Integer>[] getBuckets()
    {
        return daten;
    }
}
