/**
 * Klasse ListeIterativ
 * 
 * Implementiert die abstrakte Klasse Liste mithilfe von iterativen Algorithmen (Schleifen).
 * Diese Klasse zeigt, wie man Zeigeroperationen mithilfe von while-Schleifen 
 * Schritt für Schritt durchführt.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class ListeIterativ<T> extends Liste<T>
{
    /**
     * Konstruktor der iterativen Liste.
     * Initialisiert eine leere Liste. Der Anfang zeigt auf 'null'.
     */
    ListeIterativ()
    {
        anfang = null;  
    }

    /**
     * Ermittelt die Länge der Liste durch iteratives Durchlaufen aller Knoten.
     * 
     * @return Die Anzahl der Elemente in der Liste.
     */
    int laenge()
    {
        int laenge = 0;
        // Wir starten beim ersten Knoten der Liste
        Listenknoten<T> aktueller = anfang;
        
        // Solange wir nicht das Ende der Liste (null) erreicht haben,
        // wandern wir zum nächsten Knoten und zählen mit.
        while (aktueller != null) 
        { 
            aktueller = aktueller.nachfolger; // Zeiger auf den Nachfolger verschieben
            laenge++;                         // Zähler erhöhen
        }
        return laenge;
    }

    /**
     * Gibt den Wert an einer bestimmten Position zurück.
     * 
     * @param n Der Index des gesuchten Elements (0-basiert)
     * @return Den Wert des n-ten Knotens oder null, falls der Index ungültig ist.
     */
    T getNtenWert(int n)
    {
        // Wir starten die Suche am Anfang der Liste
        Listenknoten<T> aktueller = anfang;
        
        // Wir laufen durch die Liste und verringern n bei jedem Schritt.
        // Wenn n bei 0 ankommt und der aktuelle Knoten existiert, haben wir das Element gefunden.
        while (aktueller != null) 
        { 
            if (n == 0) 
            {
                return aktueller.daten; // Gesuchtes Element gefunden!
            } 
            aktueller = aktueller.nachfolger; // Zum nächsten Knoten weiterschalten
            n--;                              // Index-Countdown
        } 
        
        // Falls die Liste leer war oder der Index außerhalb der Grenzen lag
        return null; 
    }

    /**
     * Hängt einen neuen Wert an das Ende der Liste an.
     * 
     * @param val Der anzuhängende Wert
     */
    void anhaengen(T val)
    {
        // Wir erstellen einen neuen Knoten, der den Wert speichert.
        // Da er das neue Ende der Liste wird, zeigt sein Nachfolger auf null.
        Listenknoten<T> neuerKnoten = new Listenknoten<T>(val, null);
        
        // Sonderfall: Wenn die Liste leer ist, wird der neue Knoten zum Anfang der Liste.
        if (anfang == null) 
        {
            anfang = neuerKnoten;
        } 
        else
        {
            // Andernfalls müssen wir das aktuelle Ende der Liste finden.
            // Dazu starten wir am Anfang.
            Listenknoten<T> aktueller = anfang;
            
            // Wir laufen so lange weiter, bis wir den Knoten finden, 
            // dessen Nachfolger-Zeiger auf null zeigt (das aktuelle Endelement).
            while (aktueller.nachfolger != null) 
            { 
                aktueller = aktueller.nachfolger;
            } 
            
            // Jetzt haben wir das letzte Element gefunden. 
            // Wir verbiegen seinen Nachfolger-Zeiger, sodass er auf unseren neuen Knoten zeigt.
            aktueller.nachfolger = neuerKnoten;
        }
    }

    /**
     * Fügt einen neuen Wert an einem beliebigen, gültigen Index in der Liste ein.
     * 
     * @param index Die Einfügeposition (0 <= index <= laenge())
     * @param val Der einzufügende Wert
     */
    void einfuegenBei(int index, T val)
    {
        // Sonderfall 1: Einfügen ganz vorne (am Anfang, Index 0)
        if (index == 0) 
        {
            // Der neue Knoten wird zum neuen Anfang. 
            // Sein Nachfolger muss auf den bisherigen Anfang der Liste zeigen.
            anfang = new Listenknoten<T>(val, anfang);
        } 
        else
        {
            // Sonderfall 2: Einfügen an einer Position > 0.
            // Wir müssen den Vorgängerknoten finden (also den Knoten bei index - 1).
            Listenknoten<T> aktueller = anfang;
            
            // Wir laufen mit dem Zeiger vorwärts, bis wir genau vor der gewünschten Stelle stehen.
            while (index > 1) 
            {
                if (aktueller == null) 
                {
                    return; // Index lag außerhalb der Liste (Sicherheitsabfrage)
                } 
                aktueller = aktueller.nachfolger;
                index--;
            } 
            
            if (aktueller == null) 
            {
                return; // Index ungültig
            }
            
            // WICHTIGE REIHENFOLGE beim Zeiger-Biegen:
            // 1. Der neue Knoten muss auf den Nachfolger des aktuellen Knotens zeigen:
            //    new Listenknoten(val, aktueller.nachfolger)
            // 2. Erst danach darf der Nachfolger des aktuellen Knotens auf den neuen Knoten zeigen.
            //    Wenn wir erst den aktuellen Nachfolger überschreiben würden, ginge die restliche Liste verloren!
            aktueller.nachfolger = new Listenknoten<T>(val, aktueller.nachfolger);
        }
    }

    /**
     * Prüft, ob ein gesuchter Wert in der Liste enthalten ist.
     * 
     * @param val Der zu suchende Wert
     * @return true, wenn der Wert gefunden wurde; false sonst.
     */
    boolean enthaelt(T val)
    {
        Listenknoten<T> aktueller = anfang;
        
        // Wir wandern durch die gesamte Liste
        while (aktueller != null) 
        { 
            // Vergleiche den Dateninhalt des Knotens mit dem gesuchten Wert.
            // equals() wird verwendet, um auch Objekte korrekt zu vergleichen.
            if (aktueller.daten != null && aktueller.daten.equals(val)) 
            {
                return true; // Wert gefunden!
            } 
            aktueller = aktueller.nachfolger; // Zum nächsten Knoten
        } 
        return false; // Wert nicht in der Liste enthalten
    }

    /**
     * Entfernt den Knoten an der gegebenen Position aus der Liste.
     * 
     * @param index Die Position des zu löschenden Knotens.
     */
    void entferneBei(int index)
    {
        // Wenn die Liste bereits leer ist, gibt es nichts zu entfernen.
        if (anfang == null) 
        {
            return;
        } 
        
        // Sonderfall 1: Entfernen des ersten Elements (Index 0)
        if (index == 0) 
        {
            // Der Anfang wird einfach auf das zweite Element (nachfolger) verschoben.
            // Das erste Element wird dadurch "abgehängt".
            anfang = anfang.nachfolger;
        } 
        else
        {
            // Sonderfall 2: Entfernen an einer Position > 0.
            // Wir müssen den Vorgängerknoten (bei index - 1) des zu löschenden Elements finden.
            Listenknoten<T> vorgaenger = anfang;
            
            while (index > 1 && vorgaenger != null) 
            {
                vorgaenger = vorgaenger.nachfolger;
                index--;
            } 
            
            // Wenn der Vorgänger und das zu löschende Element (vorganger.nachfolger) existieren:
            if (vorgaenger != null && vorgaenger.nachfolger != null) 
            {
                // ZEIGER BIEGEN:
                // Wir überspringen das zu löschende Element, indem wir den Nachfolger des Vorgängers 
                // direkt auf den Nachfolger des zu löschenden Elements zeigen lassen.
                // Dadurch verliert das gelöschte Element alle Verweise und wird vom Garbage Collector gelöscht.
                vorgaenger.nachfolger = vorgaenger.nachfolger.nachfolger;
            } 
        }
    }
    
    /**
     * Erzeugt eine String-Repräsentation der Liste für die Konsole.
     * 
     * @return String im Format [wert1, wert2, wert3]
     */
    @Override
    String toString()
    {
        StringBuilder b = new StringBuilder();
        Listenknoten<T> k = anfang;
        while (k != null)
        {
            if (b.length() > 0)
            {
                b.append(", ");
            }
            b.append(k.daten);
            k = k.nachfolger;
        }
        return "[ " + b.toString() + " ]";
    }
}
