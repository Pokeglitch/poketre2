FuchsiaHouse1_h:
	db HOUSE ; tileset
	db FUCHSIA_HOUSE_1_HEIGHT, FUCHSIA_HOUSE_1_WIDTH ; dimensions (y, x)
	dw FuchsiaHouse1Blocks, FuchsiaHouse1TextPointers, FuchsiaHouse1Script, FuchsiaHouse1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaHouse1Object ; objects
