ViridianForestEntrance_h:
	db GATE ; tileset
	db VIRIDIAN_FOREST_ENTRANCE_HEIGHT, VIRIDIAN_FOREST_ENTRANCE_WIDTH ; dimensions (y, x)
	dw ViridianForestEntranceBlocks, ViridianForestEntranceTextPointers, ViridianForestEntranceScript, ViridianForestEntranceTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw ViridianForestEntranceObject ; objects
