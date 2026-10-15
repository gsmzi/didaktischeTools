// Deklaration der Variablen...
int[] zahlen;


// setup-Methode
void setup() {
  size(1000, 700);  // Fenstergröße
  background(255);  // Hintergrundfarbe weiß
  erzeugeZufallsarray();
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

void erzeugeZufallsarray() {
  zahlen = new int[4];
  /*
  zahlen[0] = int(random(1,300));
   zahlen[1] = int(random(1,300));
   zahlen[2] = int(random(1,300));
   zahlen[3] = int(random(1,300));
   */
  for (int i=0; i<4; i++) {
    zahlen[i] = int(random(1, 300));
  }
}
