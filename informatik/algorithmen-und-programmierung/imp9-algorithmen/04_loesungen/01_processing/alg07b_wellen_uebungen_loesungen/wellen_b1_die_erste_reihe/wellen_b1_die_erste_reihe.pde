// globale Variable
int s=50; // Seitenlänge der Quadrate
int d=5; // Abstand inneres Quadrat zum Rand
int weiss = 255; 
int gruen = #1CAF38;


// setup-Methode
void setup() {
  size(700, 700);
  background(255); // weißer Hintergrund
  alleQuadrate();
}

void zeichneQuadrat(int x, int y, int rahmenfarbe) {

  fill(rahmenfarbe); // Linienfarbe einstellen
  noStroke();
  rect(x, y, s, s); // Zeichnen des hinteren Quadrates

  // Bestimmen der Farbe des inneren Quadrates
  if (rahmenfarbe == weiss) {
    fill(gruen);
  } else {
    fill(weiss);
  }

  rect(x+d, y+d, s-2*d, s-2*d); // Zeichnen des inneren Quadrates
}

void alleQuadrate(){
  int farbe = gruen; // Festlegen der ersten Rahmenfarbe
  // erste Reihe
  for (int i=0; i<12; i++) {
    zeichneQuadrat(30+i*s, 30, farbe);
    if (farbe == gruen) {  // du könntest hier wieder eine Methode Farbwechsel schreiben
      farbe = weiss;
    } else {
      farbe = gruen;
    }
  }
}
