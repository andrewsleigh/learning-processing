// PVector mover example
// incorporate all PVector lessons in one OOP example
// add acceleration of different types - static and relative to mouse position

// declare object;
Mover mover;


void setup() {
  size(400,400);
  
  // initialize object
  mover = new Mover();
  
}


void draw() {
  background(100);
  
  // call object methods
  mover.display();
  mover.update();
  mover.checkEdges();

}

// Class


class Mover {
  
  // data
  PVector location;
  PVector velocity;
  PVector acceleration;
  float xAccOffset = 0.01;
  PVector centerOfScreen;
  PVector mousePosition;
  PVector mousePositionRelativeToCenter;
  
  //constructor - this function is called when a new object is initalised
  Mover() {
    noStroke();
    location = new PVector(200,200);
    velocity = new PVector(2,3);
  }
  
  
  // methods
  
  void update() {
    // create acceleration forces
    // 1. static acceleration
    // acceleration = new PVector(1,0); 

    
    // 2. Random/noise based acceleration
    // acceleration tends to throw the ball off the screen...
    // tends to be worse with perlin noise (or fixed acc) as you get consistent acceleration in one direction
    // https://stackoverflow.com/questions/22154410/accelerated-ball-leaving-screen-processing-2-1
     
    acceleration = new PVector(map(noise(1000,xAccOffset),0,1,-1,1),random(-0.1,0.1)); 
    xAccOffset = xAccOffset + 0.01; //increment the offest every time this function is called
    
    // 3. Acceleration based on mouse position relative to centre of screen
    mousePosition = new PVector(mouseX, mouseY);
    centerOfScreen = new PVector(width/2, height/2);
    mousePositionRelativeToCenter = mousePosition.sub(centerOfScreen);
    mousePositionRelativeToCenter = mousePositionRelativeToCenter.normalize(); // reduce it down to manageable amount
 
    // add acceleration forces for velocity, then add velocity to position
    velocity = velocity.add(acceleration);    
    velocity = velocity.add(mousePositionRelativeToCenter);
    location = location.add(velocity);  // add 2 PVectors using built in function of class

  }
  

  
  void display() {
    ellipseMode(CENTER);
    ellipse(location.x, location.y, 19,19); //accessing individual elements of the PVector
  }
  
  void checkEdges() { // includes fixes for ball going off edge of screen
    if (location.x > width)  {
      velocity.x = -velocity.x; 
      location.x = width;
    }
   
    if (location.x  < 0)  {
      velocity.x = -velocity.x; 
      location.x = 0;
    }
    
    if (location.y > height)  {
      velocity.y = -velocity.y; 
      location.y = height;
    }  
    
    if (location.y  < 0)  {
      velocity.y = -velocity.y; 
      location.y = 0;
    } 
  }
  
  
}
