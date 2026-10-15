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
        
        //# TODO
        // Implementiere das Aufteilen und Zusammenführen (Merge) für MergeSort.
        // 1. Teile die Liste l in zwei Hälften (links und rechts). Hänge dazu die erste Hälfte der Elemente an 'links' an und entferne sie aus 'l'.
        //    Danach ist 'links' die erste Hälfte und 'rechts' (die ursprüngliche Liste l) enthält den Rest.
        // 2. Rufe sortiere(links) und sortiere(rechts) rekursiv auf und speichere die Ergebnisse.
        // 3. Führe die beiden sortierten Listen wieder in einer neuen Liste 'out' (vom Typ c) zusammen.
        //    Vergleiche dabei immer die ersten Elemente der beiden Listen.
        // 4. Hänge verbleibende Elemente der beiden Teillisten an 'out' an.
        
        Liste<Integer> out = l.neueInstanz();
        return out;
    }
}
