// pmouse test

float mouseSpeedX;

void setup() {

  size(400,400);

}

void draw() {
 
 mouseSpeedX = mouseX - pmouseX;
 background(10 * mouseSpeedX);
  
}
