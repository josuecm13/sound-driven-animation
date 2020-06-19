Patricio patrick;
Bob bob;
Bus bus;
PImage bg;

void setup(){
  size(736,476, P2D);
  bg = loadImage("background.jpg");
  patrick = new Patricio(width + 50,height*3/4 ,5);
  bob = new Bob(-50,height*3/4);
  patrick.setLimit(width*1/4);
  bob.setLimit(width*1/8);
  bus = new Bus(width, height*3/5, 9);
  frameRate(27);
}

void draw(){
  image(bg,0,0);
  if(keyPressed){
    if(key == 'b' || key == 'b'){
      animation1();
    }
    if(key == '1'){
      animation3();
    }
    if(key == 'p' || key == 'P'){
      animation2();
    }
  }
  bob.update();
  patrick.update();
  bus.update();
}

void animation1(){
  bus.subscribeVictim((HittableByCar) bob);
  bob.move();
}

void animation2(){
  bus.subscribeVictim((HittableByCar) patrick);
  patrick.move();
}

void animation3(){
  bus.move();
}
