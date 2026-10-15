

void setup() {
  size(displayWidth, displayHeight);
}

void draw() {
}


void mouseDragged() {
    fill(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
    ellipse(pmouseX, pmouseY, 40, 40);
}
