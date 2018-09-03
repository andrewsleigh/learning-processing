//  think my forrceaccumulationwas off in the pvector examples
// trying exercise 2.1, p.70 in Nature of Code


// declare object
Balloon myBalloon;
// Cloud myCloud; 
// make array of clouds instead

// declare array of objects
Cloud[] cloudArray = new Cloud[4];


// setup forces
PVector gravity = new PVector(0,-0.2);
PVector wind = new PVector(0,0); // want this to vary throughout the draw loop
float windNoiseOffset; // for perlin noise
PVector rebound = new PVector(0,0);
PVector breathOfGod = new PVector(0,0);

PVector distantWind = new PVector(0,0);
float distantWindNoiseOffset; // for perlin noise

// setup cloud spread
float cloudHeightSpacing = 100;
float xSpeed = 0.1;


void setup () {
  size(500,500);
  // initialise by calling constructor method
  myBalloon = new Balloon();

  
  // initialize cloud objects
  for (int i = 0; i < cloudArray.length; i=i+1) {
    float cloudHeight = random(cloudHeightSpacing, cloudHeightSpacing+100);
    cloudArray[i] = new Cloud(random(0, width), cloudHeight, xSpeed);    
    cloudHeightSpacing = cloudHeightSpacing*1.5;
    xSpeed = xSpeed + 0.2;
  }
 
}

void draw(){
  background(100, 200, 255);
  
  // draw clouds first in the background
  for (int i = 0; i < cloudArray.length; i=i+1) {
    cloudArray[i].display();
    cloudArray[i].applyForce(distantWind);
    cloudArray[i].update();
  }
 
  
  // random wind
  // wind.x = random(-0.1,0.1);   
  // perlin noise wind
  windNoiseOffset = windNoiseOffset + 0.01;
  wind.x = map(noise(windNoiseOffset),0,1,-0.05,0.05);

    distantWindNoiseOffset = distantWindNoiseOffset + 0.01;
  distantWind.x = map(noise(distantWindNoiseOffset),0,1,-0.001,0.001);
  
  
  // problem with wind is that the wind force tends to accumulate in one direction, 
  // so horizontal velocity of balloon increases, or is at least more than zero
  // in the real world, this is how balloon behave of course!
  // but could damp the effect with some wind resistance, which increases with speed
  
  // same would happen with gravity if the balloon didn't bounce off the top

  
  myBalloon.display();
  myBalloon.applyForce(gravity);
  myBalloon.applyForce(wind);
   
  if (myBalloon.location.y < 0) { // balloon hits top of screen so bounce back
     println(myBalloon.location.x);
     rebound.y = myBalloon.velocity.y * -2.0; // this seems to be very volatile. Different values give wildly different behaviours
     myBalloon.applyForce(rebound);
     rebound.mult(0.3); // try to take some energy out of the rebound force each time
     myBalloon.location.y = 0; // to stop balloon from disappearing above the top
  }
  
  
  if (mousePressed) { // apply Breath of God!
    breathOfGod.x = map((mouseX - width/2),(-width/2),width/2,-0.1,0.1);
    breathOfGod.y = map((mouseY - height/2),(-height/2),height/2,-0.1,0.5);
    myBalloon.applyForce(breathOfGod);
  
  }
  
  myBalloon.update();
  
  myBalloon.velocity.mult(0.95); // enough to simulate wind resistance?
  // this should really be a force, varying with velocity 
  
  
  
}


class Balloon {
  // data
  PVector location;
  PVector velocity;
  PVector acceleration;
  float diameter = 30;
  float stringLength = 60;
  
  
  // constructor
  Balloon(){
    location = new PVector(width/2, height-diameter-stringLength);
    velocity = new PVector(0,1);
    acceleration = new PVector(0,0); // set a defalt of zero
    
  }
  
  
  // methods
  void display() {
     stroke(150, 50, 150);
     fill(255, 55, 55);
     ellipseMode(CENTER);
     ellipse(location.x, location.y, diameter, diameter);
     stroke(0);
     line(location.x, location.y+diameter/2, location.x, location.y+stringLength); 
  }
  
  void update() {
    velocity.add(acceleration); // equivalent to: velocity = velocity.add(acceleration);
    location.add(velocity); 
    acceleration.mult(0); // reset the accleeration to 0 on each frame, so forces can be reapplied
  }
  
  void applyForce(PVector force) {
    // acceleration = force; // error this only applies most recent force on update()     
    // accumulation (p.69)
    acceleration.add(force);
      
  }
}


 
class Cloud {
  // data
  PVector location;
  PVector velocity;
  PVector acceleration;
  float cloudWidth;
  float cloudHeight;
  boolean headingLeftToRight;    

  
  
  // constructor
  Cloud(float startingX, float startingY, float xSpeed){
    location = new PVector(startingX, startingY);
    
    
    //velocity = new PVector(random(-1,1),0);
    
    velocity = new PVector(xSpeed,0);
    
    acceleration = new PVector(0,0); // set a defalt of zero
    cloudWidth = 170;
    cloudHeight = 40;
  }
  
  
  // methods  
  void display() {
    // scale(2);
    fill(245, 245, 245);
    noStroke();
    rect(location.x+30, location.y,cloudWidth-50, cloudHeight);  
    ellipseMode(CORNER);
    ellipse(location.x, location.y-20, cloudHeight*1.5, cloudHeight*1.5); // first bubble
    ellipse(location.x+30, location.y-(cloudHeight*1.5), cloudHeight*2, cloudHeight*2); // second bubble
    ellipse(location.x+cloudWidth-80, location.y-40, 60, 60); // third bubble
    ellipse(location.x+cloudWidth-cloudHeight, location.y, cloudHeight, cloudHeight); // last bubble
  }
  
  
  void update() {
    velocity.add(acceleration); // equivalent to: velocity = velocity.add(acceleration);
    location.add(velocity); 
    acceleration.mult(0); // reset the accleeration to 0 on each frame, so forces can be reapplied
    
    if (velocity.x > 0) {
      headingLeftToRight = true;
    } else {
      headingLeftToRight = false;
    }
    
    if ((location.x > width) & headingLeftToRight) { // avoid reset clouds from the other direction being perpetually kept off screen
      location.x = -100 - cloudWidth; // reset it with a bit of padding
      //print("cloud: ");
      //println(location.x);
    }
    
    if ((location.x < -cloudWidth) & !headingLeftToRight) {
      location.x = width; // reset it with a bit of padding
    }


}  
  
  void applyForce(PVector force) {
    acceleration.add(force);
      
  }
  
}
