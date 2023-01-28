Lorelei_h:
	db GYM ; tileset
	db LORELEIS_ROOM_HEIGHT, LORELEIS_ROOM_WIDTH ; dimensions (y, x)
	dw LoreleiBlocks, LoreleiTextPointers, LoreleiScript, LoreleiTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw LoreleiObject ; objects
