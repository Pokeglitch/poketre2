CeruleanMart_h:
	db MART ; tileset
	db CERULEAN_MART_HEIGHT, CERULEAN_MART_WIDTH ; dimensions (y, x)
	dw CeruleanMartBlocks, CeruleanMartTextPointers, CeruleanMartScript, CeruleanMartTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanMartObject ; objects
