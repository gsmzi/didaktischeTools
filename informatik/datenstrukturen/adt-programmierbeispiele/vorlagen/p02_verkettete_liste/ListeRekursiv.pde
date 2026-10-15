/**
 * Klasse ListeRekursiv (Schülervorlage)
 * 
 * Implementiert die einfach verkettete Liste mithilfe von rekursiven Algorithmen.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. int laenge(Listenknoten<T> k)
 *    - Abbruch: k == null -> 0. Rekursion: 1 + laenge(k.nachfolger).
 * 2. T getNtenWert(Listenknoten<T> k, int n)
 *    - Abbruch: k == null -> null; n == 0 -> k.daten. Rekursion: getNtenWert(k.nachfolger, n - 1).
 * 3. void anhaengen(Listenknoten<T> k, T val)
 *    - Abbruch: k.nachfolger == null -> neuen Knoten anhängen. Rekursion: anhaengen(k.nachfolger, val).
 * 4. void einfuegenBei(Listenknoten<T> k, int index, T val)
 *    - Abbruch: index == 1 -> neuen Knoten zwischen k und k.nachfolger einhängen. Rekursion: index - 1.
 * 5. boolean enthaelt(Listenknoten<T> k, T val)
 *    - Abbruch: k == null -> false; Treffer -> true. Rekursion: enthaelt(k.nachfolger, val).
 * 6. Listenknoten<T> entferneBei(Listenknoten<T> k, int index)
 *    - Abbruch: index == 0 -> k.nachfolger zurückgeben (Knoten aushängen). Rekursion: k.nachfolger setzen.
 * ============================================================================
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeRekursiv<T> extends Liste<T>
{
    /**
     * Konstruktor der rekursiven Liste.
     * Initialisiert eine leere Liste. Der Anfang zeigt auf 'null'.
     */
    ListeRekursiv()
    {
        //# TODO: Setzen Sie den Anfangszustand der Liste
        anfang = null;
    }

    /**
     * Öffentliche Methode zur Ermittlung der Listenlänge.
     * Startet die Rekursion am Anfang der Liste.
     * 
     * @return Die Anzahl der Elemente in der Liste.
     */
    int laenge()
    {
        return laenge(anfang);
    }

    /**
     * Private Hilfsmethode zur rekursiven Längenbestimmung.
     * 
     * @param k Der aktuell betrachtete Knoten.
     * @return Die verbleibende Länge ab diesem Knoten.
     */
    private int laenge(Listenknoten<T> k)
    {
        //# TODO: Formulieren Sie die Abbruchbedingung und den Rekursionsschritt.
        
        return 0; // Platzhalter (0 statt -1 für Stabilität des GUI-Gittergerüsts)
    }

    /**
     * Öffentliche Methode zur Wertermittlung.
     * Startet die Rekursion am Listenanfang.
     * 
     * @param n Der gewünschte Index
     * @return Der n-te Wert oder null, falls der Index außerhalb liegt.
     */
    T getNtenWert(int n)
    {
        return getNtenWert(anfang, n);
    }

    /**
     * Private Hilfsmethode zur rekursiven Suche nach dem n-ten Wert.
     */
    private T getNtenWert(Listenknoten<T> k, int n)
    {
        //# TODO: Formulieren Sie die Abbruchbedingungen (Knoten ist null oder n ist 0) 
        //  und den Rekursionsschritt (Weiterschalten zum Nachfolger mit n - 1).
        
        return null; // Platzhalter
    }

    /**
     * Öffentliche Methode zum Anhängen eines Wertes.
     * Behandelt den Sonderfall der leeren Liste direkt, andernfalls startet sie die Rekursion.
     */
    void anhaengen(T val)
    {
        if (anfang == null)
        {
            anfang = new Listenknoten<T>(val, null);
        }
        else
        {
            // Rekursiver Aufruf startet am ersten Knoten
            anhaengen(anfang, val);
        }
    }

    /**
     * Private Hilfsmethode zum rekursiven Finden des Listenendes und Anhängen.
     */
    private void anhaengen(Listenknoten<T> k, T val)
    {
        //# TODO: Suchen Sie das Ende der Liste (wo nachfolger null ist) rekursiv 
        //  und hängen Sie dort den neuen Listenknoten an.
        
    }

    /**
     * Öffentliche Methode zum Einfügen eines Elements bei einem Index.
     * Behandelt das Einfügen an Index 0 als Sonderfall, delegiert sonst an die Rekursion.
     */
    void einfuegenBei(int index, T val)
    {
        if (index == 0) 
        {
            anfang = new Listenknoten<T>(val, anfang);
        } 
        else
        {
            einfuegenBei(anfang, index, val);
        }
    }

    /**
     * Private Hilfsmethode zum rekursiven Einfügen.
     * 
     * @param k Der aktuelle Knoten.
     * @param index Die verbleibende Distanz zur Einfügestelle.
     * @param val Der einzufügende Wert.
     */
    private void einfuegenBei(Listenknoten<T> k, int index, T val)
    {
        //# TODO: Navigieren Sie rekursiv zum Vorgängerknoten (index == 1) und fügen Sie 
        //  den neuen Knoten durch Umbiegen der Zeiger ein. Reichen Sie andernfalls 
        //  den Auftrag an den Nachfolger mit index - 1 weiter.
        
    }

    /**
     * Öffentliche Methode zum Prüfen der Existenz eines Wertes.
     */
    boolean enthaelt(T val)
    {
        return enthaelt(anfang, val);
    }

    /**
     * Private Hilfsmethode zur rekursiven Suche nach einem Wert.
     */
    private boolean enthaelt(Listenknoten<T> k, T val)
    {
        //# TODO: Prüfen Sie rekursiv, ob einer der Knoten den gesuchten Wert enthält.
        //  Denken Sie an die Abbruchbedingungen (Ende erreicht -> false, Wert gefunden -> true).
        
        return false; // Platzhalter
    }

    /**
     * Öffentliche Methode zum Entfernen eines Elements bei einem Index.
     */
    void entferneBei(int index)
    {
        if (anfang == null) 
        {
            return;
        } 
        
        if (index == 0) 
        {
            anfang = anfang.nachfolger;
        } 
        else
        {
            entferneBei(anfang, index);
        }
    }

    /**
     * Private Hilfsmethode zum rekursiven Entfernen eines Knotens.
     */
    private void entferneBei(Listenknoten<T> k, int index)
    {
        //# TODO: Navigieren Sie rekursiv zum Vorgängerknoten (index == 1) des zu löschenden Knotens.
        //  Entfernen Sie dann den Zielknoten, indem Sie den Nachfolger-Zeiger des Vorgängers 
        //  auf den Nachfolger-Zeiger des Zielknotens verbiegen.
        
    }
    
    /**
     * Erzeugt rekursiv eine String-Repräsentation der Liste für die Konsole.
     */
    @Override
    String toString()
    {
        String ergebnis = "[ ";
        if (anfang != null)
        {
            ergebnis += anfang.daten + toString(anfang.nachfolger);
        }
        ergebnis += " ]";
        return ergebnis;
    }
    
    /**
     * Rekursive Hilfsmethode für die toString-Funktion.
     */
    private String toString(Listenknoten<T> k)
    {
        if (k == null)
        {
            return "";
        }
        return ", " + k.daten + toString(k.nachfolger);
    }
}
