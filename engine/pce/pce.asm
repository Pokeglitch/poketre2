/*
TODO:

Update all DEX_ constants to just use the pokemon name constant
 - (update places where DEX is reduced by 1 in PCE code) (?)
 - also all pokemon name calls should use new table (& remove old name strings)

Update calls to load RedSprite and trainer sprites
- Remove old red/trainer sprites

Remove the flipped sprite loading (intro, stat screen, etc)
--------
Add in remaining sprites (pokemon backs, trainer backs, etc)
 - Remove old sprites and old sprite uncompressing code
 - update all calls to use new algo

Things that can be removed:
	UncompressSpriteFromDE
	sSpriteBuffer1
	sSpriteBuffer0
	InterlaceMergeSpriteBuffers
--------------
Add in the macro to create a menu screen
---------------

Will have to fix re-loading GHOST sprite when in battle....
 - true for substitute too??
-----------------------
Remove hardcoded banks in the source and place in the .link file

Auto convert png to pce when building

Update scan-includes to work with the IncludeTiles macro
-----------------------
Create a PrintText function to get name of class instance

Continue updating the Pokedex screen, using the new Pokemon class table

Update code for title screen ivnentory, etc to use new table/tile macros
- also, new Item class, etc
*/

INCLUDE "engine/pce/draw.asm"
INCLUDE "engine/pce/sandbox.asm"
INCLUDE "engine/pce/palette.asm"
