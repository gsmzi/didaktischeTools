// globale Variable
int s=30; // Seitenlänge der Quadrate
int d=5; // Abstand inneres Quadrat zum Rand
int weiss = 255; 
int gruen = #1CAF38;


// setup-Methode
void setup() {
  size(700, 700);
  background(255); // weißer Hintergrund
  alleQuadrate();
}

int farbwechsel(int farbe) {
  if (farbe == weiss) {  // Wechsel von weiß auf grün
    return gruen;
  } else {  // Wechsel von grün auf weiß
    return weiss;
  }
}

void zeichneQuadrat(int x, int y, int rahmenfarbe) {

  fill(rahmenfarbe); // Linienfarbe einstellen
  noStroke();
  rect(x, y, s, s); // Zeichnen des hinteren Quadrates

  // Bestimmen der Farbe des inneren Quadrates
  fill(farbwechsel(rahmenfarbe));

  rect(x+d, y+d, s-2*d, s-2*d); // Zeichnen des inneren Quadrates
}

void alleQuadrate(){
  int farbe = gruen; // Festlegen der ersten Rahmenfarbe
  for (int j=0; j<12; j++) { // j zählt die Reihen

    for (int i=0; i<12; i++) {  // i zählt die Quadrate in einer Reihe
      zeichneQuadrat(30+i*s, 30+j*s, farbe);
      farbe = farbwechsel(farbe);
    }
    // Wechsel der Farbe des ersten Quadrates für die nächste Reihe
    farbe = farbwechsel(farbe);
  }
}
