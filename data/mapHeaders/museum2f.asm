Museum2F_h:
	db GATE ; tileset
	db MUSEUM_2F_HEIGHT, MUSEUM_2F_WIDTH ; dimensions (y, x)
	dw Museum2FBlocks, Museum2FTextPointers, Museum2FScript, Museum2FTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Museum2FObject ; objects
