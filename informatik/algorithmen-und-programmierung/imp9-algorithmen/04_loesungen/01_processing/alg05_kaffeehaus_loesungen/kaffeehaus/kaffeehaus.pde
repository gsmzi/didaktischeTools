// globale Variablen
int s = 60; // Seitenlänge der Quadrate bzw. Abstand der Parallelen

int[] abstaende = {10, 20, 30, 20, 10, 20, 30, 20, 10}; // Abstände des 1. Quadrates nach links

void parallelen(){ // zeichnet 10 graue Parallelen
  stroke(125); // Linienfarbe Graustufe
  for (int i=0; i<=9; i++){
    line(0,5+i*s, 900, 5+i*s);
  }
}

void zeichneAlleQuadrate(){
  fill(0); // Füllfarbe schwarz
  for (int j=0; j<=8; j++){
    for (int i=0; i<=7; i++){
      // rect(10+2*s*i,5+j*s,s,s);  // Abstand bei allen Reihen gleich: d=10
      rect(abstaende[j]+2*s*i, 5+j*s, s, s);  // Abstand wird jeweils aus dem Feld gelesen
    }
  }
}

void setup(){
  size(900, 600);
  background(255); // Hintergrund weiß
  parallelen();  // Aufruf der Methode zum Zeichnen der Parallelen
  zeichneAlleQuadrate();
  //zeichneQuadrate(); // Aufruf der Methode zum Zeichnen der Quadrate
}




void zeichneQuadrate(){
  fill(0);  // Füllfarbe schwarz
  // fülle die erste Reihe mit Quadraten
  for (int i=0; i<=7; i++){
    rect(10+2*s*i,5,s,s);
  }

  // fülle die zweite Reihe mit Quadraten
  for (int i=0; i<=7; i++){
    rect(20+2*s*i,5+s,s,s);
  }
  
  // fülle die dritte Reihe mit Quadraten
  for (int i=0; i<=7; i++){
    rect(30+2*s*i,5+2*s,s,s);
  }
}
