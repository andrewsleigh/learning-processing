# Object Oriented Programming Basics

If I want to make complex patterns, I need to learn how to make my code more scalable. hat means OOP.

I'm using the Learning Processing book by Daniel Shiffman to help me through it.

oop_4 is the first version I have working of a basic OOP sketch. Here it is, broken down:
First, declare objects:

```
Bubble myBubble1;
Bubble myBubble2;
```

In `setup()`, initialise objects:

```
myBubble1 = new Bubble(20, 60, 1, 2);
myBubble2 = new Bubble(100, 140, 2, 4);
```

In `draw()`, call the functions of the objects:

```java
myBubble1.display();
myBubble1.move();
myBubble2.display();
myBubble2.move();
```

So my question at this stage is: why can't I use parameter in these functions to create the variations in my two objects? Maybe it will become clear.

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

* THis does seem a bit redundant. In the book, Shiffman writes (p. 130):

> In my experience, the use of constructor arguments to initialize object variables can be somewhat bewildering. Please do not blame yourself. The code is strange-looking and can seem awfully redundant: “For every single variable I want to initialize in the constructor, I have to duplicate it with a temporary argument to that constructor?”
 
> Nevertheless, this is quite an important skill to learn, and, ultimately, is one of the things that makes object-oriented programming powerful.

* I also wanted to add a transparency property, but couldn't get this to work, so I've left this out for now.
