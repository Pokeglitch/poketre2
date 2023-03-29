PewterMart_h:
	db POKECENTER ; tileset
	db PEWTER_MART_HEIGHT, PEWTER_MART_WIDTH ; dimensions (y, x)
	dw PewterMartBlocks, PewterMartTextPointers, PewterMartScript, PewterMartTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw PewterMartObject ; objects
