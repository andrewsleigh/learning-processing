---
layout: post
title:  "Converting from SVG to HPGL"
date:   2018-12-23
categories:    plotter
---

I'd like ot be able to plot (using HGPGL) simple vector images, which are often saved or generated  in SVG format

For example: <https://turtletoy.net/about>

>  Turtletoy allows you to create generative art using a minimalistic javascript Turtle graphics API. You can only create black-and-white line drawings on a square canvas. By offering a very restrictive environment we not only hope to stimulate creativity, we also make sure that the turtles can (at least theoretically) be plotted using a simple plotter.


>  Each turtle can be exported as SVG, suitable for high-res printing or a plotter.


There's also [Turtle in Python](https://docs.python.org/3/library/turtle.html).

See also [How to Think Like a Computer Scientist: Learning with Python 3](https://python.camden.rutgers.edu/python_resources/python3_book/hello_little_turtles.html)

So is it posible to generate an HPGL output file from a suitable SVG input?

---

## Software

I found a couple of possibly helpful programs:

[HPGL-Distiller](http://pldaniels.com/hpgl-distiller/)


> HPGL-Distiller is a small program that was written to filter out aspects of a HPGL file which are not relevant for various HPGL output devices, typically vinyl cutters. The original reason for filtering out the irrelevant codes was that my own personal vinyl cutter was responding poorly to the excess data.


> The HPGL-Distiller is actually a very simple program (even written in C) that breaks the incoming HPGL data stream into individual HPGL commands and simply copies or ignores each command based on the built in list of 'acceptable' HPGL commands. A lot of HPGL commands generated by pstoedit pertain to aspects of plotting like line type, width, pen colour, pen width and such, all of which aren't always relevant, especially in the cutting processes.

This requires the use of another program to generate the HPGL: [pstoedit](http://www.pstoedit.net):

> pstoedit translates PostScript and PDF graphics into other vector formats.

It's not super-clear how to get this (command line) program running, so some notes:

### 1. Install Ghostscript

pstoedit in turn requires [Ghostscript](https://www.ghostscript.com/index.html), "an interpreter for the PostScript language and for PDF"

Also not easy to see from their site how to get this running, but it turns out you can get it through Homebrew:

```
brew install ghostscript
```

### 2. Download and install pstoedit


[Get the source tarball: pstoedit-3.73.tar.gz](http://www.pstoedit.net) and extract.
In that folder there is a readme with some semi-helpful instructions:

```
If you have a Unix like system, try the following:
sh configure; 
make
make install; 
```

I ran these commands and after lots of logs flew by, including error messages like these:

```
./drvfuncs.h:30:19: warning: 'override' keyword is a C++11 extension
```

it seems to be installed.

## Testing

Let's try a [simple circle SVG from Wikipedia](https://en.wikipedia.org/wiki/File:Circle_-_black_simple.svg). The actual SVG data is pretty simple:

```
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500">
<circle cx="250" cy="250" r="210" fill="#fff" stroke="#000" stroke-width="8"/>
</svg>
```

Trying this command:
```
andrews-macbook-pro:Desktop andrew$ pstoedit -f hpgl Circle_-_black_simple.svg circle2.hpgl
```

And I get this:

```
: Copyright (C) 1993 - 2018 Wolfgang Glunz
Info: This HPGL/PCL driver is not very elaborated - consider using -f plot-hpgl or plot-pcl instead.
Error: /syntaxerror in /----nostringval----
Operand stack:

Execution stack:
   %interp_exit   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push   --nostringval--   --nostringval--   --nostringval--   false   1   %stopped_push   2028   1   3   %oparray_pop   2027   1   3   %oparray_pop   2008   1   3   %oparray_pop   1868   1   3   %oparray_pop   --nostringval--   %errorexec_pop   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push   --nostringval--   2028   1   3   %oparray_pop   2027   1   3   %oparray_pop   2008   1   3   %oparray_pop   1868   1   3   %oparray_pop   --nostringval--   %errorexec_pop   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push
Dictionary stack:
   --dict:969/1684(ro)(G)--   --dict:0/20(G)--   --dict:286/300(L)--
Current allocation mode is local
Current file position is 88900
GPL Ghostscript 9.26: Unrecoverable error, exit code 1
PostScript/PDF Interpreter finished. Return status 256 executed command : gs -q -dDELAYBIND -dWRITESYSTEMDICT -dNODISPLAY -dNOEPS /var/folders/hj/52dt3n9n4xx8s6rmtsb51_880000gn/T//psinLBRxzR
The interpreter seems to have failed, cannot proceed !
andrews-macbook-pro:Desktop andrew$ pstoedit -f hpgl Circle_-_black_simple.svg circle2.hpgl
```

But when I try 

```
andrews-macbook-pro:Desktop andrew$ pstoedit -f plot-hpgl Circle_-_black_simple.svg circle2.hpgl
```

It says `Unsupported output format plot-hpgl`...


The syntax is not clear, but I think I've figured out how to ake it less verbose:

```
pstoedit  -v bool:false
```


Let's try something simpler:

```
pstoedit -f ps Circle_-_black_simple.svg circle2.ps
```

Nope. OK, let's generate an SVG in Inkscape from a PS file included as a sample in pstoedit. Nope...

```
andrews-macbook-pro:Desktop andrew$ pstoedit -f ps spiral.svg spiral.ps
pstoedit: version 3.73 / DLL interface 108 (built: Dec 23 2018 - release build - g++ 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.10.44.4) - 64-bit) : Copyright (C) 1993 - 2018 Wolfgang Glunz
Error: /syntaxerror in /----nostringval----
Operand stack:

Execution stack:
   %interp_exit   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push   --nostringval--   --nostringval--   --nostringval--   false   1   %stopped_push   2028   1   3   %oparray_pop   2027   1   3   %oparray_pop   2008   1   3   %oparray_pop   1868   1   3   %oparray_pop   --nostringval--   %errorexec_pop   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push   --nostringval--   2028   1   3   %oparray_pop   2027   1   3   %oparray_pop   2008   1   3   %oparray_pop   1868   1   3   %oparray_pop   --nostringval--   %errorexec_pop   .runexec2   --nostringval--   --nostringval--   --nostringval--   2   %stopped_push
Dictionary stack:
   --dict:970/1684(ro)(G)--   --dict:0/20(G)--   --dict:311/450(L)--
Current allocation mode is local
Current file position is 88972
GPL Ghostscript 9.26: Unrecoverable error, exit code 1
PostScript/PDF Interpreter finished. Return status 256 executed command : gs -q -dDELAYBIND -dWRITESYSTEMDICT -dNODISPLAY -dNOEPS /var/folders/hj/52dt3n9n4xx8s6rmtsb51_880000gn/T//psinnV5LNw
The interpreter seems to have failed, cannot proceed !

```