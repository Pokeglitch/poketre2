UnknownDungeon1_h:
	db CAVERN ; tileset
	db UNKNOWN_DUNGEON_1_HEIGHT, UNKNOWN_DUNGEON_1_WIDTH ; dimensions (y, x)
	dw UnknownDungeon1Blocks, UnknownDungeon1TextPointers, UnknownDungeon1Script, UnknownDungeon1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw UnknownDungeon1Object ; objects
