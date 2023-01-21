/*
TODO:
Use entirely separate byte to identify difference between trainer and pokemon battle from map sprite
- search for 201 (and all associated RAM bytes...)
--------
Remove the flipped sprite loading (intro, stat screen, etc)
- wSpriteFlipped
---------------
Will have to fix re-loading GHOST sprite when in battle....
 - true for substitute too??
-----------------------
Remove hardcoded banks in the source and place in the .link file
--------------
Always have sRAM bank 0 available for access
- move all other game save detailsto different bank so they are safe
--------------
Add in the macro to create a menu screen
-----------------------
Continue updating the Pokedex screen, using the new Pokemon class table

Update code for title screen ivnentory, etc to use new table/tile macros
- also, new Item class, etc

- Move the inventory to always accessible SRAM location, and the user can be able to rearrange it...
   - Or, once the "Box Data" is not longer stored in in the WRAM, can use that space...
*/

INCLUDE "engine/pce/draw.asm"
INCLUDE "engine/pce/sandbox.asm"
INCLUDE "engine/pce/palette.asm"
