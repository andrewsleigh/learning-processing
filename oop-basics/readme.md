# Object Oriented Programming Basics

If I want to make complex patterns, I need to learn how to make my code more scalable. That means OOP.

I'm using the Learning Processing book by Daniel Shiffman to help me through it.

### Sketch: [`oop4.pde`](oop_4/oop_4.pde)

[oop_4](oop_4/oop_4.pde) is the first version I have working of a basic OOP sketch. Here it is, broken down. First, declare objects:

```processing
Bubble myBubble1;
Bubble myBubble2;
```

In `setup()`, initialise objects:

```processing
myBubble1 = new Bubble(20, 60, 1, 2);
myBubble2 = new Bubble(100, 140, 2, 4);
```

In `draw()`, call the functions of the objects:

```processing
myBubble1.display();
myBubble1.move();
myBubble2.display();
myBubble2.move();
```

So my question at this stage is: why can't I use parameters in these functions to create the variations in my two objects? Maybe it will become clear...

Finally, my Bubble class:

```processing
class Bubble { 
  // data
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed; 
  float xWidth;
  float yHeight;  
  color col; // colour
  
  // constructor, defined with arguments
  Bubble (float xPos_, float yPos_, float xSpeed_, float ySpeed_) { 
    xPos = xPos_;
    yPos = yPos_;
    xSpeed = xSpeed_;
    ySpeed = ySpeed_; 
    xWidth = 60;
    yHeight = 60;
    col = color(0, 255, 100);    
  }  
  
  // functions
  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(col);
    ellipse(xPos, yPos, xWidth, yHeight); 
  }
  
  void move() {
    xPos = xPos + xSpeed;  
    yPos = yPos + random(-1,1)*ySpeed; // more of a jiggle factor than speed
    if (xPos > (width + (xWidth / 2))) {
      xPos = -(xWidth / 2);
    }
    // probably should have a test for y as well...
  }  
}
```

Couple of notes here:

* In the class definition, you can use the `xyz_` convention to denote a temporary local variable

* This does seem a bit redundant. In the book, Shiffman writes (p. 130):

> In my experience, the use of constructor arguments to initialize object variables can be somewhat bewildering. Please do not blame yourself. The code is strange-looking and can seem awfully redundant: “For every single variable I want to initialize in the constructor, I have to duplicate it with a temporary argument to that constructor?”
 
> Nevertheless, this is quite an important skill to learn, and, ultimately, is one of the things that makes object-oriented programming powerful.

* I also wanted to add a transparency property, but couldn't get this to work, so I've left it out for now.

<hr/>

## Making an array of objects

I'm going to play more with arrays separately, but now the objects are modularised, it should be easy to generate a lot of them and have them all behave differently

### Sketch: [`oop5.pde`](oop_5/oop_5.pde)

The relevant parts that I changed here are below.

Declaring and creating the array of objects, instead of declaring individual objects:

```processing
int numberOfBubbles = 60;
Bubble[] myBubbles = new Bubble[numberOfBubbles];
```

Initialising the array of objects in `setup()`:

```processing
for (int i = 0; i < 60; i=i+1) {    
  int y = i * 5;    
  myBubbles[i] = new Bubble(20, y, 1+i/2, i);
}  
```
 
The parameters for `Bubble` here are:

1. xPos – where the bubbles start on the x axis
2. yPos – where they start on the y axis
3. xSpeed – how fast they move left to right. I could have just mde this `i` but I didn't want such a aggressive ramping up of speed 
4. ySpeed – really this is more of a y-axis jiggle factor, as you can see in the class `move()` function


The class definition:

```processing
class Bubble { 
  // data
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed; 
  float xWidth;
  float yHeight;

  // constructor, defined with arguments
  Bubble (float xPos_, float yPos_, float xSpeed_, float ySpeed_) { 
    xPos = xPos_;
    yPos = yPos_;
    xSpeed = xSpeed_;
    ySpeed = ySpeed_;
    xWidth = 20;
    yHeight = 20;
    col = color(0, 255, 100);    
  }  
  
  // functions
  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(col);
    ellipse(xPos, yPos, xWidth, yHeight); 
  }
  
  void move() {
    xPos = xPos + xSpeed;   
    yPos = yPos + random(-0.5,0.5)*ySpeed; // more of a jiggle factor than speed
    
    if (xPos > (width + (xWidth / 2))) {
      xPos = -(xWidth / 2);
    }
  }    
}

```
 
  
It looks something like this:

![]({{ "oop5.png" | relative_url }})  






