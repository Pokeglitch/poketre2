CopycatsHouse2F_h:
	db REDS_HOUSE ; tileset
	db COPYCATS_HOUSE_2F_HEIGHT, COPYCATS_HOUSE_2F_WIDTH ; dimensions (y, x)
	dw RedsHouse2FBlocks, CopycatsHouse2FTextPointers, CopycatsHouse2FScript, CopycatsHouse2FTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CopycatsHouse2FObject ; objects
