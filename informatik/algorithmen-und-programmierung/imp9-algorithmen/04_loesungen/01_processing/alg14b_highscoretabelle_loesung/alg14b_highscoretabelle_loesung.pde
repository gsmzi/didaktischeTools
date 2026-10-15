
/**
 * Balkendiagramm für int-Array, Zahlen werden aus CSV-Datei gelesen, Umwandlung in sortierte Tabelle.
 * Hinweis zur Benutzung: 
 * Klicke in das Zeichenfenster
 * Start des Algorithmus "wastutes" mit Taste "a"
 * @author Schaller 
 * @version 29.11.18
 */


// Liste mit allen Werten //<>// //<>// //<>//
int[]    zahlen;    
String[] namen;

// Hilfsvariablen für die Suche
int akt_maximum=-1;    // aktuell groesstes Element
int akt=-2;            // aktuell untersuchtes Element
int verzoegerung=1000;  // Geschwindigkeit der Ausführung

// Schriften
PFont kleineSchrift;  
PFont grosseSchrift;


public void setup() {
  // Zeichenfläche erzeugen
  size(1000, 700);
  background(0);
  // Schriften laden
  kleineSchrift = loadFont("KleineSchrift.vlw");
  grosseSchrift = loadFont("GrosseSchrift.vlw");

  // CSV-Datei laden und anzeigen
  ladeTabelle("punkte.csv");
  zeichneBalken();
}

public void draw() {
  zeichneBalken();
}

public void keyPressed() {
  // Animierte Suche mit Taste "a"
  if (key=='a') {
    thread("wastutes");
  }
}



public void ladeTabelle(String name) {
  // Tabelle aus CSV-Datei laden
  Table csv = loadTable(name, "header,csv");

  if (csv != null  && csv.getColumnCount()==2) {

    // Initialisiere Arrays, in die alle Zeilen der Tabelle passen
    zahlen = new int[csv.getRowCount()];
    namen = new String[csv.getRowCount()];

    // Fülle die Arrays mit Werten aus der Tabelle
    for (int i = 0; i < zahlen.length; i++) {
      // Lies Wert aus der i. Zeile und der Spalte "Punkte" bzw. "Name"
      zahlen[i] = csv.getInt(i, "Punkte");
      namen[i] = csv.getString(i, "Name");
    }
  }
}

public void zeichneBalken() {

  clear();

  // Überschrift
  fill(255, 255, 255);
  textFont(grosseSchrift);
  text("Punkte", 2, 20);
  textFont(kleineSchrift);  

  // Alle Einträge darstellen
  if (zahlen != null) {
    for (int i = 0; i< zahlen.length; i++) {

      fill(20, 25, 165);
      // aktuelle Elemente farblich hervorheben
      if (i == akt || i == akt+1 ) {
        fill(140, 230, 20);
      } 

      // Balkendiagramm zeichnen
      if (zahlen[i]>=0) rect(120, 25+i*15, zahlen[i]+1, 13);

      // Beschriftung
      fill(255, 255, 255);
      text(namen[i], 2, 35+i*15);
      text(zahlen[i], 70, 35+i*15);
    }
  }
}


public void wastutes() {
  // Sind überhaupt Daten da?
  if (zahlen.length==0 ) {
    return;
  }


  // Wiederholen den Durchlauf n-1 mal
  for (int i = 1; i< zahlen.length; i++) {
    // Durchlaufe alle Array-Elemente
    for (akt=0; akt+1 < zahlen.length; akt++) {
      // Neu zeichnen, da akt neu gesetzt wurde 
      redraw();
      delay(verzoegerung);
      // Vergleiche mit Nachbarelement. Falsch sortiert?
      if (zahlen[akt+1]> zahlen[akt]) {
        // Dreieckstausch bei Zahlen und Namen 
        int dummy = zahlen[akt];
        zahlen[akt] = zahlen[akt+1];
        zahlen[akt+1] = dummy;

        String s = namen[akt];
        namen[akt] = namen[akt+1];
        namen[akt+1] = s;

        // Zeichne Balken neu, da getauscht wurde
        redraw();
        delay(verzoegerung);
      }
    }
  }
  // Sortierung beendet
  akt = -2;
}
