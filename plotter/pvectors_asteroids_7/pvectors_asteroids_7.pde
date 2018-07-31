// solved rotation problem
// added crater, but the're not 'inside' asteroids. 
// can I change this?

import processing.serial.*;

Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object
int val;          // Data received from the serial port
int lf = 10;      // ASCII linefeed

//Enable plotting?
//////////////////////////////////////////
final boolean PLOTTING_ENABLED = false; ///////////////////////////////// check this!!!!!
//////////////////////////////////////////

//Plotter dimensions
//int xMin = 170 / 2;
//int yMin = 602 / 2;
int xMax = 15370 / 2;
int yMax = 10602 / 2;

int xMin = 0;
int yMin = 0;

// asteroid parameters
float phi = 0;      //initial rotation
float startX = 100; //offset
float startY = 100;
float spaceH = 200;  //spacing
float spaceW = 200;


Asteroid[] myAsteroid = new Asteroid[20];
Crater[] myCrater = new Crater[20];
  
void setup(){
  background(233, 233, 220);
  size(800, 600);
  noSmooth();
  frameRate(1);
    
  
  //Select a serial port
  println(Serial.list()); //Print all serial ports to the console
  String portName = Serial.list()[3]; //make sure you pick the right one
  println("Plotting to port: " + portName);
  
  //Open the port
  if (PLOTTING_ENABLED) {
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil(lf);
    
    //Associate with a plotter object
    plotter = new Plotter(myPort);
    
    //Initialize plotter
    plotter.write("IN;SP1;");
  }  

}  


void draw(){
  noLoop();

  // Declare and initialise and call methods on Asteroid objects at the same time
  
  float resizeRow = 1;
  for (int i = 0; i < myAsteroid.length; i++) {
    
    float rotation = random(-360, 360);
   // float rotation = random(-0, 0);
    float resize = random(8, 11);
    
  
    myAsteroid[i] = new Asteroid(startX, startY, resize*resizeRow, resize*resizeRow, rotation, 0.5);
    myAsteroid[i].drawIt();
    
  
    //myCrater[i] = new Crater(startX, startY, resize*resizeRow, resize*resizeRow, rotation, 0.3);
    //myCrater[i].drawIt();
    
    
    
    if (startX < width-spaceW) {
      startX = startX+spaceW;
    } else {
      startX = 100;
      startY = startY+spaceH;
      resizeRow = resizeRow * 1.2; // make each row a bit bigger 
      spaceH = resizeRow * spaceH; // also increase vertical spacing, but not horizontal
    }    
  }
}  
