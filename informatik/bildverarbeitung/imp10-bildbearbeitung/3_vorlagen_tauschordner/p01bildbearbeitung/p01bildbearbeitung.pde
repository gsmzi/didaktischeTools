color[][] pixelNeu;  // zweidim. Array für die Pixel des neues Bildes
color[][] pixelAlt;  // zweidim. Array für die Pixel des alten Bildes
PImage bildAlt, bildNeu;

void setup() {
  size(1000, 800);
  background(255);
  bildAlt = loadImage("data/see.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  
  
  // Aufgaben 7 und 8 hier ergänzen

  // Aufruf der Methode aus Aufgabe 10 hier ergänzen
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
  schreibeBildinArray(originalbild);
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

// Methode aus Aufgabe 10 hier ergänzen
