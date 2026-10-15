// globale Variablen
int s = 50; // Seitenlaenge Quadrat
int a = 15; // Abstand Quadrate
int start = 30; // Abstand zum Rand

// Methode, die schwarze Quadrate zeichnet
void quadrate() {
  fill(0);
  for (int i=0; i<=6; i++) {
    for (int j=0; j<=6; j++) {
      rect(start+j*(s+a), start+i*(s+a), s, s);
    }
  }
}

// Methode, die weiße Kreise zeichnet
void kreise() {
  fill(255);
  noStroke(); // keine Umrandung
  for (int j=0; j<6; j++) {
    for (int i=0; i<6; i++) {
      ellipse(start+s+a/2+(s+a)*i, start+s+a/2+(s+a)*j, a+2, a+2);
    }
  }
}

// setup-Methode
void setup() {
  size(500, 500);
  background(66, 165, 250);  // Hintergrundfarbe hellblau
  quadrate();
  kreise();
}
