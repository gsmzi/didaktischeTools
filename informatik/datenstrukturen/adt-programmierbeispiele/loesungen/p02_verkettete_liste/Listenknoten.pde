/**
 * Klasse Listenknoten
 * 
 * Repräsentiert ein einzelnes Element in der verketteten Liste.
 * Jeder Knoten speichert einen Datenwert und einen Verweis (Zeiger) auf seinen Nachfolger.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Listenknoten<T>
{
    /**
     * Der Datenwert (Inhalt) des Knotens.
     */
    T daten;
    
    /**
     * Der Nachfolger dieses Knotens. Zeigt auf den nächsten Knoten 
     * oder ist 'null', wenn dies das letzte Element der Liste ist.
     */
    Listenknoten<T> nachfolger;

    /**
     * Erzeugt einen neuen Listenknoten.
     * 
     * @param daten Der Datenwert des Knotens
     * @param nachfolger Der Nachfolger des Knotens (darf null sein)
     */
    Listenknoten(T daten, Listenknoten<T> nachfolger)
    {
        this.daten = daten;
        this.nachfolger = nachfolger;
    }
}
