SilphCo8_h:
	db FACILITY ; tileset
	db SILPH_CO_8F_HEIGHT, SILPH_CO_8F_WIDTH ; dimensions (y, x)
	dw SilphCo8Blocks, SilphCo8TextPointers, SilphCo8Script, SilphCo8TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo8Object ; objects
