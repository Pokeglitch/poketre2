UnknownDungeon3Object:
	db $7d ; border block

	db 1 ; warps
	warp 3, 6, 8, UNKNOWN_DUNGEON_1

	db 0 ; signs

	db 3 ; objects
	object SPRITE_SLOWBRO, 27, 13, STAY, DOWN, 1, MEWTWO, 70
	object SPRITE_BALL, 16, 9, STAY, NONE, 2, ULTRA_BALL
	object SPRITE_BALL, 18, 1, STAY, NONE, 3, MAX_REVIVE

	; warp-to
	warp_to 3, 6, UNKNOWN_DUNGEON_3_WIDTH ; UNKNOWN_DUNGEON_1
