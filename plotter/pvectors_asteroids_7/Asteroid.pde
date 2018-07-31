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
    

    asteroidPoints.add(new PVector(-4,-4) );
    asteroidPoints.add(new PVector(-2+random(-ran,ran),-4+random(-ran,ran)) );
    asteroidPoints.add(new PVector(1+random(-ran,ran),-2+random(-ran,ran)) );
    asteroidPoints.add(new PVector(2+random(-ran,ran),0+random(-ran,ran)) );
    asteroidPoints.add(new PVector(2+random(-ran,ran),1+random(-ran,ran)) );
    asteroidPoints.add(new PVector(1+random(-ran,ran),2+random(-ran,ran)) );
    asteroidPoints.add(new PVector(1+random(-ran,ran),3+random(-ran,ran)) );
    asteroidPoints.add(new PVector(0+random(-ran,ran),4+random(-ran,ran)) );
    asteroidPoints.add(new PVector(-2+random(-ran,ran),4+random(-ran,ran)) );
    asteroidPoints.add(new PVector(-4+random(-ran,ran),2+random(-ran,ran)) );
    asteroidPoints.add(new PVector(-4+random(-ran,ran),1+random(-ran,ran)) );
    asteroidPoints.add(new PVector(-5+random(-ran,ran),-1+random(-ran,ran)) );
    asteroidPoints.add(new PVector(-4,-4) );
    
 
    


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
          if (PLOTTING_ENABLED){
            plotter.write("PU;");  
          }
        }
      }  
      
    
    // now embed a crater within each asteroid
    Crater myCrater; 
    myCrater = new Crater(startX, startY, scaleX, 10, 1, 0.3);
    myCrater.drawCrater();
    
    
    
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
      if (PLOTTING_ENABLED){
        plotter.write(pen+_x1+","+_y1+";");
        plotter.write("PD"+_x2+","+_y2+";", 75); //75 ms delay
      }
    }
   
    // helper functions to handle rotation
    float rotX(float inX, float inY){ 
     return (inX*cos(r) - inY*sin(r)); 
    }
    float rotY(float inX, float inY){
     return (inX*sin(r) + inY*cos(r)); 
    }
  
}  
