CeladonMart4_h:
	db LOBBY ; tileset
	db CELADON_MART_4_HEIGHT, CELADON_MART_4_WIDTH ; dimensions (y, x)
	dw CeladonMart4Blocks, CeladonMart4TextPointers, CeladonMart4Script, CeladonMart4TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMart4Object ; objects
