UnknownDungeon2_h:
	db CAVERN ; tileset
	db UNKNOWN_DUNGEON_2_HEIGHT, UNKNOWN_DUNGEON_2_WIDTH ; dimensions (y, x)
	dw UnknownDungeon2Blocks, UnknownDungeon2TextPointers, UnknownDungeon2Script, UnknownDungeon2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw UnknownDungeon2Object ; objects
