CopycatsHouse1F_h:
	db REDS_HOUSE ; tileset
	db COPYCATS_HOUSE_1F_HEIGHT, COPYCATS_HOUSE_1F_WIDTH ; dimensions (y, x)
	dw CopycatsHouse1FBlocks, CopycatsHouse1FTextPointers, CopycatsHouse1FScript, CopycatsHouse1FTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CopycatsHouse1FObject ; objects
