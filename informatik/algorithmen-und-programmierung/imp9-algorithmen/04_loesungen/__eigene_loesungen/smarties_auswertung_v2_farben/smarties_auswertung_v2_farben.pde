// Deklaration der Variablen...
int[] zahlen;
String[] namen;
String[] farben; 


// setup-Methode
void setup() {
  size(1000, 700);  // Fenstergröße
  background(255);  // Hintergrundfarbe weiß

  ladeTabelle("Smarties.csv");
  zeichneBalken();
}

// eigene Methoden

void zeichneBalken() {
  
//  fill(0, 0, 255);
  for (int i=0; i < zahlen.length; i++) {
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
