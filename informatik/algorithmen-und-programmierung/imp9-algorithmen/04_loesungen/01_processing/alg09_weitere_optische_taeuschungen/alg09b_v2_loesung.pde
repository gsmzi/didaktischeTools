// globale Variablen
int s = 40; // Seitenlänge Quadrate
int hell = #E5A05A; // r=7, g=176, b=216
int dunkel = #E57607; // r=6, g=69, b=144


int farbwechsel(int farbe0) { // ändert zwischen hell- und dunkel
  int neuefarbe;
  if (farbe0 == hell) {
    neuefarbe = dunkel;
  } else {
    neuefarbe = hell;
  }
  return neuefarbe;
}

void quadrate_hintergrund() {
  int startfarbe = dunkel;
  int farbe = startfarbe;
  noStroke();
  for (int j=0; j<11; j++) {
    for (int i=0; i< 11; i++) {
      fill(farbe);
      rect(i*s, j*s, s, s);
      farbe = farbwechsel(farbe);
    }
  }
}

void quadrat_klein(int farbe, int x, int y, int seite) {
  strokeWeight(3);
  if (farbe == 255) {
    stroke(hell);
    fill(255);
  } else {
    stroke(dunkel);
    fill(0);
  }
  rect(x, y, seite, seite);
}

void quadrate_vordergrund() {
  int s0 = s /2;
  int startfarbe = 0;
  for (int j=0; j<10; j++) {
    for (int i=0; i<10; i++) {

      if (quadrat_zeichnen(i, j) == true) {

        quadrat_klein(startfarbe, (i+1)*s-s0/2, (j+1)*s-s0/2, s0);
      }
      if (i!=4) {
        startfarbe = 255 - startfarbe;
      }
    }
    if (j==4) {
      startfarbe = 255 - startfarbe;
    }
  }
}

boolean quadrat_zeichnen(int i0, int j0) {
  boolean ergebnis = true;

  if (((j0==0 || j0==9) && (i0<3 || i0>6)) || ((j0<3 || j0>6) && (i0==0 || i0==9))) {
    ergebnis = false;
  }

  return ergebnis;
}


void setup() {
  size(440, 440);
  background(255);  // weißer Hintergrund
  quadrate_hintergrund();
  quadrate_vordergrund();
}
