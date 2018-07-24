// Andrew Sleigh
// 2018-07-23
// Pattern test, tiles as nested objects
// creating objects using an array
// laying them out on the page in a grid

int numberOfSpaceGroups = 56;
// Declare and create the array
SpaceGroup[] mySpaceGroups = new SpaceGroup[numberOfSpaceGroups];

int columns = 8; //Total cols. Current column is stored in 'col'
int rows = 7; //Total rows. Current row is stored in 'row'

//Current rows and cols
int row = 0;
int column = 0;
boolean evenRow = true;
boolean evenColumn = true;

void setup() {
  
  //mySpaceGroup1 = new SpaceGroup(0,0,1,1,0,0);
  //mySpaceGroup2 = new SpaceGroup(80,0,1,-1,0,80);
  //mySpaceGroup3 = new SpaceGroup(160,0,1,1,0,0);
  //mySpaceGroup4 = new SpaceGroup(240,0,1,-1,0,80);
  //mySpaceGroup5 = new SpaceGroup(0,80,1,-1,0,80);
  //mySpaceGroup6 = new SpaceGroup(80,80,1,1,0,0);
  //mySpaceGroup7 = new SpaceGroup(160,80,1,-1,0,80);
  //mySpaceGroup8 = new SpaceGroup(240,80,1,1,0,0);  
  
  size (700,620);
  background (255);
  noSmooth();
  noLoop(); // reduce CPU usage
  frameRate(1);  // reduce CPU usage

}  


void draw() {
  
  translate(30,30); /// sometimes easier to see things when they're in the middle of the canvas

  for (int i = 0; i < numberOfSpaceGroups; i=i+1) {
     
    if (row < rows && column < columns){
      
      //drawSymbol(column, row);  //only draw if within bounds
      // could I use a function like this??
      
          
      // control flipping on x axis which alternates each column
      float flipX = 1;
      float transformX = 0;
 
      if (column % 2 != 0) { 
        flipX = -1;
        transformX = 80;
      }

      // control flipping on Y axis which alternates each row
      float flipY = 1;
      float transformY = 0;

      if (row % 2 != 0) {   // i.e. we're on an odd row
        flipY = -1;
        transformY = 80;
      }


        
      mySpaceGroups[i] = new SpaceGroup(column*80,row*80,flipX,flipY,transformX,transformY); // Initialize objects
      pushMatrix();  
      mySpaceGroups[i].display();
      popMatrix();
      
      
      //increment for next iteration
      if (column < columns){
        row ++;
        if (row >= rows){
         column++;
         row = 0;        
        }
      }
    }  
  } 
}  
  
  
class SpaceGroup {
  // data
  float xOrigin;
  float yOrigin; 
  float scaleX;
  float scaleY;
  float translateAmountWidth;
  float translateAmountHeight;
  
  // constructor
  SpaceGroup(float xOrigin_, float yOrigin_, float scaleX_, float scaleY_, float translateAmountWidth_, float translateAmountHeight_) {
    xOrigin = xOrigin_;
    yOrigin = yOrigin_;
    scaleX = scaleX_;
    scaleY = scaleY_;
    translateAmountWidth = translateAmountWidth_;
    translateAmountHeight = translateAmountHeight_;
        
  } 
  
  // methods
  void display() {
    
    translate(xOrigin+translateAmountWidth, yOrigin+translateAmountHeight);
    scale(scaleX,scaleY);
    
    Tile myTile1;
    Tile myTile2;
    Tile myTile3;
    Tile myTile4;

    
    myTile1 = new Tile(0,   0,  0,  0,   1, 1);
    myTile2 = new Tile(0, PI/2, 80, 80, -1, 1);
    myTile3 = new Tile(0, PI, 80,  80,  1, 1);
    myTile4 = new Tile(0, PI+PI/2, 0,  0,  -1, 1);
  
   
    pushMatrix();  
    myTile1.display();
    popMatrix();
    pushMatrix();  
    myTile2.display();
    popMatrix();
    pushMatrix();  
    myTile3.display();
    popMatrix();
    pushMatrix();  
    myTile4.display();  
    popMatrix(); 
  }   
}  

class Tile { 
  
  // data
  float xOrigin;
  float yOrigin;  
  float rotateAmount;
  float translateAmountWidth;
  float translateAmountHeight;
  float scaleX;
  float scaleY;
  color col; // colour
  
  // constructor
  Tile(float col_, float rotateAmount_, float translateAmountWidth_, float translateAmountHeight_, float scaleX_, float scaleY_) {
    xOrigin = 0;
    yOrigin = 0;
    rotateAmount = rotateAmount_;
    translateAmountWidth = translateAmountWidth_;
    translateAmountHeight = translateAmountHeight_;
    scaleX = scaleX_; 
    scaleY = scaleY_;
    col = color(col_);
  }

  // methods
  void display() {
    noFill();
    stroke(col);

    translate(translateAmountWidth, translateAmountHeight);
    rotate(rotateAmount);
    scale(scaleX,scaleY);

    //line(0,0,20,0);
    line(0,20,20,20);
    line(0,0,20,20);
    line(0,60,10,70); 
    line(0,80,20,60); 
    ellipseMode(CENTER);
    arc(40, 40, 60, 60, HALF_PI+QUARTER_PI, PI+QUARTER_PI);
    arc(20, 60, 40, 40, PI, PI+HALF_PI+QUARTER_PI);  
  }  
}
