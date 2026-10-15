int rot = 0;
int blau = 0;
int gruen = 0;
int h_rot; 
int h_blau; 
int h_gruen;
boolean schnell = false;

void setup() {
  size(650, 150);
  vorbereitung();
  //background(h_rot,h_gruen,h_blau); */
  noLoop();
}

void vorbereitung() {
  h_rot = int(random(0, 255));
  h_gruen = int(random(0, 255));
  h_blau= int(random(0, 255));
  fill(h_rot, h_gruen, h_blau);
  rect(25, 25, 100, 100);
  fill(0);
  text("Start mit Mausklick: Schrittweite 10", 150, 50);
  text("Umschalten der Schrittweite von 10 auf 1 (und umgekehrt) durch Mausklick", 150, 75);
  text("Erhöhen der Farbwerte durch Tastendruck: r - rot, g - grün, b - blau", 150, 100);
  text("Überprüfen mit Leertaste: Ausgabe in der Konsole", 150, 125);
}

void draw() {
  noStroke();
  fill(rot, gruen, blau);
  rect(50, 50, 50, 50);
}

void ueberpruefen() {
  String ausgabe_rot;
  String ausgabe_gruen;
  String ausgabe_blau;
  if (rot>h_rot) {
    ausgabe_rot = "zu viel rot";
  } else if (rot < h_rot) {
    ausgabe_rot = "zu wenig rot";
  } else {
    ausgabe_rot = "rot stimmt!";
  }
  if (gruen>h_gruen) {
    ausgabe_gruen = "zu viel grün";
  } else if (gruen < h_gruen) {
    ausgabe_gruen = "zu wenig grün";
  } else {
    ausgabe_gruen = "grün stimmt!";
  }
  if (blau>h_blau) {
    ausgabe_blau = "zu viel blau";
  } else if (blau < h_blau) {
    ausgabe_blau = "zu wenig blau";
  } else {
    ausgabe_blau = "blau stimmt!";
  }
  println(ausgabe_rot+", "+ausgabe_gruen+", "+ausgabe_blau);
}

void keyPressed() {
  int d;
  if (schnell == true) {
    d=10;
  } else {
    d=1;
  }
  if (key == 32) {  // Leertaste
    ueberpruefen();
  }
  if (key == 'r' || key == 'R') {
    rot = (rot + d) % 255;
    println("rot: "+rot+" richtig: "+h_rot);
  } else if (key == 'g' || key == 'G') {
    gruen = (gruen+d) % 255;
    println("grün: "+gruen+" richtig: "+h_gruen);
  } else if (key == 'b' || key == 'B') {
    blau = (blau+d) % 255;
    println("blau: "+blau+" richtig: "+h_blau);
  }
  redraw();
}

void mousePressed() {
  schnell = ! schnell;
  println(schnell);
}
