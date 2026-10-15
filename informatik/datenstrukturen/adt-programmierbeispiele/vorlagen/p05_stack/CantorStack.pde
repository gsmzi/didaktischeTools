/**
 * Klasse CantorStack (Schülervorlage)
 * 
 * Implementiert einen Stack für ganze Zahlen (Integer) unter Verwendung der 
 * Cantorschen Paarungsfunktion. Diese Funktion ordnet jedem Paar natürlicher Zahlen (x, y) 
 * umkehrbar eindeutig eine einzelne natürliche Zahl z zu.
 * 
 * Durch rekursives Anwenden wird der gesamte Stapel in einer einzigen, beliebig großen 
 * Zahl (BigInteger) gespeichert.
 * 
 * ============================================================================
 * ZU IMPLEMENTIERENDE METHODEN (TODOs in dieser Klasse):
 * 1. boolean isEmpty()
 *    - Prüfen, ob der Stapel leer ist (ob 'stack' gleich BigInteger.TWO ist).
 * 2. void push(Integer wert)
 *    - Element verpaaren und auflegen:
 *      Formel: z = ((x + y) * (x + y + 1)) / 2 + y
 *      (x = bisheriger stack, y = wert)
 * 3. Integer pop()
 *    - Oberstes Element entpaaren, Stack auf den Restwert setzen und Wert zurückgeben.
 *    - Wenn leer: null zurückgeben.
 *    - y mittels topInt() ermitteln, x = w - y als neuen stack-Wert setzen, y zurückgeben.
 * 4. Integer top()
 *    - Oberstes Element ansehen, ohne den Stack zu verändern.
 *    - Wenn leer: null zurückgeben, sonst topInt().intValue() zurückgeben.
 * ============================================================================
 * 
 * Formeln:
 * - Paarung:   z = ((x + y)*(x + y + 1))/2 + y  (wobei x = Rest-Stapel, y = oberster Wert)
 * - Entpaarung: Aus z wird w = floor((sqrt(8z + 1) - 1)/2) berechnet.
 *               y = z - (w^2 + w)/2
 *               x = w - y
 * 
 * Visualisierung:
 * Zeigt die aktuelle riesige Stack-Zahl. Darunter wird die mathematische Formel
 * für das Entpacken (Entpaarung) des aktuellen "top"-Werts schrittweise vorgerechnet.
 * Ganz unten werden die daraus rekonstruierten Werte als stapelförmige Boxen gezeichnet.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
import java.math.BigInteger;

class CantorStack extends Stack<Integer>
{
    /**
     * Die Zahl, die den gesamten Zustand des Stacks speichert.
     * Der leere Stack wird durch die Zahl 2 repräsentiert.
     */
    private BigInteger stack;
    
    /**
     * Erzeugt einen neuen leeren Stack (Wert = 2).
     */
    CantorStack()
    {
        stack = BigInteger.TWO;
    }
    
    /**
     * Gibt zurück, ob der Stack leer ist (Zustand = 2).
     */
    boolean isEmpty()
    {
        //# TODO: isEmpty() implementieren: Prüfen, ob der Stack leer ist (ob der stack-Wert gleich BigInteger.TWO ist).
        return false;
    }
    
    /**
     * Legt ein neues Element auf den Stack.
     * Der aktuelle Stack-Wert (x) und der neue Wert (y) werden zu einem neuen 
     * Stack-Wert (z) verpaart.
     * 
     * @param wert Die aufzulegende Zahl (muss >= 0 sein)
     */
    void push(Integer wert)
    {
        if (wert < 0)
        {
            println("CantorStack unterstützt nur nicht-negative Zahlen!");
            return;
        }
        
        //# TODO: push(Integer wert) implementieren: Element verpaaren und auflegen.
        // Formel: z = ((x + y) * (x + y + 1)) / 2 + y
        // x ist der bisherige stack-Wert, y ist 'wert'.
        // Hinweis: Verwende BigInteger-Methoden (.add, .multiply, .shiftRight(1))
    }
    
    /**
     * Gibt das oberste Element zurück, ohne es zu entfernen.
     * Nutzt die Umkehrfunktion (Entpaarung).
     */
    Integer top()
    {
        //# TODO: top() implementieren: Obersten Wert berechnen und zurückgeben, ohne den Stack zu verändern.
        // 1. Prüfen, ob der Stack leer ist. Falls ja, null zurückgeben.
        // 2. Den obersten Wert mittels topInt() ermitteln und als intValue() zurückgeben.
        return null;
    }
    
    /**
     * Berechnet den obersten Wert (y) aus der aktuellen Stack-Zahl (z).
     */
    private BigInteger topInt()
    {
        BigInteger z = stack;
        BigInteger w = q(z);
        return z.subtract(f(w));
    }
    
    /**
     * Entfernt das oberste Element und gibt es zurück.
     * Berechnet den Vorgänger-Stack-Wert (x) und setzt diesen als neuen Stack-Wert.
     */
    Integer pop()
    {
        //# TODO: pop() implementieren: Oberstes Element entpaaren, entfernen und zurückgeben.
        // 1. Prüfen, ob der Stack leer ist. Falls ja, null zurückgeben.
        // 2. Den aktuellen top-Wert ermitteln.
        // 3. Den neuen stack-Wert (Vorgänger x) berechnen: x = w - y.
        // 4. stack auf den berechneten Wert setzen.
        // 5. Den top-Wert als intValue() zurückgeben.
        return null;
    }
    
    // Hilfsfunktion f(w) = (w^2 + w) / 2
    private BigInteger f(BigInteger w)
    {
        return w.multiply(w.add(BigInteger.ONE)).shiftRight(1);
    }
    
    // Hilfsfunktion q(z) = floor((sqrt(8z + 1) - 1) / 2)
    private BigInteger q(BigInteger z)
    {
        return z.shiftLeft(3).add(BigInteger.ONE).sqrt().subtract(BigInteger.ONE).shiftRight(1);
    }
    
    /**
     * Zeichnet die mathematische Struktur des Cantor-Stacks auf die Processing-Leinwand.
     */
    void grafischZeichnen(float x, float y, float breite, float hoehe)
    {
        float startX = x - breite / 2;
        
        // 1. Anzeige des verpackten Werts (z)
        fill(30, 41, 59);
        stroke(59, 130, 246); // Blaues Highlight
        strokeWeight(2);
        rect(startX, y - hoehe, breite, 40, 8);
        
        fill(255);
        textSize(11);
        textAlign(CENTER, TOP);
        text("Verpackter Stack-Zustand (Großzahl z):", x, y - hoehe + 4);
        
        fill(96, 165, 250);
        textSize(13);
        textAlign(CENTER, BOTTOM);
        // Kürzt extrem lange Zahlen ab
        String stackString = stack.toString();
        if (stackString.length() > 24)
        {
            stackString = stackString.substring(0, 22) + "... (" + stackString.length() + " Stellen)";
        }
        text(stackString, x, y - hoehe + 36);
        
        // 2. Mathematische Entpackungs-Schritte darstellen (falls nicht leer)
        float matheY = y - hoehe + 55;
        if (!stack.equals(BigInteger.TWO))
        {
            BigInteger z = stack;
            BigInteger w = q(z);
            BigInteger t = f(w);
            BigInteger topVal = z.subtract(t);
            BigInteger restStack = w.subtract(topVal);
            
            fill(148, 163, 184);
            textSize(11);
            textAlign(LEFT, TOP);
            text("Schrittweise Entpaarung des top-Wertes:", startX, matheY);
            
            fill(226, 232, 240);
            textSize(10);
            text("1. Hilfswert w = ⌊(√(8*z + 1) - 1) / 2⌋ = " + w.toString(), startX + 10, matheY + 16);
            text("2. Hilfswert t = (w² + w) / 2 = " + t.toString(), startX + 10, matheY + 28);
            text("3. Wert y (top) = z - t = " + topVal.toString(), startX + 10, matheY + 40);
            text("4. Rest-Stack x = w - y = " + restStack.toString(), startX + 10, matheY + 52);
            
            // Hebe die Ergebnisse farbig hervor
            fill(16, 185, 129); // Grün für top
            text("→ Oben (top) = " + topVal.toString(), startX + 10, matheY + 68);
            fill(59, 130, 246); // Blau für Rest
            text("→ Rest = " + restStack.toString(), startX + 130, matheY + 68);
        }
        else
        {
            fill(239, 68, 68);
            textSize(11);
            textAlign(CENTER, TOP);
            text("Stapel ist leer (z = 2). Keine Entpaarung möglich.", x, matheY + 15);
        }
        
        // 3. Entpackte Werte als virtuellen Stapel zeichnen
        float stapelY = y;
        float zellenHoehe = 24;
        
        // Wir dekonstruieren den Stack temporär, um seine Elemente von unten nach oben zu zeichnen
        ArrayList<Integer> elemente = new ArrayList<Integer>();
        BigInteger tempStack = stack;
        
        try {
            while (!tempStack.equals(BigInteger.TWO))
            {
                BigInteger z = tempStack;
                BigInteger w = q(z);
                BigInteger topVal = z.subtract(f(w));
                elemente.add(0, topVal.intValue()); // Am Anfang einfügen, damit Reihenfolge stimmt
                tempStack = w.subtract(topVal);
                if (elemente.size() > 100) break; // Schutz vor Endlosschleife falls Fehler
            }
        } catch(Exception e) {
            // Falls fehlerhafte Berechnungen im Schülertemplate auftreten
        }
        
        // Container zeichnen
        stroke(100, 116, 139);
        strokeWeight(2);
        float containerHoehe = max(4, elemente.size()) * zellenHoehe + 10;
        line(startX + 30, stapelY + 2, startX + breite - 30, stapelY + 2); // Boden
        line(startX + 30, stapelY + 2, startX + 30, stapelY - containerHoehe); // Links
        line(startX + breite - 30, stapelY + 2, startX + breite - 30, stapelY - containerHoehe); // Rechts
        
        // Element-Boxen zeichnen
        for (int i = 0; i < elemente.size(); i++)
        {
            float boxY = stapelY - i * zellenHoehe - zellenHoehe;
            int wert = elemente.get(i);
            
            // Oberster Wert grün highlighten
            if (i == elemente.size() - 1)
            {
                fill(16, 185, 129);
            }
            else
            {
                fill(30, 41, 59);
            }
            
            stroke(71, 85, 105);
            strokeWeight(1);
            rect(startX + 35, boxY, breite - 70, zellenHoehe, 4);
            
            fill(255);
            textSize(11);
            textAlign(CENTER, CENTER);
            text(String.valueOf(wert), x, boxY + zellenHoehe / 2 - 2);
        }
        
        if (elemente.isEmpty())
        {
            fill(71, 85, 105);
            textSize(11);
            textAlign(CENTER, CENTER);
            text("(Stapel leer)", x, stapelY - 20);
        }
    }
    
    @Override
    public String toString()
    {
        String ergebnis = " <";
        CantorStack s = new CantorStack();
        // Kopie des Stack-Werts
        BigInteger originalStack = this.stack;
        
        try {
            while (!this.isEmpty())
            {
                Integer topVal = pop();
                if (topVal == null) break;
                s.push(topVal);
                ergebnis = topVal + ergebnis;
                if (!isEmpty())
                {
                    ergebnis = ", " + ergebnis;
                }
            }
        } catch(Exception e) {
            ergebnis = "Fehler bei toString";
        }
        // Wiederherstellen
        this.stack = originalStack;
        return "[ " + ergebnis;
    }
}
