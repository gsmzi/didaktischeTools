// Deklaration der Variablen...
int[] zahlen;
String[] namen;
String[] farben;

int max = 0; // maximaler Wert
int pos = -1; // Position des max. Wertes im Feld


// setup-Methode
void setup() {
  size(1000, 700);  // Fenstergröße
  background(255);  // Hintergrundfarbe weiß

  ladeTabelle("Smarties.csv");
  sucheMaximum(zahlen);
  zeichneBalken();
}

// eigene Methoden

void zeichneBalken() {
  
//  fill(0, 0, 255);
  for (int i=0; i < zahlen.length; i++) {
    if (i==pos){
      strokeWeight(3);
    } else {
      strokeWeight(1);
    }
    fill(unhex(farben[i]));
    text(namen[i]+", "+zahlen[i], 20, 25+15*i+15);
    rect(150, 25+15*i, zahlen[i], 13);
  }
}

void ladeTabelle(String name) {
  Table csv = loadTable(name, "header,csv");
  zahlen = new int[csv.getRowCount()];
  namen = new String[csv.getRowCount()];
  farben = new String[csv.getRowCount()];
  for (int i=0; i < zahlen.length; i++){
    zahlen[i] = csv.getInt(i, "Anzahl");
    namen[i] = csv.getString(i, "Farbe");
    farben[i] = csv.getString(i,"Farbcode");
    print(farben[i]+", ");
  }
}

void sucheMaximum(int[] feld){  // könnte man auch mit Rückgabe machen
  for (int i=0; i< feld.length; i++){
    if (max < feld[i]){
      max = feld[i];
      pos = i;
    }
  }
}
