/**
 * Eine einfach verkettete Liste (abstrakte Zwischenklasse)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
abstract class ListeMitVerkettung<T> extends Liste<T>
{
    /**
     * Der erste Knoten der Liste
     */
    protected Listenknoten<T> anfang;

    /**
     * Erzeugt eine neue Liste
     */
    ListeMitVerkettung()
    {
        anfang = null;
    }

    /**
     * Gibt zurück, ob die Liste leer ist.
     */
    boolean istLeer()
    {
        return anfang == null;
    }
}
