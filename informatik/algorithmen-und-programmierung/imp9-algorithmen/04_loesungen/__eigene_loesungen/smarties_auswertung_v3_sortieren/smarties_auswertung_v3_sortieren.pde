// Deklaration der Variablen...
int[] zahlen;
String[] namen;
String[] farben;

int max = 0; // maximaler Wert
int pos = -1; // Position des max. Wertes im Feld

int[] zahlen_sortiert;
String[] namen_sortiert;
String[] farben_sortiert;

// setup-Methode
void setup() {
  size(1000, 700);  // Fenstergröße
  background(255);  // Hintergrundfarbe weiß

  ladeTabelle("Smarties.csv");
  max = sucheMaximum(zahlen);
  zeichneBalken(25, zahlen, namen, farben);
  sortiereFeld();
  zeichneBalken(325, zahlen_sortiert, namen_sortiert, farben_sortiert);
}

// eigene Methoden

void zeichneBalken(int start, int[] z_feld, String[] n_feld, String[] f_feld) {

  //  fill(0, 0, 255);
  for (int i=0; i < z_feld.length; i++) {
    if ((i==pos) && (start == 25)) {
      strokeWeight(3);
    } else {
      strokeWeight(1);
    }
    fill(unhex(f_feld[i]));
    text(n_feld[i]+", "+z_feld[i], 20, start+15*i+15);
    rect(150, start+15*i, z_feld[i], 13);
  }
}

void ladeTabelle(String name) {
  Table csv = loadTable(name, "header,csv");
  zahlen = new int[csv.getRowCount()];
  namen = new String[csv.getRowCount()];
  farben = new String[csv.getRowCount()];
  for (int i=0; i < zahlen.length; i++) {
    zahlen[i] = csv.getInt(i, "Anzahl");
    namen[i] = csv.getString(i, "Farbe");
    farben[i] = csv.getString(i, "Farbcode");
    print(farben[i]+", ");
  }
}

int sucheMaximum(int[] feld) {  
  int m=0;
  int p=-1;
  for (int i=0; i< feld.length; i++) {
    if (m < feld[i]) {
      m = feld[i];
      p = i;
    }
  }
  pos = p;
  return m;
}

void sortiereFeld() {
  int[] hilfsfeld = new int[zahlen.length];  // Feld, in das die Zahlen von groß
  // nach klein geschrieben werden
  int[] suchfeld = zahlen; // Feld, in dem jeweils der größte Wert durch 0 ersetzt wird

  // hier werden auch Namen- und Farbfeld sortiert
  String[] h_farben = new String[farben.length];
  String[] h_namen = new String[namen.length];


  for (int i=0; i< zahlen.length; i++) { //<>//
    hilfsfeld[i] = sucheMaximum(suchfeld);
    h_farben[i] = farben[pos];
    h_namen[i] = namen[pos];
    suchfeld[pos] = 0;
  }
  zahlen_sortiert = hilfsfeld;
  namen_sortiert = h_namen;
  farben_sortiert = h_farben;
}
