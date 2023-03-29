FightingDojo_h:
	db GYM ; tileset
	db FIGHTING_DOJO_HEIGHT, FIGHTING_DOJO_WIDTH ; dimensions (y, x)
	dw FightingDojoBlocks, FightingDojoTextPointers, FightingDojoScript, FightingDojoTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw FightingDojoObject ; objects
