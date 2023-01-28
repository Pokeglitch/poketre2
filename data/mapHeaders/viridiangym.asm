ViridianGym_h:
	db GYM ; tileset
	db VIRIDIAN_GYM_HEIGHT, VIRIDIAN_GYM_WIDTH ; dimensions (y, x)
	dw ViridianGymBlocks, ViridianGymTextPointers, ViridianGymScript, ViridianGymTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw ViridianGymObject ; objects
