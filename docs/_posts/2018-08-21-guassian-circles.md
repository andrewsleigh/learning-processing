---
layout: post
title:  "Normally distributed circle packing"
date:   2018-08-21
categories:   basics # plotter
---


Reading, Shiffman's "The Nature of Code" book, I realised that I could get a more natrual effect in my [circle packing experiment]({{ site.baseurl }}{% post_url 2018-08-21-circle-packing %}) by positioning the circles according to a normal (gaussian) distribution. 

This means importing the Java `Random()` class:

```
import java.util.*; 
Random generator; // Java's Random class
```

Create the `Random()` object in `setup()`:

```
generator = new Random();
```

Use the `nextGaussian()`method of this Java class along with a mean and standard deviation that I can tinker with to create new random numbers on a normal distribution

```java
// generate position using Java Random() class
float xNum = (float) generator.nextGaussian();
float standardDeviationX = width/15;
float meanX = width/2;
float xPos = standardDeviationX * xNum + meanX;

float yNum = (float) generator.nextGaussian();
float standardDeviationY = height/15;
float meanY = height/2;
float yPos = standardDeviationY * yNum + meanY;
```

### Sketch: [`inclusion_collision_testing_4.pde`](https://github.com/andrewsleigh/learning-processing/blob/master/circle-packing/inclusion_collision_testing_4/inclusion_collision_testing_4.pde)


![inclusion_collision_testing_4.png]({{ "/assets/inclusion_collision_testing_4.png" | relative_url }})