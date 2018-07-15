PVectorWarpedSquare[] myPVectorWarpedSquares = new PVectorWarpedSquare[195];
  
float currentRow = 0;
float currentColumn = 0;
float screenBorder = 20;
  
void setup() {
  size(480,420);
} //<>//

void draw() {
  background(204);
  smooth();  
  frameRate(10);
   
 
  
  for (int i = 0; i < myPVectorWarpedSquares.length; i=i+1) {
    float yGridPosition; // where is each square in the grid: y axis
    float xGridPosition; // where is each square in the grid: x axis
    float randomness;

    yGridPosition = screenBorder + (currentRow*30);
    xGridPosition = screenBorder + (currentColumn*30);
    
    randomness = 10/(0.2*(currentRow+1)); // Add 1 to avoid dividing by 0. Half if to lesen the amount of reduction per row
    
    if (yGridPosition > (height - (screenBorder + 10 + 11))) { // explain this!!
      // println("end of column");
      currentColumn = currentColumn + 1;
      
      currentRow = 0;
    } else {
      currentRow = currentRow + 1;  // only increment the row if we're still in the same column   
    }  
     
    myPVectorWarpedSquares[i] = new PVectorWarpedSquare(xGridPosition, yGridPosition, randomness); // Initialize objects 

  }  
  
  
  
    // Call functions of the objects
   for (int i = 0; i < myPVectorWarpedSquares.length; i++) {
    myPVectorWarpedSquares[i].display(); // Display each object }

  }
  
  
  // myPVectorWarpedSquare1 = new PVectorWarpedSquare(100, 100, 20); 
 // myPVectorWarpedSquare1.display();
 
 
 currentRow = 0;
 currentColumn = 0;
 
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
    xWidth = 20;
    yHeight = 20;
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
    strokeWeight(1); 
    line(point1.x, point1.y, point2.x, point2.y);
    line(point2.x, point2.y, point3.x, point3.y);
    line(point3.x, point3.y, point4.x, point4.y);
    line(point4.x, point4.y, point1.x, point1.y);
  }    
}
