// globale Variable

int s=20; // Seitenlaenge Quadrat
int k=5; // Seitenlaenge kleines Quadrat
int d=1; // Abstand kleine Quadrate zum Rand

void zeichneQuadrat(int x, int y, int farbe, boolean minus) {
  fill(farbe);
  noStroke();
  rect(x, y, s, s);
  fill(255-farbe); // Farbwechsel zwischen weiß und schwarz
  if (minus == true) { // links oben, rechts unten
    rect(x+d, y+d, k, k);
    rect(x+s-d-k, y+s-d-k, k, k);
  } else { // links unten, rechts oben
    rect(x+d, y+s-d-k, k, k);
    rect(x+s-d-k, y+d, k, k);
  }
}

void optischeTaeuschung() {
  int farbe_akt = 0;
  // kompletter Hintergrund
  for (int j=0; j<24; j++) {
    for (int i=0; i<24; i++) {
      zeichneQuadrat(i*s, j*s, farbe_akt, true);
      farbe_akt = 255 - farbe_akt;
    }
    farbe_akt = 255 - farbe_akt;
  }
  // Mitte gefüllt mit schwarz - weiß...
  for (int j=0; j<12; j++){
    for (int i=0; i<12; i++){
      fill(farbe_akt);
      rect(6*s +i*s, 6*s+ j*s, s, s);
      farbe_akt = 255 - farbe_akt;
    }
    farbe_akt = 255 - farbe_akt;
  }
  // innere Mitte
  for (int j=0; j<10; j++) {
    for (int i=0; i<10; i++) {
      zeichneQuadrat(7*s+i*s, 7*s+ j*s, farbe_akt, false);
      farbe_akt = 255 - farbe_akt;
    }
    farbe_akt = 255 - farbe_akt;
  }
  
}

// setup-Methode
void setup() {
  size(500, 500);
  optischeTaeuschung();
}
