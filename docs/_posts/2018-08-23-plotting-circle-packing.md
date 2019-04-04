---
layout: post
title:  "Plotting circle packing"
date:   2018-08-23
categories:    # plotter
---

Circles are a primitive shape that it should be quite easy for my plotter to draw. 

So I adapted [my previous code]({{ site.baseurl }}{% post_url 2018-08-21-circle-packing %}) to generate HPGL plotter code for every circle that's draw to the screen

![IMG_1846.jpg]({{ "/assets/IMG_1846.jpg" | relative_url }})

### Sketch: [`inclusion_collision_testing_5a.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/circle-packing/inclusion_collision_testing_5a/inclusion_collision_testing_5a.pde)

In the previous code, I used `noLoop()` within the `draw()` function to limit the program to drawing the screen once. I then used a `for` loop to test and draw each circle in the array. This means that the screen draws once, at the end of the program execution, after all the circle placements have been calculated. 

Which is fine, but for plotting, I really want each circle to be drawn and plotted near enough simultaneously, which means I need to use the draw loop  itself to loop through the array of circles. 

```java
int i = 0; 

void draw() {

  // test and draw all the circles here

  i++;
  if (i == Circles.length) {
    noLoop();
  }
}
```

This is the equivalent of:

```java
noLoop()
for (int i = 0; i < Circles.length; i++) {

  // test and draw all the circles here

}
```

I had to add in a test for the first circle, since I can't check for collisions between that circle and any previous ones. So I made a fake zero radius circle to test it against. The reason I want to run the test at all is because this also tests for collision with the screen edges. There is a less hacky way of doing this I'm sure...

```java
if (i == 0) { // use this test only for the first circle,
  if (testForCollision(0, 0, xPos, yPos, circleRadius, 0)) { // test against fake circle
	doesCollide = true;
  } else {
	doesCollide = false; 
  }
}

if (i > 0) {

  // loop through all previous circles and test for collision
  for (int j=0; j < i ; j++) {
	
	if (testForCollision(circleXPositions[j], circleYPositions[j], xPos, yPos, circleRadius, circleRadii[j])) { 
	  doesCollide = true;
	  break;
	} else {
	  doesCollide = false;
	}
  }

}
```

## What happens on failure?

If a collision is found, this is what my code currently decides to do:

```java
if (circleRadius > minCircleRadius) { // check if we've reached the minium radius
	circleRadius--; // if not, decrease the radius
	i--; // try this circle again
	pickNewXY = false; // use the same co-ordinates
	
} else {  
	circleRadius = maxCircleRadius; // start  circle with max radius
	pickNewXY = true; // pick new random co-ordinates
	i--; // try this circle again
}
```

Earlier versions of this code didn't have this `pickNewXY` condition. So I think each time a circle was being retried it was doing so in a new spot. That doesn't feel right to me.


## Speed

I'm concerned about the efficiency of my code. Running in the draw loop like this took several hours to fill the page the first time I ran it. 

Now, that might be because I added a 2 second delay after sending the initialisation commands to the plotter, but put this delay in the draw loop - meaning it gets called every time a circle is tested. 

However, even without this, the algorithm slows down a lot towards the end. I suspect this is because it gets progressively harder to find a space to put new circles as the canvas fills up. Because each failed test restarts, this could end up with thousands (maybe millions?) of tests being run as the screen nears completion.

However, I don't really understand why this should be a problem when running the code in the draw loop, when the previous version (only drawing the circles once, after all the tests have been run) only took a few seconds. 

[The original code](https://generativeartistry.com/tutorials/circle-packing/) works the other way around, starting with an array of circles all at the minimum size, then growing them until they collide. This sounds like a better strategy, but I haven't figured out how to do it yet.



