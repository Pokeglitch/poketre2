PewterHouse2_h:
	db HOUSE ; tileset
	db PEWTER_HOUSE_2_HEIGHT, PEWTER_HOUSE_2_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, PewterHouse2TextPointers, PewterHouse2Script, PewterHouse2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw PewterHouse2Object ; objects
