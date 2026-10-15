
void setup() {
  size(600, 400);
}

void draw() {
}

void mousePressed() {
  fill(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
  ellipse(mouseX, mouseY, 40, 40);
}

void mouseDragged() {
  fill(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
  ellipse(mouseX, mouseY, 40, 40);
}
