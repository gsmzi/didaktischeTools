void zeichneQuadrate(int anz, int s) { // Anzahl der Quadrate und Seitenlänge werden übergeben
  for (int i=0; i<=anz-1; i++) {
    rect(30+i*s, 50, s, s);
  }
}

void zeichneKreise(int anz, int d) {  // Anzahl der Kreise und Abstand werden übergeben
  for (int i=0; i<=anz-1; i++) {
    ellipse(200, 200, 200-i*d, 200-i*d);
  }
}

void setup() {
  size(800, 400);
  zeichneQuadrate(20, 10);
  zeichneKreise(10, 5);
}
