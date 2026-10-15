/**
 * Klasse ListeRekursiv
 * 
 * Implementiert die abstrakte Klasse Liste mithilfe von rekursiven Algorithmen.
 * Bei der Rekursion delegiert eine Methode ihre Aufgabe an eine Hilfsmethode, 
 * die sich selbst mit dem Nachfolgeknoten aufruft, bis eine Abbruchbedingung erreicht ist.
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
        // Abbruchbedingung: Wenn der Knoten null ist, hat dieser Teilbaum die Länge 0.
        if (k == null) 
        {
            return 0;
        } 
        // Rekursionsschritt: Die Länge dieses Knotens (1) plus die Länge 
        // des gesamten Rests der Liste (Rekursion mit dem Nachfolger).
        return 1 + laenge(k.nachfolger);
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
        // Wenn der aktuelle Knoten null ist, war der Index zu groß (out of bounds)
        if (k == null)
        {
            return null;
        }
        
        // Abbruchbedingung: Wenn wir den Countdown bei 0 haben, haben wir den Zielknoten erreicht!
        if (n == 0) 
        {
            return k.daten;
        } 
        
        // Rekursionsschritt: Wir suchen das (n-1)-te Element ab dem Nachfolger-Knoten.
        return getNtenWert(k.nachfolger, n - 1);
    }

    /**
     * Öffentliche Methode zum Anhängen eines Wertes.
     * Behandelt den Sonderfall der leeren Liste direkt, andernfalls startet sie die Rekursion.
     */
    void anhaengen(T val)
    {
        // Sonderfall: Wenn die Liste leer ist, setzen wir den neuen Knoten als Anfang.
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
        // Sicherheitsabfrage: Sollte eigentlich durch die logische Struktur nicht eintreffen
        if (k == null) 
        {
            return;
        } 
        
        // Abbruchbedingung: Wenn der *Nachfolger* des aktuellen Knotens null ist, 
        // ist der aktuelle Knoten das letzte Element der Liste.
        if (k.nachfolger == null) 
        {
            // Wir hängen den neuen Knoten direkt hier an!
            k.nachfolger = new Listenknoten<T>(val, null);
        } 
        else
        {
            // Rekursionsschritt: Wenn es noch einen Nachfolger gibt, reichen wir 
            // die Aufgabe an diesen weiter.
            anhaengen(k.nachfolger, val);
        }
    }

    /**
     * Öffentliche Methode zum Einfügen eines Elements bei einem Index.
     * Behandelt das Einfügen an Index 0 als Sonderfall, delegiert sonst an die Rekursion.
     */
    void einfuegenBei(int index, T val)
    {
        // Sonderfall: Einfügen am Anfang (Index 0)
        if (index == 0) 
        {
            // Der neue Knoten zeigt auf den bisherigen Anfang und wird selbst zum Anfang.
            anfang = new Listenknoten<T>(val, anfang);
        } 
        else
        {
            // Starte Rekursion ab dem Anfang
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
        if (k == null)
        {
            return; // Sicherheitsabfrage (Index außerhalb der Grenzen)
        }

        // Abbruchbedingung: Wenn index == 1 ist, bedeutet das, dass der neue Knoten 
        // der direkte Nachfolger des aktuellen Knotens werden soll.
        if (index == 1) 
        {
            // ZEIGER BIEGEN (Reihenfolge einhalten!):
            // 1. Der neue Knoten verweist auf den bisherigen Nachfolger von k.
            // 2. Der Nachfolger-Zeiger von k wird auf den neuen Knoten umgebogen.
            k.nachfolger = new Listenknoten<T>(val, k.nachfolger);
        } 
        else
        {
            // Rekursionsschritt: Reiche die Aufgabe weiter an den Nachfolger und dekrementiere den Index.
            einfuegenBei(k.nachfolger, index - 1, val);
        }
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
        // Abbruchbedingung 1: Wir haben das Ende der Liste erreicht, ohne den Wert zu finden.
        if (k == null) 
        {
            return false;
        } 
        // Abbruchbedingung 2: Der aktuelle Knoten enthält den gesuchten Wert.
        if (k.daten != null && k.daten.equals(val)) 
        {
            return true;
        } 
        // Rekursionsschritt: Suche im Rest der Liste weiter.
        return enthaelt(k.nachfolger, val);
    }

    /**
     * Öffentliche Methode zum Entfernen eines Elements bei einem Index.
     */
    void entferneBei(int index)
    {
        // Wenn die Liste leer ist, gibt es nichts zu entfernen.
        if (anfang == null) 
        {
            return;
        } 
        
        // Sonderfall: Erstes Element (Index 0) löschen
        if (index == 0) 
        {
            // Der Anfang wird auf das zweite Element verschoben
            anfang = anfang.nachfolger;
        } 
        else
        {
            // Starte Rekursion ab dem Anfang
            entferneBei(anfang, index);
        }
    }

    /**
     * Private Hilfsmethode zum rekursiven Entfernen eines Knotens.
     */
    private void entferneBei(Listenknoten<T> k, int index)
    {
        // Sicherheitsprüfung: Nur fortfahren, wenn der Knoten und sein Nachfolger existieren
        if (k != null && k.nachfolger != null) 
        {
            // Abbruchbedingung: Wenn index == 1 ist, soll der Nachfolger von k gelöscht werden.
            if (index == 1) 
            {
                // ZEIGER BIEGEN:
                // Wir überspringen den direkten Nachfolger, indem wir k.nachfolger auf
                // dessen Nachfolger zeigen lassen.
                k.nachfolger = k.nachfolger.nachfolger;
            } 
            else 
            {
                // Rekursionsschritt: Reiche die Aufgabe weiter und verringere den Index.
                entferneBei(k.nachfolger, index - 1);  
            } 
        }
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
            // Ruft die rekursive Hilfsmethode auf
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
