// Need G4P library
import g4p_controls.*;

// ********* Deklarationen
color[][] pixelNeu;  // zweidim. Array für die Pixel des neues Bildes
color[][] pixelAlt;  // zweidim. Array für die Pixel des alten Bildes
PImage bildAlt, bildNeu;

public void setup(){
  size(800, 700, JAVA2D); 
  createGUI();
  customGUI();

  // ********** setup()-Methode ergänzen, aber hier keine Bildbearbeitungs-
  //            methode aufrufen! 
  background(255);
  bildAlt = loadImage("data/see.jpg");
  image(bildAlt, 0, 0);  // Anzeige von bildAlt; linke obere Ecke: (0,0)
  schreibeBildinArray(bildAlt);

}

public void draw(){
  // background(230);  // wird hier auskommentiert, kommt in setup()  
}

// ************* hier alle Bildbearbeitungsmethoden einfügen
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




// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
}
