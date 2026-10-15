// globale Variable
int s = 40; // Seitenlänge der Quadrate
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
  for (int j=0; j<=3; j++) {
    for (int i=0; i<=7; i++) {
      zeichneQuadrat(d + i*s, d + j*s, aktuellefarbe, pos_aktuell);
      // Farbwechsel für nächstes Quadrat
      if (aktuellefarbe == 255) {
        aktuellefarbe = 0;
      } else {
        aktuellefarbe = 255;
      }
    } // end Zeichnen einer Reihe
    // Wechsel Startfarbe
    if (aktuellefarbe == 255) {
      aktuellefarbe = 0;
    } else {
      aktuellefarbe = 255;
    }
    // Wechsel Position der Kreise
    if (pos_aktuell == true) {
      pos_aktuell = false;
    } else {
      pos_aktuell = true;
    }
  }

  //zeichne die drei Linien zwischen die Quadrate
  for (int i=0; i<=2; i++) {
    stroke(8, 250, 78);  // Linienfarbe hellgrün
    strokeWeight(2);
    line(d, d + s + s*i, d + 8*s, d + s + s*i);
  }
}

void setup() {
  size(600, 400);
  background(#FAA317);
  // Test Zeichnen zweier Quadrate
  // zeichneQuadrat(100, 100, 0, true);
  // zeichneQuadrat(100, 200, 255, false);
  // Zeichnen der optischen Täuschung
  alleQuadrate();
}
