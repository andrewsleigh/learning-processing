// test for collision between multiple circles

// set up an array of circles
int maxCircles = 20;
int Circles[] = new int[maxCircles];

// and corresponding arrays for their positions
float circleXPositions[] = new float[maxCircles];
float circleYPositions[] = new float[maxCircles];

float circleRadius = 30;

void setup() {
  size(400,400);

}

void draw() {
  noLoop(); // no looping, just loop through the array of circles
  ellipseMode(CENTER);
  background(200);
  
  // loop through the array of circles
  for (int i = 0; i < Circles.length; i++) {
    
    // set the position for a hypothetical circle
    float xPos = random(0,width);
    float yPos = random(0,height); 
    
    // loop through all previous circles and test for collision
    for (int j=0; j < i ; j++) {
      if (testForCollision(circleXPositions[j], circleYPositions[j], xPos, yPos, circleRadius, circleRadius)) {
        fill(255,0,0,50);
        break;
      } else {
        fill(0,255,0,50);
      }
  }
    // load its final dimensions into arrays, so we can test against these when making new circles        
    circleXPositions[i] = xPos;
    circleYPositions[i] = yPos;
    
    // draw it
    ellipse(xPos, yPos, 2*circleRadius, 2*circleRadius);
    
    
    
  }
}


boolean testForCollision(float existingCircleXPos, float existingCircleYPos, float newCircleXPos, float newCircleYPos, float existingCircleRadius, float newCircleRadius) {
 
  if (dist(existingCircleXPos, existingCircleYPos, newCircleXPos, newCircleYPos) < existingCircleRadius+newCircleRadius) {
    return true;
  } else {
    return false;
  }  
  
}
