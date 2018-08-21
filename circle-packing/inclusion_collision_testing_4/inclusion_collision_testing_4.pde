// test for collision between multiple circles

// PDF export  ----------------------------------------------------
import processing.pdf.*;





// set up an array of circles
int maxCircles = 800;
int Circles[] = new int[maxCircles];

// and corresponding arrays for their positions
float circleXPositions[] = new float[maxCircles];
float circleYPositions[] = new float[maxCircles];
float circleRadii[] = new float[maxCircles];

float maxCircleRadius = 200;
float circleRadius = maxCircleRadius;
boolean doesCollide = false; // first circle won't collide
boolean shrinking = false;

void setup() {
  size(800,600);
 beginRecord(PDF, "filename.pdf"); // using this to create big screenshots for desktop wallpapers
}

void draw() {
  noLoop(); // no looping, just loop through the array of circles
  frameRate(1);
  ellipseMode(CENTER);
  background(55, 55, 0);
  noStroke();
  
  // loop through the array of circles
  for (int i = 0; i < Circles.length; i++) {
    
    println(i);
    
    // set the position for a hypothetical circle
    float xPos = random(0,width);
    float yPos = random(0,height); 
    
    if (i > 0) {
    
      // loop through all previous circles and test for collision
      for (int j=0; j < i ; j++) {
        
        if (testForCollision(circleXPositions[j], circleYPositions[j], xPos, yPos, circleRadius, circleRadii[j])) { // change the test to acount for dynamic radii
          doesCollide = true;
          break;
        } else {
          doesCollide = false; // OK, draw it!
        }
      }
   
    }
    //only commit to this circle if it doesn't collide
    
    if (! doesCollide) {
      // load its final dimensions into arrays, so we can test against these when making new circles        
      circleXPositions[i] = xPos;
      circleYPositions[i] = yPos;
      circleRadii[i] = circleRadius;
      println(circleRadius);
      
      // draw it
      
      
      float minRed = map(i,0,Circles.length,0,255);
      float minGreen = map(i,0,Circles.length,200,0);
      
      fill(random(minRed,255), random(minGreen,200), random(50,150));
      ellipse(xPos, yPos, 2*circleRadius, 2*circleRadius); // remember to multiply radius by 2 to get the width and height of the ellipse
      

      // start the next circle at max possible radius
      //shrinking = false;
      circleRadius = maxCircleRadius;
      
    } else {  // or if it does collide
      
        // possible shrinking strategies:
        
        /*
        // 1a. Decrease by 1 each time (assuming we're above 1 to start with
        // quite slow and maybe cirlces get small quite quickly...?
        
          if (circleRadius > 1) { // only decrease the radius if it's more than 1
            circleRadius--; //decrease the radius
          } else { // otherwise, start again with max radius 
            circleRadius = maxCircleRadius;
          }
        */
        /*
        // 1b. Same, but if resetting, start at a smaller size
        *
          if (circleRadius > 1) { // only decrease the radius if it's more than 1
            circleRadius--; //decrease the radius
          } else { // otherwise, start again with max radius 
            circleRadius = maxCircleRadius/4;
          }
        /
        
        /**/
        // 2. decrease by small percentage (so never goes below 0)
        // dense packing (lots of large circles) but very slow  
        // on a test, this resulted in about 300 tries for the final circle (looking at th eprinted statements on the console) 
          circleRadius = circleRadius * 0.99; //decrease the radius
        
        /*
        // 2b. decrease by large percentage (so never goes below 0)
        // quick but leaves lots of space, due to lots of small circles
          circleRadius = circleRadius * 0.8; //decrease the radius
        */
        
        
        i--; // try this circle again
    }
    
    
  }

  endRecord();

}


boolean testForCollision(float existingCircleXPos, float existingCircleYPos, float newCircleXPos, float newCircleYPos, float existingCircleRadius, float newCircleRadius) {
 
  if (dist(existingCircleXPos, existingCircleYPos, newCircleXPos, newCircleYPos) < existingCircleRadius+newCircleRadius) {
    return true;
  } else {
    return false;
  }  
  
}
