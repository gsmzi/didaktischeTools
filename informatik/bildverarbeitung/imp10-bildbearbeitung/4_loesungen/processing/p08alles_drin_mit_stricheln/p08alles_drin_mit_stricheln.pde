// Need G4P library
import g4p_controls.*;


color[][] pixelNeu;  // zweidim. Array für die Pixel des neues Bildes
color[][] pixelAlt;  // zweidim. Array für die Pixel des alten Bildes
PImage bildAlt, bildNeu, bildOriginal, bildVorher;

float[][] weichzeichnen = {{1.0/9, 1.0/9, 1.0/9}, {1.0/9, 1.0/9, 1.0/9}, {1.0/9, 1.0/9, 1.0/9}};
float[][] schaerfen = {{0, -1, 0}, {-1, 5, -1}, {0, -1, 0}};
float[][] relief = {{-2, -1, 0}, {-1, 1, 1}, {0, 1, 2}};

int x_start = 0;  // Position der linken oberen Bildecke bei der Anzeige
int y_start = 50;

boolean bildgewaehlt = false;

String dateiname;

public void setup() {

  size(800, 700, JAVA2D);
  background(255);
  createGUI();
  customGUI();
  // Place your setup code here
  bildLaden("kuehe.jpg");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    bildgewaehlt = true;
    dateiname = selection.getAbsolutePath();
    // bildLaden(selection.getAbsolutePath());
  }
}

void fileSelectedSave(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    dateiname = selection.getAbsolutePath();
    bildNeu.save(dateiname+".jpg");
  }
}


public void draw() {
  if (bildgewaehlt) {
    bildLaden(dateiname);
  }  
  bildgewaehlt = false;
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}

public void AnzeigenUndMerken(int x, int y) {
  // fuer die Anzeige des veränderten Bildes und speichern des Vorgängers
  // wird nur in Eventhandlern aufgerufen
  background(255);
  image(bildNeu, x, y);
  bildVorher = new PImage(bildNeu.width, bildNeu.height, RGB);
  bildVorher = bildAlt;
  bildAlt = bildNeu;
  schreibeBildinArray(bildAlt);
}


void bildLaden(String pfad) {
  bildOriginal = loadImage(pfad);
  //  bildAlt = new PImage(bildOriginal.width, bildOriginal.height, RGB);
  bildAlt = bildOriginal;
  image(bildAlt, x_start, y_start);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
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

// Blatt 9: HSB-Farbmodell - Graustufen
PImage graustufenHSB(PImage originalbild) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;
  colorMode(HSB, 360, 100, 100);
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = 0; x < breite; x++) {
    for (int y = 0; y < hoehe; y++) {
      float h = hue(pixelAlt[x][y]); // Farbton wird übernommen
      float s = 0; // Sättigung wird auf 0 gesetzt
      float b = brightness(pixelAlt[x][y]); // Helligkeit wird übernommen
      pixelNeu[x][y]= color(int(h), int(s), int(b));
      neuesBild.set(x, y, pixelNeu[x][y]);
    }
  }
  // zurücksetzen Farbmodus:
  colorMode(RGB, 255, 255, 255);
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

// Blatt 8 - Tupfen und Stricheln
// Methode ermöglicht Tupfen von Bildern
PImage tupfen(PImage originalbild, int groesse, int anzahl) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;

  noStroke();
  for (int i = 0; i < anzahl; i++) {
    int x = groesse/2 + int(random(breite-groesse));
    int y = groesse/2 + int(random(hoehe-groesse));
    fill(red(pixelAlt[x][y]), green(pixelAlt[x][y]), blue(pixelAlt[x][y]));
    ellipse(x + x_start, y + y_start, groesse, groesse);
  }
  // Pixel der Oberfläche in neues Bild übertragen, da das Bild ja nur übermalt wurde
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = x_start; x < x_start+breite; x++) {
    for (int y = y_start; y < y_start+hoehe; y++) {
      pixelNeu[x-x_start][y-y_start] = get(x, y);
      neuesBild.set(x-x_start, y-y_start, pixelNeu[x-x_start][y-y_start]);
    }
  }
  return neuesBild;
}

// Methode ermöglicht Stricheln von Bildern
PImage stricheln(PImage originalbild, int dicke, int laenge, int anzahl) {
  int breite = originalbild.width;
  int hoehe = originalbild.height;

  for (int i = 0; i < anzahl; i++) {
    int x = laenge/2 + int(random(breite-laenge));
    int y = laenge/2 + int(random(hoehe-laenge));
    stroke(red(pixelAlt[x][y]), green(pixelAlt[x][y]), blue(pixelAlt[x][y]));
    strokeWeight(dicke);
    // mit Pythagoras
    int schritt = round(laenge / sqrt(2));
    line(x + x_start, y + y_start, x + x_start+schritt, y + y_start - schritt);
  }
  // Pixel der Oberfläche in neues Bild übertragen, da das Bild ja nur übermalt wurde
  pixelNeu = new color[breite][hoehe];
  PImage neuesBild = createImage(breite, hoehe, RGB);
  for (int x = x_start; x < x_start+breite; x++) {
    for (int y = y_start; y < y_start+hoehe; y++) {
      pixelNeu[x-x_start][y-y_start] = get(x, y);
      neuesBild.set(x-x_start, y-y_start, pixelNeu[x-x_start][y-y_start]);
    }
  }
  return neuesBild;
}
