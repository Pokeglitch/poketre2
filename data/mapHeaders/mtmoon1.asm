MtMoon1_h:
	db CAVERN ; tileset
	db MT_MOON_1_HEIGHT, MT_MOON_1_WIDTH ; dimensions (y, x)
	dw MtMoon1Blocks, MtMoon1TextPointers, MtMoon1Script, MtMoon1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw MtMoon1Object ; objects
