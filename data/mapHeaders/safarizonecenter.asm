SafariZoneCenter_h:
	db FOREST ; tileset
	db SAFARI_ZONE_CENTER_HEIGHT, SAFARI_ZONE_CENTER_WIDTH ; dimensions (y, x)
	dw SafariZoneCenterBlocks, SafariZoneCenterTextPointers, SafariZoneCenterScript, SafariZoneCenterTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SafariZoneCenterObject ; objects
