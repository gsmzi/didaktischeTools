// globale Variablen
int s = 30; // Seitenlaenge Quadrat
int a = 10; // Abstand Quadrate

// Methode, die optische Täuschung zeichnet
void quadrate() {
  fill(0); // Füllfarbe schwarz
  for (int j=0; j<=6; j++) {
    for (int i=0; i<=6; i++) {
      rect(30+i*(s+a), 30+j*(s+a), s, s);
    }
  }
}

// setup-Methode
void setup() {
  size(500, 500);
  background(255); // Hintergrund weiß
  quadrate();
}
