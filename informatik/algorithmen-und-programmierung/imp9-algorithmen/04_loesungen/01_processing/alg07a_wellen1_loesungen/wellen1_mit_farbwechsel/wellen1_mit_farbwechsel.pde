// globale Variable
int s = 60; // Seitenlänge der Quadrate
int a = 2; // Abstand Kreise - Quadratrand
int d = 20; // Abstand der optischen Täuschung zum Rand

int farbwechsel (int farbe) {
  if (farbe == 255) { // Farbe ist weiß
    farbe = 0;
  } else {  // Farbe ist nicht weiß
    farbe = 255;
  }
  return farbe;
}

void zeichneQuadrat(int x, int y, int farbe, boolean links) {
  fill(farbe); // der übergebene Wert der Variable farbe wird als Füllfarbe übergeben
  rect(x, y, s, s); // ein Quadrat mit Seitenlänge s wird an der Position (x|y) gezeichnet

  // Farbauswahl Kreise
  fill(farbwechsel(farbe));

  // Zeichnen der beiden kleinen Kreise
  ellipseMode(CORNERS);
  noStroke();
  int d = s/4;
  if (links == true) {
    ellipse(x+a, y+a, x+d+a, y+d+a);  // links oben
    ellipse(x+a, y + 3*d-a, x+d+a, y+s-a); // links unten
  } else {
    ellipse(x + 3*d-a, y+a, x+s-a, y+d+a);  // rechts oben
    ellipse(x + 3*d-a, y + 3*d-a, x+ s-a, y+s-a);  // rechts unten
  }
}

void alleQuadrate() {
  noStroke();
  int aktuellefarbe = 255; // Farbe des ersten Quadrates ist weiß
  boolean pos_aktuell = true; // Kreise sind zunächst links
  for (int j=0; j<=7; j++) {
    for (int i=0; i<=12; i++) {
      zeichneQuadrat(d + i*s, d + j*s, aktuellefarbe, pos_aktuell);
      // Farbwechsel für nächstes Quadrat
      aktuellefarbe = farbwechsel(aktuellefarbe);
    } // end Zeichnen einer Reihe
    // Wechsel Startfarbe
    aktuellefarbe = farbwechsel(aktuellefarbe);
    // Wechsel Position der Kreise
    if (pos_aktuell == true) {
      pos_aktuell = false;
    } else {
      pos_aktuell = true;
    }
  }

  //zeichne die drei Linien zwischen die Quadrate
  for (int i=0; i<=7; i++) {
    stroke(8, 250, 78);  // Linienfarbe hellgrün
    strokeWeight(4);
    line(d, d + s + s*i, d + 13*s, d + s + s*i);
  }
}

void setup() {
  size(800, 600);
  background(#FAA317);
  // Zeichnen der optischen Täuschung
  alleQuadrate();
}
