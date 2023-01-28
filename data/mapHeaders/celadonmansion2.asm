CeladonMansion2_h:
	db MANSION ; tileset
	db CELADON_MANSION_2_HEIGHT, CELADON_MANSION_2_WIDTH ; dimensions (y, x)
	dw CeladonMansion2Blocks, CeladonMansion2TextPointers, CeladonMansion2Script, CeladonMansion2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion2Object ; objects
