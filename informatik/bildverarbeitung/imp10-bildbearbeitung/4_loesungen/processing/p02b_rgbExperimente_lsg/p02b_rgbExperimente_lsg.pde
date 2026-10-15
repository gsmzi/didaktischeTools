color[][] pixelNeu;
color[][] pixelAlt;
PImage bildAlt, bildNeu;

void setup() {
  size(1000, 800);
  background(255);
  bildAlt = loadImage("data/kuehe.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  schreibeBildinArray(bildAlt);

  bildNeu = invertiere(bildAlt);
  image(bildNeu, bildAlt.width, 0);

  bildNeu = tauscheRotGruen(bildAlt);
  image(bildNeu, 0, bildAlt.height);

  bildNeu = farbaenderung(bildAlt, 2.0, 2.0, 2.0);
  image(bildNeu, bildAlt.width, bildAlt.height);
}

color invertiereFarbanteile(color farbe) {
  float r = red(farbe);
  float g = green(farbe);
  float b = blue(farbe);
  color neueFarbe = color(255-r, 255-g, 255-b);
  return neueFarbe;
}

color tauscheRotGruenFarbanteile(color farbe) {
  float r = red(farbe);
  float g = green(farbe);
  float b = blue(farbe);
  color neueFarbe = color(g, r, b);
  return neueFarbe;
}

color aendereFarbanteile(color farbe, float faktor_r, float faktor_g, float faktor_b) {
  float r = red(farbe)*faktor_r; 
  if (r>255) {
    r = 255;
  } else if (r<0) {
    r = 0;
  }
  float g = green(farbe)*faktor_g ;
  if (g>255) {
    g = 255;
  } else if (g<0) {
    g = 0;
  }

  float b = blue(farbe)*faktor_b;
  if (b>255) {
    b = 255;
  } else if (b<0) {
    b = 0;
  }

  color neueFarbe = color(r, g, b);
  return neueFarbe;
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

// Methode invertiert Farbanteile und gibt verändertes Bild aus
PImage invertiere(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelNeu[x][y]= invertiereFarbanteile(pixelAlt[x][y]);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Methode tauscht rote und grüne Farbanteile und gibt verändertes Bild aus
PImage tauscheRotGruen(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelNeu[x][y]= tauscheRotGruenFarbanteile(pixelAlt[x][y]);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}

// Methode tauscht rote und grüne Farbanteile und gibt verändertes Bild aus
PImage farbaenderung(PImage originalbild, float faktor_r, float faktor_g, float faktor_b) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      pixelNeu[x][y]= aendereFarbanteile(pixelAlt[x][y], faktor_r, faktor_g, faktor_b);
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  return neuesBild;
}
