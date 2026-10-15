void zeichneQuadrate() {
  for (int i=0; i<=9; i++) {
    rect(30+i*30, 50, 30, 30);
  }
}

void zeichneKreise() {
  for (int i=0; i<=19; i++) {
    ellipse(200, 200, 200-i*10, 200-i*10);
  }
}

void setup() {
  size(400, 400);
  zeichneQuadrate();
  zeichneKreise();
}
