SilphCo4_h:
	db FACILITY ; tileset
	db SILPH_CO_4F_HEIGHT, SILPH_CO_4F_WIDTH ; dimensions (y, x)
	dw SilphCo4Blocks, SilphCo4TextPointers, SilphCo4Script, SilphCo4TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo4Object ; objects
