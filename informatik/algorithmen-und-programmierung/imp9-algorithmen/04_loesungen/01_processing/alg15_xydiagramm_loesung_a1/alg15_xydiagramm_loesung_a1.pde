/**
 * XY-Diagramm für Schalldruckpegel, Zahlen werden aus CSV-Datei gelesen.
 * 
 * @author Schaller 
 * @version 29.11.18
 */
 
 // Liste mit allen Werten
double[] x_werte;    
double[] y_werte;    

// Hilfsvariablen für die Suche
int akt_maximum=-1;    // aktuell groesstes Element
int akt=-1;            // aktuell untersuchtes Element
int verzoegerung=0;  // Geschwindigkeit der Ausführung

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
  ladeTabelle("Amplitudes.csv");
  stroke(250,250,200);
  zeichneBalken();
}

 //<>//
public void ladeTabelle(String name) {
  // Tabelle aus CSV-Datei laden //<>//
  Table csv = loadTable(name, "header,csv");

  if (csv != null  && csv.getColumnCount()==2) {

    // Initialisiere Arrays, in die alle Zeilen der Tabelle passen
    x_werte = new double[csv.getRowCount()];
    y_werte = new double[csv.getRowCount()];

    // Fülle die Arrays mit Werten aus der Tabelle
    for (int i = 0; i < x_werte.length; i++) {
      // Lies Wert aus der i. Zeile und der Spalte "Punkte" bzw. "Name"
      x_werte[i] = csv.getDouble(i, "Time (s)");
      y_werte[i] = csv.getDouble(i, "Sound pressure level (dB)");
    }
  }
}

public void zeichneBalken() {


  // Überschrift
  fill(255,255,255);
  textFont(grosseSchrift);
  text("Lärmpegel", 2, 20);
  textFont(kleineSchrift);  

  // Alle Einträge darstellen
  if (x_werte != null) {
    for (int i = 0; i< x_werte.length; i++) {

      fill(20,25,165);
      // aktuelle Elemente farblich hervorheben
      if (i == akt) {
        fill(140,230,20);
      } 
      if (i == akt_maximum) {
        fill(230,60,140);
      } 

      // Balkendiagramm zeichnen
      int breite = (int) y_werte[i];
      if (x_werte[i]>=0) rect(160, 25+i*15, breite+1, 13);

      // Beschriftung
      fill(255,255,255);
      text(""+x_werte[i], 2, 35+i*15);
      text(""+y_werte[i], 70, 35+i*15);
    }
  }
}


public int sucheMaximum(int[] zahlen) {
  // Sind überhaupt Daten da?
  if (zahlen.length==0 ) {
    return -1;
  }

  // Startwerte setzen
  akt_maximum = 0;
  akt = 1;

  // Alle Arrayelemente untersuchen
  while (akt < zahlen.length) {

    // Neues größtes Element??
    if (zahlen[akt]> zahlen[akt_maximum]) {
      // Dann merke dir das neue 
      akt_maximum = akt;

    }
    akt = akt + 1;
  }
  // Gib Position des größten Elements zurück
  return akt_maximum;
} //<>//
