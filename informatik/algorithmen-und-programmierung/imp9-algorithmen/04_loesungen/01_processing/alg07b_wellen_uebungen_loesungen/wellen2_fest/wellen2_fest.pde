// globale Variable

int s=40; // Seitenlaenge Quadrat
int k=10; // Seitenlaenge kleines Quadrat
int d=2; // Abstand kleine Quadrate zum Rand
int f=0;  // Farbe: Start mit schwarz
int[][] feld ={{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 1, 5, 2, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 1, 1, 1, 5, 2, 2, 2, 0, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 1, 1, 5, 2, 2, 2, 2, 0, 0, 0}, 
  {0, 0, 1, 1, 1, 1, 1, 5, 2, 2, 2, 2, 2, 0, 0}, 
  {0, 0, 1, 1, 1, 1, 1, 5, 2, 2, 2, 2, 2, 0, 0}, 
  {0, 1, 1, 1, 1, 1, 1, 5, 2, 2, 2, 2, 2, 2, 0}, 
  {0, 3, 3, 3, 3, 3, 3, 0, 4, 4, 4, 4, 4, 4, 0}, 
  {0, 2, 2, 2, 2, 2, 2, 6, 1, 1, 1, 1, 1, 1, 0}, 
  {0, 0, 2, 2, 2, 2, 2, 6, 1, 1, 1, 1, 1, 0, 0}, 
  {0, 0, 2, 2, 2, 2, 2, 6, 1, 1, 1, 1, 1, 0, 0}, 
  {0, 0, 0, 2, 2, 2, 2, 6, 1, 1, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 0, 2, 2, 2, 6, 1, 1, 1, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 2, 6, 1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
};

// setup-Methode
void setup() {
  size(800, 800);
  background(#F5E77C);
  optischeTaeuschung();
}


void optischeTaeuschung(){
  if(s/3 < k){
    k = s/3;
  }
  for (int i=0; i<=14; i++) {
    for (int j=0; j<=14; j++) {
      zeichneQuadrat(10+i*s, 10+j*s, f, feld[i][j]);
      f=255-f;
    }
  }
}


void zeichneQuadrat(int posX, int posY, int farbe, int art) {
  fill(farbe);
  noStroke();
  rect(posX, posY, s, s);

  // Position der kleinen Quadrate festlegen
  boolean lo=false; 
  boolean lu=false; 
  boolean ro=false; 
  boolean ru=false;
  switch(art) {  // geht natürlich auch mit einer normalen Verzweigung
  case 0:
    lo=false; 
    lu=false; 
    ro=false; 
    ru=false;
    break;
  case 1:
    lo=false; 
    lu=true; 
    ro=true; 
    ru=false;
    break;
  case 2:
    lo=true; 
    lu=false; 
    ro=false; 
    ru=true;
    break;
  case 3:
    lo=false; 
    lu=true; 
    ro=false; 
    ru=true;
    break;
  case 4:
    lo=true; 
    lu=false; 
    ro=true; 
    ru=false;
    break;
  case 5:
    lo=false; 
    lu=false; 
    ro=true; 
    ru=true;
    break;
  case 6:
    lo=true; 
    lu=true; 
    ro=false; 
    ru=false;
    break;
  }

  // "Farbe" der kleinen Quadrate innen
  fill(255-farbe); // Wechsel zwischen weiß und schwarz

  zeichneKleineQuadrate(posX, posY, lo, lu, ro, ru);
}

void zeichneKleineQuadrate(int X, int Y, boolean lo0, boolean lu0, boolean ro0, boolean ru0) {
  noStroke();

  if (lo0 == true) {
    rect(X+d, Y+d, k, k);
  }
  if (lu0 == true) {
    rect(X+d, Y+s-k-d, k, k);
  }
  if (ro0 == true) {
    rect(X+s-k-d, Y+d, k, k);
  }
  if (ru0 == true) {
    rect(X+s-k-d, Y+s-k-d, k, k);
  }
}
