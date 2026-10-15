// Deklaration der Variablen...
int[] zahlen;


// setup-Methode
void setup() {
  size(1000, 700);  // Fenstergröße
  background(255);  // Hintergrundfarbe weiß
  erzeugeZufallsarray(10);
  zeichneBalken();
}

// eigene Methoden

void zeichneBalken() {
  fill(0, 0, 255);
  for (int i=0; i < zahlen.length; i++) {
    text("i="+i+"  zahlen["+i+"]="+zahlen[i], 20, 25+15*i+15);
    rect(150, 25+15*i, zahlen[i], 13);
  }
}

void erzeugeZufallsarray(int laenge) {
  zahlen = new int[laenge];
  for (int i=0; i<laenge; i++) {
    zahlen[i] = int(random(1, 300));
  }
}
