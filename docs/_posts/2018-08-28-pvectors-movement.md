---
layout: post
title:  "PVectors for position, velocity and acceleration"
date:   2018-08-28
categories:    # plotter
---

I [played with PVectors before]({{ site.baseurl }}{% post_url 2018-07-15-pvectors %}), in part because they're useful for plotting. Now I'm working through the _Nature of Code_ book and they come up again, this time in the context for moving objects: velocity, acceleration, forces, and so on.

### Sketch: [`pvector_oop_1.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/pvectors/pvector_oop_1/pvector_oop_1.pde)

This sketch is pretty much a straight bouncing ball example, but it wraps up all the functionality in an object. The `draw()` loop is just:

```java
void draw() {
  background(100);
  
  // call object methods
  mover.display();
  mover.update();
  mover.checkEdges();

}
```

Interestingly, when you apply acceleration to the moving ball, rather than just a constant velocity, the simple edge detection code I'd used previously fails. In that code, when an edge is detected, the velocity is reversed. However, when acceleration is applied the impat on the position of the object from the acceleration can be greater than the impact of the velocity, so if the acceleration tends in one direction, it can still push the object off the screen even if it's velocity is reversed. 

[Here's a great explanation.](https://stackoverflow.com/questions/22154410/accelerated-ball-leaving-screen-processing-2-1)


Here's my new edge detection function, which detects each edge individually, and resets the position of the object to the edge if it goes over. This gives the acceleration time to change direction (if it's random) or just keep the object pressed against the edge (if it applies a constant force towards that edge).


```java
void checkEdges() { // includes fixes for ball going off edge of screen
	if (location.x > width)  {
		velocity.x = -velocity.x; 
		location.x = width;
	}

	if (location.x  < 0)  {
		velocity.x = -velocity.x; 
		location.x = 0;
	}

	if (location.y > height)  {
		velocity.y = -velocity.y; 
		location.y = height;
	}  

	if (location.y  < 0)  {
		velocity.y = -velocity.y; 
		location.y = 0;
	} 
}
```

In the book, at this point (p. 54-56) Shiffman goes on to talk about static functions and the difference between these two lines of code:

```java
PVector w = v.add(u);
PVector w = PVector.add(v,u);
```

Only the second of these correctly creates a new PVector, `w`, as the sum of two other PVectors, `v` and `u`.