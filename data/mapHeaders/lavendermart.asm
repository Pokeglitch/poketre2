LavenderMart_h:
	db POKECENTER ; tileset
	db LAVENDER_MART_HEIGHT, LAVENDER_MART_WIDTH ; dimensions (y, x)
	dw LavenderMartBlocks, LavenderMartTextPointers, LavenderMartScript, LavenderMartTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw LavenderMartObject ; objects
