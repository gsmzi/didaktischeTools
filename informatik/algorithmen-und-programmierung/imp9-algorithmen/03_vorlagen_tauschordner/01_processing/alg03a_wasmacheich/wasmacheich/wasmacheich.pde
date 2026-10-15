//Überlege dir, was die Anweisungen in der Methode "waszeichneich" auslösen könnten
// Verändere die Werte, die den Methoden übergeben werden. Was passiert?

void waszeichneich() {
  line(100, 50, 200, 100);
  ellipse(100, 200, 50, 100);
  rect(300, 100, 250, 20);
}


void setup() {
  size(600, 400);
  waszeichneich(); // Aufruf der Methode
}
