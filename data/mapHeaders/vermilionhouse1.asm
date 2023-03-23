VermilionHouse1_h:
	db HOUSE ; tileset
	db VERMILION_HOUSE_1_HEIGHT, VERMILION_HOUSE_1_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, VermilionHouse1TextPointers, VermilionHouse1Script, VermilionHouse1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw VermilionHouse1Object ; objects
