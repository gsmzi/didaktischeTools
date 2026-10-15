color[][] pixelNeu;  // zweidim. Array für die Pixel des neues Bildes
color[][] pixelAlt;  // zweidim. Array für die Pixel des alten Bildes
PImage bildAlt, bildNeu;

void setup() {
  size(1000, 800);
  background(255);
  bildAlt = loadImage("data/see.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  schreibeBildinArray(bildAlt);
  /*
  // Aufgabe 7
   bildNeu = spiegleHorizontal(bildAlt);
   image(bildNeu, bildAlt.width, 0);
   
   // Aufgabe 8
   save("data/spiegelsee.jpg");
   
   // Aufgabe 10
   bildNeu = spiegleVertikal(bildAlt);
   image(bildNeu, 0, bildAlt.height);
*/
  // Aufgabe 15 - Testen
  bildNeu = dreheLinks(bildAlt);
  image(bildNeu, bildAlt.width, 0);

  // Aufgabe 16 - Testen
  //bildNeu = dreheRechts(bildAlt);
  //image(bildNeu, bildAlt.width, 0); 
}

// Methode schreibt die einzelnen Pixel eines Bildes in ein zweidim. Array
void schreibeBildinArray(PImage bild) {
  int breite = bild.width;
  int hoehe = bild.height;
  pixelAlt = new color[breite][hoehe];
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelAlt[x][y] = bild.get(x, y);
    }
  }
}

// Methode spiegelt Bild horizontal
PImage spiegleHorizontal(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelNeu[x][y]= pixelAlt[breite-1-x][y];
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Aufgabe 10: Methode spiegelt Bild vertikal
PImage spiegleVertikal(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelNeu[x][y]= pixelAlt[x][hoehe-1-y];
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Aufgabe 15: Methode dreht Bild nach links
PImage dreheLinks(PImage originalbild) {
  int breiteAlt = originalbild.width; //<>//
  int hoeheAlt = originalbild.height;
  pixelNeu = new color[hoeheAlt][breiteAlt];
  PImage neuesBild = createImage(hoeheAlt, breiteAlt, RGB);
  for (int xNeu = 0; xNeu < hoeheAlt; xNeu++) {
    for (int yNeu = 0; yNeu < breiteAlt; yNeu++) {
      pixelNeu[xNeu][yNeu]=  pixelAlt[breiteAlt-1-yNeu][xNeu];
      neuesBild.set(xNeu, yNeu, pixelNeu[xNeu][yNeu]);
    }
  }
  return neuesBild;
}

// Aufgabe 16: Methode dreht Bild nach rechts
PImage dreheRechts(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[hoehe][breite];
  PImage neuesBild = createImage(hoehe, breite, RGB);
  for (int x = 0; x < hoehe; x++) {
    for (int y = 0; y < breite; y++) {
      pixelNeu[x][y]=  pixelAlt[y][hoehe-1-x];
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}
