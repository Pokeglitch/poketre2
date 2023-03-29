Lance_h:
	db GYM ; tileset
	db LANCES_ROOM_HEIGHT, LANCES_ROOM_WIDTH ; dimensions (y, x)
	dw LanceBlocks, LanceTextPointers, LanceScript, LanceTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw LanceObject ; objects
