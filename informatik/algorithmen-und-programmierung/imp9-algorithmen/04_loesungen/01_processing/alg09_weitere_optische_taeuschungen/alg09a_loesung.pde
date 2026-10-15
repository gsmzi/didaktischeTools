// globale Variablen
int s = 40; // Seitenlänge Quadrate
int hell = #B2B0C4; // r=7, g=176, b=216
int dunkel = #9C98C1; // r=6, g=69, b=144


int farbwechsel(int farbe0) { // ändert zwischen hell- und dunkel
  int neuefarbe;
  if (farbe0 == hell) {
    neuefarbe = dunkel;
  } else {
    neuefarbe = hell;
  }
  return neuefarbe;
}

void quadrate() {
  int startfarbe = hell;
  int farbe = startfarbe;
  noStroke();
  for (int j=0; j<13; j++) {
    for (int i=0; i< 13; i++) {
      fill(farbe);
      rect(i*s, j*s, s, s);
      farbe = farbwechsel(farbe);
    }
  }
}

void rauten(){
  int farbe_raute = 0;
  for (int j=0;j<6; j++){
    for (int i=0; i<6; i++){
      vier_rauten(farbe_raute, (i+1)*s, (j+1)*s);  // Quadrant 4
      vier_rauten(farbe_raute, (12-i)*s, (j+1)*s); // Quadrant 1
      vier_rauten(farbe_raute, (i+1)*s, (12-j)*s);  // Quadrant 3
      vier_rauten(farbe_raute, (12-i)*s, (12-j)*s); // Quadrant 2    
      farbe_raute = 255 - farbe_raute;
    }
    farbe_raute = 255 - farbe_raute;
  }

}


void viereck(int farbe, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) {
  fill(farbe);
  quad(x1, y1, x2, y2, x3, y3, x4, y4);
}

void vier_rauten(int farbe, int x_m, int y_m) {
  int a = 8;
  noStroke();
  //Raute links
  viereck(farbe, x_m-a, y_m, x_m - a/2, y_m-a/2, x_m, y_m, x_m - a/2, y_m+a/2);
  //Raute unten
  viereck(255-farbe, x_m, y_m, x_m - a/2, y_m + a/2, x_m, y_m + a, x_m + a/2, y_m + a/2);
  //Raute rechts
  viereck(farbe, x_m, y_m, x_m + a/2, y_m + a/2, x_m + a, y_m, x_m + a/2, y_m - a/2);
  //Raute oben
  viereck(255-farbe, x_m, y_m, x_m - a/2, y_m - a/2, x_m, y_m - a, x_m + a/2, y_m - a/2);
}

void setup() {
  size(600, 600);
  background(255);  // weißer Hintergrund
  quadrate();
  rauten();
}
