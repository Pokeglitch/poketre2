CeruleanHouseTrashed_h:
	db HOUSE ; tileset
	db TRASHED_HOUSE_HEIGHT, TRASHED_HOUSE_WIDTH ; dimensions (y, x)
	dw CeruleanHouseTrashedBlocks, CeruleanHouseTrashedTextPointers, CeruleanHouseTrashedScript, CeruleanHouseTrashedTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanHouseTrashedObject ; objects
