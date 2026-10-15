import java.util.ArrayList;

/**
 * Set-Variante C: Bitset-Mengen-Implementation.
 * 
 * Jedes Element in der ArrayList speichert 32 Elemente (Wortlänge eines Java-Integers).
 * Bietet extrem schnelle Mengenoperationen über bitweise Arithmetik (AND, OR, NOT).
 * Unterstützt nur nicht-negative Werte (>= 0).
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
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                // Bitweises AND NOT
                ergebnis.daten.add(daten.get(i) & ~(bs.daten.get(i)));
            }
            for (int i = bs.daten.size(); i < daten.size(); i++)
            {
                ergebnis.daten.add(daten.get(i));
            }
        }
        else
        {
            for (int i = 0; i < 32 * daten.size(); i++)
            {
                if (enthaelt(i) && !s.enthaelt(i))
                {
                    ergebnis.einfuegen(i);
                }
            }
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
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                int a = daten.get(i);
                int b = bs.daten.get(i);
                if ((a & ~b) != 0)
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
            for (int i = 0; i < 32 * daten.size(); i++)
            {
                if (enthaelt(i) && !s.enthaelt(i))
                {
                    return false;
                }
            }
            return true;
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
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                // Bitweises OR
                ergebnis.daten.add(daten.get(i) | bs.daten.get(i));
            }
            for (int i = daten.size(); i < bs.daten.size(); i++)
            {
                ergebnis.daten.add(bs.daten.get(i));
            }
            for (int i = bs.daten.size(); i < daten.size(); i++)
            {
                ergebnis.daten.add(daten.get(i));
            }
        }
        else
        {
            int[] a = s.alsArray();
            ergebnis.daten.addAll(daten);
            for (int n : a)
            {
                ergebnis.einfuegen(n);
            }
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
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                // Bitweises AND
                ergebnis.daten.add(daten.get(i) & bs.daten.get(i));
            }
        }
        else
        {
            for (int i = 0; i < 32 * daten.size(); i++)
            {
                if (enthaelt(i) && s.enthaelt(i))
                {
                    ergebnis.einfuegen(i);
                }
            }
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
