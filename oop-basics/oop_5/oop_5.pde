// learning oop
// using arrays

int numberOfBubbles = 60;
// Declare and create the array
Bubble[] myBubbles = new Bubble[numberOfBubbles];

void setup() {
  for (int i = 0; i < 60; i=i+1) {
  int y = i * 5;    
    myBubbles[i] = new Bubble(20, y, 1+i/2, i);// Initialize object.
  }  
  
  size(800,400);
  frameRate(10);
}

void draw() {
  background(0);
  smooth();  

  // Call functions of the objects
   for (int i = 0; i < myBubbles.length; i++) {
    myBubbles[i].display(); // Display each object }

    myBubbles[i].move(); // Move each object
  }
}


class Bubble { 
  // data
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed;
  float xWidth;
  float yHeight;
  color col; // colour
  
  // constructor, defined with arguments
  Bubble (float xPos_, float yPos_, float xSpeed_, float ySpeed_) { // use xyz_ to denote a temporary local variable
    xPos = xPos_;
    yPos = yPos_;
    xSpeed = xSpeed_;
    ySpeed = ySpeed_;    
    xWidth = 20;
    yHeight = 20;
    col = color(0, 255, 100);    
  }  
  
  // functions
  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(col);
    ellipse(xPos, yPos, xWidth, yHeight); 
  }
  
  void move() {
    xPos = xPos + xSpeed;   
    yPos = yPos + random(-0.5,0.5)*ySpeed; // more of a jiggle factor than speed
    
    if (xPos > (width + (xWidth / 2))) {
      xPos = -(xWidth / 2);
    }    
  }  
}
