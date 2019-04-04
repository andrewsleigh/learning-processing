---
layout: post
title:  "Circle Packing"
date:   2018-08-21
categories:   basics
---

[This site](https://generativeartistry.com/tutorials/circle-packing/) has some nice generative art examples, written I think in JavaScript. I'm trying to write Processing sketches to create similar effects.

My first attempt at the circle packing example failed, so now I'm trying to piece it together in smaller chunks.

The overall workflow I'm following:

1. Setup the parameters for a new circle, starting with a maximum possible radius 
2. Check to see if a circle with these parameters would collide with any other circles already drawn
3. If it doesn’t collide, draw it and go back to step 1. If it does collide, shrink the radius slightly and go back to step 2


## Testing for collision

In this example, there is one static circle, and one dynamic one whose position follows the mouse. If the second circle is _included_ within the first, that second circle turns red. If it overlaps with the first, the first circle turns red. 

### Sketch: [`inclusion_collision_testing_1.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/circle-packing/inclusion_collision_testing_1/inclusion_collision_testing_1.pde)

I made these two separate tests because the original example talks about this possibility of a new circle being wholly included within an existing one. I'm not sure that I need that test, and since a test for collision (or overlap) also covers all cases of inclusion I thin kI may just need this one collision test.

![inclusion_collision_testing_1.png]({{ "/assets/inclusion_collision_testing_1.png" | relative_url }})

## Testing for collision in an array of circles

### Sketch: [`inclusion_collision_testing_2.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/circle-packing/inclusion_collision_testing_2/inclusion_collision_testing_2.pde)

In this version, I removed the inclusion testing, and drew an array of circles instead of just one fixed and one dynamic.

All circles are coloured red or green as they are drawn depending on whether they overlap. 

I noticed one subtle gotcha. When looping through all previous circles and looking for collision, you must exit the loop as soon as you get an unsuccessful result:

```java
// loop through all previous circles and test for collision
for (int j=0; j < i ; j++) {
  if (testForCollision(circleXPositions[j], circleYPositions[j], xPos, yPos, circleRadius, circleRadius)) {
	fill(255,0,0,50);
	break;
  } else {
	fill(0,255,0,50);
  }
}
```

That `break` stops the loop from continuing and possibly finding another circle with which the current one doesn't overlap, therefore letting it pass the test. 

![inclusion_collision_testing_2.png]({{ "/assets/inclusion_collision_testing_2.png" | relative_url }})

## Altering the size of circles and drawing, based on the results of the test

The next version jumps forward quite a bit, as I solved most of the problems. 

### Sketch: [`inclusion_collision_testing_3.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/circle-packing/inclusion_collision_testing_3/inclusion_collision_testing_3.pde)
A few key points to note:

 - Circle radii are no longer fixed, so I had to change the collision test to calculate distance based on radii stored in an array, as opposed to a fixed value set in a variable up top

 - Rather than drawing all the circles with different colours depending on whether they overlap, I'm only committing to drawing the circle if it doesn't overlap. If it does overlap, I shrink it a little and try again.

 - There are lots of ways of shrinking a number. There's a tradeoff between speed of calculation, and density of packing. For really dense packing, as you get towards the end of the array, you can end up having to make a lot of guesses before you get to a size that works.
 
 - I'm picking colours semi-randomly based on which circle I'm drawing. I'm using `map()` and `random()` to try and constrain these to a pleasing palette.
 

![inclusion_collision_testing_3.png]({{ "/assets/inclusion_collision_testing_3.png" | relative_url }})

### Improvements 

 - Could I use a more 'natural' way to position circles semi-randomly
 - Could I generate HPGL code to plot the result
 - Could I include boundary detection so that circles don't overlaps the edges of the screen
 - Could I weight the size of the circles, so that, say, larger circles appear more often at the bottom
