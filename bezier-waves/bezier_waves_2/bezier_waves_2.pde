float waveHeight = 50;
float waveYCrossover = 100;
float waveWidth = 30;
float waveStartX = 20;
float numberOfPoints = 12;




void setup() {
 
  size(400, 200);
  background(200); 
  
  
  //Initialize plotter
  println("IN;SP1;");
  
}

void draw() {
  smooth();
  noFill();
  noLoop();

  beginShape();
  vertex(waveStartX, waveYCrossover); // first anchor point
  println("PU" + waveStartX + "," + waveYCrossover + "; PD;");
  
  for (int i = 0; i < numberOfPoints; i = i+1) {
    
    float firstControlPointX = waveStartX+(waveWidth*PI/8);
    float firstControlPointY = waveYCrossover - waveHeight;
    
    float secondControlPointX = waveStartX+waveWidth-(waveWidth*PI/8);
    float secondControlPointY = (waveYCrossover - waveHeight);
    
    float secondAnchorPointX = (waveStartX + waveWidth);
    float secondAnchorPointY = waveYCrossover;
  
    bezierVertex(firstControlPointX,firstControlPointY, // first control point
                 secondControlPointX,secondControlPointY, // second control point
                 secondAnchorPointX,secondAnchorPointY);  // second anchor point
                 
                 // plotter
                 println("BZ" + firstControlPointX + "," + firstControlPointY + ","
                         + secondControlPointX + "," + secondControlPointY + "," 
                         + secondAnchorPointX + "," + secondAnchorPointY + ";");
    
                 waveStartX = waveStartX + waveWidth; // move the x axis along by the width of the wave for the next curve
                 waveHeight = - waveHeight; // flip the wave height over so we get the other side of the curve
  }               
               
  endShape();
  println("PU;");
}
