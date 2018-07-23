Tile myTile1;
Tile myTile2;
Tile myTile3;
Tile myTile4;

void setup() {
 
  size (400,400);
  background (255);
  

  // roation affects the whole grid, i think....
  myTile1 = new Tile(0,   0,  0,  0,   1, 1);
  myTile2 = new Tile(100, PI/2, 80, 80, -1, 1);
  myTile3 = new Tile(150, PI/2, 0,  0,  1, -1);
  myTile4 = new Tile(200, PI/2, 80,  80,  -1, 1);

}  


void draw() {
  
  //  translate(200,200);
    myTile1.display();
    myTile2.display();
    myTile3.display();
    myTile4.display();
  }  
  
  
  

class Tile { 
  
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
    
    line(0,20,20,20);
    line(0,0,20,20);
    line(0,60,10,70); 
    line(0,80,20,60); 
    ellipseMode(CENTER);
    arc(40, 40, 60, 60, HALF_PI+QUARTER_PI, PI+QUARTER_PI);
    arc(20, 60, 40, 40, PI, PI+HALF_PI+QUARTER_PI);  
    
   // scale(-scaleX, -scaleY);    
   //translate(-translateAmountWidth, -translateAmountHeight);
   //rotate(-rotateAmount);

  }
  
  
}
