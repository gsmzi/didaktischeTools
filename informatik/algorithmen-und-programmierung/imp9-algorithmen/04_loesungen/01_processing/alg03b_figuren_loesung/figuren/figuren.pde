
void zeichneBildC() {
  // Zeichne dir zunächst eine Skizze auf ein Blatt Papier und überlege dir, welche
  // Werte du den Methoden rect(x,y,b,h) und ellipse(x,y,b,h) übergeben musst, 
  // dass Bild C gezeichnet wird

  // ***** hier kommen deine Anweisungen hin ************
  rect(10, 10, 100, 100);

  ellipse(60, 60, 80, 80);
  ellipse(60, 60, 60, 60);
  ellipse(60, 60, 40, 40);

  ellipse(60, 170, 100, 100);

  rect(30, 140, 60, 60);
  rect(40, 150, 40, 40);
  rect(50, 160, 20, 20);

  // ***** Ende der eigenen Anweisungen **********
}

void zeichneBildA() {
  
  ellipse(260, 60, 100, 100);

  rect(210, 110, 100, 100);

  triangle(210, 300, 310, 300, 260, 210);
  
}


void setup() {
  size(500, 350); // Festlegen der Fenstergröße
  zeichneBildC(); // Aufruf deiner Methode
  zeichneBildA();
}
