class Crater {
  // data  
  float tx, ty; // position
  float w, h; // size
  float r; // rotation
  float ran; // randomness of each point
  
  ArrayList<PVector> craterPoints = new ArrayList<PVector>();
  
  // constructor  
  Crater(float xpos, float ypos, float scaleX, float scaleY, float rot, float randomFactor_) {
    
    tx  = xpos;
    ty  = ypos;
    w = scaleX; //scale
    h = scaleY;
    r = radians(rot);    
    ran = randomFactor_; 
    
    
    craterPoints.add(new PVector(0.5,0) );
    craterPoints.add(new PVector(1,0) );
    craterPoints.add(new PVector(0.7,1) );
    craterPoints.add(new PVector(0.3,1) );
    craterPoints.add(new PVector(0,0.5) );
    craterPoints.add(new PVector(0.5,0) );

    //asteroidPoints.add(new PVector(-4,-4) );
    //asteroidPoints.add(new PVector(-2+random(-ran,ran),-4+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(1+random(-ran,ran),-2+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(2+random(-ran,ran),0+random(-ran,ran)) );
    //craterPoints.add(new PVector(0.9,0.7) );
    //craterPoints.add(new PVector(1.4,0.7) );
    //craterPoints.add(new PVector(1.6+random(-ran,ran),0.8+random(-ran,ran)) );
    //craterPoints.add(new PVector(0.8+random(-ran,ran),1.6+random(-ran,ran)) );
    //craterPoints.add(new PVector(0.9,1.4) );
    //craterPoints.add(new PVector(0.9,0.7) );
    ////asteroidPoints.add(new PVector(1+random(-ran,ran),3+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(0+random(-ran,ran),4+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(-2+random(-ran,ran),4+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(-4+random(-ran,ran),2+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(-4+random(-ran,ran),1+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(-5+random(-ran,ran),-1+random(-ran,ran)) );
    //asteroidPoints.add(new PVector(-4,-4) );
    


}
  
  // methods
  
    void drawCrater(){  
      //draw shape  
      for (int i=0; i<craterPoints.size()-1; i++){
        drawLine(
          rotX(                        // starting x point
            craterPoints.get(i).x, 
            craterPoints.get(i).y
          )
          *w     // x width scale factor
          +tx,   // x starting position
          rotY(                        // starting y point
            craterPoints.get(i).x, 
            craterPoints.get(i).y
          )
          *h+ty, 
          rotX(                        // ending x point
            craterPoints.get(i+1).x, 
            craterPoints.get(i+1).y
          )
          *w+tx, 
          rotY(                        // ending y point
            craterPoints.get(i+1).x,
            craterPoints.get(i+1).y
          )
          *h+ty, 
          (i==0)                       // if we're drawing the first point, set pen up to true
        );
        
        if (i==craterPoints.size()-2){ // if we've got to the last point, put pen up
          if (PLOTTING_ENABLED){
            plotter.write("PU;");  
          }
        }
      }   
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
