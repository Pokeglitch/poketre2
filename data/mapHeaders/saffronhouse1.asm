SaffronHouse1_h:
	db HOUSE ; tileset
	db SAFFRON_HOUSE_1_HEIGHT, SAFFRON_HOUSE_1_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, SaffronHouse1TextPointers, SaffronHouse1Script, SaffronHouse1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SaffronHouse1Object ; objects
