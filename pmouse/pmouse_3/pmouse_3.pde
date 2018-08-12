// pmouse test
// draw a line when the mouse is pressed
// make the weight of the line relative to the speed of the mouse 

float mouseSpeedX;
float mouseSpeedY;

void setup() {

  size(400,400);
  frameRate(30);
}

void draw() {
 
 mouseSpeedX = mouseX - pmouseX;
 if (mouseSpeedX < 0) { mouseSpeedX = -mouseSpeedX;}
 
 mouseSpeedY = mouseY - pmouseY;
  if (mouseSpeedY < 0) { mouseSpeedY = -mouseSpeedY;}
 
// line(pmouseX, pmouseY, mouseX, mouseY);
// this works

// see https://processing.org/reference/pmouseX.html
//The system variable pmouseX always contains the horizontal position of the mouse in the frame previous to the current frame. 
//You may find that pmouseX and pmouseY have different values when referenced inside of draw() and inside of mouse events like mousePressed() and mouseMoved(). Inside draw(), pmouseX and pmouseY update only once per frame (once per trip through the draw() loop). But inside mouse events, they update each time the event is called. If these values weren't updated immediately during mouse events, then the mouse position would be read only once per frame, resulting in slight delays and choppy interaction. If the mouse variables were always updated multiple times per frame, then something like line(pmouseX, pmouseY, mouseX, mouseY) inside draw() would have lots of gaps, because pmouseX may have changed several times in between the calls to line().
//If you want values relative to the previous frame, use pmouseX and pmouseY inside draw(). If you want continuous response, use pmouseX and pmouseY inside the mouse event functions.
}


void mousePressed() {
 line(pmouseX, pmouseY, mouseX, mouseY);
 // this doesnt - mousePressed() is only called once:
 // https://processing.org/reference/mousePressed_.html
}



void mouseDragged() {
 strokeWeight(mouseSpeedX + mouseSpeedY);  
 line(pmouseX, pmouseY, mouseX, mouseY);
 // this works
}
