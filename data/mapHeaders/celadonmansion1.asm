CeladonMansion1_h:
	db MANSION ; tileset
	db CELADON_MANSION_1_HEIGHT, CELADON_MANSION_1_WIDTH ; dimensions (y, x)
	dw CeladonMansion1Blocks, CeladonMansion1TextPointers, CeladonMansion1Script, CeladonMansion1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion1Object ; objects
