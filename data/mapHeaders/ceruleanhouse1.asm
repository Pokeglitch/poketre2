CeruleanHouse1_h:
	db HOUSE ; tileset
	db CERULEAN_HOUSE_1_HEIGHT, CERULEAN_HOUSE_1_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, CeruleanHouse1TextPointers, CeruleanHouse1Script, CeruleanHouse1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanHouse1Object ; objects
