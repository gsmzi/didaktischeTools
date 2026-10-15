/**
 * Ein einfacher Listenknoten zur Speicherung von Daten und Nachfolgereferenzen.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Listenknoten<T>
{
    /**
     * Der Datenwert des Knotens
     */
    T daten;
    
    /**
     * Der Nachfolger des Knotens (null, falls kein Nachfolger vorhanden)
     */
    Listenknoten<T> nachfolger;

    /**
     * Erzeugt einen neuen Knoten.
     * 
     * @param daten Der zu speichernde Datenwert
     * @param nachfolger Der Nachfolgerknoten
     */
    Listenknoten(T daten, Listenknoten<T> nachfolger)
    {
        this.daten = daten;
        this.nachfolger = nachfolger;
    }
}
