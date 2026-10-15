/**
 * Balkendiagramm für int-Array, Zahlen werden aus CSV-Datei gelesen.
 * 
 * @author Schaller 
 * @version 29.11.18
 */

 // Liste mit allen Werten //<>//
int[]    zahlen;    
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
  zeichneBalken();
}


public void ladeTabelle(String name) {
  // Tabelle aus CSV-Datei laden
  Table csv = loadTable(name,"header,csv");
  
  // Initialisiere Arrays, in die alle Zeilen der Tabelle passen
  zahlen = new int[csv.getRowCount()];
  namen = new String[csv.getRowCount()];
  
  // Fülle die Arrays mit Werten aus der Tabelle
  for (int i = 0; i < zahlen.length; i++) {
    // Lies Wert aus der i. Zeile und der Spalte "Punkte" bzw. "Name"
    zahlen[i] = csv.getInt(i,"Punkte");
    namen[i] = csv.getString(i,"Name");
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

  for (int i = 0; i< zahlen.length; i++) {
  
    fill(20,30,170);
    
    // Balkendiagramm zeichnen
    rect(120, 25+i*15, zahlen[i]+1, 13);
    
    // Beschriftung
    fill(255,255,255);
    text(namen[i], 2, 35+i*15);
    text(""+zahlen[i], 70, 35+i*15);
  }
}
