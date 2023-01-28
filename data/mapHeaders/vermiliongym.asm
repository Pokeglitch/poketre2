VermilionGym_h:
	db GYM ; tileset
	db VERMILION_GYM_HEIGHT, VERMILION_GYM_WIDTH ; dimensions (y, x)
	dw VermilionGymBlocks, VermilionGymTextPointers, VermilionGymScript, VermilionGymTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw VermilionGymObject ; objects
