CeladonMansion5_h:
	db HOUSE ; tileset
	db CELADON_MANSION_5_HEIGHT, CELADON_MANSION_5_WIDTH ; dimensions (y, x)
	dw CeladonMansion5Blocks, CeladonMansion5TextPointers, CeladonMansion5Script, CeladonMansion5TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion5Object ; objects
