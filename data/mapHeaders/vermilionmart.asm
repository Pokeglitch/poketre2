VermilionMart_h:
	db POKECENTER ; tileset
	db VERMILION_MART_HEIGHT, VERMILION_MART_WIDTH ; dimensions (y, x)
	dw VermilionMartBlocks, VermilionMartTextPointers, VermilionMartScript, VermilionMartTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw VermilionMartObject ; objects
