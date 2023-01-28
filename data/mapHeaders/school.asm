School_h:
	db HOUSE ; tileset
	db VIRIDIAN_SCHOOL_HEIGHT, VIRIDIAN_SCHOOL_WIDTH ; dimensions (y, x)
	dw SchoolBlocks, SchoolTextPointers, SchoolScript, SchoolTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SchoolObject ; objects
