NameRater_h:
	db HOUSE ; tileset
	db NAME_RATERS_HOUSE_HEIGHT, NAME_RATERS_HOUSE_WIDTH ; dimensions (y, x)
	dw ViridianHouseBlocks, NameRaterTextPointers, NameRaterScript, NameRaterTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw NameRaterObject ; objects
