/**
 * Klasse Listenknoten
 * 
 * Repräsentiert einen einzelnen Knoten für eine einfach verkettete Warteschlange (LinkedQueue).
 * Jeder Knoten speichert einen Datenwert und einen Verweis (Zeiger) auf seinen Nachfolger.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Listenknoten<T>
{
    /**
     * Der im Knoten gespeicherte Datenwert.
     */
    T daten;
    
    /**
     * Verweis auf den nachfolgenden Knoten (oder null am Ende der Warteschlange).
     */
    Listenknoten<T> nachfolger;
    
    Listenknoten(T daten, Listenknoten<T> nachfolger)
    {
        this.daten = daten;
        this.nachfolger = nachfolger;
    }
}