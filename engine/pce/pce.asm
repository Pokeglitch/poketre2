/*
TODO:

Update all trainer information to use new constants
- new constnts start at 0, while old ones start at 1

InitBattleEnemyParameters
wEnemyMonOrTrainerClass
wCurOpponent

Remove OPP_X
- change object macro to differentiate between Trainers and Pokemon battles
-------
confirm EvosMovesPointerTable should be in index order, not pokedex

- also all pokemon name calls should use new table (& remove old name strings)
--------
Remove the flipped sprite loading (intro, stat screen, etc)
- wSpriteFlipped

--------------
Add in the macro to create a menu screen
---------------
Will have to fix re-loading GHOST sprite when in battle....
 - true for substitute too??
-----------------------
Remove hardcoded banks in the source and place in the .link file
-----------------------
Create a PrintText function to get name of class instance

Continue updating the Pokedex screen, using the new Pokemon class table

Update code for title screen ivnentory, etc to use new table/tile macros
- also, new Item class, etc

--------------
Always have sRAM bank 0 available for access
- move all other game save to different bank so they are safe

Move the inventory to this SRAM location, and the user can be able to rearrange it...
--------------

Brainstorming:

- SRAM can have 2 full chunks dedicated to unpacking sprites
	- they can be fully side by side, or can overlap by X tiles

If using quick background change algorithm, can add a "fade away" function by simply decreasing the BG palette until all white (or black)
	- Can also have the sprite itself fade in over the background..
		- Something like "only show pixel if darker than bg pixel"

*/

INCLUDE "engine/pce/draw.asm"
INCLUDE "engine/pce/sandbox.asm"
INCLUDE "engine/pce/palette.asm"
