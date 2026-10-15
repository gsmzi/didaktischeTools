import java.awt.Point;

/**
 * Zustand eines Schritts auf dem Backtracking-Stack für den Sudoku-Löser.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
class StackState
{
    SudokuGitter gitter;
    Point guessPos;       // Zelle, in der geraten wurde
    int guessVal;         // Geratener Wert
    int nextCandidateIdx; // Nächster zu testender Kandidatenindex
    int[] candidates;     // Alle Kandidaten für guessPos
    
    StackState(SudokuGitter g)
    {
        this.gitter = g;
        this.guessPos = null;
        this.guessVal = -1;
        this.nextCandidateIdx = -1;
        this.candidates = null;
    }
}