# Computer Geometric Art

This is a book by Ian Angell, published in 1985, with many examples of repeating geometric patterns created using a series of Fortran programs written by the author. 

According to the introduction:

> To draw a lattice pattern, the computer first has to generate a "tile"; the computer takes an elementary set of line segments and arcs, and manipulates them using a space group (a sequence of reflections, rotations and translations on the original set) into a tile, which introduces some initial symmetry. The tiles are then stacked in a regular lattice ... thus initiating further symmetries. ... Clipping is used to restrict the pattern to a finite rectangle.

I picked a pattern (on page 2) to see if I could replicate this process in Processing, and perhaps also plot it out...

### Sketch: [`cgm_page2_1.pde`](cgm_page2_1/cgm_page2_1.pde)

This sketch draws one tile, comprised of 4 sub-tiles. I used different colours for each quadrant to help me debug the translations and get them to line up properly.

![](cgm_page2_1.png) 

