class Patricio{
  int xPos, yPos, arms, direction;
  float angle, velocity;
  Boolean isMoving; 
  
  Patricio(int x, int y, int arms){
    this.xPos = x;
    this.yPos = y;
    this.arms = arms;
    this.isMoving = false;
    this.velocity = 0;
    this.direction = -1; 
  }
  
  void move(){
    this.isMoving = true;
  }
  
  void stop(){
    this.isMoving = false;
  }
    
  void update(){
    
  }
  
  
  
  
}
