/**
 * Balkendiagramm für int-Array, Zahlen werden aus CSV-Datei gelesen, Maximum der Werte wird bestimmt.
 * Hinweis zur Benutzung:
 * Klicke in das Zeichenfenster
 * Animierte Suche mit Taste "a"
 * Automatisches Testen mit Taste "t"* 
 * @author Schaller 
 * @version 29.11.18
 */
 

// Liste mit allen Werten //<>//
int[]    zahlen;    
String[] namen;


// Hilfsvariablen für die Suche
// -------------------------------------------------------------------
// ToDo: Hilfsvariablen erzeugen für aktuell größtes und aktuell 
//       untersuchtes Element
// -------------------------------------------------------------------
                        // aktuell groesstes Element
                        // aktuell untersuchtes Element
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
    thread("maximumsuche");
  }

  // Automatisches Testen mit Taste "t"
  if(key == 't') {
    // Testfall 1
    verzoegerung = 0;
    ladeTabelle("testfall1.csv");
    int m1 = maximumsuche();
    if (m1 == 12) {
      System.out.println("Maximum korrekt gefunden. In Datei testfall1.csv ist der größte Wert "+ zahlen[m1]+" von "+namen[m1]+" an Position "+m1);
    } else {
      System.out.println("Maximum in testfall.csv nicht gefunden. Du ermittelst "+m1+" richtig wäre 12");
    }
    // Testfall 2: negative Zahlen
    ladeTabelle("testfall2.csv");
    int m2 = maximumsuche();
    if (m2 == 3) {
      System.out.println("Maximum korrekt gefunden. In Datei testfall2.csv ist der größte Wert "+ zahlen[m2]+" von "+namen[m2]+" an Position "+m2);
    } else {
      System.out.println("Maximum in testfall2.csv nicht gefunden. Du ermittelst "+m2+" richtig wäre 3");
    }
    // Testfall 3: Nur 1 Element
    ladeTabelle("testfall3.csv");
    int m3 = maximumsuche();
    if (m3 == 0) {
      System.out.println("Maximum korrekt gefunden. In Datei testfall3.csv ist der größte Wert "+ zahlen[m3]+" von "+namen[m3]+" an Position "+m3);
    } else {
      System.out.println("Maximum in testfall3.csv nicht gefunden. Du ermittelst "+m3+" richtig wäre 0");
    }
    // Testfall 4: Leere Liste
    ladeTabelle("testfall4.csv");
    int m4 = maximumsuche();
    if (m4 == -1) {
      System.out.println("Maximum korrekt gefunden. Da die Datei keine Spieler enthält wird -1 zurückgegeben.");
    } else {
      System.out.println("Maximum in testfall4.csv nicht gefunden. Du ermittelst "+m4+" richtig wäre -1, da die Datei leer ist.");
    }    
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
  fill(255,255,255);
  textFont(grosseSchrift);
  text("Punkte", 2, 20);
  textFont(kleineSchrift);  

  // Alle Einträge darstellen
  if (zahlen != null) {
    for (int i = 0; i< zahlen.length; i++) {

      fill(20,25,165);
      // aktuelle Elemente farblich hervorheben
      // ----------------------------------------------------------------------
      // ToDo: Falls i dem aktuell untersuchtem oder der aktuellen Maximal-
      //       position entspricht, muss eine andere Farbe gewählt werden
      // ----------------------------------------------------------------------
      
      // Balkendiagramm zeichnen
      if (zahlen[i]>=0) rect(120, 25+i*15, zahlen[i]+1, 13);

      // Beschriftung
      fill(255,255,255);
      text(namen[i], 2, 35+i*15);
      text(""+zahlen[i], 70, 35+i*15);
    }
  }
}


public int maximumsuche() {
  // ------------------------------------------------------------------------------
  // ToDO: Implementiere die Maximumsuche, füge nach jeder Veränderung der
  //       Position des aktuellen Elements oder der Position des momentanen Maximums
  //       die Befehle: redraw(); und delay(verzoegerung); ein.
  //       Als Ergebnis soll die Methode die Position des Maximums zurückgeben
  //       Kommentiere die Maximumsuche
  // ------------------------------------------------------------------------------
  //<>//
  return -1;
}
