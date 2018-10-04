// Inspired by https://beta.observablehq.com/@pstuffa/yvaral-ii
// I'm going to try and recreate nother Vasaely work - Traces
// Pic here: http://www.dreamideamachine.com/en/?p=11684
// http://www.dreamideamachine.com/en/wp-content/uploads/sites/3/2016/04/085.jpg

// v1
// basic setup

// v2
// removed redundant stuff from constructor function. nothing is needed until it's drawn
// added new objects for other cube faces
// recalculated positions of each point form the shared center point
// created a cube object to hold all the faces


// v3
// commented out old inidividual face objects
// moved cubeHeight parameter into main cube function, so it can be controlled from within the sketch, and then inherited by each face object
// used a row and column generator from the SymbolicDisarray sketch to put them all in a grid
// but this is not the tessalating grid I need

// v4 
// fixed the tesselation
// trying to get the correct edge shape, but it's tricky
// currently the tesseleation assumes a square grid, and I'm using tests to miss out cubes on certain lines
// But this means not all cubes in the array are displayed.
// also my column calculation is still not working properly - using round() helps, because int() always rounds down
// done a bit of a hack with the padding because the shapes are all drawn a bit ot the left - this could be better
// also, in the original, there is no padding, and the background colour changes half way down...

// v5
// focusng on colour effects
// changed all disaply methods to take args for RGB values
// calculating colour variations based on mouse position, and current row and column, when parent Cube object is diaplyed
// adding PDF export so I can get nice images off it, use the p key to gt a PDF of that frame.

// still need batter variation of the colours across the grid
// and perhaps a way of constraining it to certain palettes, then varying within that


// v6 
// trying to implement some more Vasarely-like colours

// v7
// changed colour picking code to give more of a central bulge, using sin function instead of distance from center 



// ----------------------------------------------------------------------------- GO >>>


// PDF export  ----------------------------------------------------

import processing.pdf.*;
boolean record;


// declare arrays of objects

int numberOfCubes = 115;
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
float padding = 70;


Cube[] arrayCube = new Cube[numberOfCubes];




void setup () {
  size(500,500);
  //frameRate(1);
  
  columns = int(round((width - padding/2) / (cubeXSpacing))) ; // force to be an int, after rounding to the nearest whole number
  rows = numberOfCubes / columns;
  //println(columns);

  // initialize  objects
  for (int i = 0; i < arrayCube.length; i=i+1) {
     arrayCube[i] = new Cube(); // no arguments passed to constructor method  
  }
  
  
}


void draw() {
  
  // if we're exporting the screen to PDF, start now
  if (record) { 
    beginRecord(PDF, "frame-####.pdf"); // Note that #### will be replaced with the frame number. 
  }

  background(61, 55, 67);

  for (int i = 0; i < arrayCube.length; i=i+1) { // all the cubes
     
    if (currentRow < rows && currentColumn < columns) {
      
      // adjust x for the alternating odd rows
      if (oddRow) {
        xNudge = 0;
        
      } else {
        xNudge = (cubeHeight/2) * tan(radians(30)) * 3;
      }  

      // float centerX = xNudge + ((currentColumn+1) * cubeWidth * 2);
      float centerX = padding/2 + xNudge + (currentColumn * cubeXSpacing);
      float centerY = padding/2 + ((currentRow) * (cubeHeight/2));

      if ((currentColumn == (columns-1))  && !oddRow) { // need to make sure that colmuns here is an integer, so this test works
        lastCubeInEvenRow = true;
      } else {
        lastCubeInEvenRow = false;
      }

      if (!lastCubeInEvenRow) {
        
        //println(int(mouseX*255/width));
        //println(255*currentColumn/columns);
        
        arrayCube[i].display(centerX, centerY, cubeHeight, 
                             //int((width-mouseX)*255/width), i, int(mouseY*255/height), // left face colours
                             //int(255*(abs((width/2)-mouseX))/(width/2)), 0, 0,
                             
                             //int((255*abs((columns/2)-currentColumn)/(columns/2))), 0, 0, // left face, red at edges, black in middle
                             //int((255*abs((columns/2)-(currentColumn+1))/(columns/2))), 0, i*2,
                             
                             // try using centerX, centerY as source material for positioning
                             // left face
                             // red
                             int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 64, 173
                                )
                              ),
                              
                             
                              
                              // green
                              int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 43, 216
                                )
                              ),
                              
                              // blue
                              int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 43, 222
                                )
                              ),
                             
                             
                             
                             // 255-i, int(mouseX*255/width), int((width-mouseX)*255/width), // top face colours
                             
                             
                             // top face colours
                             // red
                             
                             int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 58, 164
                                )
                              ),
                              
                             /*
                             int(
                                 map(
                                     (
                                      abs(width/2-centerX) * 
                                      abs(height/2-centerY) 
                                      /
                                      (width/2*height/2)
                                     ) 
                                     ,0,0.8,164,58 // map the highs and lows in reverse, so colours a tthe center are brighter
                                    )
                                 ),
                               */  
                              
                              // green
                              
                              
                              int(
                                map(
                                  generateSeed(centerX, centerY), 0.4, 1, 68, 229
                                )
                              ),
                                
                                
                              /*
                              int(
                                 map(
                                     (
                                      abs(width/2-centerX) * 
                                      abs(height/2-centerY) 
                                      /
                                      (width/2*height/2)
                                     ) 
                                     ,0,0.5,229,68 // map the highs and lows in reverse, so colours a tthe center are brighter
                                    )
                                 ),
                               */  
                              // blue
                              
                              /*
                              int(
                                 map(
                                     (
                                      abs(width/2-centerX) * 
                                      abs(height/2-centerY) 
                                      /
                                      (width/2*height/2)
                                     ) 
                                     ,0,0.8,90,77 // map the highs and lows in reverse, so colours a tthe center are brighter
                                    )
                                 ),
                             */
                             int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 77, 90
                                )
                              ),
                                 
                                 
                             
                             
                               
                             
                             // bottom face colours
                              // red
                             int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 58, 111
                                )
                              ),
                             

                              // green
                              int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 51, 148
                                )
                              ),
                              
                              // blue
                              int(
                                map(
                                  generateSeed(centerX, centerY), 0.2, 1, 66, 229
                                )
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
