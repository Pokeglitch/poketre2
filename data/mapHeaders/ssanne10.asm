SSAnne10_h:
	db SHIP ; tileset
	db SS_ANNE_10_HEIGHT, SS_ANNE_10_WIDTH ; dimensions (y, x)
	dw SSAnne10Blocks, SSAnne10TextPointers, SSAnne10Script, SSAnne10TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SSAnne10Object ; objects
