Lab2_h:
	db LAB ; tileset
	db CINNABAR_LAB_2_HEIGHT, CINNABAR_LAB_2_WIDTH ; dimensions (y, x)
	dw Lab2Blocks, Lab2TextPointers, Lab2Script, Lab2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Lab2Object ; objects
