// nested squares
// inspired by https://twitter.com/ivanik_oksana/status/1039219810125656064
// scaling now works, though the scale factor reduces each time due to comound transforms

// tried compensating for the scaling as it afects the inset of each square, and the thickness of the line
// by increasing these in inverse proportion to the scaling effect
// i think this would be better rewritten without these transformations

// v. 3a

// fixed a few bugs with this:
// seem to be able to get relable line thickness
// no doubling p of squares (though this is not fixed by removing 1 from the offset on each new row or column....???
// but still not completing the nest 
// and I think the rotation is reducing each time. 

// true, it is, 
// but also, the idea that you can divide the width by the number of nestings to get the indentation is false:
// we're building a spiral, the length of which constantly grows, much longer than the width of the square.


// v. 3b
// GUI added
// think transformations might be interfering wiht slider controlling, say, line thickness

// yes, the initial transform messes up the mouse placement for the control


// onscreen controllers ---------------------------------------------
import controlP5.*;
ControlP5 cp5;

int backgroundFill = 200;

float xStart = 0;
float yStart = 0;
float squareWidth = 100;
float squareHeight = squareWidth;
float numberOfNestings = 3; // high numbers cause dense drawing due to cumulative scaling

//float nextSqareIndentation = 40;
float nextSqareIndentation = (squareWidth/(numberOfNestings)) * 0.2; // get crazy effects by increading this massively...
float rotateAngle = degrees(atan(nextSqareIndentation/(squareWidth - nextSqareIndentation)));
float newWidth = sqrt(sq(nextSqareIndentation) + sq(squareWidth - nextSqareIndentation));
float scaleFactor = newWidth / squareWidth;

float initialLineThickness = 3;
float lineThickness = initialLineThickness; // use this to maintain line strokeWeight() over scale transformations

boolean flipXAxis = false;
float numberOfColumns = 9;
float numberOfRows = 8;


void setup() {
  size(820,820);
  smooth(4);
  println(rotateAngle);
  println(newWidth);
  
// GUI -----------------------------------------------------------------

  cp5 = new ControlP5(this);

  cp5.addSlider("Number_of_nestings")
     .setPosition(10,10)
     .setSize(200,20)
     .setRange(0,100)
     .setValue(10)
     ;
     
  cp5.addSlider("Sqare_Width")
     .setPosition(10,45)
     .setSize(200,20)
     .setRange(10,400)
     .setValue(200)
     ;
     
  
}


void draw() {
  background(255);  
  //noLoop(); // keep looping on so we can use GUI
  frameRate(10);  
  // translate(squareWidth/2, squareWidth/2); // this moves slider off 
  rectMode(CENTER);
  noFill();
  strokeWeight(lineThickness);

  // draw all the rows
  for (int r = 0; r < numberOfRows; r++) {
     
    // draw all the columns
    for (int c = 0; c < numberOfColumns; c++) {
      
      pushMatrix(); // store setup of first square      
      // draw first unaltered square
      lineThickness = initialLineThickness;
      translate(xStart, yStart);
      strokeWeight(lineThickness);
      fill(255);
      stroke(0);
      rect(0, 0, squareWidth, squareHeight);
      
      // draw nest
      for (int i = 0; i < numberOfNestings -1; i++) { // 1st square is already drawn
        strokeWeight(lineThickness);
        rotate(radians(rotateAngle));
        scale(scaleFactor);
        fill(color(constrain((255-(i*5)), 0, 255)));
        // bright colours...
        // fill(color(constrain((255-(i*5)), 0, 255), 100, constrain(i*10, 0, 255)));
        //stroke(color(constrain(i*10, 0, 255)));
        rect(0, 0, squareWidth, squareHeight);
        
        // after drawing, scale all the affected factors to compensate for the transformations
        nextSqareIndentation = nextSqareIndentation / scaleFactor;
        lineThickness = lineThickness / scaleFactor;

      }   
      
      popMatrix(); // reset for a new nest
      rotateAngle = -1 * rotateAngle; // flip the rotation. YOu need to coment this out in some situations
      xStart = (xStart + squareWidth) + 0; // shift along to the next column,  overlappping by 1 pixel to avoid doubled up initial squares
      
    } // end of column
    
    yStart = (yStart + squareHeight); // - 1; // shift down to the next row, overlappping by 1 pixel to avoid doubled up initial squares
    xStart = 0;
    
  } // end of row
  
  yStart = 0;
  
}

// functions called by GUI sliders

void Number_of_nestings(float sliderValue) {
  numberOfNestings = sliderValue;
}

void Sqare_Width(float sliderValue) {
  squareWidth = sliderValue;
  squareHeight = sliderValue;
}
