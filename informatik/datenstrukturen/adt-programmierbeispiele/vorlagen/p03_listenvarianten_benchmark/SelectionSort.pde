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
        
        //# TODO
        // Sortiere die Elemente aus l nach dem SelectionSort-Verfahren in out.
        // Solange l nicht leer ist:
        // 1. Suche den kleinsten Wert in der verbleibenden Liste 'l' und merke dir seinen Wert und Index.
        // 2. Hänge diesen kleinsten Wert hinten an 'out' an.
        // 3. Entferne den Wert an seinem ursprünglichen Index aus 'l'.
        
        return out;
    }
}
