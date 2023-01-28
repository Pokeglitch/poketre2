Route16House_h:
	db HOUSE ; tileset
	db ROUTE_16_HOUSE_HEIGHT, ROUTE_16_HOUSE_WIDTH ; dimensions (y, x)
	dw Route16HouseBlocks, Route16HouseTextPointers, Route16HouseScript, Route16HouseTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route16HouseObject ; objects
