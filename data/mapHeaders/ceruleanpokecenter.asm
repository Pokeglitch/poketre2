CeruleanPokecenter_h:
	db POKECENTER ; tileset
	db CERULEAN_POKECENTER_HEIGHT, CERULEAN_POKECENTER_WIDTH ; dimensions (y, x)
	dw CeruleanPokecenterBlocks, CeruleanPokecenterTextPointers, CeruleanPokecenterScript, CeruleanPokecenterTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanPokecenterObject ; objects
