ViridianMart_h:
	db MART ; tileset
	db VIRIDIAN_MART_HEIGHT, VIRIDIAN_MART_WIDTH ; dimensions (y, x)
	dw ViridianMartBlocks, ViridianMartTextPointers, ViridianMartScript, ViridianMartTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw ViridianMartObject ; objects
