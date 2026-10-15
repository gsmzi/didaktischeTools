/**
 * Automatische Zeitungsmeldung mit Maximum und Durchschnitt, Zahlen werden aus CSV-Datei gelesen.
 * 
 * @author Schaller 
 * @version 29.11.18
 */
 
// Liste mit allen Werten
int[]    punkte;    
String[] namen;

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
  int summe = berechneSumme(punkte);
  System.out.println("Summe: "+summe);
  schreibeZeitungsmeldung();
}

public void ladeTabelle(String name) { //<>//
  // Tabelle aus CSV-Datei laden //<>//
  Table csv = loadTable(name, "header,csv");

  if (csv != null  && csv.getColumnCount()==2) {

    // Initialisiere Arrays, in die alle Zeilen der Tabelle passen
    punkte = new int[csv.getRowCount()];
    namen = new String[csv.getRowCount()];

    // Fülle die Arrays mit Werten aus der Tabelle
    for (int i = 0; i < punkte.length; i++) {
      // Lies Wert aus der i. Zeile und der Spalte "Punkte" bzw. "Name"
      punkte[i] = csv.getInt(i, "Punkte");
      namen[i] = csv.getString(i, "Name");
    }
  }
}

public void schreibeZeitungsmeldung() {

  clear();

  // Überschrift
  fill(225,225,255);
  stroke(155,155,255);
  textFont(grosseSchrift);
  text("BREAKING NEWS",5,32);
  strokeWeight(3);
  line(2,4,400,4);
  line(2,45,400,45);
  strokeWeight(2);
  line(2,7,400,7);
  line(2,42,400,42);
  strokeWeight(1);
  textFont(kleineSchrift); 
  fill(240);
  
  int anzahlSpieler   = anzahlSpieler(namen);
  int anzahlSpiele    = punkte.length;
  int summe           = berechneSumme(punkte);
  double durchschnitt = berechneDurchschnitt(punkte);
  
  text("Großartiges Ergebnis - Klasse XY nimmt an Binärwettbewerb teil.", 2, 60);
  text("Die Klasse XY hat beim diesjährigen Binärwettbewerb teilgenommen", 2, 82);
  text("und ein großartiges Ergebnis erzielt. Die "+anzahlSpieler+" Schülerinnen und", 2, 94);
  text("Schüler der Klasse erreichten in "+anzahlSpiele+" Spielen eine Gesamtpunktzahl",2,106);
  text("von "+summe+". Das ist ein Durchschnitt von "+durchschnitt+" pro Spiel.",2,118);

}


public int berechneSumme(int[] zahlen) {
  int summe;

  // Sind überhaupt Daten da?
  if(zahlen.length==0 ) { //<>//
    return -1;
  }
  
  // Startwerte setzen
  summe = 0;
  
  // Alle Arrayelemente untersuchen
  for (int i=0; i< zahlen.length; i++) {
    summe = summe + zahlen[i];
  }
  // Gib die Summe zurück
  return summe;
}


public double berechneDurchschnitt(int[] zahlen) {
   double durchschnitt;
   
   // Berechne Durchschnitt aus der Summe
   durchschnitt = (double) berechneSumme(zahlen)/zahlen.length;
   
   return durchschnitt;
}

public int anzahlSpieler(String[] namen) {
  int anzahl;
  boolean gefunden;
  // Startwerte setzen
  anzahl = 0;
  
  // Nach jedem Namen suchen
  for(int i=0; i< namen.length; i ++) {
    // Prüfe, ob der i. Name ein neuer Name ist
    // Kontrolliere dazu alle vorhergehenden, ob ein gleicher Name dabei ist.
    gefunden = false;
    for(int j=0; j < i; j++) {
      // Wenn der Name gleich ist, dann merke dir das
      if(namen[i].equals(namen[j])) {
        gefunden = true;
      }
    }
    // Wenn nach Kontrolle aller vorhergehender Namen der aktuelle nicht dabei
    // ist, dann ist er neu und muss gezählt werden.
    if (!gefunden) {
      anzahl++;
    }
  }
  return anzahl;
}
