UndergroundPathEntranceRoute7_h:
	db GATE ; tileset
	db PATH_ENTRANCE_ROUTE_7_HEIGHT, PATH_ENTRANCE_ROUTE_7_WIDTH ; dimensions (y, x)
	dw UndergroundPathEntranceRoute7Blocks, UndergroundPathEntranceRoute7TextPointers, UndergroundPathEntranceRoute7Script, UndergroundPathEntranceRoute7TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw UndergroundPathEntranceRoute7Object ; objects
