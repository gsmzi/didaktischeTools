import java.util.ArrayList;

/**
 * Eine Set basierend auf Bitvektoren
 * 
 * @author Rainer Helfrich
 * @version September 2026
 */
public class BitSet extends Set
{
    private ArrayList<Integer> daten;

    /**
     * Erzeugt eine neue leere Set
     */
    public BitSet()
    {
        daten = new ArrayList<Integer>();
    }

    protected int[] alsArray()
    {
        int[] ergebnis = new int[anzahl()];
        int index = 0;
        for (int i = 0; i < 32*daten.size(); i++)
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
     * Gibt zurÃ¼ck, ob die Menge kein Element enthÃ¤lt
     * @return true, wenn die Menge leer ist; false sonst
     */
    public boolean istLeer()
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
     * Gibt zurÃ¼ck, ob ein bestimmter Wert in der Menge enthalten ist.
     * @param wert Der zu suchende Wert
     */
    public boolean enthaelt(int x)
    {
        if (x >= 32*daten.size() || x < 0)
        {
            return false;
        }
        int i = x / 32;
        int j = x % 32;
        int mask = 1 << j;
        return (daten.get(i) & mask) != 0;
    }

    /**
     * Gibt die MÃ¤chtigkeit der Menge zurÃ¼ck
     * @return Die Anzahl der Elemente in der Menge
     */
    public int anzahl()
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
     * @param s Die Menge, die von dieser Menge abgezogen werden soll.
     * @return Eine neue Set, die alle Elemente dieser Menge enthÃ¤lt, die nicht in s enthalten sind.
     */
    public Set differenz(Set s)
    {
        BitSet ergebnis = new BitSet();
        if (s instanceof BitSet)
        {
            BitSet bs = (BitSet)s;
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                ergebnis.daten.add(daten.get(i) & ~(bs.daten.get(i)));
            }
            for (int i = bs.daten.size(); i < daten.size(); i++)
            {
                ergebnis.daten.add(daten.get(i));
            }
        }
        else
        {
            for (int i = 0; i < 32*daten.size(); i++)
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
     * FÃ¼gt einen neuen Wert in die Menge ein, falls er nicht bereits enthalten ist.
     * @param wert Der einzufÃ¼gende Wert
     */
    public void einfuegen(int x)
    {
        if (x >= 0)
        {
            int i = x / 32;
            daten.ensureCapacity(i+1);
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
     * Gibt zurÃ¼ck, ob diese Menge eine Untermenge der Menge s ist.
     * @param s Die Menge, die geprÃ¼ft werden soll.
     * @return true, wenn jedes Element dieser Menge in s enthalten ist; false sonst
     */
    public boolean untermenge(Set s)
    {
        if (s instanceof BitSet)
        {
            BitSet bs = (BitSet)s;
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
            for (int i = 0; i < 32*daten.size(); i++)
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
     * @param s Die Menge, mit der die Vereinigungsmenge bestimmt werden soll
     * @return Eine neue Set, die die Vereinigungsmenge der beiden Mengen reprÃ¤sentiert.
     */
    public Set vereinigungsmenge(Set s)
    {
        BitSet ergebnis = new BitSet();
        if (s instanceof BitSet)
        {
            BitSet bs = (BitSet)s;
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
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
     * @param s Die Menge, mit der die Schnittmenge bestimmt werden soll
     * @return Eine neue Set, die die Schnittmenge der beiden Mengen reprÃ¤sentiert.
     */
    public Set schnittmenge(Set s)
    {
        BitSet ergebnis = new BitSet();
        if (s instanceof BitSet)
        {
            BitSet bs = (BitSet)s;
            for (int i = 0; i < Math.min(daten.size(), bs.daten.size()); i++)
            {
                ergebnis.daten.add(daten.get(i) & bs.daten.get(i));
            }
        }
        else
        {
            for (int i = 0; i < 32*daten.size(); i++)
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
     * @param wert Der zu entfernende Wert
     */
    public void entfernen(int x)
    {
        if (x < 32*daten.size() && x >= 0)
        {
            int i = x / 32;
            int j = x % 32;
            int mask = ~(1 << j);
            daten.set(i, daten.get(i) & mask);
        }
    }

    /**
     * Gibt zurÃ¼ck, ob diese Menge und s die gleichen Elemente enthalten
     * @param s Die zu Ã¼berprÃ¼fende Menge
     * @return true, wenn beide Mengen die gleichen Elemente enthalten; false sonst
     */
    public boolean gleich(Set s)
    {
        if (s instanceof BitSet)
        {
            BitSet bs = (BitSet)s;
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
}




