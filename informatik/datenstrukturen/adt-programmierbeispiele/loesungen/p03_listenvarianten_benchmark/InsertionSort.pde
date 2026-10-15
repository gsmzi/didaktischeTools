/**
 * Sortiert eine Liste nach dem InsertionSort-Algorithmus.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class InsertionSort extends SortierenMitBenchmark
{
    /**
     * Erzeugt eine neue Testklasse für die übergebene Liste
     * @param l Die Liste, die gefüllt und sortiert werden soll
     */
    InsertionSort(Liste<Integer> l)
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
            int value = l.getNtenWert(0);
            l.entferneBei(0);
            
            int index = 0;
            int laenge = out.laenge();
            while(index < laenge && out.getNtenWert(index) < value)
            {
                index++;
            }
            out.einfuegenBei(index, value);                
        }            
        return out;
    }
}
