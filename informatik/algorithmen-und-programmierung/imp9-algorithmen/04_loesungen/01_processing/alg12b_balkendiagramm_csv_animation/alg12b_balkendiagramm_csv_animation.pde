/**
 * Balkendiagramm für int-Array, Zahlen werden aus CSV-Datei gelesen.
 * 
 * @author Schaller 
 * @version 29.11.18
 */

 // Liste mit allen Werten //<>//
int[]    zahlen;    
String[] namen;
// Variablen für Animation
int x=0;
int y=0; 
int rot = 20;
int gruen = 100; 
int blau = 70;
 // Schriften
PFont kleineSchrift;  
PFont grosseSchrift;


public void setup() {
  // Zeichenfläche erzeugen
  size(1000, 700);
  background(0);
  // Schriften laden
  kleineSchrift = loadFont("KleineSchrift.vlw");  grosseSchrift = loadFont("GrosseSchrift.vlw");
  
  // CSV-Datei laden und anzeigen
  ladeTabelle("punkte.csv");
  zeichneBalken();
}

void draw() {
    background(0);
     zeichneBalken(); 
     x =(x+1) % width;
     y=(y+2) % height ;
     rot = (rot +1) % 256; 
     gruen =(gruen +2)%256; 
     blau = (blau +3)%256; 
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
  
    fill(rot,gruen,blau);
    
    // Balkendiagramm zeichnen
    rect(x+120, y+25+i*15, zahlen[i]+1, 13);
    
    // Beschriftung
    fill(255,255,255);
    text(namen[i], x+2, y+35+i*15);
    text(""+zahlen[i], x+70, y+35+i*15);
  }
}
