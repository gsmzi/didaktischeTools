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
  ladeTabelle("punkte.xml");
  zeichneBalken();
}


public void ladeTabelle(String name) {
  // Tabelle aus XML-Datei laden
  XML xml = loadXML(name);
  XML[] rows = xml.getChildren("Row");
  
  // Initialisiere Arrays, in die alle Zeilen passen
  zahlen = new int[rows.length];
  namen  = new String[rows.length];
  
  // Fülle die Arrays mit Werten aus der Tabelle
  for (int i = 0; i < zahlen.length; i++) {
    // Lies Wert aus der i. Zeile und dort den Unterpunkten "Punkte" bzw. "Name"
    XML eintragPunkte = rows[i].getChild("Punkte");
    XML eintragName = rows[i].getChild("Name");
    
    zahlen[i] = eintragPunkte.getIntContent();
    namen[i] = eintragName.getContent();
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
