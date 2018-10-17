// based on vasarely_traces_7
// https://andrewsleigh.com/learning/processing/2018/10/vasarely-traces.html

// v1
// uses a variety of factors to influence colour on each face: 
// time elapsed (which reverses after 255 millis), 
// mouseX or mouseY

// v2 
// got centre bulge factor working on left face, but can't get horizontal gradient factor to work


// v3
// fixed gradient effect
// flipped around some values for sliders and colculation for bulge and gradient effect so it makes more sense
// more of a vignete than a bulge

// v4
// added noise factor


// ----------------------------------------------------------------------------- GO >>>


// PDF export  ----------------------------------------------------

import processing.pdf.*;
boolean record;

// onscreen controllers ---------------------------------------------
import controlP5.*;
ControlP5 cp5; // Declare ControlP5 object  - mine is called cp5
float LeftFaceRed;
float LeftFaceGreen;
float LeftFaceBlue;
float LeftFaceCenterBulge;
float LeftFaceTopDownGradient;
float LeftFaceNoise;

float TopFaceRed;
float TopFaceGreen;
float TopFaceBlue;
float TopFaceCenterBulge;
float TopFaceTopDownGradient;
float TopFaceNoise;

float BottomFaceRed;
float BottomFaceGreen;
float BottomFaceBlue;
float BottomFaceCenterBulge;
float BottomFaceTopDownGradient;
float BottomFaceNoise;

// declare arrays of objects

int numberOfCubes = 1000; // just make shedloads!
int columns; // reset this dynamically when we know size of canvas
// columns must be an integer, so we can test later on if we're on the final column
float rows; // = numberOfCubes / columns;

int currentColumn = 0;
int currentRow = 0;
boolean oddRow = false;  // use this to alternate rows for tesselation
float xNudge; // use this to alternate rows for tesselation
boolean lastCubeInEvenRow = false; // use to give nice edges

float cubeHeight = 48;
float cubeWidth = 2 * cubeHeight * tan(radians(30));
float cubeXSpacing = ((cubeHeight/2) * tan(radians(30)) * 6);
// float padding = 70;


Cube[] arrayCube = new Cube[numberOfCubes];



// set up some variables for timing related colour changes:
int currentFrame = 0;
boolean currentFrameIncrement = true; // time goes forward

void setup () {
  size(800,600);
  //fullScreen();
  frameRate(10);
  
  // columns = int(round((width) / (cubeXSpacing))) ; // force to be an int, after rounding to the nearest whole number
  // rows = (numberOfCubes / columns;
  
  columns = int(width / cubeXSpacing) + 2; // lots of excess outside the screen
  rows = 2 * int(height / cubeHeight) + 3;
  
  //println(columns);

  // initialize  objects
  for (int i = 0; i < arrayCube.length; i=i+1) {
     arrayCube[i] = new Cube(); // no arguments passed to constructor method  
  }
  
  // GUI -----------------------------------------------------------------

  cp5 = new ControlP5(this); // Initialise ControlP5 object (called cp5)
  
  
   
   //.setPosition(10,10)
   //.setSize(100,20)
   //.setRange(0,255) 
   //.setValue(0)
   //;
   
   cp5.addSlider("LeftFaceRed").setRange(0,255).setPosition(10, 10).setCaptionLabel("Left R");
   cp5.addSlider("LeftFaceGreen").setRange(0,255).setPosition(10, 30).setCaptionLabel("Left G"); 
   cp5.addSlider("LeftFaceBlue").setRange(0,255).setPosition(10, 50).setCaptionLabel("Left B");
   
   cp5.addSlider("LeftFaceCenterBulge").setRange(0,1).setPosition(10, 80).setCaptionLabel("Left Vignette");
   cp5.addSlider("LeftFaceTopDownGradient").setRange(0,1).setPosition(10, 100).setCaptionLabel("Left Gradient");
   cp5.addSlider("LeftFaceNoise").setRange(0,1).setPosition(10, 120).setCaptionLabel("Left Noise");


     
   cp5.addSlider("TopFaceRed").setRange(0,255).setPosition(210, 10).setCaptionLabel("Top R");
   cp5.addSlider("TopFaceGreen").setRange(0,255).setPosition(210, 30).setCaptionLabel("Top G"); 
   cp5.addSlider("TopFaceBlue").setRange(0,255).setPosition(210, 50).setCaptionLabel("Top B");
   
   cp5.addSlider("TopFaceCenterBulge").setRange(0,1).setPosition(210, 80).setCaptionLabel("Top Vignette");
   cp5.addSlider("TopFaceTopDownGradient").setRange(0,1).setPosition(210, 100).setCaptionLabel("Top Gradient");
   cp5.addSlider("TopFaceNoise").setRange(0,1).setPosition(210, 120).setCaptionLabel("Top Noise");
  
   
   cp5.addSlider("BottomFaceRed").setRange(0,255).setPosition(410, 10).setCaptionLabel("Bottom R") ;
   cp5.addSlider("BottomFaceGreen").setRange(0,255).setPosition(410, 30).setCaptionLabel("Bottom G"); 
   cp5.addSlider("BottomFaceBlue").setRange(0,255).setPosition(410, 50).setCaptionLabel("Bottom B");
   
   cp5.addSlider("BottomFaceCenterBulge").setRange(0,1).setPosition(410, 80).setCaptionLabel("Bottom Vignette");
   cp5.addSlider("BottomFaceTopDownGradient").setRange(0,1).setPosition(410, 100).setCaptionLabel("Bottom Gradient");
   cp5.addSlider("BottomFaceNoise").setRange(0,1).setPosition(410, 120).setCaptionLabel("Bottom Noise");

}


void draw() {
  
  // if we're exporting the screen to PDF, start now
  if (record) { 
    beginRecord(PDF, "frame-####.pdf"); // Note that #### will be replaced with the frame number. 
  }

  background(61, 55, 67);
  
  //println(LeftFaceTopDownGradient);

  for (int i = 0; i < arrayCube.length; i=i+1) { // all the cubes
     
    if (currentRow < rows && currentColumn < columns) {
      
      // adjust x for the alternating odd rows
      if (oddRow) {
        xNudge = 0;
        
      } else {
        xNudge = (cubeHeight/2) * tan(radians(30)) * 3;
      }  

      // float centerX = xNudge + ((currentColumn+1) * cubeWidth * 2);
      float centerX = xNudge + (currentColumn * cubeXSpacing);
      float centerY = ((currentRow) * (cubeHeight/2));

      if ((currentColumn == (columns-1))  && !oddRow) { // need to make sure that columns here is an integer, so this test works
        lastCubeInEvenRow = true;
      } else {
        lastCubeInEvenRow = false;
      }

      if (!lastCubeInEvenRow) {
        
        //println((currentRow/rows) + ((1 - currentRow/rows)) * LeftFaceTopDownGradient);
        
        arrayCube[i].display(centerX, 
                             centerY, 
                             cubeHeight, 
                                  
                             // left face
                             
                             int(
                               LeftFaceRed
                               * 
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-LeftFaceCenterBulge)))
                               *                            
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) *(1-LeftFaceTopDownGradient)))  
                               *
                               // noise factor
                               (noise(i+3000) +
                               ((1-noise(i+3000)) * (1-LeftFaceNoise)))
                               
                             ),
                             
                             
                             
                             int(
                               LeftFaceGreen 
                               *
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-LeftFaceCenterBulge)))
                               *
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) * (1-LeftFaceTopDownGradient)))  
*
                               // noise factor
                               
                               (noise(i+3480) +
                               ((1-noise(i+3480)) * (1-LeftFaceNoise)))
                             ),

                             int(
                               LeftFaceBlue 
                               *
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-LeftFaceCenterBulge)))   
                               *
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) * (1-LeftFaceTopDownGradient)))  
                               *
                               // noise factor
                               (noise(i+3900) +
                               ((1-noise(i+3900)) * (1-LeftFaceNoise)))
                             ),                             
                              
                             
                             // top face colours
                             int(
                               TopFaceRed
                               * 
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-TopFaceCenterBulge)))
                               *                            
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) *(1-TopFaceTopDownGradient)))  
                               *
                               // noise factor
                               (noise(i+1000) +
                               ((1-noise(i+1000)) * (1-TopFaceNoise)))
                             ),
                             
                             int(
                               TopFaceGreen 
                               *
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-TopFaceCenterBulge)))
                               *
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) * (1-TopFaceTopDownGradient)))  
                               *
                               // noise factor
                               (noise(i+1200) +
                               ((1-noise(i+1200)) * (1-TopFaceNoise)))
                             ),

                             int(
                               TopFaceBlue 
                               *
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-TopFaceCenterBulge)))   
                               *
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) * (1-TopFaceTopDownGradient)))
                               *
                               // noise factor
                               (noise(i+1890) +
                               ((1-noise(i+1890)) * (1-TopFaceNoise)))
                             ),                             
   
                             
                             
                             
                             
                             // bottom face colours
                             //int(BottomFaceRed * (generateSeed(centerX, centerY) + ((1 - generateSeed(centerX, centerY)) * BottomFaceCenterBulge))),
                             //int(BottomFaceGreen * (generateSeed(centerX, centerY) + ((1 - generateSeed(centerX, centerY)) * BottomFaceCenterBulge))),
                             //int(BottomFaceBlue * (generateSeed(centerX, centerY) + ((1 - generateSeed(centerX, centerY)) * BottomFaceCenterBulge))) 
                             
                             int(
                               BottomFaceRed
                               * 
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-BottomFaceCenterBulge)))
                               *                            
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) *(1-BottomFaceTopDownGradient)))
                               *
                               // noise factor
                               (noise(i+900) +
                               ((1-noise(i+900)) * (1-BottomFaceNoise)))
                             ),
                             
                             int(
                               BottomFaceGreen 
                               *
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-BottomFaceCenterBulge)))
                               *
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) * (1-BottomFaceTopDownGradient)))  
                               *
                               // noise factor
                               (noise(i+400) +
                               ((1-noise(i+400)) * (1-BottomFaceNoise)))
                             ),

                             int(
                               BottomFaceBlue 
                               *
                               // bulge factor
                               (generateSeed(centerX, centerY) + 
                               ((1 - generateSeed(centerX, centerY)) * (1-BottomFaceCenterBulge)))   
                               *
                               // gradient factor
                               ((currentRow/rows) +
                               ((1-(currentRow/rows)) * (1-BottomFaceTopDownGradient))) 
                               *
                               // noise factor
                               (noise(i+20) +
                               ((1-noise(i+20)) * (1-BottomFaceNoise)))
                             )                             
                             
                             );  //only draw if within bounds
                             
                             
      }
    }
    
    //increment for next iteration
    // rows take precedence
    if (currentRow < rows){
      currentColumn ++;
      if (currentColumn >= (columns)){
        currentRow++;
        oddRow = !oddRow;
        currentColumn = 0;
      }
    }
    
  } // end, all the cubes
  
  // reset grid for redraw
  currentRow = 0;
  oddRow = false;
  
  
  if (record) {
    endRecord();
    record = false;
  }
  
  if (currentFrame >= 255) {
    currentFrameIncrement = false;
  } else {
    if (currentFrame <= 0) {
      currentFrameIncrement = true;
    }
  }
    
  if (currentFrameIncrement) {  
    currentFrame++; // increment the timer
  } else {
    currentFrame--;
  }
}


void keyPressed() {
  if (key == 'p' || key == 'P') {
    record = true;

  }
}


// function to return a value between 0 and 1 based on current x,y and mode selected 
float generateSeed(float x, float y) {
  
  // central bulge
  return (sin(map(x, 0, width, 0, PI)) + 
         sin(map(y, 0, height, 0, PI)))
         / 2;
 
  
}


class Cube {
  
  // data, including objects contained within this one
  // each object is itself a kind of data!
  // see https://www.youtube.com/watch?v=V7k5bFQbhG0
  
  // I need to declare each face object
  CubeLeft cubeLeft;
  CubeTop cubeTop;
  CubeBottom cubeBottom;
  
  // and regular old data 
  float centerX;
  float centerY;
  float cubeHeight;

  // constructor
  Cube() {   
    
    // here i need to initialise each face
    cubeLeft = new CubeLeft();
    cubeTop = new CubeTop();
    cubeBottom = new CubeBottom();
    
  }
  
  void display(float centerX, float centerY, float cubeHeight, 
               int cubeLeftColorR, int cubeLeftColorG, int cubeLeftColorB, // left face colours
               int cubeTopColorR, int cubeTopColorG, int cubeTopColorB, // top face colours
               int cubeBottomColorR, int cubeBottomColorG, int cubeBottomColorB // bottom face colours
               ) {
    cubeLeft.display(centerX, centerY, cubeHeight, cubeLeftColorR, cubeLeftColorG, cubeLeftColorB); 
    cubeTop.display(centerX, centerY, cubeHeight, cubeTopColorR, cubeTopColorG, cubeTopColorB);
    cubeBottom.display(centerX, centerY, cubeHeight, cubeBottomColorR, cubeBottomColorG, cubeBottomColorB);
  }
  
}

class CubeLeft {
  // data
  //color fillColour;
  
  int cubeLeftColorR;
  int cubeLeftColorG;
  int cubeLeftColorB;
  
  float cubeHeight;
  float topLeftX;
  float topLeftY;
  float centerX;
  float centerY;
  float bottomLeftX;
  float bottomLeftY;
  float leftX;
  float leftY;
  
  // constructor
  CubeLeft() {   
    // nothing needed here
  }
  
  // methods
  void display(float centerX, float centerY, float cubeHeight,int cubeLeftColorR, int cubeLeftColorG, int cubeLeftColorB) {
    // println(leftX);
    
    
    fill(cubeLeftColorR, cubeLeftColorG, cubeLeftColorB);
    noStroke();

     
    // rewite this starting from the center point shared with all faces 
    topLeftX =  centerX - ((cubeHeight/2) * tan(radians(30)));
    topLeftY = centerY - (cubeHeight/2.0);

    // cheating a bit here - we can leave these as they are, since we now know topLeftX and topLeftY
    bottomLeftX = topLeftX;
    bottomLeftY = topLeftY + cubeHeight;
    leftX = topLeftX - ((cubeHeight/2) * tan(radians(30)));
    leftY = topLeftY + (cubeHeight/2);  
    
    quad(topLeftX, topLeftY, centerX, centerY, bottomLeftX, bottomLeftY, leftX, leftY);   
  }
}

// top right face of cube
class CubeTop {
  // data
  // color fillColour;  
  
  int cubeTopColorR;
  int cubeTopColorG;
  int cubeTopColorB;
  
  float cubeHeight;
  float topLeftX;
  float topLeftY;
  float topRightX;
  float topRightY;  
  float rightX;
  float rightY;  
  float centerX;
  float centerY;
   
  // constructor
  CubeTop() {   
    // nothing needed here
  }
  
  // methods
  void display(float centerX, float centerY,  float cubeHeight,  int cubeTopColorR, int cubeTopColorG, int cubeTopColorB) {
    // println(leftX);
    fill(cubeTopColorR, cubeTopColorG, cubeTopColorB);
    noStroke();
    
    topLeftX = centerX - ((cubeHeight/2) * tan(radians(30)));
    topLeftY = centerY - (cubeHeight/2);
    topRightX = centerX + ((cubeHeight/2) * tan(radians(30)));
    topRightY = centerY - (cubeHeight/2);    
    rightX = centerX + (2 * ((cubeHeight/2) * tan(radians(30))));
    rightY = centerY;
     
    quad(centerX, centerY, topLeftX, topLeftY, topRightX, topRightY, rightX, rightY);   
  }
}

// bottom right face of cube
class CubeBottom {
  // data
  //color fillColour;
  int cubeBottomColorR;
  int cubeBottomColorG;
  int cubeBottomColorB;
  
  float cubeHeight;
  // clockwise starting from center
  float centerX;
  float centerY;
  float rightX;
  float rightY; 
  float bottomRightX;
  float bottomRightY;  
  float bottomLeftX;
  float bottomLeftY;
  
  
  // constructor
  CubeBottom() {   
    // nothing needed here
  }
  
  // methods
  void display(float centerX, float centerY,  float cubeHeight, int cubeBottomColorR, int cubeBottomColorG, int cubeBottomColorB) {
    // println(leftX);
    fill(cubeBottomColorR, cubeBottomColorG, cubeBottomColorB);
    noStroke();
    
    // clockwise starting from center, which we already know  
    rightX = centerX + (2 * ((cubeHeight/2) * tan(radians(30))));
    rightY = centerY;
    bottomRightX = centerX + ((cubeHeight/2) * tan(radians(30)));
    bottomRightY = centerY + (cubeHeight/2);    
    bottomLeftX = centerX - ((cubeHeight/2) * tan(radians(30)));
    bottomLeftY = centerY + (cubeHeight/2);
    quad(centerX, centerY, rightX, rightY, bottomRightX, bottomRightY, bottomLeftX, bottomLeftY);   
  }
}
