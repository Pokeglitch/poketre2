SilphCo3_h:
	db FACILITY ; tileset
	db SILPH_CO_3F_HEIGHT, SILPH_CO_3F_WIDTH ; dimensions (y, x)
	dw SilphCo3Blocks, SilphCo3TextPointers, SilphCo3Script, SilphCo3TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo3Object ; objects
