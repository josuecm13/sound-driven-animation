Patricio patrick;
Bob bob;
PImage bg;

void setup(){
  size(736,476, P2D);
  bg = loadImage("background.jpg");
  patrick = new Patricio(width/2,height/2,5);
  bob = new Bob(width/2,height/2,5);
  //frameRate(27);
}


void draw(){
  image(bg,0,0);
  if(keyPressed){
    if(key == 'b' || key == 'b'){
      animation1();
    }
    if(key == 'p' || key == 'P'){
      animation2();
    }
  }
  bob.update();
  patrick.update();
}

void animation1(){
  bob.move();
}

void animation2(){
  patrick.move();
}
