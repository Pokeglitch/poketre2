SeafoamIslands2_h:
	db CAVERN ; tileset
	db SEAFOAM_ISLANDS_2_HEIGHT, SEAFOAM_ISLANDS_2_WIDTH ; dimensions (y, x)
	dw SeafoamIslands2Blocks, SeafoamIslands2TextPointers, SeafoamIslands2Script, SeafoamIslands2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SeafoamIslands2Object ; objects
