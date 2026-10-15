// globale Variable
int s = 40; // Seitenlänge der Quadrate

void zeichneQuadrat(int x, int y, int farbe, boolean links) {
  fill(farbe); // der übergebene Wert der Variable farbe wird als Füllfarbe übergeben
  rect(x, y, s, s); // ein Quadrat mit Seitenlänge s wird an der Position (x|y) gezeichnet

  // Farbauswahl Kreise
  if (farbe == 255) {  // Quadrat ist weiß
    fill(0); // Füllfarbe schwarz wird gewählt
  } else {  // Quadrat ist nicht weiß (schwarz)
    fill(255);  // Füllfarbe weiß wird gewählt
  }

  // Zeichnen der beiden kleinen Kreise
  ellipseMode(CORNERS);
  noStroke();
  int d = s/4;
  if (links == true) {
    ellipse(x, y, x+d, y+d);  // links oben
    ellipse(x, y + 3*d, x+d, y+s); // links unten
  } else {
    ellipse(x + 3*d, y, x+s, y+d);  // rechts oben
    ellipse(x + 3*d, y + 3*d, x+ s, y+s);  // rechts unten
  }
}

void alleQuadrate() {
  noStroke();
  // erste Reihe
  int aktuellefarbe = 255; // Farbe des ersten Quadrates ist weiß
  for (int i=0; i<=7; i++) {
    zeichneQuadrat(i*s, 0, aktuellefarbe, true);
    // Farbwechsel für nächstes Quadrat
    if (aktuellefarbe == 255) {
      aktuellefarbe = 0;
    } else {
      aktuellefarbe = 255;
    }
  }
  // zweite Reihe
  aktuellefarbe = 0; // Farbe des ersten Quadrates ist schwarz
  for (int i=0; i<=7; i++) {
    zeichneQuadrat(i*s, s, aktuellefarbe, false);
    // Farbwechsel für nächstes Quadrat
    if (aktuellefarbe == 255) {
      aktuellefarbe = 0;
    } else {
      aktuellefarbe = 255;
    }
  }
    // dritte Reihe
  aktuellefarbe = 255; // Farbe des ersten Quadrates ist weiß
  for (int i=0; i<=7; i++) {
    zeichneQuadrat(i*s, 2*s, aktuellefarbe, true);
    // Farbwechsel für nächstes Quadrat
    if (aktuellefarbe == 255) {
      aktuellefarbe = 0;
    } else {
      aktuellefarbe = 255;
    }
  }
  // vierte Reihe
  aktuellefarbe = 0; // Farbe des ersten Quadrates ist schwarz
  for (int i=0; i<=7; i++) {
    zeichneQuadrat(i*s, 3*s, aktuellefarbe, false);
    // Farbwechsel für nächstes Quadrat
    if (aktuellefarbe == 255) {
      aktuellefarbe = 0;
    } else {
      aktuellefarbe = 255;
    }
  }
}

void setup() {
  size(600, 400);
  // Test Zeichnen zweier Quadrate
  // zeichneQuadrat(100, 100, 0, true);
  // zeichneQuadrat(100, 200, 255, false);
  // Zeichnen der optischen Täuschung
  alleQuadrate();
}
