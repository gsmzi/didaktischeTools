color[][] pixelNeu;  // zweidim. Array für die Pixel des neues Bildes
color[][] pixelAlt;  // zweidim. Array für die Pixel des alten Bildes
PImage bildAlt, bildNeu;

float[][] weichzeichnen = {{1.0/9, 1.0/9, 1.0/9}, {1.0/9, 1.0/9, 1.0/9}, {1.0/9, 1.0/9, 1.0/9}};
float[][] schaerfen = {{0, -1, 0}, {-1, 5, -1}, {0, -1, 0}};
float[][] relief = {{-2, -1, 0}, {-1, 1, 1}, {0, 1, 2}};

void setup() {
  size(1000, 800);
  background(255);
  bildAlt = loadImage("data/see.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  schreibeBildinArray(bildAlt);

  // Aufruf der geschriebenen Methoden
  /*
  // Aufgabe 7
   bildNeu = spiegleHorizontal(bildAlt);
   image(bildNeu, bildAlt.width, 0);
   
   // Aufgabe 8
   save("data/spiegelsee.jpg");
   
   // Aufgabe 10
   bildNeu = spiegleVertikal(bildAlt);
   image(bildNeu, 0, bildAlt.height);
   
   // Aufgabe 15 - Testen
   bildNeu = dreheLinks(bildAlt);
   image(bildNeu, bildAlt.width, 0);
   
   bildNeu = graustufenDurchschnitt(bildAlt);
   image(bildNeu, bildAlt.width, 0);
   
   bildNeu = graustufenMin(bildAlt);
   image(bildNeu, 0, bildAlt.height);
   
   bildNeu = graustufenMax(bildAlt);
   image(bildNeu, bildAlt.width, bildAlt.height);
   
   bildNeu = graustufenNatuerlich(bildAlt);
   image(bildNeu,0,0);
   
   bildNeu = invertiere(bildAlt);
   image(bildNeu, bildAlt.width, 0);
   
   bildNeu = tauscheRotGruen(bildAlt);
   image(bildNeu, 0, bildAlt.height);
   
   bildNeu = farbaenderung(bildAlt, 2.0, 2.0, 2.0);
   image(bildNeu, bildAlt.width, bildAlt.height);
   
   
   
   // Aufgabe 16 - Testen
   bildNeu = dreheRechts(bildAlt);
   image(bildNeu, bildAlt.width, 0); 
   */

  bildNeu = faltung(bildAlt, weichzeichnen);
  image(bildNeu, bildAlt.width, 0);

  bildNeu = faltung(bildAlt, schaerfen);
  image(bildNeu, 0, bildAlt.height);

  bildNeu = faltung(bildAlt, relief);
  image(bildNeu, bildAlt.width, bildAlt.height);
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
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  pixelNeu = new color[hoehe][breite];
  PImage neuesBild = createImage(hoehe, breite, RGB);
  for (int x = 0; x < hoehe; x++) {
    for (int y = 0; y < breite; y++) {
      pixelNeu[x][y]=  pixelAlt[breite-1-y][x];
      neuesBild.set(x, y, pixelNeu[x][y]);
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

// Schreiben der Methoden aus den Aufgaben 1 bis 3

PImage faltung(PImage originalbild, float[][] filter) {
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
      float rot = 0;
      float gruen = 0;
      float blau = 0;
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
