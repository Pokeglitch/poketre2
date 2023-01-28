SSAnne1_h:
	db SHIP ; tileset
	db SS_ANNE_1_HEIGHT, SS_ANNE_1_WIDTH ; dimensions (y, x)
	dw SSAnne1Blocks, SSAnne1TextPointers, SSAnne1Script, SSAnne1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw SSAnne1Object ; objects
