DiglettsCave_h:
	db CAVERN ; tileset
	db DIGLETTS_CAVE_HEIGHT, DIGLETTS_CAVE_WIDTH ; dimensions (y, x)
	dw DiglettsCaveBlocks, DiglettsCaveTextPointers, DiglettsCaveScript, DiglettsCaveTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw DiglettsCaveObject ; objects
