CeruleanGym_h:
	db GYM ; tileset
	db CERULEAN_GYM_HEIGHT, CERULEAN_GYM_WIDTH ; dimensions (y, x)
	dw CeruleanGymBlocks, CeruleanGymTextPointers, CeruleanGymScript, CeruleanGymTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanGymObject ; objects
