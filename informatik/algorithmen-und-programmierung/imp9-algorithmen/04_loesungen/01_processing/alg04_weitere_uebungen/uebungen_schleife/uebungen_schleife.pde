void setup() {
  size(800, 600);
  //zeichneQuadrate();
  //zeichneFarbQuadrate();
  //zeichneKreise();
  //zeichneFarbKreise();
  //zeichneTreppenstufen();
  //reihenhaussiedlung();
  seifenblasen();
}


// Programmiere die folgenden Methoden und rufe sie in der setup-Methode auf
// (Dazu entfernst du nur die Kommentarstriche zu Beginn der Zeile.)

// Aufgabe 1a:
void zeichneQuadrate() {
  // hier folgt dein Code:
  for (int i=0; i<10; i++) {
    rect(10+i*20, 10, 20, 20);
  }
}

// Aufgabe 1b:
void zeichneFarbQuadrate() {
  // hier folgt dein Code:
  for (int i=0; i<10; i++) {
    fill(255-i*16, 0, 0);
    rect(220+i*20, 10, 20, 20); // Start neben den weißen Quadraten
  }
}

// Aufgabe 2a:
void zeichneKreise() {
  // hier folgt dein Code:
  fill(255);
  for (int i=0; i<20; i++) {
    ellipse(120, 200, 210-i*10, 210-i*10);
  }
}

// Aufgabe 2b:
void zeichneFarbKreise() {
  // hier folgt dein Code:
  noStroke();
  for (int i=0; i<20; i++) {
    fill(67+i*16, 138-i*8, 222-i*16);
    ellipse(350, 200, 210-i*10, 210-i*10);
  }
}

// Aufgabe 3:
void zeichneTreppenstufen() {
  // hier folgt dein Code:
  stroke(0);
  for (int i=0; i<6; i++) {
    line(10+i*30, 590-i*20, 10+i*30, 570-i*20);
    line(10+i*30, 570-i*20, 40+i*30, 570-i*20);
  }
}

// Aufgabe 4:
void reihenhaussiedlung() {
  // hier folgt dein Code:
  fill(255);
  for (int i=0; i<5; i++) {
    fill(#8AB8F0);
    rect(250+i*100, 450, 100, 100); // Wände
    fill(#621009);
    triangle(250+i*100, 450, 250+i*100+50, 410, 250+i*100+100, 450); // Dach
    //line(250+i*100, 450, 250+i*100+50, 410);
    //line(250+i*100+50, 410, 250+i*100+100, 450);
    fill(#132564);
    rect(250+i*100+60, 510, 20, 40); // Tür
    fill(#F9FC45);
    rect(250+i*100+20, 480, 20, 20); // Fenster
  }
}

// Aufgabe 5:
void seifenblasen() {
  // hier folgt dein Code:
  for (int i=0; i<100; i++) {
    fill(random(255), random(255), random(255));
    circle(random(width), random(height), random(50));
  }
}
