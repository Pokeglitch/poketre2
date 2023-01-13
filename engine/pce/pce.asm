/*
TODO:
Add in remaining sprites (trainers, pokemon backs, trainer backs, Red/Oak, etc)
 - Remove old sprites and old sprite uncompressing code
 - update all calls to use new algo

Will have to fix re-loading GHOST sprite when in battle....
 - true for substitute too??

Handle flipping sprite
 - For this to work, the tiles should be ordered horizontally...
 - unless we want to add ability to flip it upside down as well...
 - scaling??

Auto convert png to pce when building

Add in real backing options (besides just colors)

Update code for title screen ivnentory, etc to use new struct/table/tile macros

Update scan-includes to work with the IncludeTiles macro
-----------------------
Brainstorming:

Can quicky change backing using normal drawing routine by:
 - For all non-alpha palette colors, simply skip those pixels
 - For all alpha palette colors, pull the corresponding pixel from the other image
 -- can use masks for quick effect

Can we use tile animations (like overworld) to animate some sprites?
  - or, use pce to load body parts... to proper location

use smaller sprite so the position can be shifted around?
 - Will need to update code to know when to move destination byte back to start of row/col...
 -- fill any empty space with alpha
 --- so if the same color is at end of row and start of next, will need to interrupt and fill with alpha...

Use Stack Pointer to set the pixels?
 - can push the high and low bytes at once, and don't need HL...

Add in alternative FillPixel algorithms:
 - Try to replicate holo algo:
 -- FillHoloAlgorithm can lookup the next color, and if its black, then adjust that counter (dec by 1) and fill 1 more pixel with alpha
 - Rainbow/alternating colors (next pixel is different color from previous)

What if we include more colors?
 - can have change outfit color
 -- for example Color 5 = light gray shirt, or dark gray shirt
 - can have change in design
 -- for example, a design can be same color as shirt in one palette, but be different in another palette
 - can have different forms
 -- for example, a body part can be transparent (blend in with BG or match color of surrounding body) in on palette, but visible in another
 - need at least 2 more colors for this to work (1 for alt color, and 1 for overlap between alt color and orig color)
 -- how will this affect file size and loading time?
 --- can the image header list how many colors (so loading algo can skip the missing ones when sorting the list)
*/

INCLUDE "engine/pce/draw.asm"
INCLUDE "engine/pce/sandbox.asm"
INCLUDE "engine/pce/palette.asm"
