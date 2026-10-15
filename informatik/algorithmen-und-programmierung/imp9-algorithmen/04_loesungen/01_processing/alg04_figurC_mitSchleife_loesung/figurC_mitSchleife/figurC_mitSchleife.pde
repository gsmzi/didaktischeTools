void zeichneBildC() {
  rect(10, 10, 100, 100);
  for (int i=0; i<=2; i++) {
    ellipse(60, 60, 80-i*20, 80-i*20);
  }

  ellipse(60, 170, 100, 100);
  for (int i=0; i<=2; i++) {
    rect(30+i*10, 140+i*10, 60-i*20, 60-i*20);
  }
}

void setup() {
  size(120, 250);
  zeichneBildC();
}
