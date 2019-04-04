---
layout: post
title:  "Asteroid field"
date:   2018-07-31
categories: plotter
---

I'd like to generate an image of asteroids, roughly in a grid, and each varying in size and shape.

Working from the Symbolic Disarray code, I'm creating my own `Asteroid()` class, and then using parameters passed to it when initialising each object in the array to introduce variations.

In plain old Processing, this would be quite simple. You could use `pushMatrix()` and `popMatrix()` to apply translations to each object as it's created, then reset the canvas for the next one. 

But the screen display for me is secondary. I want to generate HPGL for each line, so the position of each point on the line needs to be calculated in absolute terms, not relative to a canvas which has been transformed. 

This makes a simple rotation complex.

### Sketch: [`pvectors_asteroids_5`](https://github.com/andrewsleigh/learning-processing/blob/master/plotter/pvectors_asteroids_5/)

In this sketch I'm trying to rotate each asteroid a random amount, but display them in an even grid. The problem is that the rotation function moves each point around an origin, messing up the grid:

Here's the helper function `rotX()` that works out the new x co-ordinate for a point for a given rotation:

``` processing    
float rotX(float inX, float inY){
  return (inX*cos(r) - inY*sin(r)); 
}
```

So if our starting x = 3, and y = 2, and we rotate the point by 90&deg; the result is:
```
x = (2 * cos(90)) - (3 * sin(90))
```

Which is equivalent to:

```
x = (2 * 0) - (3 * -1)
```



![rotation-problem.png](<{{ "/assets/rotation-problem.png" | relative_url }}>)

The result, my grid is messed up with asteroids being placed out of alignment based on their rotation (If you look carefully, you can see the sharp point of each object is placed neatly on the grid. This is the first point of the shape, drawn at 0,0.

![pvectors_asteroids_5.png]({{ "/assets/pvectors_asteroids_5.png" | relative_url }})

The solution is to draw each asteroid with an origin at its center. In my case, with an asteroid being drawn within a 8 x 8 square, that means the top left point is at `-4, -4`, and the bottom right point at `4, 4`:

```java
asteroidPoints.add(new PVector(-4,-4) );
asteroidPoints.add(new PVector(-2+random(-ran,ran),-3+random(-ran,ran)) );
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
```

### Sketch: [`pvectors_asteroids_6.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/plotter/pvectors_asteroids_6/pvectors_asteroids_6.pde)


The result:

![pvectors_asteroids_6.png]({{ "/assets/pvectors_asteroids_6.png" | relative_url }})

<hr/>


### Sketch: [`pvectors_asteroids_7.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/plotter/pvectors_asteroids_7/pvectors_asteroids_7.pde)

![pvectors_asteroids_7.png]({{ "/assets/pvectors_asteroids_7.png" | relative_url }})

The next sketch makes some changes to tidy up the code. I put all the calls to the Plotter class inside conditional clauses, so it still runs even if you're not connected to a plotter.

I separated the classes out into their own files. Move up a directory in the Github repo to see them. 

Most importantly, I added a Crater class, to add some detail to each asteroid. I'm including this class within each asteroid, however, I think there are many problems here:

* The placement of each crater is not being properly calculated
* I have no idea if the HPGL being geenrated is correct - I haven't tested this yet
* I want craters to be placed at different points around the asteroid, with some variation
* Craters should only be placed within the boundaries of the asteroid. At the moment, the logic that draws them could allow lines to extend beyond the boundaries of the asteroid



