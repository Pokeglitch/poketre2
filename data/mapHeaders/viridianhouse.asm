ViridianHouse_h:
	db HOUSE ; tileset
	db VIRIDIAN_HOUSE_HEIGHT, VIRIDIAN_HOUSE_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, ViridianHouseTextPointers, ViridianHouseScript, ViridianHouseTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw ViridianHouseObject ; objects

	db $0
