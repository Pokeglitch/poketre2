SafariZoneRestHouse2_h:
	db GATE ; tileset
	db SAFARI_ZONE_REST_HOUSE_2_HEIGHT, SAFARI_ZONE_REST_HOUSE_2_WIDTH ; dimensions (y, x)
	dw SafariZoneRestHouse2Blocks, SafariZoneRestHouse2TextPointers, SafariZoneRestHouse2Script, SafariZoneRestHouse2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SafariZoneRestHouse2Object ; objects
