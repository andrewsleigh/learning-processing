PVectorWarpedSquare myPVectorWarpedSquare1;

void setup() {
  size(400,400);
} //<>//

void draw() {
  background(204);
  smooth();  
  frameRate(10);
  
  // move the initialisation to the draw function so a new shape is created on each screen redraw
  myPVectorWarpedSquare1 = new PVectorWarpedSquare(100, 100, 20); 
  myPVectorWarpedSquare1.display();
}


class PVectorWarpedSquare { 
  
  // data
  float xPos;
  float yPos;
  float xWidth;
  float yHeight;
  color col;  
  float ran; // randomness
  
  PVector point1; 
  PVector point2;
  PVector point3;
  PVector point4;


  // constructor, defined with arguments
  PVectorWarpedSquare (float xPos_, float yPos_, float ran_) {
    xPos = xPos_;
    yPos = yPos_; 
    xWidth = 200;
    yHeight = 200;
    col = color(0); 
    ran = ran_;
    
        
    point1 = new PVector(xPos+random(-ran,ran),yPos+random(-ran,ran)); 
    point2 = new PVector(xPos+xWidth+random(-ran,ran),yPos+random(-ran,ran));
    point3 = new PVector(xPos+xWidth+random(-ran,ran),yPos+yHeight+random(-ran,ran));
    point4 = new PVector(xPos+random(-ran,ran),yPos+yHeight+random(-ran,ran));
    
  }  
  
  // functions
  
  void display(){  
    //draw shape  
    strokeWeight(2); 
    line(point1.x, point1.y, point2.x, point2.y);
    line(point2.x, point2.y, point3.x, point3.y);
    line(point3.x, point3.y, point4.x, point4.y);
    line(point4.x, point4.y, point1.x, point1.y);
  }  
    
  
}
