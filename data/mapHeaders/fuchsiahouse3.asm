FuchsiaHouse3_h:
	db SHIP ; tileset
	db FUCHSIA_HOUSE_3_HEIGHT, FUCHSIA_HOUSE_3_WIDTH ; dimensions (y, x)
	dw FuchsiaHouse3Blocks, FuchsiaHouse3TextPointers, FuchsiaHouse3Script, FuchsiaHouse3TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaHouse3Object ; objects
