/*
TODO:
Move the remaining trainer data into the trainer table
	- TrainerClassMoveChoiceModifications
	- TrainerAIPointers
	- LoneMoves
	- TeamMoves

- Use Trainer Bank value in the SECTION definition within the Trainer macro
- move the "parties" and trainer ai data in this bank
- move all functions that read from the table 
- - ReadTrainer, ReadTrainerHeaderInfo, GetTrainerInformation
------------------
Make macros to check flag value
- need to know if flag is expected to be a 1 or 0, to place either 'z/c' or 'nz/nc'
- also macro for masking
--------------
Define constant to indicate the byte size of each property

Macro to GetInstanceProperty
- returns into either a or hl based on the size of the property it is trying to acces

Make a macro for GetInstanceProperties to calculate how many bytes to allocate
------------------
Move all tables to their own bank
- Class ID can be the bank
- the tables can all start at $4000

Move all trainer data to a separate bank

---------------------
Move the Sprites to be inside the classes/trainer folder

Update the makefiles dependencies:
- sprites insides classes -> <name> -> pce sub folders
- asm files inside classes -> <name> -> data sub folders
--------
Use entirely separate byte to identify difference between trainer and pokemon battle from map sprite when reading object info from map header
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
Create a macro for running the appropriate functions before/after a screen is displayed
- or a home routine
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
