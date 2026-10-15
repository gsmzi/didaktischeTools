// globale Variablen
int e = 60; // Länge der waagrechten Diagonale der grauen Raute
int f = 35; // Länge der senkrechten Diagonale der grauen Raute

int farbe1 = #3F71C4;  // blau
int farbe2 = #54B966;  // grün
int farbe3 = #969B96; // grau

// setup-Methode
void setup() {
  size(600, 400);
  background(farbe3);
  drei_d();
}

void viereck(int farbe, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4){
  fill(farbe);
  stroke(farbe);
  quad(x1,y1,x2,y2,x3,y3,x4,y4);
}

void drei_d() {
  int x = 0;
  int y = 0;
  boolean ungerade = true; // es beginnt mit Farbe 1 - jede ungerade Reihe
  while (y < height) {
    while (x < width) {
      viereck(farbe1, x,y,x+ e/2,y+f/2,x+e/2,y+3*f/2,x,y+f);
      viereck(farbe2, x+ e/2,y+f/2,x+e/2,y+3*f/2,x+e,y+f,x+e,y);
      x = x + e;
    }
    if (ungerade == true){
      ungerade = false;
      x = -e/2;  // erste sichtbare Farbe links ist Farbe 2
    } else {
      ungerade = true;
      x = 0;
    }
    y = y + 3*f/2;
  }
}
