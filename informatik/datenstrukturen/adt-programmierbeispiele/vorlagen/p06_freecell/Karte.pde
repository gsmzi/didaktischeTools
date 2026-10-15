/**
 * Repräsentiert eine Spielkarte im Spiel Freecell (Schülervorlage)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Karte
{
    /**
     * Konstanten für die vier Kartenfarben
     */
    public static final int PIK = 0;
    public static final int KREUZ = 1;
    public static final int HERZ = 2;
    public static final int KARO = 3;

    /**
     * Konstanten für die Maße der Karte
     */
    public static final int CARD_WIDTH = 100;
    public static final int CARD_HEIGHT = 150;

    private int farbe;
    private int wert;
    private boolean markiert;

    /**
     * Erzeugt eine neue Karte auf Basis des Ganzzahl-Codes.
     * @param nummer Ein Wert von 0 bis 51
     */
    Karte(int nummer)
    {
        farbe = nummer / 13;
        wert = nummer % 13 + 1;
        markiert = false;
    }

    /**
     * Zeichnet die Spielkarte programmatisch in Vektoroptik mit Schatten und Symbolen.
     * @param x Die x-Koordinate der linken oberen Ecke
     * @param y Die y-Koordinate der linken oberen Ecke
     */
    void zeichne(float x, float y)
    {
        // 1. Drop Shadow (Subtiler Schatten für Tiefenwirkung)
        fill(15, 23, 42, 65);
        noStroke();
        rect(x + 2, y + 2, CARD_WIDTH, CARD_HEIGHT, 8);
        
        // 2. Kartenhintergrund
        fill(255);
        stroke(markiert ? color(59, 130, 246) : color(71, 85, 105)); // Blauer Rahmen bei Selektion
        strokeWeight(markiert ? 3.5 : 1);
        rect(x, y, CARD_WIDTH, CARD_HEIGHT, 8);
        
        // 3. Symbole und Texte bestimmen
        int txtCol = istRot() ? color(220, 38, 38) : color(15, 23, 42); // Rot oder Dunkelblau/Schwarz
        String symbol = "";
        if (farbe == PIK) symbol = "♠";
        else if (farbe == KREUZ) symbol = "♣";
        else if (farbe == HERZ) symbol = "♥";
        else if (farbe == KARO) symbol = "♦";
        
        String wertStr = "";
        if (wert == 1) wertStr = "A";
        else if (wert == 11) wertStr = "J";
        else if (wert == 12) wertStr = "Q";
        else if (wert == 13) wertStr = "K";
        else wertStr = String.valueOf(wert);
        
        fill(txtCol);
        
        // 4. Zeichne Wert und Farbe oben links
        textSize(13);
        textAlign(LEFT, TOP);
        text(wertStr, x + 8, y + 6);
        textSize(14);
        text(symbol, x + 8, y + 21);
        
        // 5. Zeichne Wert und Farbe unten rechts (um 180 Grad rotiert)
        pushMatrix();
        translate(x + CARD_WIDTH, y + CARD_HEIGHT);
        rotate(PI);
        textSize(13);
        textAlign(LEFT, TOP);
        text(wertStr, 8, 6);
        textSize(14);
        text(symbol, 8, 21);
        popMatrix();
        
        // 6. Zentrales großes Symbol
        textSize(38);
        textAlign(CENTER, CENTER);
        text(symbol, x + CARD_WIDTH / 2, y + CARD_HEIGHT / 2 - 2);
    }

    /**
     * Gibt an, ob die Karte markiert ist.
     */
    boolean getMarkiert()
    {
        return markiert;
    }

    /**
     * Setzt die Markierung der Karte.
     */
    void setMarkiert(boolean b)
    {
        markiert = b;
    }

    /**
     * Gibt den Wert der Karte zurück (1 = Ass, 11 = Bube, 12 = Dame, 13 = König)
     */
    int getWert()
    {
        return wert;
    }

    /**
     * Gibt die Farbe der Karte zurück (PIK, KREUZ, HERZ, KARO)
     */
    int getFarbe()
    {
        return farbe;
    }

    /**
     * Gibt an, ob die Karte rot ist (Herz oder Karo).
     */
    boolean istRot()
    {
        return farbe == HERZ || farbe == KARO;
    }
}
