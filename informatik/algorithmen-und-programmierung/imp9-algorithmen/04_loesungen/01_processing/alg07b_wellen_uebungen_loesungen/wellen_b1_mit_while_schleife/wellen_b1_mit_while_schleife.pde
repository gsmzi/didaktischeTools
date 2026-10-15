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
  int pos_x = 0;
  int pos_y = 0;
  while (pos_y < 700) { // unterer Rand ist noch nicht erreicht

    while (pos_x < 700) {  // rechter Rand ist noch nicht erreicht
      zeichneQuadrat(pos_x, pos_y, farbe);
      farbe = farbwechsel(farbe);
      pos_x = pos_x + s;  // verändern der x-Position um s
    }
    // Wechsel der Farbe des ersten Quadrates für die nächste Reihe
    farbe = farbwechsel(farbe);
    // x-Position wieder an linken Rand setzen
    pos_x = 0;
    pos_y = pos_y + s; // verändern der y-Position um s
  }
}
