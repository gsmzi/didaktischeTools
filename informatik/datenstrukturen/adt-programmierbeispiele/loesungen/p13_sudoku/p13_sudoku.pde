/**
 * Hauptprogramm: p13_sudoku (Musterlösung)
 * 
 * Bietet einen interaktiven Playground für Sudoku-Rätsel:
 * - Lädt 400 verschiedene Rätsel aus der Datenbank in vier Schwierigkeitsstufen.
 * - Visualisiert das 9x9-Gitter mit festen Werten, Kandidatenmengen (3x3-Hilfsziffern) und Widersprüchen.
 * - Simuliert das Backtracking-Konzept über einen Gitter-Zustandsstack (anstelle von AWT-Fenstern).
 * - Bietet manuelle Knöpfe für didaktische Schritte: "Kandidaten erstellen", "Eintragen" und "Backtracking-Schritt".
 * - Bietet eine automatische Lösungsfunktion (Deductions-Autoplay & Vollautomatisches Backtracking).
 * 
 * @author Antigravity
 * @version September 2026
 */

import java.awt.Point;
import java.awt.Color;
import java.util.ArrayList;

final float GUI_SCALE = 1.4;

// Log-Historie
ArrayList<String> aktionsLogs = new ArrayList<String>();

// Das aktuelle Rätsel
int raetselNummer = 100;

// Gitter-Zustands-Stack für Backtracking
ArrayList<StackState> stateStack = new ArrayList<StackState>();

// Buttons
Button btnKandidaten;
Button btnEintragen;
Button btnBacktrack;
Button btnZurueck;
Button btnDeductions;
Button btnVollautomatisch;

Button btnPrev1, btnNext1, btnPrev10, btnNext10, btnRandom;

// Zustand
boolean candidatesCreated = false;
boolean contradiction = false;
boolean solved = false;
boolean vollautomatischAktiv = false;
int lastAutoTime = 0;
int autoDelay = 300; // ms pro automatischem Schritt

void setup()
{
    size(1250, 800);
    surface.setResizable(true);
    
    // Steuerungsknöpfe
    color colStandard = color(51, 65, 85);    // Slate 700
    color colAktion = color(59, 130, 246);    // Blau
    color colGefahr = color(239, 68, 68);     // Rot
    color colAktiv = color(16, 185, 129);     // Grün
    
    // Gitter und Solver Buttons
    btnKandidaten = new Button(50, 160, 240, 26, "Kandidatenmengen erstellen", colStandard);
    btnEintragen = new Button(50, 195, 240, 26, "Eintragen (Einer-Regeln)", colStandard);
    btnBacktrack = new Button(50, 230, 240, 26, "Backtracking-Schritt (Raten)", colAktion);
    btnZurueck = new Button(50, 265, 240, 26, "Zurückgehen / Backtrack", colGefahr);
    
    btnDeductions = new Button(50, 310, 240, 26, "Logische Deductions-Autoplay", colAktiv);
    btnVollautomatisch = new Button(50, 345, 240, 26, "Vollautomatisch lösen", colAktiv);
    
    // Rätselauswahl Buttons
    btnPrev1 = new Button(150, 95, 25, 20, "-1", colStandard);
    btnNext1 = new Button(180, 95, 25, 20, "+1", colStandard);
    btnPrev10 = new Button(215, 95, 30, 20, "-10", colStandard);
    btnNext10 = new Button(250, 95, 30, 20, "+10", colStandard);
    btnRandom = new Button(288, 95, 45, 20, "Zufall", colAktion);
    
    loadPuzzle(raetselNummer);
}

void loadPuzzle(int nummer)
{
    raetselNummer = nummer;
    stateStack.clear();
    
    SudokuGitter g = new SudokuGitter(raetselNummer);
    stateStack.add(new StackState(g));
    
    candidatesCreated = false;
    contradiction = false;
    solved = false;
    vollautomatischAktiv = false;
    btnVollautomatisch.label = "Vollautomatisch lösen";
    btnVollautomatisch.col = color(16, 185, 129);
    
    logHinzufuegen("Rätsel Nr. " + raetselNummer + " geladen.");
    updateButtonStates();
}

SudokuGitter getActiveGitter()
{
    if (stateStack.isEmpty()) return null;
    return stateStack.get(stateStack.size() - 1).gitter;
}

StackState getActiveState()
{
    if (stateStack.isEmpty()) return null;
    return stateStack.get(stateStack.size() - 1);
}

void updateButtonStates()
{
    SudokuGitter g = getActiveGitter();
    if (g == null) return;
    
    solved = g.istGeloest();
    
    // Kandidaten-Knopf aktivieren, wenn noch keine Kandidaten erstellt wurden
    btnKandidaten.setEnabled(!candidatesCreated && !solved && !contradiction);
    
    // Eintragen aktivieren, wenn Kandidaten erstellt wurden und kein Widerspruch vorliegt
    btnEintragen.setEnabled(candidatesCreated && !solved && !contradiction);
    
    // Backtrack-Schritt (Raten) aktivieren, wenn wir Kandidaten haben, aber eintragen() keine Änderung mehr bringt
    // (stuck / stuck state), und kein Widerspruch vorliegt
    btnBacktrack.setEnabled(candidatesCreated && !solved && !contradiction);
    
    // Zurückgehen aktivieren, wenn wir uns in einem geratenen Zustand befinden (Stack-Tiefe > 0)
    btnZurueck.setEnabled(stateStack.size() > 1);
}

void erzeugeKandidaten()
{
    SudokuGitter g = getActiveGitter();
    if (g == null || solved || contradiction) return;
    
    boolean ok = g.kandidatenMengenErstellen();
    candidatesCreated = true;
    
    if (!ok)
    {
        contradiction = true;
        logHinzufuegen("Widerspruch gefunden! Eine Zelle hat keine Kandidaten mehr -> Backtracking nötig.");
    }
    else
    {
        logHinzufuegen("Kandidatenmengen erfolgreich erstellt.");
    }
    updateButtonStates();
}

void eintragenSchritt()
{
    SudokuGitter g = getActiveGitter();
    if (g == null || !candidatesCreated || solved || contradiction) return;
    
    boolean geaendert = g.eintragen();
    if (geaendert)
    {
        candidatesCreated = false; // Zurücksetzen, damit Kandidaten neu berechnet werden
        logHinzufuegen("Zahl eingetragen. Kandidaten müssen neu erstellt werden.");
    }
    else
    {
        logHinzufuegen("Keine Einer-Deduction möglich. Raten erforderlich (Backtracking-Schritt).");
    }
    updateButtonStates();
}

void backtrackSchritt()
{
    SudokuGitter g = getActiveGitter();
    StackState activeState = getActiveState();
    if (g == null || !candidatesCreated || solved || contradiction) return;
    
    // 1. Zelle mit kleinster Kandidatenmenge finden
    Point pos = g.getPositionVonKleinsterKandidatenmenge();
    if (pos == null)
    {
        if (g.istGeloest())
        {
            logHinzufuegen("Sudoku bereits gelöst!");
            solved = true;
        }
        return;
    }
    
    Kandidatenmenge km = (Kandidatenmenge)g.getEintrag(pos.x, pos.y);
    int[] candidates = km.alsArray();
    
    if (candidates.length == 0)
    {
        contradiction = true;
        logHinzufuegen("Kandidatenmenge ist leer! Sackgasse.");
        return;
    }
    
    // State für dieses Level einrichten (wo geraten wird)
    activeState.guessPos = pos;
    activeState.candidates = candidates;
    activeState.nextCandidateIdx = 0;
    
    // Ersten Versuch starten
    int val = candidates[0];
    activeState.guessVal = val;
    
    logHinzufuegen("Raten an Stelle (" + pos.x + "," + pos.y + ") -> Wert: " + val + " (Versuch 1 von " + candidates.length + ")");
    
    // Klon erzeugen und auf den Stack schieben
    SudokuGitter spNeu = g.klonErzeugen(pos.x, pos.y, val);
    stateStack.add(new StackState(spNeu));
    
    // Auf neuem Level anfangen
    candidatesCreated = false;
    contradiction = false;
    updateButtonStates();
}

void zurueckgehen()
{
    if (stateStack.size() <= 1) return;
    
    // Top entfernen (gescheiterten Versuch verwerfen)
    stateStack.remove(stateStack.size() - 1);
    
    // Parent-State aktualisieren
    StackState parentState = getActiveState();
    parentState.nextCandidateIdx++;
    
    if (parentState.nextCandidateIdx >= parentState.candidates.length)
    {
        // Alle Optionen auf diesem Level sind gescheitert! Wir müssen weiter zurück.
        logHinzufuegen("Alle Versuche an Stelle (" + parentState.guessPos.x + "," + parentState.guessPos.y + ") gescheitert.");
        contradiction = true;
        // Erneutes Zurückgehen nötig
        zurueckgehen();
    }
    else
    {
        // Nächsten Kandidaten probieren
        int val = parentState.candidates[parentState.nextCandidateIdx];
        parentState.guessVal = val;
        
        logHinzufuegen("Nächster Versuch an Stelle (" + parentState.guessPos.x + "," + parentState.guessPos.y + ") -> Wert: " + val + 
                       " (Versuch " + (parentState.nextCandidateIdx + 1) + " von " + parentState.candidates.length + ")");
        
        // Neuen Klon erzeugen und auf den Stack schieben
        SudokuGitter spNeu = parentState.gitter.klonErzeugen(parentState.guessPos.x, parentState.guessPos.y, val);
        stateStack.add(new StackState(spNeu));
        
        candidatesCreated = false;
        contradiction = false;
    }
    updateButtonStates();
}

// Führt logische Deductions aus, bis es nicht mehr weitergeht
void runDeductions()
{
    SudokuGitter g = getActiveGitter();
    if (g == null || solved || contradiction) return;
    
    logHinzufuegen("Starte logische Deductions...");
    
    boolean geaendert = true;
    while(geaendert && !solved && !contradiction)
    {
        // 1. Kandidaten erstellen
        boolean ok = g.kandidatenMengenErstellen();
        candidatesCreated = true;
        if (!ok)
        {
            contradiction = true;
            logHinzufuegen("Deduction Widerspruch: Zelle leer!");
            break;
        }
        
        // 2. Eintragen versuchen
        geaendert = g.eintragen();
        if (geaendert)
        {
            candidatesCreated = false;
        }
        
        solved = g.istGeloest();
    }
    
    if (solved)
    {
        logHinzufuegen("Sudoku durch logische Deductions gelöst!");
    }
    else if (!contradiction)
    {
        logHinzufuegen("Deductions beendet. Keine weiteren direkten Schlüsse möglich.");
    }
    updateButtonStates();
}

// Vollautomatisches Lösen: Ein Timer-basierter Schritt der Backtracking-Suche
void runVollautomatischStep()
{
    SudokuGitter g = getActiveGitter();
    if (g == null) return;
    
    if (g.istGeloest())
    {
        logHinzufuegen("Automatisch Gelöst!");
        vollautomatischAktiv = false;
        btnVollautomatisch.label = "Vollautomatisch lösen";
        btnVollautomatisch.col = color(16, 185, 129);
        updateButtonStates();
        return;
    }
    
    if (contradiction)
    {
        // Wenn ein Widerspruch vorliegt, müssen wir sofort zurückgehen
        logHinzufuegen("Auto: Widerspruch! Gehe zurück...");
        zurueckgehen();
        return;
    }
    
    if (!candidatesCreated)
    {
        // 1. Kandidatenmengen erstellen
        erzeugeKandidaten();
        return;
    }
    
    // 2. Versuchen einzutragen
    boolean geaendert = g.eintragen();
    if (geaendert)
    {
        candidatesCreated = false;
        logHinzufuegen("Auto: Zahl eingetragen.");
    }
    else
    {
        // Stuck! Wir müssen einen Backtracking-Schritt (Raten) ausführen
        logHinzufuegen("Auto: Keine logischen Schlüsse mehr. Starte Rate-Schritt.");
        backtrackSchritt();
    }
    updateButtonStates();
}

void draw()
{
    float w = width / GUI_SCALE;
    float h = height / GUI_SCALE;
    
    background(15, 23, 42); // Deep Slate
    
    // Vollautomatisch Timer
    if (vollautomatischAktiv && !solved)
    {
        int now = millis();
        if (now - lastAutoTime > autoDelay)
        {
            runVollautomatischStep();
            lastAutoTime = now;
        }
    }
    
    pushMatrix();
    scale(GUI_SCALE);
    
    // 1. Header
    fill(30, 41, 59);
    noStroke();
    rect(0, 0, w, 70);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text("Interaktives Backtracking-Sudoku", 30, 25);
    
    fill(148, 163, 184);
    textSize(11);
    text("Didaktische Visualisierung von logischer Elimination, Naked Pairs und Backtracking-Versuchsketten.", 30, 48);
    // Versionsnummer und Datum anzeigen
    fill(148, 163, 184);
    textSize(9);
    textAlign(RIGHT, BOTTOM);
    text("v1.0 (18.09.2026)", w - 30, 60);
    textAlign(LEFT, BASELINE); // Reset
    
    // Status-Badge
    fill(solved ? color(16, 185, 129, 40) : (contradiction ? color(239, 68, 68, 40) : color(245, 158, 11, 40)));
    stroke(solved ? color(16, 185, 129) : (contradiction ? color(239, 68, 68) : color(245, 158, 11)));
    strokeWeight(1);
    rect(w - 230, 20, 200, 30, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    String statusStr = "BEREIT / LOGIK";
    if (solved) statusStr = "GELÖST!";
    else if (contradiction) statusStr = "WIDERSPRUCH! (ZURÜCK)";
    else if (stateStack.size() > 1) statusStr = "VERSUCHSTIEFE: " + (stateStack.size() - 1);
    text(statusStr, w - 130, 34);
    
    // 2. Layout
    // Gitter zeichnen (Mitte/Links)
    pushMatrix();
    translate(30, 90);
    drawSudokuGitter(540, 540);
    popMatrix();
    
    // Trennlinie vertikal
    stroke(51, 65, 85);
    strokeWeight(1.5);
    line(590, 80, 590, h - 160);
    
    // SteuerungsPanel (Rechts)
    drawSteuerungsPanel(610, 90, 270, h - 270);
    
    // Stack Hierarchie (Ganz rechts)
    drawStackHierarchie(w - 320, 90, 290, h - 270);
    
    // Logger (Unten)
    drawLogger(w, h);
    
    popMatrix();
}

void drawSudokuGitter(float gw, float gh)
{
    // Container zeichnen
    fill(30, 41, 59, 150);
    stroke(51, 65, 85);
    strokeWeight(2);
    rect(0, 0, gw, gh, 8);
    
    SudokuGitter activeG = getActiveGitter();
    if (activeG == null) return;
    
    float cellW = gw / 9.0;
    float cellH = gh / 9.0;
    
    // 1. Zellenhintergründe & Werte zeichnen
    for (int x = 0; x < 9; x++)
    {
        for (int y = 0; y < 9; y++)
        {
            float cx = x * cellW;
            float cy = y * cellH;
            
            // Highlights bestimmen
            boolean istGemarkt = false;
            StackState activeState = getActiveState();
            // Wenn diese Zelle die Zelle ist, wo geraten wurde
            if (activeState.guessPos != null && activeState.guessPos.x == x && activeState.guessPos.y == y)
            {
                istGemarkt = true;
            }
            
            // Hintergrundfarbe
            noStroke();
            if (istGemarkt)
            {
                fill(140, 70, 120, 60); // Magenta-Glow für geratene Zelle
            }
            else if ((x/3 + y/3) % 2 == 0)
            {
                fill(15, 23, 42, 60); // Dezentes Schachbrettmuster für 3x3 Blöcke
            }
            else
            {
                fill(30, 41, 59, 60);
            }
            rect(cx, cy, cellW, cellH);
            
            // Gitterlinien dünn
            stroke(71, 85, 105, 120);
            strokeWeight(0.5);
            noFill();
            rect(cx, cy, cellW, cellH);
            
            // Eintrag zeichnen
            Eintrag e = activeG.getEintrag(x, y);
            if (e != null)
            {
                pushMatrix();
                e.zeichneDich(cx, cy, cellW, cellH);
                popMatrix();
            }
        }
    }
    
    // 2. Dicke Trennlinien für 3x3 Blöcke
    stroke(148, 163, 184);
    strokeWeight(3);
    for (int i = 0; i <= 3; i++)
    {
        line(i * cellW * 3, 0, i * cellW * 3, gh);
        line(0, i * cellH * 3, gw, i * cellH * 3);
    }
}

void drawSteuerungsPanel(float x, float y, float w, float h)
{
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    fill(241, 245, 249);
    textSize(12);
    textAlign(LEFT, TOP);
    text("Rätsel-Datenbank:", x + 20, y + 15);
    
    // Rätsel Nummer & Schwierigkeit
    fill(255);
    textSize(11);
    text("Rätsel Nr. " + raetselNummer, x + 30, y + 40);
    
    String diff = "Einfach";
    if (raetselNummer >= 100 && raetselNummer < 200) diff = "Mittel";
    else if (raetselNummer >= 200 && raetselNummer < 300) diff = "Schwer";
    else if (raetselNummer >= 300) diff = "Sehr schwer";
    fill(148, 163, 184);
    text("Schwierigkeit: " + diff, x + 30, y + 56);
    
    // Auswahltaster
    btnPrev1.x = x + 20; btnPrev1.y = y + 75; btnPrev1.zeichnen();
    btnNext1.x = x + 50; btnNext1.y = y + 75; btnNext1.zeichnen();
    btnPrev10.x = x + 85; btnPrev10.y = y + 75; btnPrev10.zeichnen();
    btnNext10.x = x + 120; btnNext10.y = y + 75; btnNext10.zeichnen();
    btnRandom.x = x + 160; btnRandom.y = y + 75; btnRandom.zeichnen();
    
    stroke(51, 65, 85);
    line(x + 20, y + 110, x + w - 20, y + 110);
    
    // Didaktische Aktionen
    fill(241, 245, 249);
    textSize(12);
    text("Lösungsschritte (Manuell):", x + 20, y + 125);
    
    btnKandidaten.x = x + 20; btnKandidaten.y = y + 145; btnKandidaten.w = w - 40; btnKandidaten.zeichnen();
    btnEintragen.x = x + 20; btnEintragen.y = y + 180; btnEintragen.w = w - 40; btnEintragen.zeichnen();
    btnBacktrack.x = x + 20; btnBacktrack.y = y + 215; btnBacktrack.w = w - 40; btnBacktrack.zeichnen();
    btnZurueck.x = x + 20; btnZurueck.y = y + 250; btnZurueck.w = w - 40; btnZurueck.zeichnen();
    
    line(x + 20, y + 290, x + w - 20, y + 290);
    
    // Auto Aktionen
    fill(241, 245, 249);
    text("Autopilot:", x + 20, y + 305);
    
    btnDeductions.x = x + 20; btnDeductions.y = y + 325; btnDeductions.w = w - 40; btnDeductions.zeichnen();
    btnVollautomatisch.x = x + 20; btnVollautomatisch.y = y + 360; btnVollautomatisch.w = w - 40; btnVollautomatisch.zeichnen();
}

void drawStackHierarchie(float x, float y, float w, float h)
{
    // Hierarchie Rahmen
    fill(30, 41, 59, 120);
    stroke(51, 65, 85);
    rect(x, y, w, h, 8);
    
    fill(241, 245, 249);
    textSize(12);
    textAlign(LEFT, TOP);
    text("Backtracking-Stack (Ebenen):", x + 20, y + 15);
    
    textSize(10);
    fill(148, 163, 184);
    text("Jeder Rate-Schritt klont das Gitter.", x + 20, y + 35);
    
    // Liste der Ebenen
    float sy = y + 60;
    for (int i = 0; i < stateStack.size(); i++)
    {
        StackState state = stateStack.get(i);
        boolean istAktiv = (i == stateStack.size() - 1);
        
        // Kasten für diesen Level
        fill(istAktiv ? color(99, 102, 241, 40) : color(15, 23, 42, 60));
        stroke(istAktiv ? color(99, 102, 241) : color(51, 65, 85));
        rect(x + 15, sy + i * 42, w - 30, 36, 4);
        
        fill(255);
        textSize(10.5);
        String label = "Ebene " + i + ": ";
        if (i == 0)
        {
            label += "Originalrätsel";
        }
        else
        {
            label += "Raten (" + state.guessPos.x + "," + state.guessPos.y + ") <- " + state.guessVal;
        }
        text(label, x + 25, sy + i * 42 + 6);
        
        // Zusatzinfos
        fill(148, 163, 184);
        textSize(9);
        if (i > 0)
        {
            text("Versuch " + (state.nextCandidateIdx + 1) + " von " + state.candidates.length, x + 25, sy + i * 42 + 20);
        }
        else
        {
            text("Start-Zustand des Gitters", x + 25, sy + i * 42 + 20);
        }
    }
    
    if (stateStack.isEmpty())
    {
        fill(239, 68, 68);
        text("Kein Gitter geladen.", x + 20, sy);
    }
}

void drawLogger(float w, float h)
{
    float logW = w - 60;
    float logH = 110;
    float logY = h - 140;
    
    fill(15, 23, 42);
    stroke(51, 65, 85);
    strokeWeight(1);
    rect(30, logY, logW, logH, 8);
    
    fill(51, 65, 85);
    rect(30, logY, logW, 22, 8, 8, 0, 0);
    fill(148, 163, 184);
    textSize(9.5);
    textAlign(LEFT, CENTER);
    text("SUDOKU PROTOKOLL & LOGS", 45, logY + 11);
    
    textSize(10.5);
    textAlign(LEFT, TOP);
    for (int i = 0; i < aktionsLogs.size(); i++)
    {
        fill(226, 232, 240, 255 - (aktionsLogs.size() - 1 - i) * 50);
        text(aktionsLogs.get(i), 45, logY + 30 + i * 15);
    }
}

void mousePressed()
{
    // 1. Rätsel-Selektor
    if (btnPrev1.mouseOver()) loadPuzzle(max(0, raetselNummer - 1));
    if (btnNext1.mouseOver()) loadPuzzle(min(399, raetselNummer + 1));
    if (btnPrev10.mouseOver()) loadPuzzle(max(0, raetselNummer - 10));
    if (btnNext10.mouseOver()) loadPuzzle(min(399, raetselNummer + 10));
    if (btnRandom.mouseOver()) loadPuzzle((int)random(400));
    
    // 2. Didaktische Aktionen
    if (btnKandidaten.mouseOver() && btnKandidaten.isEnabled())
    {
        erzeugeKandidaten();
    }
    if (btnEintragen.mouseOver() && btnEintragen.isEnabled())
    {
        eintragenSchritt();
    }
    if (btnBacktrack.mouseOver() && btnBacktrack.isEnabled())
    {
        backtrackSchritt();
    }
    if (btnZurueck.mouseOver() && btnZurueck.isEnabled())
    {
        zurueckgehen();
    }
    
    // 3. Auto Aktionen
    if (btnDeductions.mouseOver() && btnDeductions.isEnabled())
    {
        runDeductions();
    }
    if (btnVollautomatisch.mouseOver())
    {
        vollautomatischAktiv = !vollautomatischAktiv;
        if (vollautomatischAktiv)
        {
            btnVollautomatisch.label = "Pause";
            btnVollautomatisch.col = color(245, 158, 11); // Orange
            lastAutoTime = millis();
            logHinzufuegen("Vollautomatisches Backtracking gestartet...");
        }
        else
        {
            btnVollautomatisch.label = "Vollautomatisch lösen";
            btnVollautomatisch.col = color(16, 185, 129); // Grün
            logHinzufuegen("Autopilot pausiert.");
        }
    }
}

void logHinzufuegen(String msg)
{
    String zeit = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    aktionsLogs.add("[" + zeit + "] " + msg);
    if (aktionsLogs.size() > 5)
    {
        aktionsLogs.remove(0);
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
    boolean enabled = true;
    
    Button(float x, float y, float w, float h, String label, color col)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.label = label;
        this.col = col;
    }
    
    void setEnabled(boolean state)
    {
        this.enabled = state;
    }
    
    boolean isEnabled()
    {
        return this.enabled;
    }
    
    void zeichnen()
    {
        boolean hover = mouseOver() && enabled;
        color zeichnFarbe = hover ? lerpColor(col, color(255), 0.15) : col;
        
        if (!enabled)
        {
            zeichnFarbe = color(30, 41, 59, 100); // Gedimmt für disabled
        }
        
        fill(zeichnFarbe);
        stroke(255, 30);
        strokeWeight(1);
        rect(x, y, w, h, 4);
        
        if (enabled)
        {
            fill(255);
        }
        else
        {
            fill(100, 116, 139); // Slate 500 for disabled text
        }
        textSize(10);
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