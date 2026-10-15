void setup(){

  size(600,400);
  
  // Nummer 1 
  for (int i=0; i<10; i++){
    ellipse(50+i*50,50,50,50);
  }
  
  // Nummer 2
  for (int i=0; i<10; i++) {
    ellipse(50+i*50, 50+i*25, 50, 50);
  }
  
  // Nummer 3
  for (int i=0; i<10; i++) {
    ellipse(100, 100, 110-i*10, 110-i*10);
  }
  
  // Nummer 4
  for (int i=0; i<20; i++) {
    ellipse(100+i*10, 100+i*10, 200-i*10, 200-i*10);
  }
  
  // Nummer 5
  for (int i=0; i<5; i++) {
    rect(10+i*60, 10, 50, 40);
  }
  
  // Nummer 6
  for (int i=0; i<5; i++) {
    rect(10+i*60, 10+i*40, 50, 40);
  }
  
  // Nummer 7
  for (int i=0; i<10; i++) {
    rect(10, 10, 100-i*10, 100-i*10);
  }
  
}
