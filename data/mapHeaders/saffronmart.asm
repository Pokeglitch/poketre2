SaffronMart_h:
	db POKECENTER ; tileset
	db SAFFRON_MART_HEIGHT, SAFFRON_MART_WIDTH ; dimensions (y, x)
	dw SaffronMartBlocks, SaffronMartTextPointers, SaffronMartScript, SaffronMartTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SaffronMartObject ; objects
