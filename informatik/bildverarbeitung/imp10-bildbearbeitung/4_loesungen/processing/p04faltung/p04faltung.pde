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

  // Aufruf der geschriebenen Methoden
  bildNeu = faltung(bildAlt,weichzeichnen);
  image(bildNeu,bildAlt.width,0);
  
  bildNeu = faltung(bildAlt,schaerfen);
  image(bildNeu,0,bildAlt.height);
  
  bildNeu = faltung(bildAlt,relief);
  image(bildNeu,bildAlt.width,bildAlt.height);
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

// Schreiben der Methoden aus den Aufgaben 1 bis 3

PImage faltung(PImage originalbild, double[][] filter) {
  // Größe der Filtermatrix bestimmen
  int laenge = filter.length;
  int halb = laenge / 2;

  // Erzeuge neues Bild
  PImage bild_neu = createImage(originalbild.width, originalbild.height, RGB);

  // Faltung berechnen
  // Schleife über alle Spalten
  for (int x = halb; x<originalbild.width-halb; x++) {
    // Schleife über alle Zeilen
    for (int y = halb; y<originalbild.height-halb; y++) {
      // Deklarieren der neuen Farbkomponenten
      double rot = 0.0;
      double gruen = 0.0;
      double blau = 0.0;
      //Koordinaten des Pixels links oben in der Ecke der Filtermatrix
      int xx = x - halb;
      int yy = y - halb;
      //Schleifen über jeden Punkt der Filtermatrix
      for (int i =0; i<laenge; i++) {
        for (int j=0; j<laenge; j++) {
          // Summiere die gewichteten Farbkomponenten der Originalpixel
          rot += filter[i][j] * red(pixelAlt[xx+i][yy+j]);
          gruen += filter[i][j] * green(pixelAlt[xx+i][yy+j]);
          blau += filter[i][j] * blue(pixelAlt[xx+i][yy+j]);
        }
      }
      // Begrenzung auf zulässigen Bereich
      if (rot < 0.0)     rot = 0.0;
      if (rot > 255.0)   rot = 255.0;
      if (gruen < 0.0)   gruen = 0.0;
      if (gruen > 255.0) gruen = 255.0;
      if (blau < 0.0)    blau = 0.0;
      if (blau > 255.0)  blau = 255.0;

      // Definiere Farbe des neuen Pixels
      pixelNeu[x][y] = color((int)rot, (int)gruen, (int)blau);
      bild_neu.set(x, y, pixelNeu[x][y]);
    }
  }
  return bild_neu;
}
