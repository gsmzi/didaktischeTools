color[][] pixelNeu;  // zweidim. Array für die Pixel des neues Bildes
color[][] pixelAlt;  // zweidim. Array für die Pixel des alten Bildes
PImage bildAlt, bildNeu;

double[][] weichzeichnen = {{1.0/9,1.0/9,1.0/9},{1.0/9,1.0/9,1.0/9},{1.0/9,1.0/9,1.0/9}};
double[][] schaerfen = {{0,-1,0},{-1,5,-1},{0,-1,0}};
double[][] relief = {{-2,-1,0},{-1,1,1},{0,1,2}};

void setup() {
  size(1000, 800);
  background(255);
  bildAlt = loadImage("data/see.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  schreibeBildinArray(bildAlt);

}

// Methode schreibt die einzelnen Pixel eines Bildes in beide zweidim. Array
void schreibeBildinArray(PImage bild) {
  int breite = bild.width;
  int hoehe = bild.height;
  pixelAlt = new color[breite][hoehe];
  pixelNeu = new color[breite][hoehe];
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelAlt[x][y] = bild.get(x, y);
      // neue Pixel zunächst wie alte, damit Rand kopiert wird:
      pixelNeu[x][y] = bild.get(x, y);
    }
  }
}
