---
layout: post
title:  "Force Accumulation"
date:   2018-09-03
categories:    # plotter
---

Moving on from simple acceleration comes the more complex work of applying multiple forces. 

### Sketch: [`force_accumulation_balloon_and_clouds_2.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/pvectors/force_accumulation_balloon_and_clouds_2/force_accumulation_balloon_and_clouds_2.pde)

This sketch tried to simulate multiple forces acting on a balloon floating in the sky:

 - gravity pushing the (helium) balloon up
 - gusting wind blowing it from side to side (using perlin noise for smooth changes in wind velocity)
 - a rebound force when the balloon hits the top of the screen
 - a _Breath of God_ force, which can be applied in any direction by the user clicking the mouse where the breath is coming from
 
The balloon is an object, and I also experimented with an array of cloud objects to try to give it some realism. These vary in velocity as they get closer in an imagined 3D space, and are also subject to a very mild perlin noise-based wind force. 

![balloon-clouds.png]({{ "/assets/balloon-clouds.png" | relative_url }})

There are lots of gotchas here...

### Accumulation
The first being the one Shiffman points out in the book. In the Balloon object, you have this function:


```java
void applyForce(PVector force) {
  acceleration.add(force);
}
```  
  
In the draw loop, it's called for each force like this:

```java
myBalloon.applyForce(gravity);
myBalloon.applyForce(wind);  
```

This is what he means by _accumulation_. It might be tempting to write the function as:

```java
void applyForce(PVector force) {
  acceleration = force; 
}
```

But with this code, each force would be assigned to acceleration (and then applied to velocity, and position) replacing the last. So only the last assigned force would have an effect.

### Emptying the acceleration vector on each loop

Here's the update function:
```java
void update() {
  velocity.add(acceleration); // equivalent to: velocity = velocity.add(acceleration);
  location.add(velocity); 
  acceleration.mult(0); // reset the accleeration to 0 on each frame, so forces can be reapplied
}
```

That last line resets the `acceleration` PVector to (0,0) so that it can be refilled with new accumulating forces on the next `draw()`. Without it, forces would quickly spiral out of control.

### Boundary detection and bouncing

I'm still getting strange behaviour when the balloon bounces off the top of the screen. With some settings of PVector values it bounces forever, sometimes it disappears. I think so many multiplications are being applied to `velocity` in this situation that things can quickly get confusing.

### Newton's first law 

"An object in motion stays in motion". When trying to simulate natural systems, you need to think about all the forces that keep things in equilibrium, otherwise the system tends to go of in one direction never to come back. 

In my case, if the wind tends to blow in one direction more than another, the balloon disappears off the side of the screen, never to return. Or it bounces off the top in an unnatural way. So I had to add in some damping effects on the bouncing, and a hacky version of wind resistance to slow all movement down over time. 

I think these kinds of dynamic forces could be done better. Maybe I'll learn how, soon...

