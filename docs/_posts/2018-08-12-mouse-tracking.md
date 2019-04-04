---
layout: post
title:  "Tracking the mouse"
date:   2018-08-12
categories:    # plotter
---


I've spen a day or so trying to build Pong in Processing. I've had some success, but I've encountered a few intractable bugs, so I'm going to take a break from that and try some smaller things. 

Going back to Daniel Shiffman's Learning Processing book `mouseX` and `mouseY` system variables.

So I made a few simple sketches that work with these:

### Sketch: [`pmouse_1`](https://github.com/andrewsleigh/learning-processing/blob/master/pmouse/pmouse_1/pmouse_1.pde)

Changes the background colour in relation to the mouse position


### Sketch: [`pmouse_2`](https://github.com/andrewsleigh/learning-processing/blob/master/pmouse/pmouse_2/pmouse_2.pde)

Draws a line where the angle is determined by the mouse position. Gives the effect of lag, especially when you drop the frame rate, but very difficult to see the effect at higher frame rates.

### Sketch: [`pmouse_3`](https://github.com/andrewsleigh/learning-processing/blob/master/pmouse/pmouse_3/pmouse_3.pde)

Tracks the mouse position within a `mouseDragged()` function to create a simple paint brush tool. The weight of the line is determined by the sped of the mouse

![pmouse3.png]({{ "/assets/pmouse3.png" | relative_url }})

### Sketch: [`pmouse_4`](https://github.com/andrewsleigh/learning-processing/blob/master/pmouse/pmouse_4/pmouse_4.pde)

Adds some smoothing to the previous sketch, by keeping track of the previous 6 mouse positions and averaging between them when calculating mouse speed. This results in a much more realistic paint effect.


![pmouse4.png]({{ "/assets/pmouse4.png" | relative_url }})


In all of these examples, I'm using some logic to turn negative values for the difference in mouse position into positive ones. I now see that there is a function that does this job more simply: `[abs()](https://processing.org/reference/abs_.html)`

So I could replace 

```java
mouseSpeedY = mouseY - pmouseY;
if (mouseSpeedY < 0) { 
	mouseSpeedY = -mouseSpeedY;
}
```

with

```java 
mouseSpeedY = abs(mouseY - pmouseY);
```


