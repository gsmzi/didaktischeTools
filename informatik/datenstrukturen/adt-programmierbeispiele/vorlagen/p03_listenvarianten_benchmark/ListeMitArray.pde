/**
 * Klasse ListeMitArray (Schülervorlage)
 * 
 * Eine ArrayList-artige Listenimplementation (mit Benchmark-Zählern).
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. void einfuegenBei(int index, T val)
 *    - Elemente ab Index nach rechts schieben, um Platz zu schaffen.
 *    - Benchmark-Zähler leseZugriffe und schreibZugriffe pflegen.
 * 2. void entferneBei(int index)
 *    - Elemente ab Index + 1 nach links schieben, um die Lücke zu schließen.
 *    - Benchmark-Zähler leseZugriffe und schreibZugriffe pflegen.
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeMitArray<T> extends Liste<T>
{
    /**
     * Das Array, das die Nutzdaten speichert
     */
    private Object[] daten;
    
    /**
     * Zähler, der angibt, wie viele der Werte im Array gültig sind
     */
    private int anzahl;

    /**
     * Erzeugt eine neue Liste
     */
    ListeMitArray()
    {
        daten = new Object[10];
        anzahl = 0;
    }
    
    Liste<T> neueInstanz()
    {
        return new ListeMitArray<T>();
    }
    
    /**
     * Gibt die Anzahl der Elemente der Liste zurück
     */
    int laenge()
    {
        // Ein Lesezugriff auf das Größenfeld
        leseZugriffe++;
        return anzahl;
    }
    
    /**
     * Gibt die Listenelemente hintereinander auf der Konsole aus.
     */
    void ausgeben()
    {
        for (int i = 0; i < anzahl; i++)
        {   
            print(daten[i] + " ");
        } 
        println();
    }
    
    /**
     * Fügt einen neuen Wert an einer gewünschten Stelle in der Liste ein.
     */
    void einfuegenBei(int index, T val)
    {
        if (index >= 0 && index <= anzahl)
        {
            groessePruefen();
            
            // Jede Verschiebung ist ein Lesen und ein Schreiben
            // Bitte die Benchmark-Zähler leseZugriffe und schreibZugriffe entsprechend erhöhen.
            
            //# TODO
            // Verschiebe Elemente nach rechts, um Platz für das neue Element zu schaffen.
            
            daten[index] = val;
            schreibZugriffe++;
            anzahl++;
        }
    }
    
    /**
     * Hängt einen neuen Wert hinten an die Liste an.
     */
    void anhaengen(T val)
    {
        einfuegenBei(anzahl, val);
    }
    
    /**
     * Gibt den n-ten Wert (0-basierte Zählweise) der Liste zurück.
     */
    T getNtenWert(int n)
    {
        if (n >= 0 && n < anzahl)
        {
            leseZugriffe++; // Array-Zellzugriff
            return (T)daten[n];
        }
        return null;
    }
    
    /**
     * Prüft die Array-Größe und verdoppelt sie bei Bedarf.
     */
    private void groessePruefen()
    {
        if (anzahl >= daten.length)
        {
            Object[] tmp = new Object[daten.length * 2];
            System.arraycopy(daten, 0, tmp, 0, anzahl);
            
            // Kopierkosten für Benchmark erfassen
            leseZugriffe += anzahl;
            schreibZugriffe += anzahl;
            
            daten = tmp;
        }
    }
    
    /**
     * Entfernt das Element, das am gegebenen Index steht, aus der Liste.
     */
    void entferneBei(int index)
    {
        if (index >= 0 && index < anzahl)
        {
            // Verschiebe Elemente nach links
            // Bitte die Benchmark-Zähler leseZugriffe und schreibZugriffe entsprechend erhöhen.
            
            //# TODO
            // Verschiebe alle Elemente ab index+1 um eine Position nach links, um die Lücke zu schließen.
            
            anzahl--;
            daten[anzahl] = null; // Speicher freigeben
            schreibZugriffe++;
        }
    }
        
    /**
     * Gibt zurück, ob ein Wert sich in der Liste befindet
     */
    boolean enthaelt(T val)
    {
        for (int i = 0; i < anzahl; i++)
        {
            leseZugriffe++;
            if (daten[i] != null && daten[i].equals(val))
            {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Gibt zurück, ob die Liste leer ist.
     */
    boolean istLeer()
    {
        return anzahl == 0;
    }
}
