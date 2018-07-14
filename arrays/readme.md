# Arrays

Programming types always get excited/angry about pointers. I don't really know what a pointer is. BUt this strikes me as quite a nice description, by Daniel Shiffman from the Learning Processing book:

>9.2 What is an array?
From Chapter 4, you may recall that a variable is a named pointer to a location in memory where data is stored. **In other words, variables allow programs to keep track of information over a period of time**. An array is exactly the same, only instead of pointing to one singular piece of information, an array points to multiple pieces.


## Declaring Arrays

With variables, you'd use something like this:

```processing
int myIntegerVariable;
```

With arrays it looks like:


```processing
int [] myArrayOfIntegers = new int [23];
```

Or for an array of objects of a class (e.g. `Bubble`) you've defined:

```processing
Bubble[] myBubbles = new Bubble[23];
```

So the differences here are: 

1. Use the `[]` notation to specify that you're creating an array
2. Create the array, as well as declaring it, by using the `new` notation (Is it possible or useful to just declare an array without creating an instance of it, with `int [] myArrayOfIntegers;`? I don't know...
3. Give it a predetermined size (of 23 integers or Bubbles in the examples above)

## Length of Arrays

Useful to know, when filling the array, or when avoiding overstepping its bounds. Here's the notation in a _filling_ loop:

```processing
for (int i = 0; i < myArrayOfIntegers.length; i++) { 
  myArrayOfIntegers[i] = 0;
}
```


