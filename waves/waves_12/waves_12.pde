// 2018-07-01
// Andrew Sleigh
// this version adds PDF export

// onscreen controllers ---------------------------------------------
import controlP5.*;
ControlP5 cp5;
Slider slider_waveSpacing;
Slider slider_numberOfPoints;
Slider slider_peakHeight;
Slider slider_peakYRange;
Slider slider_xPositionRange;
Slider slider_CalmOrChaosModifierOriginal;
Slider slider_CalmOrChaosTrend;
Toggle toggle_stepThrough;
Toggle toggle_reDraw;

boolean reDraw = true;
boolean onlyDrawOneStep = false;

// PDF export  ----------------------------------------------------

import processing.pdf.*;
boolean record;

// shapes  --------------------------------------------------------

// float waveSpacing;  
float numberOfWaves = 50;
float numberOfPoints = 43; // number of peaks and troughs and crossovers, excluding end points // must be a float, so I can do division later

int startx = 300;
float currentXPosition = startx; // move the x position along as we plot the wave
int startYOriginal = 100; // need an original setting in case we want to redraw the screen
float starty = startYOriginal;

int waveWidth = 780;
float peakHeight;
float peakDepth;

volatile float keyPointDistance = int(waveWidth / numberOfPoints);    // a key point is a crossover, a peak or a trough. Has to be an int?
float waveSpacing = 12; // vertical distance between each line

// wave shape logic
boolean isRising = true; // is wave going up or down
boolean atACrossover = true; // is the current point on the wave an x crossover

// how much variation in each point
float peakYRange = 0.5; // adding y randomness
float xPositionRange = 5; // adding x randomness

// for sine wave shaped tapering of wave, and randomness
float currentXPositionAsProportionOfPi;
float sineEffect = 0.1; // how much to apply the sine shaping // unused


// to change wave extremity over each repetition
float CalmOrChaosModifierOriginal = 1;
float CalmOrChaosModifier = CalmOrChaosModifierOriginal; // how much calming to apply on each line. 0 starts with flat calm, 1 starts with defaults, higher than 1 amplifies
float CalmOrChaosTrend = -0.01; // how much to change the calming on each line. Negative numbers calm, until CalmOrChaosModifier gets below zero 


void setup(){

  size(1100, 800);
  // smooth(3);
  frameRate(30); // super slow refresh
  

  
  cp5 = new ControlP5(this);
  
    slider_waveSpacing = cp5.addSlider("Wave Spacing");
    slider_waveSpacing.setPosition(10,20).setSize(200,20).setValue(10);

    slider_numberOfPoints = cp5.addSlider("Number of points");
    slider_numberOfPoints.setPosition(10,50).setSize(200,20).setValue(60); 
    
    slider_peakHeight = cp5.addSlider("Height");
    slider_peakHeight.setPosition(10,80).setSize(200,20).setValue(50);     
    
    slider_peakYRange = cp5.addSlider("Height variation");
    slider_peakYRange.setPosition(10,110).setSize(200,20).setValue(10);     
  
    slider_xPositionRange = cp5.addSlider("X position variation");
    slider_xPositionRange.setPosition(10,140).setSize(200,20).setValue(10);     

    slider_CalmOrChaosModifierOriginal= cp5.addSlider("Calm or chaos");
    slider_CalmOrChaosModifierOriginal.setPosition(10,170).setSize(200,20).setValue(60);     

    slider_CalmOrChaosTrend = cp5.addSlider("Calm or chaos trend");
    slider_CalmOrChaosTrend.setPosition(10,200).setSize(200,20).setValue(50);     

    // create a toggle
    toggle_reDraw = cp5.addToggle("reDraw");
    toggle_reDraw.setPosition(10,230).setSize(50,20).setValue(true).setLabel("Redraw continuously?");
    
   
    toggle_stepThrough = cp5.addToggle("stepThrough");
    toggle_stepThrough.setPosition(10,270).setSize(50,20).setValue(false).setLabel("Redraw once");
  
  
     cp5.addBang("ExportPDF")
       .setPosition(10,350)
       .setSize(40, 40)
       .setTriggerEvent(Bang.RELEASE)
       ;
   
  }


void draw() { 
  

   
  waveSpacing = (map(slider_waveSpacing.getValue(), 0, 100, 2, 60)); 
  numberOfWaves = (height - 200) / (waveSpacing);
  numberOfPoints =  int(map(slider_numberOfPoints.getValue(), 0, 100, 2, 100)); 
  keyPointDistance = int(waveWidth / numberOfPoints);
  peakHeight = slider_peakHeight.getValue() / 50;
  peakDepth = peakHeight;
  peakYRange = slider_peakYRange.getValue() / 50;
  xPositionRange = slider_xPositionRange.getValue() / 50;
  CalmOrChaosModifierOriginal = map(slider_CalmOrChaosModifierOriginal.getValue(), 0, 100, 0, 100);
  CalmOrChaosTrend = map(slider_CalmOrChaosTrend.getValue(), 0, 100, -1, 1) * (100 / numberOfWaves);
  
  if (toggle_stepThrough.getBooleanValue()) { //<>//
   background(203, 203, 190); 
   reDraw = true;
   onlyDrawOneStep = true;
  toggle_reDraw.setValue(false);
  } 
  
  
  
  if (toggle_reDraw.getBooleanValue() && !onlyDrawOneStep) { //<>//
    background(203, 203, 190); 
  }

  // if we're exporting the screen to PDF, start now
  if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    beginRecord(PDF, "frame-####.pdf"); 
    // onlyDrawOneStep = true;
   // background(203, 203, 190); 
  }


  // noLoop();

  if (reDraw  || onlyDrawOneStep) { 
  for (int i = 0; i < numberOfWaves; i = i+1) { // draw a series of waves
    
    // stroke(150); // draw guide lines
    // line(startx, starty, waveWidth+startx, starty);
    
    stroke(000);    
    noFill();
    beginShape();
    
    // first point
    curveVertex(currentXPosition, starty);
    curveVertex(currentXPosition, starty); 
    atACrossover = true;
      
    // loop through all intermediate points
    for (int points = 2; points <= numberOfPoints-1; points = points+1) { // point 1 and point[numberOfPoints] are drawn outside the loop
      
      // move the x position along to the next point
      // can't just increment it, otherwise the randomness also increments. Need to recalculate it each time
      // currentXPosition = currentXPosition + keyPointDistance;
      currentXPosition = startx + (keyPointDistance * points);
      currentXPositionAsProportionOfPi = (points / numberOfPoints) * PI;   // work out where we are in the total wave as a proportion of pi
      // println(currentXPositionAsProportionOfPi); 
  
      float randomnessModifier =  sin(currentXPositionAsProportionOfPi); // set the randomness modifier to that proportion, with calming effect

      // println(randomnessModifier); 
      
      // add some randomness
      float currentHeightModifier = randomnessModifier * random(1-peakYRange,1+peakYRange);
      currentXPosition = currentXPosition + (randomnessModifier * random(-xPositionRange,xPositionRange) * CalmOrChaosModifier) ;
        
      // Start wave logic
    
      if (atACrossover && isRising) {           // then we're at the crossover now and next point must be a peak
      
        // do stuff
        curveVertex(currentXPosition,  starty);  
              
        // finish this section by leaving the crossover
        atACrossover = false;
      
      } else if (!atACrossover && isRising) {   // then we're at a peak now, and next point must be a crossover heading down
    
        // do stuff
        curveVertex(currentXPosition,  starty - (peakHeight * currentHeightModifier * CalmOrChaosModifier) );
       
        // finish this section by setting the wave to falling and leaving the peak
        isRising = false; 
        atACrossover = true;      
      
      } else if (atACrossover && !isRising) {   // then we're at the crossover now and next point must be a trough
      
        // do stuff
        curveVertex(currentXPosition,  starty);  
        
        // finish this section by leaving the crossover
        atACrossover = false;  
      
      } else if (!atACrossover && !isRising) {   // then we're at a trough now and next point must be a crossover heading up
       
        // do stuff
        curveVertex(currentXPosition,  starty + (peakDepth * currentHeightModifier * CalmOrChaosModifier));  
        
        // finish this section by setting the wave to rising and leaving the trough
        isRising = true; 
        atACrossover = true;       
        
      } else {                                   // final error state
        println("Something has gone wrong in this wave");
      } // end wave logic  
          
      // ellipse(currentXPosition, starty, 2, 2);   // also draw a dot to help us see what's going on
      // println(currentXPosition);
  
    } // end if loop  
  
    // last point
    curveVertex(waveWidth+startx,  starty);    
    curveVertex(waveWidth+startx,  starty);
    //ellipse(waveWidth+startx, starty, 2, 2);   // also draw a dot to help us see what's going on
    endShape();
    

  // reset everything for the next line
  currentXPosition = startx; // reset x for the next line
  isRising = true; // reset the wave so it's rising
  starty = starty + waveSpacing; // move dowwn a line
  
  // apply the calming or chaos effect to the next line
  CalmOrChaosModifier = CalmOrChaosModifier + (CalmOrChaosTrend); //<>//

  }
  
  // if we're exporting the screen to PDF, stop now
  if (record) {
    endRecord();
    record = false;
  }

    
  // if we're redrawing the screen, set variables back to their original setting.
  // delay(10);
  starty = startYOriginal;
  CalmOrChaosModifier = CalmOrChaosModifierOriginal;
  
  if (onlyDrawOneStep) {
   reDraw = false;
   onlyDrawOneStep = false;
   toggle_stepThrough.setValue(false);
  } 
    
  }  
  
 if (record) {
    endRecord();
  record = false;
  }
  
}  


// 
public void controlEvent(ControlEvent theEvent) {  
  if (theEvent.getController().getName().equals("ExportPDF")) {
  record = true;
  }
}
