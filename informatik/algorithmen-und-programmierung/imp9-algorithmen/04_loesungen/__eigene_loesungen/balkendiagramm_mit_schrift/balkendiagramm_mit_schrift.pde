// Deklaration der Variablen...
int[] zahlen={-20, 0, 145, 87, 98, 2, 1, 23, 23, 24, 56};
// 45, 23, 145, 87, 98, 2, 1, 23, 23, 24, 56

// Schriften
PFont ueberschrift;
PFont beschriftung_balken;

// setup-Methode
void setup() {
  size(1000, 700);  // Fenstergröße
  background(255);  // Hintergrundfarbe weiß

  // Schriften
  ueberschrift = createFont("Calibri", 48);
  beschriftung_balken = createFont("Calibri", 12);
  // Überschrift schreiben
  textFont(ueberschrift);
  fill(0, 255, 0);
  text("Balkendiagramm", 2, 50);

  zeichneBalken();
  
  String[] fontList = PFont.list();
  printArray(fontList);
}

// eigene Methoden
void zeichneBalken() {
  // Schrift einstellen
  textFont(beschriftung_balken);
  fill(0, 0, 255);
  for (int i=0; i < zahlen.length; i++) {
    text("i="+i+"  zahlen["+i+"]="+zahlen[i], 20, 25+15*i+15);
    rect(150, 25+15*i, zahlen[i], 13);
  }
  // rect(120, 40, 23, 13);
}
