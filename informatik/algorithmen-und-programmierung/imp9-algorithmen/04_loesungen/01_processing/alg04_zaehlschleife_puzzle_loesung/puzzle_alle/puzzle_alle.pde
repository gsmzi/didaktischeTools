void setup(){

  size(1000,700);
  
  // Nummer 1
  
  for (int i=0; i<10; i++){
    ellipse(50+i*50,100,50,50);
  }
  
  // Nummer 2
  
  for (int i=0; i<10; i++){
    ellipse(50+i*50,200+i*25,50,50);
  }
  
  // Nummer 3
  
  for (int i=0; i<10; i++){
    ellipse(200,400,110-i*10,110-i*10);
  }
  
  // Nummer 4
  
  for (int i=0; i<20; i++){
    ellipse(700+i*10,300+i*10,200-i*10,200-i*10);
  }
  
  // Nummer 5
  
  for (int i=0; i<5; i++){
    rect(10+i*60,500,50,40);
  }
  
  // Nummer 6
  
  for (int i=0; i<5; i++){
    rect(10+i*60, 500+i*40, 50,40);
  }
  
  // Nummer 7
  
  for (int i=0; i<10; i++){
    rect(500,500,100-i*10, 100-i*10);
  }

}
