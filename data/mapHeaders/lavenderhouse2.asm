LavenderHouse2_h:
	db HOUSE ; tileset
	db LAVENDER_HOUSE_2_HEIGHT, LAVENDER_HOUSE_2_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, LavenderHouse2TextPointers, LavenderHouse2Script, LavenderHouse2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw LavenderHouse2Object ; objects
