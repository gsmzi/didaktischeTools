/**
 * Abstrakte Basisklasse für Sortieralgorithmen im Benchmark.
 * 
 * Verwaltet die zu sortierende Liste und führt Messungen von Zeit
 * und Elementzugriffen durch.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class SortierenMitBenchmark
{
    /**
     * Die zu sortierende Liste
     */
    protected Liste<Integer> liste;

    /**
     * Erzeugt eine neue Testklasse für die übergebene Liste.
     * @param l Die Liste, die gefüllt und sortiert werden soll
     */
    SortierenMitBenchmark(Liste<Integer> l)
    {
        this.liste = l;
    }

    /**
     * Gibt eine (ggf. neue) Liste zurück, die die Zahlen der Eingabeliste in sortierter Reihenfolge enthält.
     * @param l Die zu sortierende Liste; wird u.U. verändert.
     * @return Eine Liste mit den sortierten Elementen der Eingabeliste
     */
    protected abstract Liste<Integer> sortiere(Liste<Integer> l);

    /**
     * Hilfsmethode, um eine Liste zu duplizieren (Kopieren der Elemente).
     * @param l Die zu kopierende Liste
     * @return Eine Kopie der Liste (gleicher Implementierungstyp)
     */
    protected Liste<Integer> listKopieren(Liste<Integer> l)
    {
        Liste<Integer> kopie = l.neueInstanz();
        int laenge = l.laenge();
        for (int i = 0; i < laenge; i++)
        {
            kopie.anhaengen(l.getNtenWert(i));
        }
        return kopie;
    }

    /**
     * Führt den Sortier-Benchmark aus: Füllt die Liste mit Zufallswerten,
     * erstellt eine Kopie, sortiert diese und misst Zeit und Array/Knoten-Zugriffe.
     * 
     * @param anzahlElemente Die Anzahl der zu sortierenden Zufallselemente
     * @return Das BenchmarkResult mit Zeit und Zählerständen
     */
    public BenchmarkResult ausfuehren(int anzahlElemente)
    {
        // 1. Liste zurücksetzen und neu mit Zufallswerten befüllen
        while (!liste.istLeer())
        {
            liste.entferneBei(0);
        }
        
        // Zufallsgenerator mit festem Seed (didaktisch wertvoll für exakte Vergleiche!)
        randomSeed(42); 
        for (int i = 0; i < anzahlElemente; i++)
        {
            liste.anhaengen((int)random(1, 1000));
        }

        // 2. Kopie erzeugen (auf dieser wird sortiert)
        Liste<Integer> kopie = listKopieren(liste);
        if (kopie == null) return new BenchmarkResult(0, 0, 0);
        
        // Zähler auf der Kopie vor dem Sortieren nullen
        kopie.resetCounters();

        // 3. Sortierung und Zeitmessung
        long start = System.nanoTime();
        Liste<Integer> sortierteListe = sortiere(kopie);
        long dauer = System.nanoTime() - start;

        // Zeit in Millisekunden umrechnen
        double zeitMs = dauer / 1000000.0;
        int lese = kopie.leseZugriffe;
        int schreib = kopie.schreibZugriffe;

        return new BenchmarkResult(zeitMs, lese, schreib);
    }
}

/**
 * Speicherklasse für die Testergebnisse eines einzelnen Benchmark-Durchlaufs.
 */
class BenchmarkResult
{
    /**
     * Benötigte Zeit in Millisekunden
     */
    double zeitMs;
    
    /**
     * Anzahl der Lese-Zugriffe (Lookups, Traversierungen)
     */
    int leseZugriffe;
    
    /**
     * Anzahl der Schreib-Zugriffe (Insertion, Append, Delete)
     */
    int schreibZugriffe;

    BenchmarkResult(double zeitMs, int lese, int schreib)
    {
        this.zeitMs = zeitMs;
        this.leseZugriffe = lese;
        this.schreibZugriffe = schreib;
    }
}
