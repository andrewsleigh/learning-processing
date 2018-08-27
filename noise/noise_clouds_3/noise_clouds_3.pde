// clouds
// made of perlin noise
// can I use a function to add some variation?

// yes, but I wonder if this rows and columns approach is what is giving me a weird cross-like result.
// because at the mid x points, and extremes of y, only the x is having an effect, and v/v
// we should combine the x and y at each point.

float startingOffset = 100;
float noiseIncrement = 0.01; // higher numbers mean greater variation
float noiseOffsetX = startingOffset; 
float noiseOffsetY = startingOffset;



void setup() {
  size(400, 400); 
}


void draw() {
  noLoop();

  for(int x = 0; x < width; x++) { // draw the columns
       
    noiseOffsetY = startingOffset; // every time you start a new column, need to reset the y offset
    
    for(int y = 0; y < height; y++) { // draw the rows
   
      stroke(map(noise(noiseOffsetX,noiseOffsetY),0,1,0,255));
      point(x,y);
      
      // increment the noise offset 
      // larger offsets result in more dramtic shifts
      noiseOffsetY = noiseOffsetY + noiseIncrement*generateSeed(y);
     }
    
    // increase the variation as you go from left to right
    noiseOffsetX = noiseOffsetX + noiseIncrement*generateSeed(x); 
   
  }

}


// functions to return a value between 0 and 1 based on current x,y and mode selected 
// 2D
float generateSeed(float x,float y, String mode) {
  // central bulge
  return (sin(map(x, 0, width, 0, PI)) + 
         sin(map(y, 0, height, 0, PI)))
         / 2;
}

//1D
float generateSeed(float x) { 
  // central bulge
  return sin(map(x, 0, width, 0, PI));
}
