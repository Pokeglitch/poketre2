Mansion2_h:
	db FACILITY ; tileset
	db MANSION_2_HEIGHT, MANSION_2_WIDTH ; dimensions (y, x)
	dw Mansion2Blocks, Mansion2TextPointers, Mansion2Script, Mansion2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion2Object ; objects
