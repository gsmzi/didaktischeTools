/**
 * Sortiert eine Liste nach dem SelectionSort-Algorithmus.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class SelectionSort extends SortierenMitBenchmark
{
    /**
     * Erzeugt eine neue Testklasse für die übergebene Liste
     * @param l Die Liste, die gefüllt und sortiert werden soll
     */
    SelectionSort(Liste<Integer> l)
    {
        super(l);
    }

    /**
     * Gibt eine Liste zurück, die die Zahlen der Eingabeliste in sortierter Reihenfolge enthält.
     */
    protected Liste<Integer> sortiere(Liste<Integer> l)
    {
        // Erstelle eine neue leere Ausgabeliste desselben Typs
        Liste<Integer> out = l.neueInstanz();
        
        while(!l.istLeer())
        {
            int minIndex = 0;
            int minValue = l.getNtenWert(0);
            int laenge = l.laenge();
            for (int i = 1; i < laenge; i++)
            {
                int v = l.getNtenWert(i);
                if (v < minValue)
                {
                    minValue = v;
                    minIndex = i;
                }
            }
            out.anhaengen(minValue);
            l.entferneBei(minIndex);
        }            
        return out;
    }
}
