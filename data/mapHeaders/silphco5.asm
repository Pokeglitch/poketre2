SilphCo5_h:
	db FACILITY ; tileset
	db SILPH_CO_5F_HEIGHT, SILPH_CO_5F_WIDTH ; dimensions (y, x)
	dw SilphCo5Blocks, SilphCo5TextPointers, SilphCo5Script, SilphCo5TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SilphCo5Object ; objects
