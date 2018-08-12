// pmouse test

float mouseSpeedX;

void setup() {

  size(400,400);
  frameRate(30);
}

void draw() {
 
 mouseSpeedX = mouseX - pmouseX;
 background(200);
 
 line(pmouseX, 10, mouseX, 390);
  
}
