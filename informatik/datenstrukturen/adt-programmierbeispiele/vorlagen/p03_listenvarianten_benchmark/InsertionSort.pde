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
        
        //# TODO
        // Sortiere die Elemente aus l nach dem InsertionSort-Verfahren in out.
        // Solange l nicht leer ist:
        // 1. Nimm den Wert am Index 0 aus l.
        // 2. Finde die richtige Position (index) in der Liste 'out', so dass 'out' sortiert bleibt.
        // 3. Füge den Wert an dieser Position in 'out' ein und entferne ihn aus 'l'.
        
        return out;
    }
}
