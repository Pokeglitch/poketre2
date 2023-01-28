ViridianPokecenter_h:
	db POKECENTER ; tileset
	db VIRIDIAN_POKECENTER_HEIGHT, VIRIDIAN_POKECENTER_WIDTH ; dimensions (y, x)
	dw ViridianPokecenterBlocks, ViridianPokecenterTextPointers, ViridianPokeCenterScript, ViridianPokecenterTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw ViridianPokecenterObject ; objects
