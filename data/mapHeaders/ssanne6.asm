SSAnne6_h:
	db SHIP ; tileset
	db SS_ANNE_6_HEIGHT, SS_ANNE_6_WIDTH ; dimensions (y, x)
	dw SSAnne6Blocks, SSAnne6TextPointers, SSAnne6Script, SSAnne6TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SSAnne6Object ; objects
