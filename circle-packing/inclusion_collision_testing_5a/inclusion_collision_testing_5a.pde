// circle packing for the plotter
// very slow as it nears the end
// should be rewritten perhaps to start with all small circles set up, and then increase them in size

// PDF export  ----------------------------------------------------
import processing.pdf.*;

import java.util.*; 
Random generator; // Java's Random class

import processing.serial.*;
Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object
int val;          // Data received from the serial port
int lf = 10;      // ASCII linefeed

//Enable plotting?
final boolean PLOTTING_ENABLED = true;


// set up an array of circles
int maxCircles = 300;
int Circles[] = new int[maxCircles];

// and corresponding arrays for their positions
float circleXPositions[] = new float[maxCircles];
float circleYPositions[] = new float[maxCircles];
float circleRadii[] = new float[maxCircles];

float maxCircleRadius = 90;
float minCircleRadius = 3;
float xPos;
float yPos;
float circleRadius = maxCircleRadius;
boolean doesCollide = false; // first circle won't collide
boolean pickNewXY = true;

// set up looping through array within draw loop
int i = 0;

void setup() {
  // size(297,210); // simulate A4
  size(420, 297);
  background(255);
  frameRate(60);
  noSmooth();
  noFill();
  generator = new Random();
  
  beginRecord(PDF, "filename.pdf"); // using this to create big screenshots for desktop wallpapers
 
  if (PLOTTING_ENABLED) {
     
    //Select a serial port
    println(Serial.list()); //Print all serial ports to the console
    String portName = Serial.list()[7]; //make sure you pick the right one
    println("Plotting to port: " + portName);
    
    //Open the port
  
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil(lf);
  
    //Associate with a plotter object
    plotter = new Plotter(myPort);

  }
  
  
  //Initialize plotter
  String plotterInit = "IN;SC0,"+ width + "," + height + ",0;SP1;"; // SC scales the plotter area to the smae dimensions as the sketch, flipping back the y-axis

  println(plotterInit);
  if (PLOTTING_ENABLED) {
    plotter.write(plotterInit, 2000);
  }
  
   if (PLOTTING_ENABLED) {
    delay(4000); // wait for the plotter to initialise and grab the pen 
  }

 
}

void draw() {
  ellipseMode(CENTER);
    
    println(i);
    println(pickNewXY);
    
    if (pickNewXY) { // only generate new XY if we're starting a fresh circle
      /**/
      // set the position for a hypothetical circle
      xPos = random(0,width);
      yPos = random(0,height); 
    }  
 
    if (i == 0) { // use this test only for the first circle,
      if (testForCollision(0, 0, xPos, yPos, circleRadius, 0)) { // set up a fake other circle to test it against, with a radius of 0
        doesCollide = true;
      } else {
        doesCollide = false; // OK, draw it!
      }
    }
    
    
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
      //println(circleRadius);
      
      // draw it
      
       ellipse(xPos, yPos, 2*circleRadius, 2*circleRadius); // remember to multiply radius by 2 to get the width and height of the ellipse
      
      // plotter instructions
      println("PA" + xPos + "," + yPos + ";");
      println("CI" + circleRadius + ";");
      if (PLOTTING_ENABLED) {
        plotter.write("PA" + xPos + "," + yPos + ";");
        plotter.write("CI" + circleRadius + ";", 1000); // add a small delay every time we get a successful circle
      }
      
      // start the next circle at max possible radius
      circleRadius = maxCircleRadius;
      
    
    } else {  // or if it does collide
     if (circleRadius > minCircleRadius) { // only decrease the radius if it's more than min we set
        circleRadius--; //decrease the radius
        i--; // try this circle again
        pickNewXY = false; // use the same co-ordinates
        
      } else { // otherwise, start  circle with max radius 
        circleRadius = maxCircleRadius;
        pickNewXY = true;
        i--; // try this circle again - remove this to skip it
      }

      
    }
    
 // endRecord();
 

 i++;
 if (i == Circles.length) { // stop the draw loop when we reach the end of the array of circles
   noLoop();
 }
 

}


boolean testForCollision(float existingCircleXPos, float existingCircleYPos, float newCircleXPos, float newCircleYPos, float newCircleRadius, float existingCircleRadius) {
 
  if (dist(existingCircleXPos, existingCircleYPos, newCircleXPos, newCircleYPos) < existingCircleRadius+newCircleRadius
    || newCircleXPos + newCircleRadius >= width
    || newCircleXPos - newCircleRadius <= 0
    || newCircleYPos + newCircleRadius >= height
    || newCircleYPos - newCircleRadius <= 0)  
  {
    return true;
  } else {
    return false;
  }  
}



/* Simple plotter class    */

class Plotter {
  Serial port;
  
  Plotter(Serial _port){
    port = _port;
  }
  
  void write(String hpgl){
    if (PLOTTING_ENABLED){
      port.write(hpgl);
    }
  }
  
  void write(String hpgl, int del){
    if (PLOTTING_ENABLED){
      port.write(hpgl);
      delay(del);
    }
  }
}
