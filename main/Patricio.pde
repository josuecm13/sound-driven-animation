class Patricio{
  int  arms, direction, framecount;
  float xPos, yPos, angle, velocity;
  Boolean isMoving; 
  PShape shape;
  private int tMessage;
  
  Patricio(float x, float y, int arms){
    this.xPos = x;
    this.yPos = y;
    this.arms = arms;
    this.isMoving = false;
    this.velocity = 5;
    this.direction = -1; 
    this.framecount= 0;
    this.tMessage = 1;
    initStar(xPos, yPos, 50, 100, arms);
  }
  
  void initStar(float x, float y, float radius1, float radius2, int npoints) {
    float angle = (TWO_PI / npoints);
    float halfAngle = angle/2.0;
    shape = createShape();
    shape.beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      shape.vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      shape.vertex(sx, sy);
    }
    shape.endShape();
    shape.setStroke(color(252-50, 136-50, 112-50));
    shape.setFill(color(252, 136, 112));
  }
  
  void move(){
    this.isMoving = true;
  }
  
  void stop(){
    this.isMoving = false;
  }
  
  void triggerMessage(int trigger){
    if(trigger > 0){
      print("current xPos: ",xPos, " yPos: ", yPos);
      tMessage--;
    }
  }
    
  void update(){
    float rotationAngle = 0;
    if(isMoving){
      if(xPos > 0){
        xPos += direction*velocity;
      }else{
        triggerMessage(tMessage);
      }
      //rotationAngle = 0.11;
    }
    if(framecount%5 == 0){
      rotationAngle *= -1;
    }
    shape.rotate(rotationAngle);
    shape(shape,xPos,yPos*0.5);
    framecount++;
    framecount %= 30;
  }
  
  
  
  
}
