PewterHouse1_h:
	db HOUSE ; tileset
	db PEWTER_HOUSE_1_HEIGHT, PEWTER_HOUSE_1_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, PewterHouse1TextPointers, PewterHouse1Script, PewterHouse1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw PewterHouse1Object ; objects
