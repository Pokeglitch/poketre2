FuchsiaGym_h:
	db GYM ; tileset
	db FUCHSIA_GYM_HEIGHT, FUCHSIA_GYM_WIDTH ; dimensions (y, x)
	dw FuchsiaGymBlocks, FuchsiaGymTextPointers, FuchsiaGymScript, FuchsiaGymTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaGymObject ; objects
