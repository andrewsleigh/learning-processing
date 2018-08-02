// learning  arrays


// Declare and create the array
Grain[] myGrains = new Grain[200];

float currentRow = 1;
float currentColumn = 1;

void setup() {
  size(400,400);

  for (int i = 0; i < myGrains.length; i=i+1) {
    float yGridPosition; // where is each grain in the grid: y axis
    float xGridPosition; // where is each grain in the grid: x axis

    yGridPosition = (currentRow*20); //<>//
    xGridPosition = currentColumn*20;
    
    if (yGridPosition > (height-40)) {
      // println("end of column");
      currentColumn = currentColumn + 1;
      currentRow = 0;
    }  
     
    myGrains[i] = new Grain(xGridPosition, yGridPosition); // Initialize objects 
    currentRow = currentRow + 1;
  }  
  
}

void draw() {
  background(204);
  smooth();  

  // Call functions of the objects
   for (int i = 0; i < myGrains.length; i++) {
    myGrains[i].display(); // Display each object }

  }
}


class Grain { 
  // data
  float xPos;
  float yPos;
  float xWidth;
  float yHeight;
  color col;  

  // constructor, defined with arguments
  Grain (float xPos_, float yPos_) {
    xPos = xPos_;
    yPos = yPos_; 
    xWidth = 9;
    yHeight = 9;
    col = color(0); 
  }  
  
  // functions
  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(col);
    ellipse(xPos, yPos, xWidth, yHeight); 
  }
}
