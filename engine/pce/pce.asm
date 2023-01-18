/*
TODO:

Add in pokemon backs

Old Sprite Code/Refernces that can be removed:
	UncompressSpriteFromDE
	sSpriteBuffer1
	sSpriteBuffer0
	InterlaceMergeSpriteBuffers
    LoadUncompressedSpriteData
	ScaleSpriteByTwo
-----------
Update all trainer information to use new constants
- new constnts start at 0, while old ones start at 1

InitBattleEnemyParameters
wEnemyMonOrTrainerClass
wCurOpponent

Remove OPP_X
- change object macro to differentiate between Trainers and Pokemon battles
-------
Update all DEX_ constants to just use the pokemon name constant
- new constnts start at 0, while old ones start at 1
- also all pokemon name calls should use new table (& remove old name strings)
--------
Remove the flipped sprite loading (intro, stat screen, etc)

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
