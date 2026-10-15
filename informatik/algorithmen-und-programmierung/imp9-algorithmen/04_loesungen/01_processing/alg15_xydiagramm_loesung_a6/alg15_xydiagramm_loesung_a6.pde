/**
 * XY-Diagramm für Schalldruckpegel, Zahlen werden aus CSV-Datei gelesen.
 * 
 * @author Schaller 
 * @version 29.11.18
 */

// Liste mit allen Werten //<>//
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
  stroke(250, 250, 250);
  zeichneXYDiagramm(40);
  stroke(250, 100, 100);
  zeichneXYDiagramm(100);
}


public void ladeTabelle(String name) {
  // Tabelle aus CSV-Datei laden
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

public void zeichneXYDiagramm(int schrittweite) {


  // Überschrift
  fill(255, 255, 255);
  textFont(grosseSchrift);
  text("Lärmpegel", 2, 20);
  textFont(kleineSchrift);  

  // Alle Einträge darstellen
  if (x_werte != null) {
    // Maximum bestimmen
    int max_x_pos = sucheMaximum(x_werte);
    int max_y_pos = sucheMaximum(y_werte);
    double max_x = x_werte[max_x_pos];
    double max_y = y_werte[max_y_pos];

    // Skalierungsfaktoren
    double faktor_x = 1000.0 / max_x;
    double faktor_y = 700.0 / max_y;

    for (int i = 0; i+schrittweite< x_werte.length; i+=schrittweite) {

      // Durchschnitt berechnen
      double x_durchschnitt1 = berechneDurchschnitt(x_werte,i,schrittweite);
      double y_durchschnitt1 = berechneDurchschnitt(y_werte,i,schrittweite);
      double x_durchschnitt2 = berechneDurchschnitt(x_werte,i+schrittweite,schrittweite);
      double y_durchschnitt2 = berechneDurchschnitt(y_werte,i+schrittweite,schrittweite);
      // Linien zeichnen
      int x1 = (int) (x_durchschnitt1*faktor_x);
      int y1 = (int) (700- y_durchschnitt1*faktor_y);
      int x2 = (int) (x_durchschnitt2*faktor_x);
      int y2 = (int) (700- y_durchschnitt2*faktor_y);
      System.out.println("x1:"+x1+"y1:"+y1);


      line(x1,y1,x2,y2);
    }
  }
}


public int sucheMaximum(double[] zahlen) {
  // Sind überhaupt Daten da?
  if (zahlen.length==0 ) {
    return -1;
  }

  // Startwerte setzen
  akt_maximum = 0;
  akt = 1;

  // Alle Arrayelemente untersuchen
  while (akt < zahlen.length) {
    // Neu zeichnen, da akt neu gesetzt wurde 
    redraw();
    delay(verzoegerung);
    // Neues größtes Element??
    if (zahlen[akt]> zahlen[akt_maximum]) {
      // Dann merke dir das neue 
      akt_maximum = akt;
      // Zeichne Balken neu, da neues größtes Element
      redraw();
      delay(verzoegerung);
    }
    akt = akt + 1;
  }
  // Gib Position des größten Elements zurück
  return akt_maximum;
}



public double berechneDurchschnitt(double[] zahlen, int start, int n) {
  double summe;
  int i;

  // Sind überhaupt Daten da?
  if(zahlen.length==0 ) {
    return -1;
  }
  
  // Startwerte setzen
  summe = 0;
  
  // n Arrayelemente ab start addieren
  for (i=0; start+i< zahlen.length && i<n; i++) {
    summe = summe + zahlen[start+i];
  }

  // Gib die Durchschnitt zurück
  return summe/i;
}  
