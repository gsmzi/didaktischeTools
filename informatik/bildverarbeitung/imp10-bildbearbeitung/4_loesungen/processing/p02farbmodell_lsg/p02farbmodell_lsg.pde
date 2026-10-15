color[][] pixelNeu;
color[][] pixelAlt;
PImage bildAlt, bildNeu;

void setup() {
  size(1000, 800);
  background(255);
  bildAlt = loadImage("data/see.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  schreibeBildinArray(bildAlt);
  /*
*/

  bildNeu = graustufenDurchschnitt(bildAlt);
  image(bildNeu, bildAlt.width, 0);

  bildNeu = graustufenMin(bildAlt);
  image(bildNeu, 0, bildAlt.height);

  bildNeu = graustufenMax(bildAlt);
  image(bildNeu, bildAlt.width, bildAlt.height);
  
  bildNeu = graustufenNatuerlich(bildAlt);
  image(bildNeu,0,0);
}

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

// Methode bestimmt Mittelwert der Farbwerte, liefert Bild in Graustufen
PImage graustufenDurchschnitt(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  float r = 0;
  float g = 0;
  float b = 0;
  float m = 0;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      r = red(pixelAlt[x][y]); // Rotanteil des Pixels
      g = green(pixelAlt[x][y]); // Gruenanteil des Pixels
      b = blue(pixelAlt[x][y]); // Blauanteil des Pixels
      m = (r+g+b)/3;
      pixelNeu[x][y]= color(m);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Methode bestimmt Minimum der Farbwerte, liefert Bild in Graustufen
PImage graustufenMin(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  float r = 0;
  float g = 0;
  float b = 0;
  float m = 0;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      r = red(pixelAlt[x][y]); // Rotanteil des Pixels
      g = green(pixelAlt[x][y]); // Gruenanteil des Pixels
      b = blue(pixelAlt[x][y]); // Blauanteil des Pixels
      m = min(r, g, b);
      pixelNeu[x][y]= color(m);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Methode bestimmt Maximum der Farbwerte, liefert Bild in Graustufen
PImage graustufenMax(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  float r = 0;
  float g = 0;
  float b = 0;
  float m = 0;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      r = red(pixelAlt[x][y]); // Rotanteil des Pixels
      g = green(pixelAlt[x][y]); // Gruenanteil des Pixels
      b = blue(pixelAlt[x][y]); // Blauanteil des Pixels
      m = max(r, g, b);
      pixelNeu[x][y]= color(m);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Methode bestimmt Graustufe mit gewichteten Farbanteilen
PImage graustufenNatuerlich(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  float r = 0;
  float g = 0;
  float b = 0;
  float m = 0;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      r = red(pixelAlt[x][y]); // Rotanteil des Pixels
      g = green(pixelAlt[x][y]); // Gruenanteil des Pixels
      b = blue(pixelAlt[x][y]); // Blauanteil des Pixels
      m = 0.299*r + 0.587*g + 0.114*b;
      pixelNeu[x][y]= color(m);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}
