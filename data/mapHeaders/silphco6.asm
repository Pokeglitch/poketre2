SilphCo6_h:
	db FACILITY ; tileset
	db SILPH_CO_6F_HEIGHT, SILPH_CO_6F_WIDTH ; dimensions (y, x)
	dw SilphCo6Blocks, SilphCo6TextPointers, SilphCo6Script, SilphCo6TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo6Object ; objects
