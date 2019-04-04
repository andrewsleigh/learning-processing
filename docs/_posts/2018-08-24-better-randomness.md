---
layout: post
title:  "Better Randomness"
date:   2018-08-24
categories:    # plotter
---

I've used a lot of random seed in my experiments so far, but pure randomness can feel quite artificial and flat. The first chapter of Daniel Shiffmann's _The Nature of Code_, dives straight into this, with discussions of [normal distribution]({{ site.baseurl }}{% post_url 2018-08-21-guassian-circles %}) and other types of randomness. In these sketches I'm playing with Perlin noise.


## Simple noise fields  

This code generates a screen of random brightness dots:

```java
void setup() {
  size(400, 400); 
}

void draw() {
  noLoop();
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      stroke(random(0,255));
      point(x,y);
    }
  }
}
```

![noise_clouds_1.png]({{ "/assets/noise_clouds_1.png" | relative_url }})


This code generates a screen of dots whose brightness is selected from a 2D field of Perlin noise.

```java
float startingOffset = 100;
float noiseIncrement = 0.006;
float noiseOffsetX = startingOffset; 
float noiseOffsetY = startingOffset;

void setup() {
  size(400, 400); 
}

void draw() {
  noLoop();
  for(int x = 0; x < width; x++) { // draw the columns
    noiseOffsetY = startingOffset; // reset y offset every column    
    for(int y = 0; y < height; y++) { // draw the rows  
      stroke(map(noise(noiseOffsetX,noiseOffsetY),0,1,0,255));
      point(x,y);
      noiseOffsetY = noiseOffsetY + noiseIncrement; // increment the noise offset 
     }    
    noiseOffsetX = noiseOffsetX + noiseIncrement; // increment the noise offset    
  }
}
```

![noise_clouds_2a.png]({{ "/assets/noise_clouds_2a.png" | relative_url }})

Couple of interesting things here:

 - As far as I can tell, the noise is deterministic. i.e. a particular point in the Perlin cloud will always have the same value. 
 - Smooth changes in value (ie soft clouds) come from small increments along the Perlin axis. If you change the value of `noiseIncrement` to be something much higher, e.g. `1`, then you get a much more coarsely textured noise. You can also see the repeating pattern at this scale, which gives some credence to the idea that it is deterministic.
 - However, each time you run the sketch, you get different clouds, so there must be some non-deterministic element...

![noise_clouds_2a-large-offset.png]({{ "/assets/noise_clouds_2a-large-offset.png" | relative_url }})


I'd like to introduce some variation to the noise, perhaps, making the clouds denser in the middle of the screen and smoother towards the edges. I tried adding a function to create a sine wave-shaped variation:

```java
// 2D
float generateSeed(float x,float y) {
  return (sin(map(x, 0, width, 0, PI)) + 
         sin(map(y, 0, height, 0, PI)))
         / 2;
}         
         
//1D
float generateSeed(float x) {
  return sin(map(x, 0, width, 0, PI));
}        
}
```
On a simple brightness field, this yields a soft bulge in the centre of the screen:

![xy-seed.png]({{ "/assets/xy-seed.png" | relative_url }})

But applied here, I get a cross-like shape, which isn't what I'd hoped for:

![noise_clouds_3.png]({{ "/assets/noise_clouds_3.png" | relative_url }})

In both cases, the field of colour is created by looping through a series of rows and columns of pixels, but I wonder if the cross-shape here relates to the use of the offset to create the variation in cloud density?

### Sketch: [`noise_clouds_3.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/noise/noise_clouds_3/noise_clouds_3.pde)



