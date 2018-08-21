// simplest possible test for inclusion

float circle1XPos = 200;
float circle1YPos = 200;
float circle1Radius = 80;

float circle2XPos; // we'll assign these values dynamically
float circle2YPos;
float circle2Radius = 30;

void setup() {
  size(400,400);

}

void draw() {
  
  ellipseMode(CENTER);
  background(200);
  
  if (testForCollision()) {
    fill(255,0,0,50);
  } else {
    fill(0,255,0,50);
  }
  
  // draw the first circle in a static, known position
  ellipse(circle1XPos, circle1YPos, 2*circle1Radius, 2*circle1Radius);
  
  circle2XPos = mouseX;
  circle2YPos = mouseY;
  

  if (testForInclusion()) {
    fill(255,0,0,50);
  } else {
    fill(0,255,0,50);
  }

  ellipse(circle2XPos, circle2YPos, 2*circle2Radius, 2*circle2Radius);

}


boolean testForInclusion() { // is the center of the new circle inside an existing circle?

  if (dist(circle1XPos, circle1YPos, circle2XPos, circle2YPos) < circle1Radius) {
    return true;
  } else {
    return false;
  }
}
    
boolean testForCollision() {
 
  if (dist(circle1XPos, circle1YPos, circle2XPos, circle2YPos) < circle1Radius+circle2Radius) {
    return true;
  } else {
    return false;
  }  
  
}
