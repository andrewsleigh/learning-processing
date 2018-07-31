// this works.
// next, try sending data directly to the plotter.

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
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(lf);
  
  //Associate with a plotter object
  plotter = new Plotter(myPort);
  
  //Initialize plotter
  plotter.write("IN;SP1;");

}  


void draw(){
  noLoop();
  
  // Declare and initialise and call methods on Asteroid objects at the same time
  
 
  for (int i = 0; i < myAsteroid.length; i++) {
    
    float rotation = random(-360, 360);
  
    myAsteroid[i] = new Asteroid(startX, startY, 10, 10, rotation, 0.3);
    myAsteroid[i].drawIt();
    
    if (startX < width-spaceW) {
      startX = startX+spaceW;
    } else {
      startX = 100;
      startY = startY+spaceH;
    }
    

     
   

  }
  
  
  //Asteroid s = new Asteroid(startX+spaceW+phi, startY+spaceH+phi, 15, 15, 90, 0.1);
  //s.drawIt();
  //Asteroid t = new Asteroid(startX+spaceW+phi, startY+spaceH+phi, 20, 20, 1, 0.4);
  //t.drawIt();  
}  




class Asteroid {
  // data  
  float tx, ty; // position
  float w, h; // size
  float r; // rotation
  float ran; // randomness of each point
  
  // file:///Applications/Processing.app/Contents/Java/modes/java/reference/ArrayList.html
  // An ArrayList stores a variable number of objects. 
  // This is similar to making an array of objects, but with an ArrayList, items can be easily 
  // added and removed from the ArrayList and it is resized dynamically. 
  // This can be very convenient, but it's slower than making an array of objects when using many elements.
  ArrayList<PVector> asteroidPoints = new ArrayList<PVector>();
  
  // constructor  
  Asteroid(float xpos, float ypos, float scaleX, float scaleY, float rot, float randomFactor_) {
    
    tx  = xpos;
    ty  = ypos;
    w = scaleX; //scale
    h = scaleY;
    r = radians(rot);    
    ran = randomFactor_; 
  
    asteroidPoints.add(new PVector(0,0) );
    asteroidPoints.add(new PVector(2+random(-ran,ran),1+random(-ran,ran)) );
    asteroidPoints.add(new PVector(5+random(-ran,ran),2+random(-ran,ran)) );
    asteroidPoints.add(new PVector(6+random(-ran,ran),4+random(-ran,ran)) );
    asteroidPoints.add(new PVector(6+random(-ran,ran),5+random(-ran,ran)) );
    asteroidPoints.add(new PVector(5+random(-ran,ran),6+random(-ran,ran)) );
    asteroidPoints.add(new PVector(5+random(-ran,ran),7+random(-ran,ran)) );
    asteroidPoints.add(new PVector(4+random(-ran,ran),8+random(-ran,ran)) );
    asteroidPoints.add(new PVector(2+random(-ran,ran),8+random(-ran,ran)) );
    asteroidPoints.add(new PVector(0+random(-ran,ran),6+random(-ran,ran)) );
    asteroidPoints.add(new PVector(0+random(-ran,ran),5+random(-ran,ran)) );
    asteroidPoints.add(new PVector(-1+random(-ran,ran),3+random(-ran,ran)) );
    asteroidPoints.add(new PVector(0,0) );
    
  }
  
  // methods
  
    void drawIt(){  
      //draw shape  
      for (int i=0; i<asteroidPoints.size()-1; i++){
        drawLine(
          rotX(                        // starting x point
            asteroidPoints.get(i).x, 
            asteroidPoints.get(i).y
          )
          *w     // x width scale factor
          +tx,   // x starting position
          rotY(                        // starting y point
            asteroidPoints.get(i).x, 
            asteroidPoints.get(i).y
          )
          *h+ty, 
          rotX(                        // ending x point
            asteroidPoints.get(i+1).x, 
            asteroidPoints.get(i+1).y
          )
          *w+tx, 
          rotY(                        // ending y point
            asteroidPoints.get(i+1).x,
            asteroidPoints.get(i+1).y
          )
          *h+ty, 
          (i==0)                       // if we're drawing the first point, set pen up to true
        );
        
        if (i==asteroidPoints.size()-2){ // if we've got to the last point, put pen up
          plotter.write("PU;");  
        }
      } 
    if (PLOTTING_ENABLED){
      delay(1000); // wait a bit between each shape
    }    
  
  }
    
    void drawLine(float x1, float y1, float x2, float y2, boolean up){
      // draw the line on screen
      line(x1, y1, x2, y2);
      
      // generate the HPGL instructions for that line
      float _x1 = map(x1, 0, width, xMin, xMax);
      float _y1 = map(y1, 0, height, yMin, yMax);
      float _x2 = map(x2, 0, width, xMin, xMax);
      float _y2 = map(y2, 0, height, yMin, yMax);
      String pen = "PD";
      if (up) {
        pen="PU";
      }
      plotter.write(pen+_x1+","+_y1+";");
      //plotter.write("PD"+_x2+","+_y2+";"); 
      plotter.write("PD"+_x2+","+_y2+";", 75); //75 ms delay
    }
   
    // helper functions to handle rotation
    float rotX(float inX, float inY){ // I don't really know what these rotation functions do...
     return (inX*cos(r) - inY*sin(r)); 
    }
    float rotY(float inX, float inY){
     return (inX*sin(r) + inY*cos(r)); 
    }
  
}  



/*************************
  Simple plotter class
*************************/

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
