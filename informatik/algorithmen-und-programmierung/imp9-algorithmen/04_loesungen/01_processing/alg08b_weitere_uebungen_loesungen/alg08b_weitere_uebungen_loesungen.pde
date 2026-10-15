// globale Variablen
int breite = 40; // Breite der schwarzen Streifen
int hellblau = #07B0D8; // r=7, g=176, b=216
int dunkelblau = #064590; // r=6, g=69, b=144

void schwarze_streifen() {
  fill(0); // Füllfarbe schwarz
  int pos = breite/2; // Abstand erster Streifen zum linken Rand
  while (pos < width) {
    rect(pos, 0, breite, height);
    pos = pos + 2*breite;
  }
}

void blaue_streifen() {
  int startfarbe = dunkelblau;
  int farbe = startfarbe;
  int d_nach_oben = breite;  // Abstand zum oberen Rand
  int d_nach_links = 0; // Abstand nach links
  int farbe_raute = 0;
  noStroke();
  while (d_nach_oben < height) {
    while (d_nach_links < width) {
      fill(farbe);
      rect(d_nach_links, d_nach_oben, breite, breite);
      vier_rauten(farbe_raute, d_nach_links + breite/2, d_nach_oben); // obere Rauten
      vier_rauten(255-farbe_raute, d_nach_links + breite/2, d_nach_oben + breite); // untere
      d_nach_links = d_nach_links + breite;
      farbe = farbwechsel(farbe);
      farbe_raute = 255 - farbe_raute;
    }
    d_nach_oben = d_nach_oben + breite + breite + breite/2;
    d_nach_links = 0;
    startfarbe = farbwechsel(startfarbe);
  }
}

int farbwechsel(int farbe0) { // ändert zwischen hell- und dunkelblau
  int neuefarbe;
  if (farbe0 == hellblau) {
    neuefarbe = dunkelblau;
  } else {
    neuefarbe = hellblau;
  }
  return neuefarbe;
}

void viereck(int farbe, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) {
  fill(farbe);
  quad(x1,y1,x2,y2,x3,y3,x4,y4);
}

void vier_rauten(int farbe, int x_m, int y_m) {
  int a = 12;
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
  size(600, 400);
  background(255);  // weißer Hintergrund
  schwarze_streifen();
  blaue_streifen();
}
