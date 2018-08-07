float waveHeight = 50;
float waveYCrossover = 100;
float waveWidth = 30;
float waveStartX = 20;
float numberOfPoints = 12;



void setup() {
 
  size(400, 200);
  background(200); 
  
}

void draw() {
  smooth();
  noFill();
  noLoop();

  beginShape();
  vertex(waveStartX, waveYCrossover); // first anchor point
  
  for (int i = 0; i < numberOfPoints; i = i+1) {
  
    bezierVertex(waveStartX+(waveWidth*PI/8),(waveYCrossover - waveHeight), // first control point
                 (waveStartX+waveWidth)-(waveWidth*PI/8),(waveYCrossover - waveHeight), // second control point
                 (waveStartX + waveWidth),waveYCrossover);  // second anchor point
    
                 waveStartX = waveStartX + waveWidth; // move the x axis along by the width of the wave for the next curve
                 waveHeight = - waveHeight; // flip the wave hieght over so we get the other side of the curve
  }               
               
  endShape();

}
