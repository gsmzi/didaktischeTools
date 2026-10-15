/**
 * Sortiert eine Liste nach dem MergeSort-Algorithmus.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class MergeSort extends SortierenMitBenchmark
{
    /**
     * Erzeugt eine neue Testklasse für die übergebene Liste
     * @param l Die Liste, die gefüllt und sortiert werden soll
     */
    MergeSort(Liste<Integer> l)
    {
        super(l);
    }

    /**
     * Gibt eine (ggf. neue) Liste zurück, die die Zahlen der Eingabeliste in sortierter Reihenfolge enthält.
     */
    protected Liste<Integer> sortiere(Liste<Integer> l)
    {
        if (l.laenge() <= 1)
        {
            return l;
        }
        
        Liste<Integer> links = l.neueInstanz();
        int laenge = l.laenge();
        for (int i = 0; i < laenge/2; i++)
        {
            links.anhaengen(l.getNtenWert(0));
            l.entferneBei(0);
        }
        
        Liste<Integer> rechts = l;
        
        // Rekursive Aufteilungen
        links = sortiere(links);
        rechts = sortiere(rechts);
        
        // Zusammenführen (Merge)
        Liste<Integer> out = l.neueInstanz();
        while(!links.istLeer() && !rechts.istLeer())
        {
            int lw = links.getNtenWert(0);
            int rw = rechts.getNtenWert(0);
            if (lw < rw)
            {
                out.anhaengen(lw);
                links.entferneBei(0);
            }
            else
            {
                out.anhaengen(rw);
                rechts.entferneBei(0);
            }
        }
        
        while(!links.istLeer())
        {
            out.anhaengen(links.getNtenWert(0));
            links.entferneBei(0);
        }
        
        while(!rechts.istLeer())
        {
            out.anhaengen(rechts.getNtenWert(0));
            rechts.entferneBei(0);
        }
        
        return out;
    }
}
