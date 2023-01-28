SaffronHouse2_h:
	db HOUSE ; tileset
	db SAFFRON_HOUSE_2_HEIGHT, SAFFRON_HOUSE_2_WIDTH ; dimensions (y, x)
	dw SaffronHouse2Blocks, SaffronHouse2TextPointers, SaffronHouse2Script, SaffronHouse2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SaffronHouse2Object ; objects
