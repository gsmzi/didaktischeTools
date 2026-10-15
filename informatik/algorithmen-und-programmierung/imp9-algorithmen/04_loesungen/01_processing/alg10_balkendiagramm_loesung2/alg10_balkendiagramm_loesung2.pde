// Programm zur Darstellung eines Arrays als Balkendiagramm
// Autor: Thomas Schaller
// Version: 1.0 vom 12.02.2019

 // Liste mit allen Werten //<>//
int[]   zahlen={45, 23, 123, 87, 98, 2, 1, 23, 23, 34};    
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
  // Balkendiagramm zeichnen
  zeichneBalken();
}

public void zeichneBalken() {

  clear();
  
  // Überschrift
  fill(255,255,255);
  textFont(grosseSchrift);
  text("Balkendiagramm", 2, 20);
  textFont(kleineSchrift);  

  // Alle Einträge darstellen
  if(zahlen != null) {
    for (int i = 0; i< zahlen.length; i++) {
      
      fill(20,30,170);
      
      // Balkendiagramm zeichnen
      if(zahlen[i]>=0) rect(120, 25+i*15, zahlen[i]+1, 13);
      
      // Beschriftung
      fill(255,255,255);
      text("i="+i, 2, 35+i*15);
      text("zahlen["+i+"]="+zahlen[i], 30, 35+i*15);
    }
  }
}
