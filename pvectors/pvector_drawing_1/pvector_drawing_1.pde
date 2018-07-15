// using pvectors to draw simple shapes
// redundant when simple, but can let you draw more complex variations on shapes
// by modifying the pvectors

SimpleSquare mySimpleSquare1; // Declare objects
PVectorSquare myPVectorSquare1;
PVectorWarpedSquare myPVectorWarpedSquare1;


void setup() {
  size(400,400);
  mySimpleSquare1 = new SimpleSquare(10, 10); // Initialize objects //<>//
  myPVectorSquare1 = new PVectorSquare(120, 120);
  myPVectorWarpedSquare1 = new PVectorWarpedSquare(230, 230);
}

void draw() {
  background(204);
  smooth();  
  mySimpleSquare1.display();
  myPVectorSquare1.display();
  myPVectorWarpedSquare1.display();
}


class SimpleSquare { 
  // data
  float xPos;
  float yPos;
  float xWidth;
  float yHeight;
  color col;  

  // constructor, defined with arguments
  SimpleSquare (float xPos_, float yPos_) {
    xPos = xPos_;
    yPos = yPos_; 
    xWidth = 100;
    yHeight = 100;
    col = color(0); 
  }  
  
  // functions
  void display(){  
    //draw shape  
    line(xPos, yPos, xPos+xWidth, yPos);
    line(xPos+xWidth, yPos, xPos+xWidth, yPos+yHeight);
    line(xPos+xWidth, yPos+yHeight, xPos, yPos+yHeight);
    line(xPos, yPos+yHeight, xPos, yPos);
  }   
}


class PVectorSquare { 
  
  // data
  float xPos;
  float yPos;
  float xWidth;
  float yHeight;
  color col;  

  PVector point1; 
  PVector point2;
  PVector point3;
  PVector point4;


  // constructor, defined with arguments
  PVectorSquare (float xPos_, float yPos_) {
    xPos = xPos_;
    yPos = yPos_; 
    xWidth = 100;
    yHeight = 100;
    col = color(0); 
        
    point1 = new PVector(xPos,yPos); 
    point2 = new PVector(xPos+xWidth,yPos);
    point3 = new PVector(xPos+xWidth,yPos+yHeight);
    point4 = new PVector(xPos,yPos+yHeight);
    
  }  
  
  // functions
  
  void display(){  
    //draw shape  
    line(point1.x, point1.y, point2.x, point2.y);
    line(point2.x, point2.y, point3.x, point3.y);
    line(point3.x, point3.y, point4.x, point4.y);
    line(point4.x, point4.y, point1.x, point1.y);
  }  
    
  
}



class PVectorWarpedSquare { 
  
  // data
  float xPos;
  float yPos;
  float xWidth;
  float yHeight;
  color col;  

  PVector point1; 
  PVector point2;
  PVector point3;
  PVector point4;


  // constructor, defined with arguments
  PVectorWarpedSquare (float xPos_, float yPos_) {
    xPos = xPos_;
    yPos = yPos_; 
    xWidth = 100;
    yHeight = 100;
    col = color(0); 
        
    point1 = new PVector(xPos-43,yPos+12); 
    point2 = new PVector(xPos+xWidth-10,yPos+3);
    point3 = new PVector(xPos+xWidth,yPos+yHeight+60);
    point4 = new PVector(xPos-20,yPos+yHeight);
    
  }  
  
  // functions
  
  void display(){  
    //draw shape  
    line(point1.x, point1.y, point2.x, point2.y);
    line(point2.x, point2.y, point3.x, point3.y);
    line(point3.x, point3.y, point4.x, point4.y);
    line(point4.x, point4.y, point1.x, point1.y);
  }  
    
  
}
