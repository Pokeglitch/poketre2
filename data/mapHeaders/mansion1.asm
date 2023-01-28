Mansion1_h:
	db FACILITY ; tileset
	db MANSION_1_HEIGHT, MANSION_1_WIDTH ; dimensions (y, x)
	dw Mansion1Blocks, Mansion1TextPointers, Mansion1Script, Mansion1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion1Object ; objects
