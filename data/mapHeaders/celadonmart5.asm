CeladonMart5_h:
	db LOBBY ; tileset
	db CELADON_MART_5_HEIGHT, CELADON_MART_5_WIDTH ; dimensions (y, x)
	dw CeladonMart5Blocks, CeladonMart5TextPointers, CeladonMart5Script, CeladonMart5TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMart5Object ; objects
