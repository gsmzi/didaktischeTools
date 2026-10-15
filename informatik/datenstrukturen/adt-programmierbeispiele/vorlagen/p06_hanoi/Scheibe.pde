/**
 * Repräsentiert eine Scheibe im Spiel "Die Türme von Hanoi" (Schülervorlage)
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class Scheibe
{
    private int farbe;
    private int groesse;

    /**
     * Erzeugt eine neue Scheibe in der gewünschten Größe.
     * @param groesse Die Größe der Scheibe (1 bis 14)
     */
    Scheibe(int groesse)
    {
        // Farbpalette für Premium-Ausschauen im HSL-Stil
        int[] farben =
        {
            #0f172a, // LSB / 0 (Nicht benutzt)
            #ef4444, #10b981, #3b82f6, #f59e0b,
            #8b5cf6, #ec4899, #14b8a6, #f97316,
            #64748b, #a855f7, #06b6d4, #84cc16,
            #eab308, #d946ef
        };
        this.groesse = groesse;
        this.farbe = farben[groesse % farben.length];
    }

    /**
     * Zeichnet die Scheibe zentriert an der Position (x,y)
     * @param x Die x-Koordinate der Mitte der Scheibe
     * @param y Die y-Koordinate der oberen Kante
     */
    void zeichne(float x, float y)
    {
        fill(farbe);
        stroke(15, 23, 42); // Dunkel-Umrandung
        strokeWeight(1.5);
        
        float scheibenBreite = groesse * 18 + 15; // Skaliert ansprechend
        float scheibenHoehe = 18;
        
        rectMode(CENTER);
        rect(x, y + scheibenHoehe / 2, scheibenBreite, scheibenHoehe, 5);
        rectMode(CORNER); // Zurücksetzen
        
        // Label für didaktischen Wert
        fill(255, 200);
        textSize(9);
        textAlign(CENTER, CENTER);
        text(groesse, x, y + scheibenHoehe / 2 - 1);
    }

    /**
     * Gibt die Größe der Scheibe zurück
     * @return Die Größe der Scheibe (1 bis 14)
     */
    int getGroesse()
    {
        return groesse;
    }
}
