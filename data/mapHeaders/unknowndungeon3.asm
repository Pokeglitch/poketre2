UnknownDungeon3_h:
	db CAVERN ; tileset
	db UNKNOWN_DUNGEON_3_HEIGHT, UNKNOWN_DUNGEON_3_WIDTH ; dimensions (y, x)
	dw UnknownDungeon3Blocks, UnknownDungeon3TextPointers, UnknownDungeon3Script, UnknownDungeon3TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw UnknownDungeon3Object ; objects
