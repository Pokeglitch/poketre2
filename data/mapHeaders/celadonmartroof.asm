CeladonMartRoof_h:
	db LOBBY ; tileset
	db CELADON_MART_ROOF_HEIGHT, CELADON_MART_ROOF_WIDTH ; dimensions (y, x)
	dw CeladonMartRoofBlocks, CeladonMartRoofTextPointers, CeladonMartRoofScript, CeladonMartRoofTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMartRoofObject ; objects
