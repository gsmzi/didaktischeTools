/**
 * Hauptprogramm: p02_verkettete_liste (Vorlage)
 * 
 * Vergleicht die iterative und rekursive Implementierung einer einfach verketteten Liste.
 * 
 * ============================================================================
 * AUFGABENSTELLUNG / ZU IMPLEMENTIERENDE KLASSEN:
 * - ListeIterativ.pde:
 *   Iterative Implementierung der einfach verketteten Liste mit Hilfszeigern
 *   und while-Schleifen.
 *   Zu programmieren: laenge(), getNtenWert(int n), anhaengen(T val),
 *   einfuegenBei(int index, T val), enthaelt(T val), entferneBei(int index).
 * - ListeRekursiv.pde:
 *   Rekursive Implementierung der einfach verketteten Liste mittels
 *   Rekursionsanker und Rekursionsschritt über rekursive Hilfsmethoden.
 *   Zu programmieren: laenge(Listenknoten<T> k), getNtenWert(Listenknoten<T> k, int n),
 *   anhaengen(Listenknoten<T> k, T val), einfuegenBei(Listenknoten<T> k, int index, T val),
 *   enthaelt(Listenknoten<T> k, T val), entferneBei(Listenknoten<T> k, int index).
 * - (Vorgegeben: Liste.pde [Interface], Listenknoten.pde [Knotenklasse],
 *    p02_verkettete_liste.pde [GUI-Testumgebung])
 * ============================================================================
 * 
 * @author Antigravity
 * @version September 2026
 */

Liste<Integer> aktiveListe;
ListeIterativ<Integer> iterativeListe;
ListeRekursiv<Integer> rekursiveListe;

boolean istIterativAktiv = true;

// Zustand für die GUI-Buttons und Zähler
int einfuegeIndex = 0;
int entferneIndex = 0;
int suchWert = 50;
Integer aktuellerSuchwertHighlight = null;
int suchFrameCounter = 0; // Für temporäres Highlight beim Suchen

// Zoom-Faktor NUR für die Liste
float zoomFaktor = 1.0;

// Fester Skalierungsfaktor für die Benutzeroberfläche (Schaltflächen, Texte, Panels)
final float GUI_SCALE = 1.4;

// UI Scroll-Steuerung für lange Listen
float scrollX = 50;

// Log-Historie für Aktionen
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Buttons
Button btnIterativ;
Button btnRekursiv;
Button btnAnhaengen;
Button btnVorneEinfuegen;
Button btnLeeren;
Button btnLaenge;

Button btnEinfuegenBei;
Button btnEinfuegenDec;
Button btnEinfuegenInc;

Button btnEntferneBei;
Button btnEntferneDec;
Button btnEntferneInc;

Button btnSuchwertDec;
Button btnSuchwertInc;
Button btnSuchen;

Button btnZoomDec;
Button btnZoomInc;

// =========================================================================
// INTERFACE-MAPPING: BUTTON-AKTIONEN ZU DEN METHODEN DER LISTE (FÜR TESTS)
// =========================================================================

/**
 * Entspricht dem Klick auf "Iterativ" (Umschalten auf iterative Implementierung).
 */
void triggerUmschaltenIterativ()
{
    istIterativAktiv = true;
    rekursiveListeZuIterativeListe();
    aktiveListe = iterativeListe;
    logHinzufuegen("Zur iterativen Implementierung gewechselt (Daten übernommen).");
}

/**
 * Entspricht dem Klick auf "Rekursiv" (Umschalten auf rekursive Implementierung).
 */
void triggerUmschaltenRekursiv()
{
    istIterativAktiv = false;
    iterativeListeZuRekursiveListe();
    aktiveListe = rekursiveListe;
    logHinzufuegen("Zur rekursiven Implementierung gewechselt (Daten übernommen).");
}

/**
 * Entspricht dem Button "+ Zufall hinten".
 * Ruft die Listenmethode: aktiveListe.anhaengen(T val) auf.
 */
void triggerAnhaengen()
{
    int wert = int(random(10, 100));
    aktiveListe.anhaengen(wert);
    logHinzufuegen("Wert " + wert + " hinten angehängt.");
    grenzenPruefen();
}

/**
 * Entspricht dem Button "+ Zufall vorne".
 * Ruft die Listenmethode: aktiveListe.einfuegenBei(int index, T val) mit index = 0 auf.
 */
void triggerVorneEinfuegen()
{
    int wert = int(random(10, 100));
    aktiveListe.einfuegenBei(0, wert);
    logHinzufuegen("Wert " + wert + " bei Index 0 (vorne) eingefügt.");
    grenzenPruefen();
}

/**
 * Entspricht dem Button "Leeren".
 * Leert die Liste durch Neu-Instanziierung.
 */
void triggerLeeren()
{
    if (istIterativAktiv)
    {
        iterativeListe = new ListeIterativ<Integer>();
        aktiveListe = iterativeListe;
    }
    else
    {
        rekursiveListe = new ListeRekursiv<Integer>();
        aktiveListe = rekursiveListe;
    }
    logHinzufuegen("Die Liste wurde geleert.");
    grenzenPruefen();
}

/**
 * Entspricht dem Button "Einfügen bei".
 * Ruft die Listenmethoden: aktiveListe.laenge() und aktiveListe.einfuegenBei(int index, T val) auf.
 */
void triggerEinfuegenBei(int index)
{
    int laenge = aktiveListe.laenge();
    if (index >= 0 && index <= laenge)
    {
        int wert = int(random(10, 100));
        aktiveListe.einfuegenBei(index, wert);
        logHinzufuegen("Wert " + wert + " bei Index " + index + " eingefügt.");
        grenzenPruefen();
    }
    else
    {
        logHinzufuegen("FEHLER: Index " + index + " ist ungültig (Erlaubt: 0 bis " + laenge + ").");
    }
}

/**
 * Entspricht dem Button "Entfernen bei".
 * Ruft die Listenmethoden: aktiveListe.laenge(), aktiveListe.getNtenWert(int n) und aktiveListe.entferneBei(int index) auf.
 */
void triggerEntferneBei(int index)
{
    int laenge = aktiveListe.laenge();
    if (laenge == 0)
    {
        logHinzufuegen("FEHLER: Liste ist leer. Kein Element zum Entfernen.");
    }
    else if (index >= 0 && index < laenge)
    {
        Integer alterWert = aktiveListe.getNtenWert(index);
        aktiveListe.entferneBei(index);
        String wertStr = (alterWert != null) ? alterWert.toString() : "?";
        logHinzufuegen("Element bei Index " + index + " (Wert: " + wertStr + ") entfernt.");
        grenzenPruefen();
    }
    else
    {
        logHinzufuegen("FEHLER: Index " + index + " ungültig (Erlaubt: 0 bis " + (laenge - 1) + ").");
    }
}

/**
 * Entspricht dem Button "Suchen".
 * Ruft die Listenmethode: aktiveListe.enthaelt(T val) auf.
 */
void triggerSuchen(int wert)
{
    boolean gefunden = aktiveListe.enthaelt(wert);
    if (gefunden)
    {
        aktuellerSuchwertHighlight = wert;
        suchFrameCounter = 0;
        logHinzufuegen("Wert " + wert + " wurde in der Liste GEFUNDEN und wird hervorgehoben.");
    }
    else
    {
        aktuellerSuchwertHighlight = null;
        logHinzufuegen("Wert " + wert + " wurde in der Liste NICHT gefunden.");
    }
}

/**
 * Entspricht dem Button "Länge".
 * Ruft die Listenmethode: aktiveListe.laenge() auf.
 */
void triggerLaenge()
{
    int laenge = aktiveListe.laenge();
    logHinzufuegen("Aktuelle Länge der Liste: " + laenge);
}

void setup()
{
    // Größeres Standardfenster, damit die 140% vergrößerten Schaltflächen gut Platz haben
    size(1350, 700);
    
    // Macht das Fenster flexibel vergrößerbar (Fensterränder ziehbar)
    surface.setResizable(true);
    
    // Listen instanziieren
    iterativeListe = new ListeIterativ<Integer>();
    rekursiveListe = new ListeRekursiv<Integer>();
    
    // Standardmäßig mit der iterativen Liste starten
    aktiveListe = iterativeListe;
    
    // Einige Standardwerte zum Start einfügen, damit die Oberfläche nicht leer ist
    aktiveListe.anhaengen(23);
    aktiveListe.anhaengen(45);
    aktiveListe.anhaengen(89);
    
    // UI-Buttons initialisieren (x, y, breite, hoehe, label, farbe)
    color colAktiv = color(16, 185, 129);      // Smaragdgrün
    color colStandard = color(51, 65, 85);    // Slate 700
    color colAktion = color(59, 130, 246);     // Blau
    color colGefahr = color(239, 68, 68);      // Rot
    
    btnIterativ = new Button(50, 95, 100, 30, "Iterativ", colAktiv);
    btnRekursiv = new Button(160, 95, 100, 30, "Rekursiv", colStandard);
    
    btnAnhaengen = new Button(280, 95, 130, 30, "+ Zufall hinten", colAktion);
    btnVorneEinfuegen = new Button(420, 95, 130, 30, "+ Zufall vorne", colAktion);
    btnLeeren = new Button(560, 95, 80, 30, "Leeren", colGefahr);
    btnLaenge = new Button(650, 95, 80, 30, "Länge", colAktiv);
    
    // Index Einfügen
    btnEinfuegenBei = new Button(50, 140, 110, 30, "Einfügen bei", colAktion);
    btnEinfuegenDec = new Button(165, 140, 30, 30, "-", colStandard);
    btnEinfuegenInc = new Button(235, 140, 30, 30, "+", colStandard);
    
    // Index Entfernen
    btnEntferneBei = new Button(280, 140, 110, 30, "Entfernen bei", colGefahr);
    btnEntferneDec = new Button(395, 140, 30, 30, "-", colStandard);
    btnEntferneInc = new Button(465, 140, 30, 30, "+", colStandard);
    
    // Suchsteuerung
    btnSuchen = new Button(560, 140, 80, 30, "Suchen", colAktiv);
    btnSuchwertDec = new Button(650, 140, 30, 30, "-", colStandard);
    btnSuchwertInc = new Button(720, 140, 30, 30, "+", colStandard);
    
    // Zoomsteuerung für die Liste
    btnZoomDec = new Button(825, 95, 30, 30, "-", colStandard);
    btnZoomInc = new Button(905, 95, 30, 30, "+", colStandard);
    
    logHinzufuegen("Programm gestartet. Iterative Liste geladen.");
}

void draw()
{
    // Berechne die logischen Dimensionen des skalierten Viewports
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate (dunkler Hintergrund)
    
    // Wende die GUI-Skalierung an (Menü und Schaltflächen dauerhaft vergrößert auf 140%)
    pushMatrix();
    scale(GUI_SCALE);
    
    // 1. Header zeichnen
    fill(30, 41, 59);
    noStroke();
    rect(0, 0, w, 70);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text("Didaktische Visualisierung: Verkettete Liste (Vorlage)", 30, 25);
    
    fill(148, 163, 184);
    textSize(12);
    text("Gymnasiale Oberstufe | Datenstruktur live erleben", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge rechts oben
    fill(istIterativAktiv ? color(16, 185, 129, 40) : color(59, 130, 246, 40));
    stroke(istIterativAktiv ? color(16, 185, 129) : color(59, 130, 246));
    strokeWeight(1);
    rect(w - 250, 20, 220, 30, 6);
    
    fill(istIterativAktiv ? color(52, 211, 153) : color(96, 165, 250));
    textSize(11);
    textAlign(CENTER, CENTER);
    text("AKTIV: " + (istIterativAktiv ? "ITERATIVE IMPLEMENTIERUNG" : "REKURSIVE IMPLEMENTIERUNG"), w - 140, 34);
    
    // 2. Control Panel Hintergrund
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, 80, w - 60, 105, 8);
    
    // Buttons aktualisieren und zeichnen
    btnIterativ.col = istIterativAktiv ? color(16, 185, 129) : color(51, 65, 85);
    btnRekursiv.col = !istIterativAktiv ? color(59, 130, 246) : color(51, 65, 85);
    
    btnIterativ.zeichnen();
    btnRekursiv.zeichnen();
    btnAnhaengen.zeichnen();
    btnVorneEinfuegen.zeichnen();
    btnLeeren.zeichnen();
    btnLaenge.zeichnen();
    
    btnZoomDec.zeichnen();
    btnZoomInc.zeichnen();
    
    // Zoom-Texte zeichnen (Zeigt den Zoom der Liste an)
    fill(148, 163, 184);
    textSize(13);
    textAlign(LEFT, CENTER);
    text("List-Zoom:", 750, 110);
    fill(255);
    textAlign(CENTER, CENTER);
    text(round(zoomFaktor * 100) + "%", 875, 110);
    
    btnEinfuegenBei.zeichnen();
    btnEinfuegenDec.zeichnen();
    btnEinfuegenInc.zeichnen();
    
    // Werte zwischen den +/- Knöpfen zeichnen
    fill(255);
    textSize(13);
    textAlign(CENTER, CENTER);
    text(einfuegeIndex, 210, 154);
    
    btnEntferneBei.zeichnen();
    btnEntferneDec.zeichnen();
    btnEntferneInc.zeichnen();
    
    fill(255);
    text(entferneIndex, 440, 154);
    
    btnSuchen.zeichnen();
    btnSuchwertDec.zeichnen();
    btnSuchwertInc.zeichnen();
    
    fill(255);
    text(suchWert, 695, 154);
    
    // 3. Visualisierungsbereich zeichnen (mit list-Zoom)
    pushMatrix();
    // Die y-Position der Liste wird dynamisch an die Fensterhöhe angepasst (Zentrierung)
    translate(scrollX, h / 2 + 15);
    scale(zoomFaktor); // ZoomFaktor steuert NUR noch die Liste!
    
    // Wenn Suche aktiv ist, blende nach einiger Zeit das Highlight wieder aus
    if (aktuellerSuchwertHighlight != null)
    {
        suchFrameCounter++;
        if (suchFrameCounter > 120) // ca. 2 Sekunden bei 60 fps
        {
            aktuellerSuchwertHighlight = null;
            suchFrameCounter = 0;
        }
    }
    
    aktiveListe.grafischZeichnen(0, -22.5, aktuellerSuchwertHighlight);
    popMatrix();
    
    // Scroll-Hinweis zeichnen, falls Liste lang ist
    if (aktiveListe.laenge() > 5)
    {
        fill(148, 163, 184, 150);
        textSize(11);
        textAlign(RIGHT, BOTTOM);
        text("↔ Ziehe mit der Maus im mittleren Bereich zum Scrollen", w - 30, h - 130);
    }
    
    // 4. Log-Konsole (unten) zeichnen (dynamisch positioniert bei h - 120)
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, h - 120, w - 60, 95, 8);
    
    fill(51, 65, 85);
    rect(30, h - 120, w - 60, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(10);
    textAlign(LEFT, CENTER);
    text("AKTIONSHISTORIE (LOG)", 45, h - 110);
    
    // Log-Einträge zeichnen
    textSize(12);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50); // Ältere Einträge verblassen leicht
        text(aktionsLogs.get(i), 50, h - 90 + i * 16);
    }
    
    popMatrix();
}

void mousePressed()
{
    // Klick auf Iterativ umschalten
    if (btnIterativ.mouseOver() && !istIterativAktiv)
    {
        triggerUmschaltenIterativ();
    }
    
    // Klick auf Rekursiv umschalten
    if (btnRekursiv.mouseOver() && istIterativAktiv)
    {
        triggerUmschaltenRekursiv();
    }
    
    // Klick auf Zufall hinten anhängen
    if (btnAnhaengen.mouseOver())
    {
        triggerAnhaengen();
    }
    
    // Klick auf Zufall vorne einfügen
    if (btnVorneEinfuegen.mouseOver())
    {
        triggerVorneEinfuegen();
    }
    
    // Klick auf Leeren
    if (btnLeeren.mouseOver())
    {
        triggerLeeren();
    }
    
    // Klick auf Länge
    if (btnLaenge.mouseOver())
    {
        triggerLaenge();
    }
    
    // Klick auf Einfügen bei
    if (btnEinfuegenBei.mouseOver())
    {
        triggerEinfuegenBei(einfuegeIndex);
    }
    
    // Einfüge-Index verringern/erhöhen
    if (btnEinfuegenDec.mouseOver() && einfuegeIndex > 0)
    {
        einfuegeIndex--;
    }
    if (btnEinfuegenInc.mouseOver())
    {
        einfuegeIndex++;
    }
    
    // Klick auf Entfernen bei
    if (btnEntferneBei.mouseOver())
    {
        triggerEntferneBei(entferneIndex);
    }
    
    // Entferne-Index verringern/erhöhen
    if (btnEntferneDec.mouseOver() && entferneIndex > 0)
    {
        entferneIndex--;
    }
    if (btnEntferneInc.mouseOver())
    {
        entferneIndex++;
    }
    
    // Klick auf Suchen
    if (btnSuchen.mouseOver())
    {
        triggerSuchen(suchWert);
    }
    
    // Suchwert verringern/erhöhen
    if (btnSuchwertDec.mouseOver() && suchWert > 0)
    {
        suchWert--;
    }
    if (btnSuchwertInc.mouseOver() && suchWert < 99)
    {
        suchWert++;
    }
    
    // Zoom der Liste verringern/erhöhen
    if (btnZoomDec.mouseOver() && zoomFaktor > 0.5)
    {
        zoomFaktor -= 0.1;
        logHinzufuegen("Listen-Zoom verkleinert auf: " + round(zoomFaktor * 100) + "%");
    }
    if (btnZoomInc.mouseOver() && zoomFaktor < 2.0)
    {
        zoomFaktor += 0.1;
        logHinzufuegen("Listen-Zoom vergrößert auf: " + round(zoomFaktor * 100) + "%");
    }
}

void mouseDragged()
{
    // Wenn die Maus im Visualisierungsbereich bewegt wird, verschiebe die Ansicht
    float lmY = mouseY / GUI_SCALE;
    float h = height / GUI_SCALE;
    if (lmY > 200 && lmY < (h - 130))
    {
        // Draggeschwindigkeit passt sich der Skalierung der GUI an
        scrollX += (mouseX - pmouseX) / GUI_SCALE;
        // Verhindert das zu weite Rausscrollen
        scrollX = constrain(scrollX, -1500, 100);
    }
}

// Log-Historie pflegen (maximal 4 Einträge)
void logHinzufuegen(String msg)
{
    String zeit = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    aktionsLogs.add("[" + zeit + "] " + msg);
    if (aktionsLogs.size() > 4)
    {
        aktionsLogs.remove(0);
    }
}

// Hilfsmethode: Stellt sicher, dass die GUI-Auswahlindizes im sinnvollen Rahmen bleiben
void grenzenPruefen()
{
    int laenge = aktiveListe.laenge();
    einfuegeIndex = constrain(einfuegeIndex, 0, laenge);
    if (laenge == 0)
    {
        entferneIndex = 0;
    }
    else
    {
        entferneIndex = constrain(entferneIndex, 0, laenge - 1);
    }
}

// Übertragungsmethoden zur Synchronisation der Daten beim Umschalten des ADTs
void iterativeListeZuRekursiveListe()
{
    rekursiveListe = new ListeRekursiv<Integer>();
    int laenge = iterativeListe.laenge();
    for (int i = 0; i < laenge; i++)
    {
        Integer wert = iterativeListe.getNtenWert(i);
        if (wert != null)
        {
            rekursiveListe.anhaengen(wert);
        }
    }
}

void rekursiveListeZuIterativeListe()
{
    iterativeListe = new ListeIterativ<Integer>();
    int laenge = rekursiveListe.laenge();
    for (int i = 0; i < laenge; i++)
    {
        Integer wert = rekursiveListe.getNtenWert(i);
        if (wert != null)
        {
            iterativeListe.anhaengen(wert);
        }
    }
}

/**
 * Hilfsklasse für interaktive GUI-Buttons.
 */
class Button
{
    float x, y, w, h;
    String label;
    color col;
    
    Button(float x, float y, float w, float h, String label, color col)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.label = label;
        this.col = col;
    }
    
    void zeichnen()
    {
        boolean hover = mouseOver();
        
        // Hover-Effekt: Etwas hellere Farbe, wenn die Maus darüber schwebt
        color zeichnFarbe = hover ? lerpColor(col, color(255), 0.15) : col;
        
        fill(zeichnFarbe);
        stroke(255, 30);
        strokeWeight(1);
        rect(x, y, w, h, 6);
        
        fill(255);
        textSize(12);
        textAlign(CENTER, CENTER);
        text(label, x + w / 2, y + h / 2 - 2);
    }
    
    boolean mouseOver()
    {
        float lmX = mouseX / GUI_SCALE;
        float lmY = mouseY / GUI_SCALE;
        return lmX >= x && lmX <= x + w && lmY >= y && lmY <= y + h;
    }
}