RocketHideout3_h:
	db FACILITY ; tileset
	db ROCKET_HIDEOUT_3_HEIGHT, ROCKET_HIDEOUT_3_WIDTH ; dimensions (y, x)
	dw RocketHideout3Blocks, RocketHideout3TextPointers, RocketHideout3Script, RocketHideout3TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw RocketHideout3Object ; objects
