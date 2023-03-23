Route2House_h:
	db HOUSE ; tileset
	db ROUTE_2_HOUSE_HEIGHT, ROUTE_2_HOUSE_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, Route2HouseTextPointers, Route2HouseScript, Route2HouseTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route2HouseObject ; objects
