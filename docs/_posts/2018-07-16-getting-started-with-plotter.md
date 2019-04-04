---
layout: post
title:  "Getting started with the pen plotter"
date:   2018-07-16
categories: plotter
---

I bought an HP745 pen plotter off eBay. I'm trying to program it using Processing. 





## Serial Port

First, we have to figure out which port it's on:

```processing
import processing.serial.*;
println(Serial.list()); //Print all serial ports to the console
```

I have 2 USB A ports on my Macbook Pro. For some reason, the one on the right often doesn't work for these kinds of serial communication tasks (I often can't get it to work when uploading to an Arduino either...) 

When I have the plotter connected (via a [USB to RS232 DB9 Adapter](https://www.amazon.co.uk/dp/B00QUZY4L0)) to the right side USB port, I get this list:

```
/dev/cu.AndrewsiPad-WirelessiAP 
/dev/cu.AndrewsiPhone2-Wireless 
/dev/cu.Bluetooth-Incoming-Port 
/dev/tty.AndrewsiPad-WirelessiAP 
/dev/tty.AndrewsiPhone2-Wireless 
/dev/tty.Bluetooth-Incoming-Port
```

On the left side, I get this list:

```
/dev/cu.AndrewsiPad-WirelessiAP 
/dev/cu.AndrewsiPhone2-Wireless 
/dev/cu.Bluetooth-Incoming-Port 
/dev/cu.usbserial-A106Z4UW 
/dev/tty.AndrewsiPad-WirelessiAP 
/dev/tty.AndrewsiPhone2-Wireless 
/dev/tty.Bluetooth-Incoming-Port 
/dev/tty.usbserial-A106Z4UW
```

I need to use the last port on that list, which is index 7 in the array.




## Reading the docs

HP published a book detailing how the HPGL language works:

**The HP-GL/2 and HP RTL Reference Guide – A Handbook for Program Developers**

It's easy to find a PDF of this online.




### Origin

The plotter's origin can be reset using HPGL commands, however, according to the HPGL reference guide:

> The default origin (0,0) depends on the type of device, and is shown on page 10. (PCL dual-context uses the PCL default logical page coordinate system).



![default-origin.png]({{ "/assets/default-origin.png" | relative_url }})

On my plotter, the origin is at the top left corner of the page. For an A4 sheet, which is loaded sideways into the plotter, that means that for a portrait plot, the origin is somewhat confusingly in the corner that appears to be in the bottom left. 

**Question: how do you switch it to landscape?**

P. 40:

![rotating-picture.png]({{ "/assets/rotating-picture.png" | relative_url }})

> Plotters always set the X-axis parallel to the longest edge of your plot; small-format printers set the Y-axis parallel to the longest edge. However, you can change this orientation using the RO (Rotate Coordinate System) instruction to rotate the coordinate system counterclockwise 90°, 180°, or 270°. Figure 23 shows the default, for most HP-GL/2 devices, and rotated orientation of the axes and locations of P1 and P2.
Note that P2 is now off the page. This occurs because the X, Y coordinates of P1 and P2 do not change. To set P1 and P2 at the hard-clip limits, use either the IP or IR instruction after the RO instruction; see page 275 for more information. If you reset your coordinate system to its de- fault orientation, remember to reset P1 and P2, using either the IP or IR instruction again.



## Drawing polygons

I think this might be important (p.53):

> Counting the Points in a Polygon
The starting pen location and each subsequent point define a polygon. As shown in the follow- ing illustration, a rectangle is defined by five points, not four. This is because the starting location is counted again as the ending location. The second shape has seven points.


![counting-points-polygon.png]({{ "/assets/counting-points-polygon.png" | relative_url }})


## Labels

It's not clear to me what you put in the Label (LB) command to finish a string of text. Do you actually put the letters **ETX**? Interestingly, BBEdit displays this character, copied-and-pasted from Preview, as **Shift-Return**...

Here's the text from p.71:

> Terminating Labels
LB tells the device to print every character following the instruction, rather than interpreting the characters as graphics instructions. In order to allow the normal terminator, the semicolon (;), to be used in text, the instruction is defined so that you must use the special label terminator to tell the device to once again interpret characters as graphics instructions. (If the instruction had been defined otherwise, you wouldn’t be able to print semicolons in your text.)The default label terminator is the non-printing ASCII end-of-text character ⇧↵ (decimal code 3, and denoted in BASIC by CHR$(3)). You must use the label terminator, or the device prints the rest of your file as text instead of executing the instructions. You can change the label ter- minator using the DT (Define Label Terminator) instruction.

Here's a screenshot of that same text (the PDF file opened in Preview on a Mac):

![terminating-labels.png]({{ "/assets/terminating-labels.png" | relative_url }})

In my tests, I have definitely run into this non-termination problem.

Here's how Tobias Toft generates HPGL for a label [in his code](https://github.com/tobiastoft/SymbolicDisarray/blob/master/SymbolicDisarray.pde):

```java
plotter.write("SI0.14,0.14;DI0,1;LB" + label + char(3));
```
(Where `label` is his String variable to hold the text to be printed.

