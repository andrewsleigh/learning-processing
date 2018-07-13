// learning oop
// adding variation to the objects

Bubble myBubble1; // Declare an object.
Bubble myBubble2;

void setup() {
  myBubble1 = new Bubble(20, 60, 1, 2);// Initialize object.
  myBubble2 = new Bubble(100, 140, 2, 4);// Initialize object.  
  
  size(200,200);
}

void draw() {
  background(0);
  smooth();  

  // Call methods on the objects

  myBubble1.display();
  myBubble1.move();
  myBubble2.display();
  myBubble2.move();
}


class Bubble { 
  // data
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed;
  
  float xWidth;
  float yHeight;
  
  // float transparency; // can't get alpha to work, so leave this out for now
  color col; // colour
  
  // constructor, defined with arguments
  Bubble (float xPos_, float yPos_, float xSpeed_, float ySpeed_) { // use xyz_ to denote a temporary local variable
    //xPos = width/2;
    //yPos = height/2;
    
    xPos = xPos_;
    yPos = yPos_;
    xSpeed = xSpeed_;
    ySpeed = ySpeed_;

    
    xWidth = 60;
    yHeight = 60;
    
    // transparency = 50;
    col = color(0, 255, 100);    
  }  
  
  // methods
  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(col);
    ellipse(xPos, yPos, xWidth, yHeight); 
  }
  
  void move() {
    xPos = xPos + xSpeed;
    
    yPos = yPos + random(-1,1)*ySpeed; // more of a jiggle factor than speed
    
    if (xPos > (width + (xWidth / 2))) {
      xPos = -(xWidth / 2);
    }
    
    // probably should have a test for y as well...
    
  }  
  
  
}
