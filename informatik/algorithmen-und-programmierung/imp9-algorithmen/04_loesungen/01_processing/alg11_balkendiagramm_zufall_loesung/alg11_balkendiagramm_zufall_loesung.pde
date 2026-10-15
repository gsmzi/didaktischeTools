/**
 * Balkendiagramm für int-Array, Zahlen werden zufällig erzeugt.
 * 
 * @author Schaller 
 * @version 29.11.18
 */

 // Liste mit allen Werten //<>//
int[]   zahlen;    
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
  
  // Zufallszahlen erzeugen und anzeigen
  erzeugeZufallsarray(20);
  zeichneBalken();
}

public int getZufallszahl(int min, int max) {
  java.util.Random r = new java.util.Random();
  return r.nextInt(max-min+1)+min;
}

public void erzeugeZufallsarray(int laenge) {
  // Neues Array der richtigen Länge erzeugen
  zahlen = new int[laenge];
  
  // Jedes Element mit einer Zufallszahl belegen
  for(int i= 0; i< laenge; i++) {
    zahlen[i] = getZufallszahl(1, 300);
  }
}
  

public void zeichneBalken() {

  clear();
  
  // Überschrift
  fill(255,255,255);
  textFont(grosseSchrift);
  text("Balkendiagramm", 2, 20);
  textFont(kleineSchrift);  

  // Alle Einträge darstellen
  for (int i = 0; i< zahlen.length; i++) {
    
    fill(20,30,170);
    
    // Balkendiagramm zeichnen
    rect(120, 25+i*15, zahlen[i]+1, 13);
    
    // Beschriftung
    fill(255,255,255);
    text("i="+i, 2, 35+i*15);
    text("zahlen["+i+"]="+zahlen[i], 30, 35+i*15);
  }
}
