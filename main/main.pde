Patricio patrick;
PImage bg;

void setup(){
  size(736,476, P2D);
  bg = loadImage("background.jpg");
  patrick = new Patricio(width/2,height/2,5);
  //frameRate(27);
}


void draw(){
  image(bg,0,0);
  if(keyPressed){
    if(key == 'p' || key == 'P'){
      animation2();
    }
  }
  patrick.update();
}

void animation2(){
  patrick.move();
}
